# KSeF - Przewodnik dla użytkowników API

Ten dokument jest przeznaczony dla użytkowników Fakturowni, którzy wystawiają faktury przez API i chcą przygotować się na obowiązkowy KSeF.

## Spis treści

1. [Quick Start](#quick-start)
2. [Wprowadzenie](#wprowadzenie)
3. [Włączanie KSeF w Fakturowni](#włączanie-ksef-w-fakturowni)
4. [Zmiany w API przy tworzeniu faktur](#zmiany-w-api-przy-tworzeniu-faktur)
5. [Ustawienie validate_invoices_for_gov](#ustawienie-validate_invoices_for_gov)
6. [Wysyłanie faktur do KSeF przez API](#wysyłanie-faktur-do-ksef-przez-api)
7. [Tryby OFFLINE (awaryjny, niedostępność, OFFLINE24)](#tryby-offline-awaryjny-niedostępność-offline24)
8. [Sprawdzanie statusu wysyłki](#sprawdzanie-statusu-wysyłki)
9. [Pobieranie dokumentów KSeF](#pobieranie-dokumentów-ksef)
10. [Wystawca faktury (Issuer)](#wystawca-faktury-issuer)
11. [Odbiorca faktury (Recipient)](#odbiorca-faktury-recipient)
12. [Rodzaj identyfikatora podatkowego (tax_no_kind)](#rodzaj-identyfikatora-podatkowego-tax_no_kind)
13. [Korekty faktur](#korekty-faktur)
14. [Checklista migracji](#checklista-migracji)
15. [Przykłady curl](#przykłady-curl)
16. [FAQ i rozwiązywanie problemów](#faq-i-rozwiązywanie-problemów)

---

## Quick Start

Minimalny przykład utworzenia faktury i wysłania do KSeF:

```bash
curl -X POST "https://app.fakturownia.pl/invoices.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "TWOJ_TOKEN",
    "gov_save_and_send": true,
    "invoice": {
      "kind": "vat",
      "seller_name": "Moja Firma Sp. z o.o.",
      "seller_tax_no": "5252445767",
      "seller_street": "ul. Przykładowa 10",
      "seller_post_code": "00-001",
      "seller_city": "Warszawa",
      "buyer_name": "Klient ABC Sp. z o.o.",
      "buyer_tax_no": "9876543210",
      "buyer_company": true,
      "positions": [
        {
          "name": "Usługa",
          "quantity": 1,
          "total_price_gross": 1230.00,
          "tax": 23
        }
      ]
    }
  }'
```

**Kluczowe elementy:**
- `gov_save_and_send` - parametr który po zapisaniu zleca wysyłkę faktury do KSeF
- `seller_tax_no`, `seller_street`, `seller_post_code`, `seller_city` - dane sprzedawcy
- `buyer_tax_no` - NIP nabywcy (wymagany dla firm)
- `buyer_company: true` - oznaczenie że nabywca jest firmą (kluczowe dla [automatycznej wysyłki](#konfiguracja-automatycznej-wysyłki))

Po utworzeniu faktury możesz [sprawdzić status wysyłki](#sprawdzanie-statusu-wysyłki).

---

## Wprowadzenie

### Co to jest KSeF?

KSeF (Krajowy System e-Faktur) to rządowy system elektronicznych faktur w Polsce. Obowiązek wystawiania faktur w KSeF dla podatników VAT będzie wprowadzany etapami od 1 lutego 2026 roku.

### Jak to wpływa na integrację API?

Jeśli korzystasz z API Fakturowni do wystawiania faktur, musisz:

1. **Zautoryzować się z KSeF** - w ustawieniach Fakturowni
2. **Uzupełnić wymagane pola** - KSeF wymaga więcej danych niż do tej pory wymagaliśmy w Fakturowni
3. **Obsłużyć nowe pola w odpowiedzi** - statusy wysyłki, numer KSeF
4. **Skonfigurować ustawienia integracji** - m.in. wybrać tryb wysyłki: ręczny/automatyczny, tryb pobierania wydatków: ręczny/automatyczny

---

## Włączanie KSeF w Fakturowni

### Tryb DEMO (przedprodykcyjny)

Zacznij od trybu DEMO, aby przetestować integrację bez wysyłania faktur do prawdziwego KSeF:

1. Zaloguj się do Fakturowni
2. Przejdź do: Ustawienia → Integracje i dodatki → KSeF (DEMO)
3. Aktywuj integrację i wybierz odpowiednie dane identyfikacyjne do autoryzacji (NIP)
4. Zautoryzuj się z KSeF (DEMO) poprzez wgranie certyfikatów DEMO lub wygenerowanie pliku autoryzacyjnego
5. Skonfiguruj odpowiednie ustawienia

Zakres walidacji dokumentów:
- faktury generowane i przesyłane przez system podlegają walidacji zgodnie z obowiązującymi wymaganiami strukturalnymi i logicznymi KSeF (schema fa(3)).

Środowisko:
- integracja komunikuje się wyłącznie z API KSeF w wersji przedprodukcyjnej (DEMO),
- każdej poprawnie przyjętej fakturze nadawany jest testowy numer KSeF,
- komunikacja służy testowaniu i weryfikacji poprawności integracji,
- faktury przesyłane do środowiska DEMO KSeF otrzymują statusy techniczne odzwierciedlające etap przetwarzania w DEMO: np. `demo_processing`, `demo_ok` i inne statusy techniczne właściwe dla trybu testowego.

Ograniczenia funkcjonalne:

Po skutecznym przekazaniu faktury do KSeF DEMO:
- nie są wyświetlane kody QR zawierające numer KSeF,
- nie jest blokowana możliwość edycji ani usuwania dokumentów, niezależnie od ich statusu wysyłki do KSeF,
- nie jest blokowana wysyłka dokumentów e-mailem do Klientów.

### Tryb produkcyjny

Po przetestowaniu w trybie demo (dostępne od 1 lutego 2026):

1. Zaloguj się do Fakturowni
2. Przejdź do: Ustawienia → Integracje i dodatki → KSeF
3. Aktywuj integrację i wybierz odpowiednie dane identyfikacyjne do autoryzacji (NIP)
4. Zautoryzuj się z KSeF poprzez wgranie certyfikatów lub wygenerowanie pliku autoryzacyjnego
5. Skonfiguruj odpowiednie ustawienia

Zakres walidacji dokumentów:
- faktury generowane i przesyłane przez system podlegają walidacji zgodnie z obowiązującymi wymaganiami strukturalnymi i logicznymi KSeF (schema fa(3)).

Środowisko:
- integracja komunikuje się z produkcyjnym API KSeF 2.0,
- dokumenty są rejestrowane w centralnym systemie KSeF,
- każdej poprawnie przyjętej fakturze nadawany jest unikalny numer KSeF,
- moment nadania numeru KSeF jest równoznaczny z uznaniem faktury za wystawioną w rozumieniu przepisów prawa,
- faktury przesyłane do środowiska KSeF otrzymują statusy techniczne odzwierciedlające etap przetwarzania: np. `processing`, `ok` i inne statusy techniczne właściwe dla trybu produkcyjnego.

Ograniczenia funkcjonalne:

Po skutecznym przekazaniu faktury do KSeF:
- edycja oraz usunięcie dokumentu zostają zablokowane w systemie,
- wszelkie korekty realizowane są wyłącznie poprzez wystawienie faktur korygujących zgodnie z zasadami KSeF,
- kod QR umieszczany jest na wizualizacji dokumentu zgodnie z obowiązującymi wytycznymi,
- system umożliwia wysyłkę dokumentów e-mailem do Klientów wyłącznie po skutecznym nadaniu numeru KSeF lub oznaczeniu trybu OFFLINE.

---

## Zmiany w API przy tworzeniu faktur

### Nowe wymagane pola

Gdy KSeF jest aktywny, następujące pola stają się wymagane:

#### Dane sprzedawcy (seller)

| Pole | Opis |
|------|------|
| `seller_tax_no` | NIP sprzedawcy |
| `seller_name` | Nazwa firmy |
| `seller_street` | Ulica i numer |
| `seller_post_code` | Kod pocztowy |
| `seller_city` | Miasto |
| `seller_country` | Kod kraju (np. "PL") |

#### Dane nabywcy (buyer)

| Pole | Opis |
|------|------|
| `buyer_company` | Czy nabywca jest firmą (true/false) |
| `buyer_name` | Nazwa firmy/imię i nazwisko |
| `buyer_tax_no` | NIP nabywcy |
| `buyer_tax_no_kind` | Rodzaj numeru identyfikacyjnego: `""` (polski NIP - domyślnie), `"nip_ue"`, `"other"`, `"empty"` |
| `buyer_country` | Kod kraju |

**Uwaga:** Pole `buyer_tax_no` jest wymagane gdy `buyer_company=true` i `buyer_tax_no_kind` nie jest ustawione na `"empty"`.

**Dla nabywców zagranicznych:** Ustaw `buyer_tax_no_kind` na odpowiednią wartość:
- `"nip_ue"` - dla firm z UE (numer VAT UE)
- `"other"` - dla firm spoza UE (inny numer identyfikacyjny)
- `"empty"` - gdy nabywca nie posiada numeru identyfikacyjnego (wtedy `buyer_tax_no` nie jest wymagane)

**Ważne:** Pole `buyer_company` ma kluczowe znaczenie dla automatycznej wysyłki do KSeF - w trybach "Tylko polskie firmy" i "Wszystkie firmy" wysyłane są tylko faktury z `buyer_company=true`. Zawsze wysyłaj to pole w API.

#### Nabywca - osoba fizyczna

Dla faktur wystawianych osobom fizycznym (konsumenci, B2C):

```json
{
  "invoice": {
    "buyer_company": false,
    "buyer_first_name": "Jan",
    "buyer_last_name": "Kowalski",
    "buyer_street": "ul. Prywatna 5",
    "buyer_post_code": "00-100",
    "buyer_city": "Warszawa",
    "buyer_country": "PL"
  }
}
```

**Uwagi:**
- Dla osób fizycznych (`buyer_company=false`) wymagane są pola `buyer_first_name` i `buyer_last_name`. System automatycznie złoży je w `buyer_name` jeśli to pole jest puste.
- Pole `buyer_tax_no` nie jest wymagane gdy `buyer_company=false`.
- Takie faktury trafiają do KSeF tylko w trybie "Wszystkie dokumenty wystawiane dla firm i osób prywatnych".

### Zachowanie przy podaniu ID klienta lub działu

#### Podanie `department_id` lub `client_id`

Gdy w API podasz `department_id` lub `client_id`, dane z tych obiektów **nadpiszą** dane podane bezpośrednio w requestcie. Tak było do tej pory i tak pozostaje.

Przykład:
```json
{
  "invoice": {
    "department_id": 123,
    "seller_name": "Moja nazwa",  // zostanie nadpisana danymi z department 123
    "client_id": 456,
    "buyer_name": "Nazwa klienta"  // zostanie nadpisana danymi z client 456
  }
}
```

#### Nowe zachowanie przy KSeF: uzupełnianie po nazwie

**Nowość:** Gdy KSeF jest aktywny, system dodatkowo uzupełnia brakujące pola na podstawie `seller_name` lub `buyer_name`:

- Jeśli podasz `seller_name` pasujące do istniejącego działu, system uzupełni brakujące pola sprzedawcy (adres, NIP itp.)
- Jeśli podasz `buyer_name` pasujące do istniejącego klienta, system uzupełni brakujące pola nabywcy

To zachowanie jest aktywne tylko gdy KSeF jest włączony i ma na celu ułatwienie spełnienia wymagań KSeF bez konieczności podawania wszystkich pól w każdym requeście.

### Pola warunkowe

| Pole | Kiedy wymagane |
|------|----------------|
| `exempt_tax_kind` | Gdy pozycje mają stawkę VAT "zw" (zwolniony) |
| `np_tax_kind` | Gdy pozycje mają stawkę VAT "np" (nie podlega) |

Dozwolone wartości dla `exempt_tax_kind`:
- `Zwolnienie ze względu na rodzaj prowadzonej działalności (art. 43 ust 1 ustawy o VAT)`
- `Zwolnienie ze względu na nieprzekroczenie limitu obrotu (art. 113 ust 1 i 9 ustawy o VAT)`
- `Zwolnienie na mocy rozporządzenia MF (art. 82 ust 3 ustawy o VAT)`
- `Zwolnienie, o którym mowa w art. 132 ust 1 lub art. 135 ust 1 Dyrektywy 2006/112/WE`
- lub własny tekst opisujący podstawę zwolnienia

Dozwolone wartości dla `np_tax_kind`:
- `export_service` - Dostawa towarów oraz świadczenie usług poza terytorium kraju
- `export_service_eu` - w tym świadczenie usług, o których mowa w art.100 ust.1 pkt 4 ustawy

Przykład faktury ze stawką "np":
```json
{
  "invoice": {
    "kind": "vat",
    "np_tax_kind": "export_service",
    "seller_name": "Moja Firma Sp. z o.o.",
    "seller_tax_no": "5252445767",
    "seller_street": "ul. Przykładowa 10",
    "seller_post_code": "00-001",
    "seller_city": "Warszawa",
    "buyer_name": "Foreign Company Ltd",
    "buyer_tax_no": "DE123456789",
    "buyer_country": "DE",
    "buyer_company": true,
    "positions": [
      {
        "name": "Usługa IT dla klienta zagranicznego",
        "quantity": 1,
        "total_price_gross": 5000.00,
        "tax": "np"
      }
    ]
  }
}
```

### Ograniczenia długości pól

KSeF narzuca limity na długość niektórych pól:

| Pole | Maksymalna długość | Nowe ograniczenie |
|------|-------------------|------------|
| Nazwa pozycji (`positions[].name`) | 256 znaków | Tak |
| Opis/stopka faktury (`description`) | 3500 znaków | Tak |
| Email (`buyer_email`, `seller_email`) | 255 znaków | Tak (format) |
| Telefon (`buyer_phone`, `seller_phone`) | 16 znaków | Tak |
| Powód korekty (`correction_reason`) na korekcie| 256 znaków | Tak |
| Nazwa (`seller_name`, `buyer_name`) | 255 znaków (Fakturownia) | Nie |
| Adres (`seller_street`, `buyer_street`) | 255 znaków (Fakturownia) | Nie |
| GTIN (pole `additional_info` gdy `additional_info_desc=GTIN`) | 20 znaków | Tak |
| PKWiU/PKOB/CN (pole `additional_info`) | 50 znaków | Tak |

**Ważne:** Jeśli Twoja integracja generuje długie opisy pozycji lub stopki faktur, musisz je skrócić.


### Typy faktur wysyłane do KSeF

Tylko poniższe typy faktur (`kind`) będą wysyłane do KSeF:

| Typ | Opis |
|-----|------|
| `vat` | Faktura VAT |
| `correction` | Faktura korygująca |
| `vat_mp` | Faktura VAT marża (procedura marży) |
| `vat_margin` | Faktura VAT marża |
| `wdt` | Wewnątrzwspólnotowa dostawa towarów |
| `export_products` | Eksport towarów |
| `advance` | Faktura zaliczkowa |
| `final` | Faktura końcowa |

**Inne typy dokumentów** (proformy, paragony, wyceny, zamówienia, dokumenty magazynowe itp.) można nadal wystawiać przez API - po prostu nie będą wysyłane do KSeF. Przy próbie wysłania otrzymają status `not_applicable`.

---

## Ustawienie validate_invoices_for_gov

To ustawienie na poziomie konta kontroluje, jak system reaguje na błędy walidacji KSeF.

### Jak włączyć/wyłączyć

1. Zaloguj się do Fakturowni
2. Przejdź do: Ustawienia → KSeF
3. Znajdź opcję "Zablokuj tworzenie faktur niezgodnych z KSeF"
4. Włącz lub wyłącz według potrzeb

### Zachowanie gdy włączone (domyślnie)

Gdy ustawienie jest włączone:
- Faktura **nie zostanie zapisana** jeśli nie spełnia wymagań KSeF
- API zwróci błąd 422 z listą problemów
- Musisz poprawić dane i wysłać ponownie

Przykład odpowiedzi błędu (HTTP 422):
```json
{
  "code": "error",
  "message": {
    "buyer_tax_no": ["- nie może być puste"],
    "buyer_phone": ["- pole jest za długie (maksymalna ilość znaków: 16)"],
    "exempt_tax_kind": ["- nie może być puste"]
  }
}
```

### Zachowanie gdy wyłączone

Gdy ustawienie jest wyłączone:
- Faktura **zostanie zapisana** nawet z błędami KSeF
- Błędy będą zapisane w polu `gov_error_messages`
- Automatyczna wysyłka faktury do KSeF nie uda się z powodu błędów
- Możesz poprawić fakturę później i wysłać ręcznie

### Sprawdzanie błędów walidacji

W odpowiedzi API sprawdź pole `gov_error_messages`:

`GET /invoices/12345.json?fields[invoice]=gov_error_messages`
```json
{
  "gov_error_messages": [
    "Telefon klienta - pole jest za długie (maksymalna ilość znaków: 16)",
    "podstawa zwolnienia z podatku VAT - nie może być puste"
  ]
}
```

---

## Wysyłanie faktur do KSeF przez API

### Ręczne wysłanie istniejącej faktury

Możesz wysłać istniejącą fakturę do KSeF na dwa sposoby:

**Sposób 1: Parametr `send_to_ksef`**
```
GET /invoices/{ID}.json?send_to_ksef=yes&api_token=TWOJ_TOKEN
```

**Sposób 2: Parametr `gov_save_and_send` przy tworzeniu/edycji**
```json
POST /invoices.json?gov_save_and_send=1&api_token=TWOJ_TOKEN

{
  "invoice": { ... }
}
```

Odpowiedź:
```json
{
  "id": 12345,
  "gov_status": "processing",
  "gov_id": null,
  ...
}
```

Status `processing` oznacza, że faktura została przekazana do wysyłki. Numer KSeF (`gov_id`) pojawi się po przetworzeniu.

### Konfiguracja automatycznej wysyłki

Automatyczną wysyłkę konfiguruje się przez interfejs Fakturowni (nie przez API):

1. Zaloguj się do Fakturowni
2. Przejdź do: Ustawienia → KSeF
3. Znajdź sekcję "Automatyczna wysyłka"
4. Wybierz tryb (`gov_auto_send_mode`):
   - **Wyłączona** (`null`) - wysyłka tylko ręczna
   - **Tylko dokumenty wystawiane dla firm z Polski** (`pl_companies`) - faktury z `buyer_company=true` i `buyer_country=PL` (lub puste). Dokumenty dla firm zagranicznych należy wysyłać ręcznie.
   - **Wszystkie dokumenty wystawiane dla firm** (`all_companies`) - faktury z `buyer_company=true` (niezależnie od kraju). Dokumenty dla osób prywatnych nie będą wysyłane automatycznie.
   - **Wszystkie dokumenty wystawiane dla firm i osób prywatnych** (`all`) - wszystkie faktury (zarówno dla firm, jak i dla osób prywatnych)

**Rekomendacja:** Zacznij od "Tylko polskie firmy" - to najbezpieczniejsza opcja.

**Ważne dla integracji API:** Upewnij się, że zawsze wysyłasz pole `buyer_company` (true/false). Decyduje ono czy faktura zostanie automatycznie wysłana do KSeF.

---

## Tryby OFFLINE (awaryjny, niedostępność, OFFLINE24)

### Kiedy stosowany jest tryb OFFLINE24/OFFLINE?

OFFLINE24:
- brak internetu lub opóźnienia/awaria systemu u podatnika,
- obowiązek wysłania do KSeF w ciągu doby,
- nie wymaga zgłoszenia do MF.

OFFLINE (awaryjny/niedostępność)
- oficjalna awaria KSeF po stronie MF,
- faktury poza KSeF,
- wysyłka po przywróceniu systemu (wg komunikatu MF).

### Automatyczne wykrywanie trybu OFFLINE24

W Fakturowni tryb OFFLINE24 jest **wykrywany automatycznie** na podstawie daty wystawienia faktury:
- jeśli `issue_date` jest wcześniejsza niż dzisiejsza data, system ostrzega o trybie OFFLINE24,
- nie ma osobnego pola API do oznaczania trybu OFFLINE24,
- trybem OFFLINE24 będą również (opcjonalnie) oznaczane wysyłane dokumenty, które przekroczą limity API wysyłki.

Przykład: Jeśli dzisiaj jest 2026-03-15 i wystawiasz fakturę z `issue_date: "2026-03-14"`, system automatycznie potraktuje ją jako fakturę OFFLINE24.

### Zachowanie systemu w trybie OFFLINE24

Gdy faktura jest wystawiana w trybie OFFLINE24:
- faktura zostaje zapisana w systemie,
- system wyświetla ostrzeżenie o wysyłce w trybie OFFLINE24,
- system automatycznie wyświetla 2 kody QR na dokumencie,
- faktura zostanie dosłana do KSeF z odpowiednim oznaczeniem.

Gdy faktura jest wystawiana w trybie OFFLINE:
- faktura zostaje zapisana w systemie,
- system automatycznie wyświetla 2 kody QR na dokumencie,
- fakturę należy dosłać do KSeF samodzielnie.

### Ważne informacje

- Faktury OFFLINE muszą być wysłane do KSeF w ciągu określonego czasu zgodnie z przepisami
- Tryb OFFLINE24 nie jest przeznaczony do regularnego fakturowania z datą wsteczną

---

## Sprawdzanie statusu wysyłki

### Pola statusu w odpowiedzi API

Pobierając fakturę przez API, otrzymujesz pola związane z KSeF:

```
GET /invoices/{ID}.json?fields[invoice]=gov_status,gov_id,gov_send_date,gov_sell_date,gov_error_messages,gov_verification_link,gov_link,gov_corrected_invoice_number&api_token=TWOJ_TOKEN
```

Przykładowa odpowiedź dla faktury wysłanej do KSeF:
```json
{
  "gov_status": "ok",
  "gov_id": "5252445767-20260201-ABC123DEF456",
  "gov_send_date": "2026-02-01T10:30:00.000+01:00",
  "gov_sell_date": "2026-02-01T00:00:00.000+01:00",
  "gov_error_messages": null,
  "gov_verification_link": "https://ksef.mf.gov.pl/web/verify/5252445767-20260201-ABC123DEF456/YwucKLcs88uk...",
  "gov_link": null,
  "gov_corrected_invoice_number": null
}
```

### Możliwe statusy (`gov_status`)

**Statusy produkcyjne:**

| Status | Opis |
|--------|------|
| `ok` | Wysłana pomyślnie do KSeF |
| `processing` | W trakcie wysyłki |
| `send_error` | Błąd wysyłki - sprawdź `gov_error_messages` |
| `server_error` | Błąd serwera KSeF - spróbuj ponownie później |
| `not_applicable` | Faktura nie kwalifikuje się do KSeF (np. proforma) |
| `not_connected` | KSeF nie jest połączony z kontem (brak autoryzacji) |
| `null` | Nie wysłano do KSeF |

**Statusy w trybie demo:**

| Status | Opis |
|--------|------|
| `demo_ok` | Wysłana pomyślnie (tryb demo) |
| `demo_processing` | W trakcie wysyłki (tryb demo) |
| `demo_send_error` | Błąd wysyłki (tryb demo) |
| `demo_server_error` | Błąd serwera (tryb demo) |
| `demo_not_applicable` | Nie kwalifikuje się (tryb demo) |
| `demo_not_connected` | KSeF nie jest połączony (tryb demo) |

### Opis wszystkich pól KSeF

| Pole | Typ | Opis |
|------|-----|------|
| `gov_status` | string | Status wysyłki do KSeF (patrz tabela powyżej) |
| `gov_id` | string | Unikalny numer KSeF faktury (format: `{NIP}-{DATA}-{ID}`) |
| `gov_send_date` | datetime | Data i czas wysyłki do KSeF |
| `gov_sell_date` | datetime | Data sprzedaży zarejestrowana w KSeF |
| `gov_error_messages` | array/null | Lista błędów walidacji lub wysyłki. Wartość `null` oznacza brak błędów lub brak walidacji. |
| `gov_verification_link` | string | Link do weryfikacji faktury w portalu KSeF (używany do generowania QR) |
| `gov_link` | string | Bezpośredni link do faktury w portalu KSeF (używany do generowania QR) |
| `gov_corrected_invoice_number` | string | Numer korygowanego dokumentu (dla faktur korygujących) |

### Numer KSeF (`gov_id`)

Po pomyślnej wysyłce faktura otrzymuje unikalny numer KSeF w formacie:
```
{NIP_SPRZEDAWCY}-{DATA}-{IDENTYFIKATOR}
```

Przykład: `5252445767-20260201-ABC123DEF456`

Ten numer jest oficjalnym potwierdzeniem przyjęcia faktury przez KSeF.

### Link weryfikacyjny (`gov_verification_link`)

Link do weryfikacji faktury w portalu KSeF. Używany do generowania kodu QR na wydruku faktury.

Format: `https://ksef.mf.gov.pl/web/verify/{gov_id}/{hash}`

Kod QR jest wyświetlany tylko gdy:
- `gov_verification_link` jest wypełniony
- Faktura nie jest w trybie demo
- `gov_id` nie musi być wypełniony

### Korekty KSeF (`gov_corrected_invoice_number`)

Dla faktur korygujących pole `gov_corrected_invoice_number` zawiera numer KSeF oryginalnej faktury.

Przykład odpowiedzi dla korekty:
```json
{
  "id": 12346,
  "kind": "correction",
  "gov_status": "ok",
  "gov_id": "5252445767-20260201-XYZ789ABC123",
  "gov_corrected_invoice_number": "5252445767-20260201-ABC123DEF456"
}
```

### Webhooki

Gdy faktura zostanie pomyślnie wysłana do KSeF i otrzyma numer KSeF (`gov_id`), pola faktury zostaną zaktualizowane. Ta aktualizacja wywoła standardowe webhooki Fakturowni skonfigurowane dla Twojego konta.

**Uwaga:** Webhooki nie są wywoływane dla faktur zakupowych (wydatków), w tym tych pobranych automatycznie z KSeF.

---

## Pobieranie dokumentów KSeF

Po poprawnej wysyłce faktury do KSeF Fakturownia udostępnia do pobrania XML Faktury i XML UPO. Oba pliki są dostępne do pobrania w załącznikach faktury po zmianie `gov_status` na `ok`.
W przypadku interaktywnej wysyłki faktur do KSeF załączniki będą dostępne od razu. W przypadku wysyłki wsadowej załączniki pojawią się w ciągu godziny. Aktualnie nie da się sprawdzić metody wysyłki faktur do KSeF.

### XML faktury KSeF

Pobierz XML faktury w formacie KSeF:

```
GET /invoices/{ID}/attachment?kind=gov&api_token=TWOJ_TOKEN
```

Zwraca plik XML zgodny ze schematem KSeF (Content-Type: text/xml).

### XML UPO (Urzędowe Poświadczenie Odbioru)

Pobierz XML potwierdzenia:

```
GET /invoices/{ID}/attachment?kind=gov_upo&api_token=TWOJ_TOKEN
```

---

## Wystawca faktury (Issuer)

KSeF pozwala na wskazanie dodatkowego wystawcy faktury (np. biura rachunkowego).

### Dodawanie wystawcy

```json
{
  "api_token": "TWOJ_TOKEN",
  "invoice": {
    "seller_name": "Moja Firma Sp. z o.o.",
    "seller_tax_no": "5252445767",
    ...
    "issuers": [
      {
        "name": "Biuro Rachunkowe ABC",
        "tax_no": "1234567890",
        "company": true,
        "country": "PL",
        "role": "Wystawca faktury"
      }
    ]
  }
}
```

### Dostępne role wystawcy

Role należy podawać po polsku:

| Rola | Opis |
|------|------|
| `Wystawca faktury` | Domyślna rola - podmiot wystawiający fakturę |
| `Faktor` | Instytucja finansowa (faktoring) |
| `Podmiot pierwotny` | Pierwotny wystawca (przy samofakturowaniu) |
| `JST – wystawca` | Jednostka samorządu terytorialnego |
| `Członek GV – wystawca` | Podmiot w grupie VAT |
| `Rola inna` | Własny opis roli podany w polu `role_description` (max 25 znaków) |

---

## Odbiorca faktury (Recipient)

KSeF pozwala na wskazanie dodatkowych odbiorców faktury (np. współwłaścicieli).

### Dodawanie odbiorcy

```json
{
  "api_token": "TWOJ_TOKEN",
  "invoice": {
    "buyer_name": "Firma ABC Sp. z o.o.",
    "buyer_tax_no": "9876543210",
    ...
    "recipients": [
      {
        "name": "Współwłaściciel XYZ Sp. z o.o.",
        "tax_no": "1111111111",
        "company": true,
        "country": "PL",
        "street": "ul. Przykładowa 1",
        "city": "Warszawa",
        "post_code": "00-001",
        "role": "Dodatkowy nabywca",
        "participation": 30.0
      }
    ]
  }
}
```

### Dostępne role odbiorcy

Role należy podawać po polsku:

| Rola | Opis | Pole `participation` |
|------|------|---------------------|
| `Odbiorca` | Odbiorca faktury | Nie |
| `Dodatkowy nabywca` | Współwłaściciel/współnabywca | Tak (% udziału) |
| `Dokonujący płatności` | Podmiot płacący | Nie |
| `JST – odbiorca` | Jednostka samorządu terytorialnego | Nie |
| `Członek GV – odbiorca` | Podmiot w grupie VAT | Nie |
| `Pracownik` | Pracownik | Nie |
| `Rola inna` | Własny opis roli podany w polu `role_description` (max 25 znaków) | Nie |

### Pole `participation`

Dla roli "Dodatkowy nabywca" możesz określić procentowy udział:

```json
{
  "recipients": [
    {
      "name": "Współwłaściciel A",
      "role": "Dodatkowy nabywca",
      "participation": 40.0,
      ...
    },
    {
      "name": "Współwłaściciel B",
      "role": "Dodatkowy nabywca",
      "participation": 30.0,
      ...
    }
  ]
}
```

---

## Rodzaj identyfikatora podatkowego (tax_no_kind)

KSeF pozwala na różne rodzaje identyfikatorów podatkowych dla nabywcy i sprzedawcy. Pole `tax_no_kind` określa typ identyfikatora, co wpływa na walidację i sposób zapisu w XML KSeF.

### Pola API

| Pole | Opis |
|------|------|
| `seller_tax_no_kind` | Rodzaj identyfikatora podatkowego sprzedawcy |
| `buyer_tax_no_kind` | Rodzaj identyfikatora podatkowego nabywcy |

### Dozwolone wartości

| Wartość | Opis | Format identyfikatora |
|---------|------|----------------------|
| `""` (puste) lub brak | NIP (domyślnie) | Polski NIP: 10 cyfr, opcjonalnie z prefiksem kraju (np. `5252445767`, `PL5252445767`) |
| `nip_ue` | NIP UE | Numer VAT UE: 1-12 znaków (cyfry, litery, `+`, `*`), opcjonalnie z prefiksem kraju (np. `DE123456789`, `ATU12345678`) |
| `other` | Numer identyfikacji podatkowej | Dowolny identyfikator: 1-50 znaków alfanumerycznych, opcjonalnie z prefiksem kraju |
| `empty` | Brak identyfikatora | Pole `tax_no` musi być puste |
| `nip_with_id` | NIP z wewnętrznym ID | Polski NIP z 5-cyfrowym identyfikatorem wewnętrznym, format: `{NIP}-{ID}` (np. `5252445767-12345`) |

### Walidacja formatu identyfikatora

System waliduje format `tax_no` zgodnie z wybranym `tax_no_kind`:

| tax_no_kind | Wzorzec (regex) | Przykłady poprawnych wartości |
|-------------|-----------------|-------------------------------|
| `""` (NIP) | `[1-9]((\d[1-9])\|([1-9]\d))\d{7}` | `5252445767`, `PL5252445767` |
| `nip_ue` | `(\d\|[A-Z]\|+\|*){1,12}` | `DE123456789`, `ATU12345678`, `1ABC2` |
| `other` | `[a-zA-Z0-9]{1,50}` | `ABC123`, `1234567890abcdef` |
| `empty` | (pusty string) | `""`, `null` |
| `nip_with_id` | `[1-9]((\d[1-9])\|([1-9]\d))\d{7}[-]\d{5}` | `5252445767-12345`, `PL5252445767-00001` |

**Uwaga:** Prefiks kraju (np. `PL`, `DE`) jest opcjonalny dla wszystkich typów.

### Wpływ na wymagalność pola tax_no

Pole `buyer_tax_no` jest wymagane dla firm (`buyer_company=true`), **chyba że** `buyer_tax_no_kind` jest ustawione na `empty`. Pozwala to na wystawienie faktury dla firmy bez NIP-u (np. dla podmiotów zagranicznych bez europejskiego numeru VAT).

```json
{
  "invoice": {
    "buyer_company": true,
    "buyer_tax_no_kind": "empty",
    "buyer_tax_no": "",
    "buyer_name": "Foreign Company Ltd"
  }
}
```

### Przykłady użycia

#### Nabywca z NIP-em UE (firma zagraniczna)
```json
{
  "invoice": {
    "buyer_company": true,
    "buyer_tax_no_kind": "nip_ue",
    "buyer_tax_no": "DE123456789",
    "buyer_name": "German Company GmbH",
    "buyer_country": "DE"
  }
}
```

#### Nabywca z innym identyfikatorem podatkowym
```json
{
  "invoice": {
    "buyer_company": true,
    "buyer_tax_no_kind": "other",
    "buyer_tax_no": "CHE123456789",
    "buyer_name": "Swiss Company AG",
    "buyer_country": "CH"
  }
}
```

#### Nabywca bez identyfikatora podatkowego
```json
{
  "invoice": {
    "buyer_company": true,
    "buyer_tax_no_kind": "empty",
    "buyer_tax_no": "",
    "buyer_name": "Company Without Tax ID",
    "buyer_country": "US"
  }
}
```

#### Nabywca z NIP i wewnętrznym ID (np. oddział firmy)
```json
{
  "invoice": {
    "buyer_company": true,
    "buyer_tax_no_kind": "nip_with_id",
    "buyer_tax_no": "5252445767-00001",
    "buyer_name": "Firma ABC Sp. z o.o. - Oddział Kraków"
  }
}
```

### Uwagi

- Domyślnie (gdy pole `tax_no_kind` jest puste lub nie jest przekazane) system zakłada standardowy polski NIP.
- Dla `issuers` i `recipients` również dostępne jest pole `tax_no_kind` z tymi samymi dozwolonymi wartościami.
- Przy korekcie faktury pole `buyer_tax_no_kind` nie może być zmienione względem oryginalnej faktury.

---

## Korekty faktur

Tworzenie korekt przez API działa tak samo jak bez KSeF. Główne różnice po włączeniu KSeF:

### Nowe wymagania

1. **Wymagane powiązanie z fakturą** - pole `invoice_id` musi wskazywać na istniejącą fakturę w systemie
2. **Zakaz zmiany niektórych pól** - poniższe pola nie mogą być zmienione względem oryginalnej faktury:
   - Sprzedawca: `department_id`, `seller_tax_no`, `seller_email`, `seller_phone`, `seller_fax`, `seller_www`, `seller_tax_no_kind`, `seller_bdo_no`
   - Nabywca: `buyer_company`, `buyer_tax_no`, `buyer_note`, `buyer_email`, `buyer_phone`, `buyer_mobile_phone`, `buyer_tax_no_kind`
   - Inne: `use_invoice_issuer`, `invoice_issuer`, `use_delivery_address`, `delivery_address`

### Pole `gov_corrected_invoice_number`

W odpowiedzi API dla korekty pojawia się pole `gov_corrected_invoice_number` zawierające numer KSeF korygowanej faktury. Możesz też ustawić je ręcznie przy tworzeniu korekty.

**Uwaga:** W KSeF nie można usunąć faktury - jedynym sposobem "anulowania" jest wystawienie korekty do zera.

---

## Checklista migracji

Użyj tej listy do sprawdzenia gotowości Twojej integracji:

### Przygotowanie

- [ ] Włącz KSeF w trybie demo w Fakturowni
- [ ] Przetestuj wystawianie faktur przez API w trybie demo
- [ ] Sprawdź logi błędów walidacji (`gov_error_messages`)

### Dane na fakturach

- [ ] Uzupełnij wszystkie wymagane pola sprzedawcy (`seller_*`)
- [ ] Uzupełnij NIP nabywcy dla faktur firmowych (`buyer_tax_no`)
- [ ] Sprawdź długość nazw pozycji (max 256 znaków)
- [ ] Sprawdź długość stopki faktury (max 3500 znaków)
- [ ] Dodaj `exempt_tax_kind` dla faktur ze stawką "zw"
- [ ] Dodaj `np_tax_kind` dla faktur ze stawką "np"

### Obsługa odpowiedzi API

- [ ] Obsłuż nowe pola: `gov_status`, `gov_id`, `gov_send_date`
- [ ] Obsłuż pole `gov_error_messages` (tablica błędów)
- [ ] Zdecyduj o ustawieniu "Blokuj zapis faktur niespełniających wymagań KSeF"

### Dokumenty KSeF

- [ ] Przetestuj pobieranie XML faktury
- [ ] Przetestuj pobieranie UPO (XML i PDF)
- [ ] Zapisuj numer KSeF (`gov_id`) w swoim systemie

### Przejście na produkcję

- [ ] Skonfiguruj autoryzację KSeF (token/certyfikat)
- [ ] Włącz KSeF produkcyjny przed 1 lutego 2026
- [ ] Skonfiguruj automatyczną wysyłkę w ustawieniach
- [ ] Monitoruj statusy wysyłki pierwszych faktur

---

## Przykłady curl

### Utworzenie faktury z danymi KSeF

```bash
curl -X POST "https://app.fakturownia.pl/invoices.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "TWOJ_TOKEN",
    "invoice": {
      "kind": "vat",
      "issue_date": "2026-02-01",
      "place": "Warszawa",
      "sell_date": "2026-02-01",
      "payment_to": "2026-02-15",
      "payment_type": "transfer",

      "seller_name": "Moja Firma Sp. z o.o.",
      "seller_tax_no": "5252445767",
      "seller_street": "ul. Przykładowa 10",
      "seller_post_code": "00-001",
      "seller_city": "Warszawa",
      "seller_country": "PL",

      "buyer_name": "Klient ABC Sp. z o.o.",
      "buyer_tax_no": "9876543210",
      "buyer_street": "ul. Testowa 5",
      "buyer_post_code": "00-002",
      "buyer_city": "Kraków",
      "buyer_country": "PL",
      "buyer_company": true,

      "positions": [
        {
          "name": "Usługa programistyczna",
          "quantity": 10,
          "quantity_unit": "godz.",
          "total_price_gross": 1845,
          "tax": 23
        }
      ]
    }
  }'
```

### Utworzenie faktury i wysłanie do KSeF w jednym kroku

Podaj parametr `gov_save_and_send` w URL lub w body.

```bash
curl -X POST "https://app.fakturownia.pl/invoices.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "TWOJ_TOKEN",
    "gov_save_and_send": true,
    "invoice": {
      "kind": "vat",
      ...
    }
  }'
```

### Wysłanie istniejącej faktury do KSeF

Podaj parametr `send_to_ksef` w URL lub w body.

```bash
curl -X GET "https://app.fakturownia.pl/invoices/12345.json?send_to_ksef=yes&api_token=TWOJ_TOKEN"
```

### Sprawdzenie statusu faktury

```bash
curl -X GET "https://app.fakturownia.pl/invoices/12345.json?api_token=TWOJ_TOKEN&fields[invoice]=id,number,gov_status,gov_id,gov_send_date,gov_sell_date,gov_error_messages,gov_verification_link,gov_link,gov_corrected_invoice_number"
```

Odpowiedź (fragment):
```json
{
  "id": 12345,
  "number": "FV/1/2026",
  "gov_status":"ok",
  "gov_id":"5213704420-20260215-ABC123DEF456",
  "gov_corrected_invoice_number":null,
  "gov_sell_date":"2026-02-01T00:00:00.000+01:00",
  "gov_send_date":"2026-02-01T10:30:00.000+01:00",
  "gov_error_messages":null,
  "gov_verification_link":"https://ksef.mf.gov.pl/web/verify/5213704420-20260215-ABC123DEF456/YwucKLcs88uk",
  "gov_link":"https://ksef.mf.gov.pl/invoice/123"
}
```

### Pobranie XML faktury KSeF i UPO

XML faktury zgodny ze schematem KSeF (Content-Type: text/xml):
```
GET /invoices/{ID}/attachment?kind=gov&api_token=TWOJ_TOKEN
```

XML UPO (Urzędowe Potwierdzenie Odbioru):
```
GET /invoices/{ID}/attachment?kind=gov_upo&api_token=TWOJ_TOKEN
```

Możliwe odpowiedzi:
- **HTTP 302** - przekierowanie do pobierania pliku (plik jest gotowy)
- **HTTP 404** - brak danego pliku dla tej faktury

### Rozbudowany przykład (issuer, recipient, stawka zw)

Przykład faktury zawierającej wszystkie opcjonalne elementy KSeF: wystawcę (issuer), dodatkowego odbiorcę (recipient) oraz pozycję ze stawką zwolnioną:

```bash
curl -X POST "https://app.fakturownia.pl/invoices.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "TWOJ_TOKEN",
    "invoice": {
      "kind": "vat",
      "seller_name": "Klinika Medyczna Sp. z o.o.",
      "seller_tax_no": "5252445767",
      "seller_street": "ul. Zdrowia 10",
      "seller_post_code": "00-001",
      "seller_city": "Warszawa",

      "buyer_name": "Firma Pacjent Sp. z o.o.",
      "buyer_tax_no": "9876543210",
      "buyer_street": "ul. Biznesowa 5",
      "buyer_post_code": "00-002",
      "buyer_city": "Kraków",
      "buyer_company": true,

      "exempt_tax_kind": "Zwolnienie ze względu na rodzaj prowadzonej działalności (art. 43 ust 1 ustawy o VAT)",

      "positions": [
        {
          "name": "Konsultacja lekarska",
          "quantity": 2,
          "total_price_gross": 400.00,
          "tax": "zw"
        },
        {
          "name": "Badanie laboratoryjne",
          "quantity": 1,
          "total_price_gross": 123.00,
          "tax": 23
        }
      ],

      "issuers": [
        {
          "name": "Biuro Rachunkowe XYZ",
          "tax_no": "1111111111",
          "company": true,
          "country": "PL",
          "role": "Wystawca faktury"
        }
      ],

      "recipients": [
        {
          "name": "Współwłaściciel A Sp. z o.o.",
          "tax_no": "2222222222",
          "company": true,
          "country": "PL",
          "street": "ul. Partnerska 1",
          "city": "Gdańsk",
          "post_code": "80-001",
          "role": "Dodatkowy nabywca",
          "participation": 40.0
        }
      ]
    }
  }'
```

---

## FAQ i rozwiązywanie problemów

### Często zadawane pytania

**Q: Jak sprawdzić czy moja faktura przeszła walidację KSeF?**

Sprawdź pole `gov_error_messages` w odpowiedzi API:
```bash
curl "https://app.fakturownia.pl/invoices/12345.json?fields[invoice]=gov_error_messages&api_token=TWOJ_TOKEN"
```
Jeśli pole jest puste (`null` lub `[]`), faktura jest poprawna.

**Q: Faktura ma status `send_error` - co robić?**

1. Sprawdź szczegóły błędu w `gov_error_messages`
2. Popraw dane faktury (edycja przez API lub panel)
3. Wyślij ponownie: `?send_to_ksef=yes`

**Q: Jak długo trwa wysyłka do KSeF?**

Typowo kilka sekund. Status `processing` oznacza, że faktura jest w kolejce. Po przetworzeniu zmieni się na `ok` lub `send_error`.

**Q: Czy mogę edytować fakturę wysłaną do KSeF?**

Nie. Po otrzymaniu numeru KSeF (`gov_id`) edycja faktury jest zablokowana. Zmiany można wprowadzić tylko przez wystawienie korekty.

**Q: Co oznacza status `server_error`?**

Problem po stronie serwerów KSeF. Poczekaj kilka minut i spróbuj ponownie wysłać fakturę. Fakturownia nie ponawia wysyłki.

### Najczęstsze błędy walidacji

| Błąd | Przyczyna | Rozwiązanie |
|------|-----------|-------------|
| "NIP nabywcy - nie może być puste" | Brak `buyer_tax_no` dla firmy | Dodaj NIP lub ustaw `buyer_company: false` |
| "Telefon klienta - pole jest za długie" | `buyer_phone` > 16 znaków | Skróć numer telefonu |
| "podstawa zwolnienia z podatku VAT - nie może być puste" | Stawka "zw" bez `exempt_tax_kind` | Dodaj pole `exempt_tax_kind` |
| "Nazwa pozycji - pole jest za długie" | `positions[].name` > 256 znaków | Skróć nazwę pozycji |

### Retry logic - zalecenia

Dla statusu `server_error` zalecamy:
1. Odczekaj minutę
2. Sprawdź status faktury
3. Jeśli nadal `server_error`, ponów wysyłkę do KSeF `?send_to_ksef=1` i poczekaj 5 minut
4. Powtórz maksymalnie 3 razy, zwiększając odstępy czasowe
5. Jeśli problem nadal występuje, sprawdź status KSeF na stronie MF

---

## Pomoc

### Dokumentacja Fakturowni
- Dokumentacja API: [github.com/fakturownia/API](https://github.com/fakturownia/API)
- Wsparcie techniczne: kontakt przez panel Fakturowni

### Oficjalna dokumentacja KSeF
- Portal KSeF: [ksef.mf.gov.pl](https://ksef.mf.gov.pl)
- Środowisko testowe (DEMO): [ksef-demo.mf.gov.pl](https://ksef-demo.mf.gov.pl)
- Specyfikacja schematu FA(3): [Ministerstwo Finansów - struktury](https://ksef.podatki.gov.pl/informacje-ogolne-ksef-20/struktura-logiczna-fa-3/)

### Wersja schematu

Fakturownia używa schematu **FA(3)** - aktualnej wersji struktury faktur KSeF. Schemat definiuje:
- Wymagane i opcjonalne pola faktury
- Formaty danych (np. NIP, daty, kwoty)
- Ograniczenia długości pól
- Dozwolone wartości dla pól wyliczeniowych

Pełna specyfikacja schematu dostępna jest na stronie Ministerstwa Finansów.
