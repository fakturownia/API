# API - Rachunki bankowe na fakturach

## Spis treści

1. [Wprowadzenie](#1-wprowadzenie)
2. [Pobieranie rachunków bankowych z faktury](#2-pobieranie-rachunków-bankowych-z-faktury)
3. [Tworzenie faktury z rachunkami bankowymi](#3-tworzenie-faktury-z-rachunkami-bankowymi)
4. [Zarządzanie rachunkami bankowymi (CRUD)](#4-zarządzanie-rachunkami-bankowymi-crud)
5. [Kopiowanie faktur](#5-kopiowanie-faktur)
6. [Płatności masowe (Mass Payments)](#6-płatności-masowe-mass-payments)
7. [Zabezpieczenia rachunków bankowych](#7-zabezpieczenia-rachunków-bankowych)
8. [Obsługa błędów](#8-obsługa-błędów)
9. [FAQ](#9-faq)

---

## 1. Wprowadzenie

Każda faktura może mieć przypisany jeden lub wiele **rachunków bankowych sprzedawcy**, które wyświetlają się na wydruku dokumentu.

### Kluczowe zasady

- Jeśli przy tworzeniu faktury **nie podasz** rachunków bankowych → faktura automatycznie otrzyma rachunki z **działu** (te oznaczone jako widoczne na fakturze).
- Jeśli **podasz** rachunki bankowe → faktura otrzyma **wyłącznie** podane rachunki (domyślne rachunki z działu nie są dodawane).
- System wykonuje **deduplikację** numerów rachunków - jeśli rachunek o tym samym numerze już istnieje, zostanie użyty zamiast tworzyć duplikat.

### Format numeru rachunku


Każdy rachunek posiada dwa formaty numeru:

| Pole | Przykład | Opis |
|------|---------|------|
| `bank_account_number` | `"PL 35 1090-2402-4713 1271 5624 3889"` | Numer w oryginalnym formacie (ze spacjami, myślnikami) |
| `formatted_bank_account_number` | `"PL35109024024713127156243889"` | Numer znormalizowany - **używaj do porównań i identyfikacji** |

---

## 2. Pobieranie rachunków bankowych z faktury

### Żądanie

```http
GET /invoices/{id}.json?api_token=API_TOKEN
```

Pole `bank_accounts` jest zwracane automatycznie w odpowiedzi.

### Przykład

```bash
curl "https://twojaDomena.fakturownia.pl/invoices/462474440.json?api_token=API_TOKEN"
```

### Odpowiedź (200 OK)

```json
{
  "id": 462474440,
  "number": "15/02/2026",
  "kind": "vat",
  "seller_name": "Szymon Lach",
  "buyer_name": "Dalajlama",
  "price_gross": "2.46",
  "currency": "PLN",
  "...": "...",
  "bank_accounts": [
    {
      "id": 428554,
      "name": "Rachunek główny",
      "bank_name": "ING Bank Śląski",
      "bank_account_number": "PL00000000000000000000000000",
      "formatted_bank_account_number": "PL00000000000000000000000000",
      "bank_currency": "PLN",
      "bank_swift": null
    }
  ]
}
```

### Opis pól obiektu rachunku bankowego

| Pole | Typ | Opis |
|------|-----|------|
| `id` | integer | Identyfikator rachunku bankowego |
| `name` | string | Nazwa rachunku bankowego (np. „Rachunek główny PLN") |
| `bank_name` | string | Nazwa banku |
| `bank_account_number` | string | Numer rachunku w oryginalnym formacie |
| `formatted_bank_account_number` | string | Znormalizowany numer rachunku - do porównań i deduplikacji |
| `bank_currency` | string | Waluta rachunku (np. `"PLN"`, `"EUR"`) |
| `bank_swift` | string \| null | Kod SWIFT banku |

---

## 3. Tworzenie faktury z rachunkami bankowymi

### Endpoint

```http
POST /invoices.json
```

Do przypisania rachunków bankowych przy tworzeniu faktury służy parametr `bank_accounts`.
Podaj tablicę obiektów z numerem rachunku. System wyszuka istniejący rachunek po numerze - jeśli nie znajdzie, utworzy nowy.

### Przykład żądania

```bash
curl -X POST "https://twojaDomena.fakturownia.pl/invoices.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "API_TOKEN",
    "invoice": {
      "kind": "vat",
      "buyer_name": "Klient Sp. z o.o.",
      "positions": [
        {"name": "Usługa", "tax": 23, "total_price_gross": 123.00, "quantity": 1}
      ],
      "bank_accounts": [
        {
          "bank_account_number": "PL61 1090 1014 0000 0712 1981 2874",
          "bank_name": "Santander Bank Polska",
          "bank_currency": "EUR",
          "bank_swift": "WBKPPLPP"
        }
      ]
    }
  }'
```

#### Atrybuty

| Pole | Wymagane | Domyślna wartość | Opis |
|------|----------|------------------|------|
| `bank_account_number` | **TAK** | - | Numer rachunku bankowego |
| `bank_name` | NIE | `"Rachunek bankowy"` | Nazwa banku |
| `bank_currency` | NIE | Waluta działu | Waluta rachunku |
| `bank_swift` | NIE | `null` | Kod SWIFT banku |

---

### Deduplikacja

Jeśli w żądaniu podasz `bank_account_number` rachunku, który **już istnieje** - system użyje istniejącego rekordu. Atrybuty z żądania (np. `bank_name`) zostaną **zignorowane** - zachowane zostaną oryginalne dane rachunku.

---

### Zachowanie domyślne (bez podania `bank_accounts`)

Jeśli żądanie **nie zawiera** parametru `bank_accounts` → faktura automatycznie otrzymuje rachunki z **działu**, które mają włączoną opcję wyświetlania na fakturze (`show_on_invoice`).

---

### Nadpisywanie domyślnych rachunków z działu

Jeśli dział ma 2 rachunki domyślne, a API przekazuje `bank_accounts` z 1 rachunkiem → faktura będzie miała **tylko 1 rachunek** (ten z żądania API). Domyślne rachunki z działu **nie są dokładane**.

```
Dział:  2 domyślne rachunki (PLN + EUR)
API:    bank_accounts: [{ bank_account_number: "PL77..." }]
Wynik:  faktura ma TYLKO rachunek PL77...
```

---

### Przykład odpowiedzi POST (201 Created)

```json
{
  "id": 462474442,
  "number": "17/02/2026",
  "kind": "vat",
  "buyer_name": "Test Client API",
  "price_gross": "123.0",
  "...": "...",
  "bank_accounts": [
    {
      "id": 428549,
      "name": null,
      "bank_name": "Test Bank",
      "bank_account_number": "PL61 1090 1014 0000 0712 1981 2874",
      "formatted_bank_account_number": "PL61109010140000071219812874",
      "bank_currency": "EUR",
      "bank_swift": "NEWSWIFT"
    }
  ],
  "positions": [...]
}
```

---

## 4. Zarządzanie rachunkami bankowymi (CRUD)

### Tworzenie rachunku

```http
POST /bank_accounts.json
```

### Przykład żądania

```bash
curl -X POST "https://twojaDomena.fakturownia.pl/bank_accounts.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "API_TOKEN",
    "bank_account": {
      "name": "Rachunek główny PLN",
      "bank_account_number": "PL61 1090 1014 0000 0712 1981 2874",
      "bank_name": "Santander Bank Polska",
      "bank_currency": "PLN",
      "bank_swift": "WBKPPLPP"
    }
  }'
```

#### Atrybuty

| Pole | Wymagane | Opis |
|------|----------|------|
| `name` | **TAK** | Nazwa rachunku (wyświetlana w systemie) |
| `bank_account_number` | **TAK** | Numer rachunku bankowego |
| `bank_name` | NIE | Nazwa banku |
| `bank_currency` | NIE | Waluta rachunku |
| `bank_swift` | NIE | Kod SWIFT banku |

#### Powiązanie z działem (opcjonalne)

Aby rachunek automatycznie pojawiał się na fakturach z danego działu, dodaj `bank_account_version_departments`:

```json
{
  "bank_account": {
    "name": "Rachunek główny PLN",
    "bank_account_number": "PL61 1090 1014 0000 0712 1981 2874",
    "bank_name": "Santander Bank Polska",
    "bank_account_version_departments": [
      {
        "department_id": 123,
        "show_on_invoice": true,
        "main_on_department": true
      }
    ]
  }
}
```

| Pole | Typ | Opis |
|------|-----|------|
| `department_id` | integer | ID działu |
| `remove` | boolean | `true` = usuwa powiązanie z działem |
| `main_on_department` | boolean | Czy to główny rachunek działu (jeden na dział) |
| `show_on_invoice` | boolean | Czy rachunek domyślnie wyświetla się na fakturach z tego działu |

#### Przykład odpowiedzi (201 Created)

```json
{
  "id": 1,
  "name": "Rachunek główny PLN",
  "bank_name": "Santander Bank Polska",
  "bank_account_number": "PL61 1090 1014 0000 0712 1981 2874",
  "formatted_bank_account_number": "PL61109010140000071219812874",
  "bank_currency": "PLN",
  "bank_swift": "WBKPPLPP",
  "bank_account_id": 1,
  "main": true,
  "show_on_invoice": false,
  "main_on_department": false
}
```

> **Uwaga:** Pole `id` i `bank_account_id` zawsze mają tę samą wartość - identyfikator rachunku bankowego.

### Aktualizacja rachunku

```http
PUT /bank_accounts/{id}.json
```

### Przykład żądania

```bash
curl -X PUT "https://twojaDomena.fakturownia.pl/bank_accounts/1.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "API_TOKEN",
    "bank_account": {
      "name": "Zaktualizowany rachunek",
      "bank_account_number": "PL61 1090 1014 0000 0712 1981 2874",
      "bank_name": "Nowa nazwa banku",
      "bank_currency": "PLN",
      "bank_swift": "WBKPPLPP"
    }
  }'
```

### Odpowiedź (200 OK)

Zwraca zaktualizowany obiekt rachunku (format jak w przykładzie tworzenia).

### Usuwanie rachunku

```http
DELETE /bank_accounts/{id}.json
```

### Przykład żądania

```bash
curl -X DELETE "https://twojaDomena.fakturownia.pl/bank_accounts/1.json?api_token=API_TOKEN"
```

### Odpowiedź (200 OK)

```json
{
  "code": "success"
}
```

### Lista rachunków

```http
GET /bank_accounts.json?api_token=API_TOKEN
```

### Przykład żądania

```bash
curl "https://twojaDomena.fakturownia.pl/bank_accounts.json?api_token=API_TOKEN"
```

### Odpowiedź (200 OK)

Tablica obiektów rachunków bankowych (format jak w przykładzie odpowiedzi tworzenia).

```json
[
  {
    "id": 1,
    "name": "BANK",
    "bank_name": "ING",
    "bank_account_number": "00000000000000000000000001",
    "formatted_bank_account_number": "00000000000000000000000001",
    "bank_currency": "PLN",
    "bank_swift": "Switft",
    "bank_account_id": 1,
    "main": true,
    "show_on_invoice": false,
    "main_on_department": false
  }
]
```

---

## 5. Kopiowanie faktur

### Endpoint

```http
POST /invoices.json
```

### Przykład żądania

```bash
curl -X POST "https://twojaDomena.fakturownia.pl/invoices.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "API_TOKEN",
    "invoice": {
      "copy_invoice_from": 12345
    }
  }'
```

> **Uwaga:** Parametry `copy_invoice_from` i `positions` wzajemnie się wykluczają.

### Zachowanie rachunków bankowych

**Zasada:** Skopiowana faktura **zawsze** otrzymuje rachunki z **działu** - niezależnie od tego, jakie rachunki miała faktura źródłowa.

| Faktura źródłowa | Wynik na kopii |
|-------------------|---------------|
| Bez rachunków | Rachunki z działu |
| Z 1 rachunkiem | Rachunki z działu (nie ze źródła) |
| Z wieloma rachunkami | Rachunki z działu (nie ze źródła) |
| Z rachunkiem w EUR (dział w PLN) | Rachunki z działu (PLN) |

Jest to zabezpieczenie przed kopiowaniem nieaktualnych numerów rachunków bankowych.

Aby przypisać **konkretny rachunek** do nowej faktury, użyj parametru `bank_accounts` z `positions`:

```bash
curl -X POST "https://twojaDomena.fakturownia.pl/invoices.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "API_TOKEN",
    "invoice": {
      "kind": "vat",
      "buyer_name": "Klient Sp. z o.o.",
      "positions": [
        {"name": "Usługa", "tax": 23, "total_price_gross": 123.00, "quantity": 1}
      ],
      "bank_accounts": [
        {
          "bank_account_number": "PL21 2121 2121 2121 2121 2121 2121",
          "bank_name": "Bank z API"
        }
      ]
    }
  }'
```

---

## 6. Płatności masowe (Mass Payments)

### Jak działają?

System automatycznie generuje numer rachunku bankowego na podstawie wzorca działu i kodu klienta:

```
Numer rachunku = mass_payment_pattern + mass_payment_code

Przykład:
  pattern = "PL00 0000 0000 0000 0000 0000 03"
  code    = "99"
  wynik   = "PL00 0000 0000 0000 0000 0000 0399"
```

### Warunki

Wszystkie poniższe warunki muszą być spełnione:

- Na rachunku włączone: `use_mass_payment = true`
- Na dziale włączone: `use_mass_payment = true`
- Na dziale ustawiony: `mass_payment_pattern`
- Na kliencie ustawiony: `mass_payment_code`

### Priorytet

Mass payment ma **priorytet** nad domyślnymi rachunkami z działu. Gdy warunki są spełnione, faktura otrzyma rachunek mass_payment zamiast domyślnych rachunków działu.

### Tworzenie faktury dla klienta z mass_payment

```bash
curl -X POST "https://twojaDomena.fakturownia.pl/invoices.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "API_TOKEN",
    "invoice": {
      "kind": "vat",
      "buyer_name": "Klient z MPC",
      "client_id": 789,
      "department_id": 1,
      "positions": [
        {"name": "Usługa", "tax": 23, "total_price_gross": 123.00, "quantity": 1}
      ]
    }
  }'
```

Jeśli klient `789` ma `mass_payment_code = "01"` i dział ma ustawiony wzorzec, faktura automatycznie otrzyma odpowiedni rachunek.

### Nadpisywanie kodu klienta (`buyer_mass_payment_code`)

API pozwala na przekazanie kodu mass_payment klienta przy tworzeniu faktury z flagą `buyer_override: true`:

```bash
curl -X POST "https://twojaDomena.fakturownia.pl/invoices.json" \
  -H "Content-Type: application/json" \
  -d '{
    "api_token": "API_TOKEN",
    "invoice": {
      "kind": "vat",
      "buyer_name": "Klient Sp. z o.o.",
      "client_id": 789,
      "buyer_mass_payment_code": "99",
      "buyer_override": true,
      "department_id": 1,
      "positions": [
        {"name": "Usługa", "tax": 23, "total_price_gross": 123.00, "quantity": 1}
      ]
    }
  }'
```

**Zachowanie zależy od poziomu zabezpieczeń i stanu klienta:**

#### Klient MA istniejący kod (np. `"01"`), API przekazuje `"99"`

| Zabezpieczenie | Wynik |
|----------------|-------|
| `none` | ✅ Kod zmieniony na `"99"` - na fakturze i na kliencie |
| `normal` / `strong` | ❌ System wymusza oryginalny kod klienta `"01"` |

#### Klient BEZ kodu, API przekazuje `"99"`

| Zabezpieczenie | Wynik |
|----------------|-------|
| `none` | ✅ Kod ustawiony na `"99"` - na fakturze i na kliencie |
| `normal` / `strong` | ❌ **Błąd 422** - nie można ustawić nowego kodu przy zabezpieczeniach |

---

## 7. Zabezpieczenia rachunków bankowych

### Poziomy zabezpieczeń

| Poziom | Opis |
|--------|------|
| `none` | Brak zabezpieczenia - każdy użytkownik może zmieniać rachunki |
| `normal` | Tylko admin może **tworzyć** nowe rachunki. Rachunki na fakturze są **wymuszane z działu** |
| `strong` | Nawet admin nie może zmieniać - tylko operator |

### Tworzenie faktury bez podania `bank_accounts`

Niezależnie od poziomu zabezpieczeń, faktura zawsze otrzymuje domyślne rachunki z działu:

| Zabezpieczenie | Rola | Wynik |
|----------------|------|-------|
| `none` | dowolna | Rachunki z działu ✓ |
| `normal` | dowolna | Rachunki z działu ✓ |
| `strong` | dowolna | Rachunki z działu ✓ |

### Tworzenie nowych rachunków przez `bank_accounts` (atrybuty)

| Zabezpieczenie | Rola | Rachunek istnieje? | Wynik |
|----------------|------|-----------------|-------|
| `none` | dowolna | Nie | ✅ Tworzy nowy rachunek |
| `none` | dowolna | Tak | ✅ Używa istniejącego rachunku |
| `normal` | member | Nie | ❌ Ignorowane - faktura dostaje rachunki z działu |
| `normal` | member | Tak | ✅ Używa istniejącego rachunku (deduplikacja) |
| `normal` | admin | Nie | ✅ Tworzy nowy rachunek |
| `strong` | admin | Nie | ❌ Ignorowane - faktura dostaje rachunki z działu |

> **Uwaga:** Rachunki mass_payment są tworzone automatycznie przez system i **działają niezależnie od poziomu zabezpieczeń**.

---

## 8. Obsługa błędów

### Typowe błędy

| Kod | Sytuacja | Przykład odpowiedzi |
|-----|----------|---------------------|
| `422` | Brak `bank_account_number` w atrybutach | `{"code": "error", "message": {"bank_accounts": ["can't be blank"]}}` |
| `422` | Próba ustawienia `buyer_mass_payment_code` przy `security != none` dla klienta bez kodu | `422 Unprocessable Entity` |
| `404` | Rachunek bankowy nie istnieje (CRUD) | `{"code": "error", "message": "Not found"}` |

---

## 9. FAQ

### Dlaczego skopiowana faktura ma inne rachunki niż źródłowa?

Skopiowana faktura zawsze otrzymuje rachunki z **działu**, nie ze źródłowej faktury. Jest to zabezpieczenie przed używaniem nieaktualnych numerów rachunków na nowych dokumentach.

### Jak przypisać konkretny rachunek do faktury?

Użyj parametru `bank_accounts` z atrybutami rachunku (przede wszystkim `bank_account_number`). Rachunki podane jawnie mają **priorytet** nad domyślnymi rachunkami z działu.

### Jak działa deduplikacja?

System normalizuje numer rachunku (usuwa spacje i myślniki, dodaje prefix kraju) i porównuje z istniejącymi rachunkami. Jeśli znajdzie pasujący numer - użyje istniejącego rekordu zamiast tworzyć nowy.

### Dlaczego nie mogę zmienić rachunku na fakturze?

Sprawdź poziom zabezpieczeń (`bank_account_security_level`) na rachunku. Przy `normal` i `strong` system wymusza rachunki z działu. Przy `normal` tylko admin może tworzyć nowe rachunki.

### Czy nie-admin może tworzyć nowe rachunki?

| Zabezpieczenie | Wynik |
|----------------|-------|
| `none` | ✅ Tak |
| `normal` | ❌ Nie (ale może użyć istniejącego rachunku) |
| `strong` | ❌ Nie |

Wyjątek: rachunki mass_payment są tworzone automatycznie przez system i działają niezależnie od zabezpieczeń i roli użytkownika.

---

## Podsumowanie - skąd faktura bierze rachunki?

| Scenariusz | Źródło rachunków |
|------------|----------------|
| API z `bank_accounts` | Podane rachunki |
| API bez rachunków | Dział (domyślne rachunki z `show_on_invoice`) |
| `copy_invoice_from` | Dział |
| Klient z mass_payment_code | Rachunek mass_payment (priorytet nad działem) |
