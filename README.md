# Fakturownia API


Opis jak zintegrować własną aplikację lub serwis z systemem [Fakturownia.pl](https://fakturownia.pl)

Dzięki API można z innych systemów wystawiać faktury/rachunki/paragony oraz zarządzać tymi dokumentami, a także klientami i produktami.

Działające przykłady wywołania API Fakturowni znajdują się też w w systemie Fakturownia (po zalogowaniu) w menu <b>Ustawienia > API</b> oraz na stronie: https://app.fakturownia.pl/api

## Spis treści
+ [API Token](#token)
+ [Dodatkowe parametry dostępne przy pobieraniu listy rekordów](#list_params)
+ [Faktury - przykłady wywołania](#examples)
	+ [Pobranie listy faktur z aktualnego miesiąca](#f1)
	+ [Pobranie listy faktur wraz z ich pozycjami](#f2)
	+ [Faktury danego klienta](#f3)
	+ [Pobranie faktury po ID](#f4)
	+ [Pobranie PDF-a](#f5)
	+ [Wysłanie faktury E-MAILEM do klienta](#f6)
	+ [Dodanie nowej faktury](#f7)
	+ [Dodanie nowej faktury (po ID klienta, produktu, sprzedawcy)](#f8)
	+ [Dodanie faktury podobnej (po ID innej faktury, np. zaliczkowej z zamówienia, końcowej z zaliczkowych itp.)](#f8b)
	+ [Dodanie faktury OSS](#f8c)
	+ [Dodanie nowej faktury korygującej](#f9)
    + [Dodanie faktury kosztowej](#f21)
	+ [Aktualizacja faktury](#f10)
	+ [Aktualizacja pozycji na fakturze](#f10b)
	+ [Usunięcie pozycji na fakturze](#f10c)
	+ [Dodanie pozycji na fakturze](#f10d)
	+ [Zmiana statusu faktury](#f11)
	+ [Pobranie listy definicji faktur cyklicznych](#f12)
	+ [Dodanie definicji faktury cyklicznej](#f13)
	+ [Aktualizacja definicji faktury cyklicznej](#f14)
	+ [Usunięcie faktury](#f15)
	+ [Anulowanie faktury](#f16)
	+ [Połączenie istniejącej faktury i paragonu](#f17)
    	+ [Dodawanie faktury do istniejącego paragonu](#f17b)
	+ [Pobranie załączników w archiwum ZIP](#f18)
	+ [Dodanie załącznika](#f18b)
	+ [Wydruk fiskalny](#f19)
	+ [Faktura korekta](#f20)
    + [Dodanie domyślnych uwag z ustawień konta](#f21)
    + [Zaczytanie cen produktów z cennika podczas wystawiania faktury](#f22)
    + [Pobranie faktury razem z połączonymi płatnościami](#f23)
    + [Odbiorcy/Wystawcy na fakturze](#f24)
+ [Link do podglądu faktury i pobieranie do PDF](#view_url)
+ [Przykłady użycia  - zakup szkolenia](#use_case1)
+ [Faktury - specyfikacja, rodzaje pól, kody GTU](#invoices)
+ [Klienci](#clients)
	+ [Lista klientów](#k1)
	+ [Wyszukiwanie klientów po nazwie, mailu, nazwie skróconej lub numerze NIP](#k1b)
	+ [Pobranie wybranego klienta po ID](#k2)
	+ [Pobranie wybranego klienta po zewnętrznym ID](#k2b)
	+ [Dodanie klienta](#k3)
	+ [Aktualizacja klienta](#k4)
	+ [Usunięcie klienta](#k5)
+ [Produkty](#products)
	+ [Lista produktów](#p1)
	+ [Lista produktów ze stanem magazynowym podanego magazynu](#p2)
	+ [Pobranie wybranego produktu po ID](#p3)
	+ [Pobranie wybranego produktu po ID ze stanem magazynowym podanego magazynu](#p4)
	+ [Dodanie produktu](#p5)
    + [Dodanie produktu, który jest zestawem](#p5b)
	+ [Aktualizacja produktu](#p6)
+ [Cenniki](#price_lists)
	+ [Lista cenników](#pricel1)
	+ [Dodanie cennika](#pricel2)
	+ [Aktualizacja cennika](#pricel3)
	+ [Usunięcie cennika](#pricel4)
+ [Dokumenty magazynowe](#warehouse_documents)
	+ [Wszystkie dokumenty magazynowe](#wd1)
	+ [Pobranie wybranego dokumentu po ID](#wd2)
	+ [Dodanie dokumentu magazynowego MM](#wd3a)
	+ [Dodanie dokumentu magazynowego PZ](#wd3)
	+ [Dodanie dokumentu magazynowego WZ](#wd4)
	+ [Dodanie dokumentu magazynowego PZ dla istniejącego klienta, działu i produktu](#wd5)
	+ [Aktualizacja dokumentu](#wd6)
	+ [Usunięcie dokumentu](#wd7)
	+ [Połączenie istniejących faktur i dokumentu magazynowego](#wd8)
+ [Płatności](#payments)
	+ [Wszystkie płatności](#pl1)
	+ [Pobranie wybranej płatności po ID](#pl2)
	+ [Dodanie nowej płatności](#pl3)
	+ [Pobranie płatności wraz z danymi przypiętych faktur](#pl4)
	+ [Dodanie nowej płatności powiązanej z istniejącymi fakturami](#pl5)
	+ [Aktualizacja płatności](#pl6)
	+ [Usuwanie płatności](#pl7)
+ [Kategorie](#categories)
	+ [Lista kategorii](#cat1)
	+ [Pobranie wybranej kategorii po ID](#cat2)
	+ [Dodanie nowej kategorii](#cat3)
	+ [Aktualizacja kategorii](#cat4)
	+ [Usunięcie kategorii o podanym ID](#cat5)
+ [Magazyny](#warehouses)
	+ [Lista magazynów](#wh1)
	+ [Pobranie wybranego magazynu po ID](#wh2)
	+ [Dodanie nowego magazynu](#wh3)
	+ [Aktualizacja magazynu](#cat4)
	+ [Usunięcie magazynu o podanym ID](#cat5)
+ [Akcje magazynowe](#warehouse_actions)
	+ [Lista akcji magazynowych](#wa1)
+ [Działy](#departments)
	+ [Lista działów](#dep1)
	+ [Pobranie wybranego działu po ID](#dep2)
	+ [Dodanie nowego działu](#dep3)
	+ [Aktualizacja_działu](#dep4)
  	+ [Usunięcie działu o podanym ID](#dep5)
	+ [Dodanie logo](#dep6)
+ [Wystawcy](#issuers)
	+ [Lista wystawców](#issuers1)
	+ [Pobranie wystawcy po ID](#issuers2)
	+ [Dodanie nowego wystawcy](#issuers3)
	+ [Aktualizacja wystawcy](#issuers4)
    + [Usunięcie wystawcy po ID](#issuers5)
+ [Logowanie i pobranie Tokena przez API](#get_token_by_api)
+ [Dodawanie użytkowników](#usersystem)
+ [Konta systemowe](#accounts)
    + [Zakładanie konta](#a1)
    + [Pobieranie informacji o koncie](#a2)
    + [Usuwanie konta](#a3)
    + [Odłączanie konta](#a4)
+ [Przykłady w PHP i Ruby](#codes)
+ [Webhooki](#webhooks)
+ [E-paragony i Paragony papierowe](#eparagony)
+ [KSeF - Przewodnik integracji](KSeF.md)

<a name="token"></a>

## API token

`API_TOKEN` token trzeba pobrać z ustawień aplikacji ("Ustawienia -> Ustawienia konta -> Integracja -> Kod autoryzacyjny API")

<a name="list_params"></a>

## Dodatkowe parametry dostępne przy pobieraniu listy rekordów
Do wywołań można przekazywać dodatkowe parametry - te same które są używane w aplikacji, np. `page=`, `period=` itp.

Parametr `page=` umożliwia iterowanie po paginowanych rekordach.
Domyślnie przyjmuje wartość `1` i wyświetla pierwsze N rekordów, gdzie N to limit ilości zwracanych rekordów. Aby uzyskać kolejne N rekordów, należy wywołać akcję z parametrem `page=2`, itd.

N można ustawiać za pomocą parametru `per_page=` (gdzie 100 to jego maksymalna wartość).

Parametr `period=` umożliwia wybranie rekordów z zadanego okresu.
Może przyjąć następujące wartości:
```shell
- last_12_months
- this_month
- last_30_days
- last_month
- this_year
- last_year
- all
- more (tutaj trzeba jeszcze dostarczyć dodatkowe parametry date_from (np. "2018-12-16") i date_to (np. "2018-12-21"))
```

Parametr `include_positions=` z wartością `true` umożliwia pobranie listy rekordów wraz z ich pozycjami

Parametr `income=` z wartością `no` umożliwia pobranie faktur kosztowych (wydatków)

Parametr `invoice_ids` umożliwia przekazanie id faktur do pobrania np.: `invoice_ids=123,456,789`

Parametr `number=` umożliwia pobranie faktury o wskazanym numerze

Parametr `kind=` pozwala pobrać tylko jeden konkretny rodzaj dokumentów np.: `kind=accounting_note`

Parametr `kinds=` pozwala wybrać kilka różnych rodzajów dokumentów np.: `&kinds[]=vat&kinds[]=proforma`

Parametr `search_date_type=` określa po jakiej dacie chcemy wyszukiwać dokumenty. Może przyjmować następujące wartości:

```shell
`issue_date` - data wystawienia
`paid_date` - data płatności
`transaction_date` - data sprzedaży
```
Domyślnie ustawiona jest data wystawienia `issue_date`.

Parametr `order=` pozwala wybrać wartość, według której będzie ustalona kolejność wyświetlania faktur.

```shell
`number` - numer faktury
`updated_at` - daty ostatniej modyfikacji
`price_net` - cena netto
`price_gross` - cena brutto
`price_tax` - podatek
`issue_date` - data wystawienia dokumentu
`payment_to` - termin płatności
`paid_date` - data płatności
`transaction_date` - data sprzedaży
`buyer_name` - nazwa kupującego
`buyer_tax_no` - nip kupującego
`seller_name` - nazwa sprzedającego
`oid` - zewnętrzny identyfikator faktury
```

Można dodać do parametru `.desc` aby zmienić kolejność sortowania na malejącą np. `updated_at.desc`.

<a name="examples"></a>
## Przykłady wywołania

<a name="f1"></a>
Pobranie listy faktur z aktualnego miesiąca

```shell
curl https://twojaDomena.fakturownia.pl/invoices.json?period=this_month&api_token=API_TOKEN&page=1
```

<a name="f2"></a>
Pobranie listy faktur wraz z ich pozycjami

```shell
curl https://twojaDomena.fakturownia.pl/invoices.json?include_positions=true&api_token=API_TOKEN&page=1
```

<a name="f3"></a>
Faktury danego klienta

```shell
curl https://twojaDomena.fakturownia.pl/invoices.json?client_id=ID_KLIENTA&api_token=API_TOKEN
```

<a name="f4"></a>
Pobranie faktury po ID


```shell
curl https://twojaDomena.fakturownia.pl/invoices/100.json?api_token=API_TOKEN
```

<a name="f5"></a>
Pobranie PDF-a


```shell
curl https://twojaDomena.fakturownia.pl/invoices/100.pdf?api_token=API_TOKEN
```

<a name="f6"></a>
Wysłanie faktury e-mailem do klienta (na e-mail klienta podany przy tworzeniu faktury, pole "buyer_email")


```shell
curl -X POST https://twojaDomena.fakturownia.pl/invoices/100/send_by_email.json?api_token=API_TOKEN
```
Opcjonalne parametry do wywołania send_by_email:

Parametr `email_to=` z wartością `email1,email2,email3,` umożliwia przekazanie listy adresatów emaila z fakturą.
Można ustawić w ten sposób do 5 adresów email.

Parametr `email_cc=` z wartością `email1,email2,email3` umożliwia przekazanie listy adresatów do których wyślemy kopię emaila (email cc).

Parametr `email_pdf=` z wartością `true` umożliwa dołączenie w załączniku pliku pdf z fakturą.

Parametr `update_buyer_email=` z wartością `true` umożliwa aktualizację emaila odbiorcy na fakturze (musimy również przekazać parametr `email_to`).
Jeśli na fakturze jest ustawiony odbiorca (recipient) to aktualizujemy `recipient_email`, zamiast `buyer_email`.


inne opcje PDF:
* print_option=original - Oryginał
* print_option=copy - Kopia
* print_option=original_and_copy - Oryginał i kopia
* print_option=duplicate Duplikat


<a name="f7"></a>
Dodanie nowej faktury

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "kind":"vat",
            "number": null,
            "sell_date": "2013-01-16",
            "issue_date": "2013-01-16",
            "payment_to": "2013-01-23",
            "seller_name": "Wystawca Sp. z o.o.",
            "seller_tax_no": "6272616681",
            "buyer_name": "Klient1 Sp. z o.o.",
            "buyer_email": "buyer@testemail.pl",
            "buyer_tax_no": "6272616681",
            "positions":[
                {"name":"Produkt A1", "tax":23, "total_price_gross":10.23, "quantity":1},
                {"name":"Produkt A2", "tax":0, "total_price_gross":50, "quantity":3}
            ]
        }
    }'
```
<b>Klient: nowy lub istniejący </b><br>
Podczas dodawania nowego dokumentu system automatycznie stara się dopasować przesłane dane nabywcy z istniejącym na koncie klientem. W dopasowaniu biorą udział następujące pola: "buyer_name", "buyer_tax_no", "buyer_email" (i/lub dla klienta prywatnego "buyer_first_name" i "buyer_last_name"). Jeśli nie uda się dopasować żadnego istniejącego klienta, system utworzy nowego. Gdy dodajemy dokument dla klienta, którego mamy już w bazie, zamiast pól zaczynających się od słowa "buyer" zaleca się używanie samego identyfikatora klienta - "client_id".
Wówczas na wystawianym dokumencie dane nabywcy będą identyczne jak dane w karcie wskazanego klienta.
Możesz zaktualizować niektóre dane na karcie klienta (np.: adres), dodając parametr `"buyer_override": true`. Przykład:

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
	-H 'Accept: application/json' \
	-H 'Content-Type: application/json' \
	-d '{"api_token": "API_TOKEN",
		"invoice": {
            "kind":"vat",
            "number": null,
            "sell_date": "2013-01-16",
            "issue_date": "2013-01-16",
            "payment_to": "2013-01-23",
            "seller_name": "Wystawca Sp. z o.o.",
            "seller_tax_no": "6272616681",
            "client_id": 1,
                "buyer_post_code": "06000",
                "buyer_city": "Nice",
                "buyer_street": "Rue de la Joie 11",
                "buyer_country": "FR",
                "buyer_override": true,
            "positions":[
                {"name":"Produkt A1", "tax":23, "total_price_gross":10.23, "quantity":1},
                {"name":"Produkt A2", "tax":0, "total_price_gross":50, "quantity":3}
            ]
	    }}'
```


<a name="f8"></a>
Dodanie nowej faktury - minimalna wersja (tylko pola wymagane), gdy mamy Id produktu (product_id), nabywcy (client_id) i sprzedawcy (department_id) wtedy nie musimy podawać pełnych danych. Opcjonalnie można podać również id odbiorcy (recipient_id).
Zostanie wystawiona Faktura VAT z aktualnym dniem i z 5 dniowym terminem płatności.

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"api_token": "API_TOKEN",
        "invoice": {
            "payment_to_kind": 5,
            "client_id": 1,
            "positions":[
                {"product_id": 1, "quantity":2}
            ]
        }}'
```

<a name="f8b"></a>
Dodanie nowej faktury – dokumentu podobnego do faktury o podanym ID (copy_invoice_from).

Dodanie identycznej faktury o podanym rodzaju

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "copy_invoice_from": ID_DOKUMENTU_ZRODLOWEGO,
            "kind": "RODZAJ_FAKTURY"
        }
    }'
```

Dodanie faktury zaliczkowej na podstawie zamówienia – % pełnej kwoty (podłączenie dokładnie 1 zamówienia jest wymagane; użycie `advance_creation_mode: percent/amount` od razu łączy z zamówieniem z `copy_invoice_from`)

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "copy_invoice_from": ID_ZAMOWIENIA,
            "kind": "advance",
            "advance_creation_mode": "percent",
            "advance_value": "10",
            "position_name": "Zaliczka na wykonanie zamówienia ZAM-NR"
        }
    }'
```

Dodanie faktury zaliczkowej na podstawie zamówienia – podana kwota brutto (podłączenie dokładnie 1 zamówienia jest wymagane; użycie `advance_creation_mode: percent/amount` od razu łączy z zamówieniem z `copy_invoice_from`)

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "copy_invoice_from": ID_ZAMOWIENIA,
            "kind": "advance",
            "advance_creation_mode": "amount",
            "advance_value": "150",
            "position_name": "Zaliczka na wykonanie zamówienia ZAM-NR"
        }
    }'
```

Dodanie faktury końcowej na podstawie zamówienia i faktur zaliczkowych (podłącznie przynajmniej jednej zaliczki przez `invoice_ids` jest wymagane)

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "copy_invoice_from": ID_ZAMOWIENIA,
            "kind": "final",
            "invoice_ids": [ID_ZALICZKI_1, ID_ZALICZKI_2, ...]
        }
    }'
```

Dodanie faktury VAT na podstawie faktury Proforma

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "copy_invoice_from": ID_PROFORMY,
            "kind": "vat"
        }
    }'
```

<a name="f8c"></a>
Dodanie faktury OSS

Jeśli w ustawieniach konta zaznaczyłeś opcję "Faktury OSS", możesz utworzyć fakturę oznaczoną jako sprzedaż OSS poprzez dopisanie parametru "use_oss":

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "kind":"vat",
            "seller_name": "Wystawca Sp. z o.o.",
            "seller_country": "PL",
            "buyer_name": "Klient1 Sp. z o.o."
            "buyer_country": "FR",
            "use_oss": true,
            "positions":[
                {"name":"Produkt A1", "tax":20, "total_price_gross":50, "quantity":3}
            ]
        }
    }'
```

Dodanie do żądania rekordu  "identify_oss": "1" spowoduje, że system przed oznaczeniem dokumentu jako "OSS" najpierw sprawdzi, czy spełnia on odpowiednie warunki. W przypadku nieprawidłowych danych, system nie oznaczy faktury jako faktura "OSS" - na przykład, jeśli na przesłanej fakturze kraj Nabywcy będzie taki sam jak kraj Sprzedawcy. Rekord ten należy dodać w tym samym miejscu, co "api_token" i "invoice".


```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "identify_oss": "1" ,
        "invoice": {
            "kind":"vat",
            "seller_name": "Wystawca Sp. z o.o.",
            "seller_country": "PL",
            "buyer_name": "Klient1 Sp. z o.o."
            "buyer_country": "FR",
            "use_oss": true,
            "positions":[
                {"name":"Produkt A1", "tax":20, "total_price_gross":50, "quantity":3}
            ]
        }
    }'
```

<a name="f9"></a>
Dodanie nowej faktury korygującej

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"api_token": "API_TOKEN",
        "invoice": {
            "kind": "correction",
            "correction_reason": "Zła ilość",
            "invoice_id": "2432393",
            "from_invoice_id": "2432393",
            "client_id": 1,
            "positions":[
                {"name": "Product A1",
                "quantity":-1,
                "total_price_gross":"-10",
                "tax":"23",
                "kind":"correction",
                "correction_before_attributes": {
                    "name":"Product A1",
                    "quantity":"2",
                    "total_price_gross":"20",
                    "tax":"23",
                    "kind":"correction_before"
                },
                "correction_after_attributes": {
                    "name":"Product A1",
                    "quantity":"1",
                    "total_price_gross":"10",
                    "tax":"23",
                    "kind":"correction_after"
                }
            }]
        }}'
```
<a name="f21"></a>
Dodanie faktury kosztowej

W celu wystawienia faktury kosztowej konieczne jest przekazanie w parametrach pola `income="0"`.

Ważne! W przypadku faktur kosztowych wszystkie pola zaczynające się od `seller_` zostaną wyświetlone na fakturze w sekcji "Nabywca", a pola zaczynające się od `buyer_` pokażą się w sekcji "Sprzedawca".

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "kind":"vat",
            "income": "0",
            "sell_date": "2013-01-16",
            "issue_date": "2013-01-16",
            "payment_to": "2013-01-23",
            "seller_name": "Wystawca Sp. z o.o.",
            "seller_tax_no": "5252445767",
            "buyer_name": "Klient1 Sp. z o.o.",
            "buyer_email": "buyer@testemail.pl",
            "buyer_tax_no": "5252445767",
            "positions":[
                {"name":"Produkt A1", "tax":23, "total_price_gross":10.23, "quantity":1},
            ]
        }
    }'
```

Pola zaczynające się od `seller_` oraz `buyer_` można odpowiednio zastąpić przez `department_id` oraz `client_id`.

<a name="f10"></a>
Aktualizacja faktury

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices/111.json \
    -X PUT \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "buyer_name": "Nowa nazwa klienta Sp. z o.o."
        }
    }'
```

<a name="f10b"></a>
Aktualizacja pozycji na fakturze - aby edytować pozycję na fakturze, należy podać id pozycji.

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices/111.json \
    -X PUT \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "positions": [{"id":32649087, "name":"test"}]
        }
    }'
```

<a name="f10c"></a>
Usunięcie pozycji na fakturze - aby usunąć pozycję na fakturze, należy podać id pozycji wraz z parametrem _destroy=1.

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices/111.json \
    -X PUT \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "positions": [{"id":32649087, "_destroy": 1}]
        }
    }'
```

<a name="f10d"></a>
Dodanie pozycji na fakturze. Pozycja zostanie dopisana jako ostatnia.

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices/111.json \
    -X PUT \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "positions": [{"name":"Produkt A1", "tax":23, "total_price_gross":10.23, "quantity":1}]
        }
    }'
```

<a name="f11"></a>
Zmiana statusu faktury

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/invoices/111/change_status.json?api_token=API_TOKEN&status=STATUS" -X POST
```

<a name="f12"></a>
Pobranie listy definicji faktur cyklicznych

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/recurrings.json?api_token=API_TOKEN
```

<a name="f13"></a>
Dodanie definicji faktury cyklicznej

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/recurrings.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"api_token": "API_TOKEN",
        "recurring": {
            "name": "Nazwa cyklicznosci",
            "invoice_id": 1,
            "start_date": "2016-01-01",
            "every": "1m",
            "issue_working_day_only": false,
            "send_email": true,
            "buyer_email": "mail1@mail.pl, mail2@mail.pl",
            "end_date": "null"
        }}'
```

<a name="f14"></a>
Aktualizacja definicji faktury cyklicznej (zmiana daty wystawienia następnej faktury)

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/recurrings/111.json \
    -X PUT \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "recurring": {
            "next_invoice_date": "2016-02-01"
        }
    }'
```

<a name="f15"></a>
Usunięcie faktury

```shell
curl -X DELETE "https://YOUR_DOMAIN.fakturownia.pl/invoices/INVOICE_ID.json?api_token=API_TOKEN"
```

<a name="f16"></a>
Anulowanie faktury

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices/cancel.json \
        -X POST \
	-H 'Accept:application/json' \
	-H 'Content-Type: application/json' \
	-d '{
	        "api_token": "API_TOKEN",
            "cancel_invoice_id": ID_FAKTURY,
		    "cancel_reason": "Powód anulowania (opcjonalnie)"
	 }'
```

Aby wyświetlić powód anulowania wskazany w anulowanym dokumencie, dołącz parametr `additional_fields[invoice]=cancel_reason` w adresie URL żądania. Przykład:

https://YOUR_DOMAIN.fakturownia.pl/invoices/ID_FAKTURY.json?api_token=API_TOKEN&additional_fields[invoice]=cancel_reason

<a name="f17"></a>
Połączenie istniejącej faktury i paragonu

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices/ID_FAKTURY.json \
    -X PUT \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "from_invoice_id": ID_PARAGONU,
            "invoice_id": ID_PARAGONU,
            "exclude_from_stock_level": true
        }
    }'
```

<a name="f17b"></a>
Dodawanie faktury do istniejącego paragonu

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -X POST \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "from_invoice_id": ID_PARAGONU,
            "additional_params":"for_receipt",
            "exclude_from_stock_level": true,
            "buyer_name": "Klient1 Sp. z o.o.",
            "buyer_tax_no": "6272616681",
            "positions": [
                {"name":"Produkt A1","quantity":"1","tax":"23","total_price_gross":"10,23"}
            ]
        }
    }'
```

Dane `buyer_name`, `buyer_tax_no`, `positions` wypełniamy danymi z paragonu.

<a name="f18"></a>
Pobranie wszystkich załączników faktury w archiwum ZIP

```shell
curl -o attachments.zip https://YOUR_DOMAIN.fakturownia.pl/invoices/INVOICE_ID/attachments_zip.json?api_token=API_TOKEN
```

<a name="f18b"></a>
Dodanie nowego załącznika do faktury

1. Pobranie danych niezbędnych do przesłania pliku:
    ```shell
    curl https://YOUR_DOMAIN.fakturownia.pl/invoices/INVOICE_ID/get_new_attachment_credentials.json?api_token=API_TOKEN
    ```

2. Przesłanie pliku:
    ```shell
    curl -F 'AWSAccessKeyId=received_AWSAccessKeyId' \
         -F 'key=received_key' \
         -F 'policy=received_policy' \
         -F 'signature=received_signature' \
         -F 'acl=received_acl' \
         -F 'success_action_status=received_success_action_status' \
         -F 'file=@/file_path/name.ext' \
         received_url
    ```

3. Dodanie załącznika (przesłanego pliku) do faktury:
    ```shell
    curl -X POST https://YOUR_DOMAIN.fakturownia.pl/invoices/INVOICE_ID/add_attachment.json?api_token=API_TOKEN&file_name=name.ext
    ```

4. Domyślnie załączniki nie są widoczne dla klientów. Aby to zmienić, można wysłać następujące żądanie:

    ```shell
        curl https://YOUR_DOMAIN.fakturownia.pl/invoices/INVOICE_ID.json \
        -X PUT \
        -H 'Accept: application/json'  \
        -H 'Content-Type: application/json' \
        -d '{
            "api_token": "API_TOKEN",
            "invoice": {
                "show_attachments": true
            }
        }'
    ```

<a name="f19"></a>

## Wydruk fiskalny

```shell
curl https://twojaDomena.fakturownia.pl/invoices/fiscal_print?api_token=API_TOKEN&invoice_ids[]=111&invoice_ids[]=112&fiskator_name=NAZWA_DRUKARKI
```

Za pomocą parametru `invoice_ids[]` przekazujemy id faktur do wydrukowania.

Za pomocą parametru `fiskator_name` możemy przekazać nazwę drukarki, na której uruchomi się wydruk (przydatne jeśli mamy połączoną więcej niż jedną drukarkę).

<a name="f20"></a>

## Faktura korekta

1. Pobranie faktury korekty wraz z dwoma dodatkowymi polami "Treść korygowana" i "Treść poprawiona":

```shell
curl https://twojaDomena.fakturownia.pl/invoices/INVOICE_ID.json?api_token=API_TOKEN&additional_fields[invoice]=corrected_content_before,corrected_content_after
```

2. Dodanie nowej faktury korygującej
```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"api_token": "API_TOKEN",
    "invoice": {
        "kind": "correction",
        "correction_reason": "Zła ilość",
        "invoice_id": "2432393",
        "from_invoice_id": "2432393",
        "client_id": 1,
        "positions":[
            {"name": "Product A1",
            "quantity":-1,
            "total_price_gross":"-10",
            "tax":"23",
            "kind":"correction",
            "correction_before_attributes": {
                "name":"Product A1",
                "quantity":"2",
                "total_price_gross":"20",
                "tax":"23",
                "kind":"correction_before"
            },
            "correction_after_attributes": {
                "name":"Product A2",
                "quantity":"1",
                "total_price_gross":"10",
                "tax":"23",
                "kind":"correction_after"
            }
        }]
    }}'
```

Pobranie faktury korekty wraz z informacją "przed / po korekcie" w pozycjach:

```shell
curl https://twojaDomena.fakturownia.pl/invoices/INVOICE_ID.json?api_token=API_TOKEN&correction_positions=full
```

<a name="f21"></a>

## Dodanie domyślnych uwag z ustawień konta

Do faktury można dodać domyśle uwagi z ustawień konta korzystając z parametru: `fill_default_descriptions`:

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -X POST \
	-H 'Accept:application/json' \
	-H 'Content-Type: application/json' \
	-d '{
	        "api_token": "API_TOKEN",
            "fill_default_descriptions":true,
            "invoice": {
                "kind":"vat",
                "seller_name": "Wystawca Sp. z o.o.",
                "seller_tax_no": "6272616681",
                "buyer_name": "Klient1 Sp. z o.o.",
                "positions":[
                    {"name":"towar", "quantity":1, "total_price_gross": 123}
                ]
            }
	 }'
```

<a name="f22"></a>

## Zaczytanie cen produktów z cennika podczas wystawiania faktury

Jeśli cena produktu na fakturze ma pochodzić z cennika (a nie karty produktu), w żądaniu dodatkowo należy podać `use_prices_from_price_lists: true` oraz `price_list_id: ID_CENNIKA`.

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -X POST \
	-H 'Accept:application/json' \
	-H 'Content-Type: application/json' \
	-d '{
	        "api_token": "API_TOKEN",
            "invoice": {
                "use_prices_from_price_lists": true,
                "price_list_id": ID_CENNIKA,
                "seller_name": "Wystawca Sp. z o.o.",
                "buyer_name": "Klient1 Sp. z o.o.",
                "positions":[
                    { "product_id": id_produktu, "quantity": 1}
                ]
            }
	 }'
```

Jeśli w żądaniu przesyłamy `client_id`, a w karcie tego klienta mamy określony domyślny cennik, wówczas wystarczy przesłać samo `"use_prices_from_price_lists": true` bez konieczności podawania dodatkowo `price_list_id`.

<a name="f23"></a>

## Pobranie faktury razem z połączonymi płatnościami

```shell
curl https://twojaDomena.fakturownia.pl/invoices/INVOICE_ID.json?api_token=API_TOKEN&additional_fields[invoice]=connected_payments
```

<a name="f24"></a>

## Odbiorcy/Wystawcy na fakturze

Dodawanie:
```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -X POST \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "issue_date": "2024-08-01",
            "seller_name": "Wystawca Sp. z o.o.",
            "buyer_name": "Klient1 Sp. z o.o.",
            "positions":[
                {"name":"Produkt A1", "tax":23, "total_price_gross":10.23, "quantity":1},
                {"name":"Produkt A2", "tax":0, "total_price_gross":50, "quantity":3}
            ],
            "recipients": [
                {"name": "Odbiorca1", "company": "true", "email": "odbiorca1@email.pl"},
                {"name": "Odbiorca2", "company": "true", "email": "odbiorca2@email.pl"},
            ],
            "issuers": [
                {"name": "Wystawca1", "company": "true", "email": "wystawca1@email.pl"},
                {"name": "Wystawca2", "company": "true", "email": "wystawca2@email.pl"},
            ]
        }
    }'
```
Edytowanie:
```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices/111.json \
    -X PUT \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "recipients": [{"id":1, "name": "Nowa nazwa"}]
        }
    }'
```
Usuwanie:
```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices/111.json \
    -X PUT \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "invoice": {
            "recipients": [{"id":1, "_destroy": 1}]
        }
    }'
```

Pola odbiorcy/wystawcy (recipient/issuer):
```shell
   "name": "Nazwa"
   "first_name": "Imię"
   "last_name": "Nazwisko"
   "tax_no": "1000000000"
   "company":  true/false - pole określa, czy dany podmiot jest firmą
   "country": "Kraj"
   "city": "Miasto"
   "post_code": "00-000"
   "street": "Ulica 1"
   "phone": "711000000"
   "email": "email@test.pl"
   "note": "Dodatkowe uwagi"
   "role": "Dodatkowy odbiorca" - pole określa rodzaj podmiotów; przy tworzeniu faktur, jeżeli nie podano, zostanie domyślnie użyta pierwsza z dozwolonych wartości -> "Odbiorca"/"Wystawca faktury" (używane tylko przy włączonym KSEF na koncie)
	Dozwolone wartości dla odbiorcy (recipient):
		"Odbiorca"
		"Dodatkowy nabywca"
		"Dokonujący płatności"
		"JST – odbiorca"
		"Członek GV – odbiorca"
        "Pracownik"
        "Rola inna"
	Dozwolone wartości dla wystawcy (issuer):
	   	"Wystawca faktury"
		"Faktor"
		"Podmiot pierwotny"
		"JST – wystawca"
		"Członek GV – wystawca"
        "Rola inna"
   "participation": 10.00 - pole określa udział podmiotu (używane tylko przy włączonym KSEF na koncie)
   "role_description": "Opis roli nie zdefiniowanej w KSeF" - max 25 znaków, należy podać tylko jeżeli w "role" wybrano "Rola inna" (używane tylko przy włączonym KSEF na koncie)
```

<a name="view_url"></a>

## Link do podglądu faktury i pobieranie do PDF

Po pobraniu danych faktury np. przez:

```shell
curl https://twojaDomena.fakturownia.pl/invoices/100.json?api_token=API_TOKEN
```

API zwraca nam m.in. pole `token` na podstawie którego możemy otrzymać linki do podglądu faktury oraz do pobrania PDF-a z wygenrowaną fakturą.
Linki takie umożliwiają odwołanie się do wybranej faktury  bez konieczności logowania - czyli możemy np. te linki przesłać klientowi, który otrzyma dostęp do faktury i PDF-a.

Linki te są postaci:

podgląd: `https://twojaDomena.fakturownia.pl/invoice/{{token}}`
pdf: `https://twojaDomena.fakturownia.pl/invoice/{{token}}.pdf`, `https://twojaDomena.fakturownia.pl/invoice/{{token}}.pdf?inline=yes`

Np dla tokenu równego: `HBO3Npx2OzSW79RQL7XV2` publiczny PDF będzie pod adresem `https://twojaDomena.fakturownia.pl/invoice/HBO3Npx2OzSW79RQL7XV2.pdf`

<a name="use_case1"></a>

## Przykłady użycia w PHP - zakup szkolenia

`TODO`

Przykład flow Portalu, który generuje dla klienta fakturę Proformę, wysyła ją klientowi i po opłaceniu wysyła do klienta bilet na szkolenie

* Klient wypełnia dane w Portalu
* Portal wywołuje API z fakturownia.pl i tworzy fakturę
* Portal wysyła Klientowi fakturę Proforma w PDF wraz z linkiem do płatności
* Klient opłaca fakturę Proforma (np. na PayPal lub PayU.pl)
* Fakturownia.pl otrzymuje informację, że płatność została wykonana, tworzy Fakturę VAT i wysyła ją Klientowi oraz wywołuje API Portalu
* Po otrzymaniu informacji o płatności (przez API) Portal wysyła Klientowi bilet na Szkolenie


<a name="invoices"></a>

## Faktury


* `GET /invoices/1.json` pobranie faktury
* `POST /invoices.json` dodanie nowej faktury
* `PUT /invoices/1.json` aktualizacja faktury
* `DELETE /invoices/1.json` skasowanie faktury


Przykład - dodanie nowej faktury (minimalna wersja, gdy mamy Id produktu, nabywcy i sprzedawcy wtedy nie musimy podawać pełnych danych). Zostanie wystawiona Faktura VAT z aktualnym dniem i z 5 dniowym terminem płatności. Pole department_id określa firmę (lub dział) który wystawia fakturę (można go uzyskać klikając na firmę w menu Ustawienia > Dane firmy)

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"api_token": "API_TOKEN",
        "invoice": {
            "payment_to_kind": 5,
            "client_id": 1,
            "positions":[
                {"product_id": 1, "quantity":2}
            ]
        }}'
```

Pola faktury

```shell
"number" : "13/2012", - numer faktury (jeśli nie będzie podany wygeneruje się automatycznie)
"kind" : "vat", - rodzaj faktury (vat, proforma, bill, receipt, advance, correction, vat_mp, invoice_other, vat_margin, kp, kw, final, estimate)
"income" : "1", - faktura przychodowa (1) lub kosztowa (0)
"issue_date" : "2013-01-16", - data wystawienia
"place" : "Warszawa", - miejsce wystawienia
"sell_date" : "2013-01-16", - data sprzedaży (może być data lub miesiąc postaci 2012-12)
"category_id" : "", - id kategorii
"department_id" : "1", - id działu firmy (w menu Ustawienia > Dane firmy należy kliknąć na firmę/dział i ID działu pojawi się w URL); Jeśli nie będzie tego pola oraz nie będzie pola 'seller_name' wtedy będą wstawione domyślne dane Twojej firmy
"accounting_kind": "", - rodzaj wydatku dla faktur kosztowych - (purchases, expenses, media, salary, incident, fuel0, fuel_expl75, fuel_expl100, fixed_assets, fixed_assets50, no_vat_deduction)
"seller_name" : "Radgost Sp. z o.o.", - sprzedawca
"seller_tax_no" : "525-244-57-67", - numer identyfikacji podatkowej sprzedawcy (domyślnie NIP)
"seller_tax_no_kind" : "", - rodzaj numeru identyfikacyjnego sprzedawcy; pole puste (domyślnie) jest interpretowane jako "NIP"; w innym wypadku traktowane jako dowolny wpis własny (np. PESEL, REGON); po wejściu KSeF jedynymi dopuszczalnymi wartościami (oprócz pustego pola) będą: "nip_ue" (NIP UE), "other" (Numer identyfikacji podatkowej), "empty" (Brak nr. id. podatkowej)
"seller_bank_account" : "24 1140 1977 0000 5921 7200 1001", - konto bankowe sprzedawcy
"seller_bank" : "BRE Bank",
"seller_post_code" : "02-548",
"seller_city" : "Warszawa",
"seller_street" : "ul. Olesińska 21",
"seller_country" : "", - kraj sprzedawcy (ISO 3166)
"seller_email" : "platnosci@radgost123.com",
"seller_www" : "",
"seller_fax" : "",
"seller_phone" : "",
"seller_bdo_no": "1234567899", - numer BDO
"seller_jst": "0", Czy faktura dotyczy jednostki samorządu terytorialnego? (tylko wydatki)
"seller_gv": "0", Czy faktura dotyczy członka grupy VAT? (tylko wydatki)
"use_invoice_issuer": "1",
"invoice_issuer": "Dane Wystawcy",
"client_id" : "-1" - id kupującego (jeśi -1 to klient zostanie utworzony w systemie)
"buyer_name" : "Nazwa klienta" - nabywca
"buyer_tax_no" : "525-244-57-67", - numer identyfikacji podatkowej nabywcy (domyślnie NIP)
"buyer_tax_no_kind" : "", - rodzaj numeru identyfikacyjnego nabywcy; pole puste (domyślnie) jest interpretowane jako "NIP"; w innym wypadku traktowane jako wpis własny (np. PESEL, REGON); po wejściu KSeF jedynymi dopuszczalnymi wartościami (oprócz pustego pola) będą: "nip_ue" (NIP UE), "other" (Numer identyfikacji podatkowej), "empty" (Brak nr. id. podatkowej)
"disable_tax_no_validation" : "",
"buyer_post_code" : "30-314", - kod pocztowy nabywcy
"buyer_city" : "Warszawa", - miasto nabywcy
"buyer_street" : "Nowa 44", - ulica nabywcy
"buyer_country" : "PL", - kraj nabywcy (ISO 3166)
"buyer_note" : "", - dodatkowy opis nabywcy
"buyer_email" : "", - email nabywcy
"buyer_jst": "1", Czy faktura dotyczy jednostki samorządu terytorialnego? (tylko przychody)
"buyer_gv": "1", Czy faktura dotyczy członka grupy VAT? (tylko przychody)
"recipient_id" : "", - id odbiorcy (id klienta z systemu)
"recipient_name" : "", - nazwa odbiorcy
"recipient_street" : "", - ulica odbiorcy
"recipient_post_code" : "", - kod pocztowy odbiorcy
"recipient_city" : "", - miasto odbiorcy
"recipient_country" : "", - kraj odbiorcy (ISO 3166)
"recipient_email" : "", - e-mail odbiorcy
"recipient_phone" : "", - numer telefonu odbiorcy
"recipient_note" : "", - dodatkowy opis odbiorcy
"additional_info" : "0" - czy wyświetlać dodatkowe pole na pozycjach faktury
"additional_info_desc" : "PKWiU" - nazwa dodatkowej kolumny na pozycjach faktury
"show_discount" : "0" - czy rabat
"payment_type" : "transfer",
"payment_to_kind" : pozwala określić termin płatności. Można tu podać liczbę np.: 5, wówczas mamy 5-dniowy termin płatności. Wpisanie "off" spowoduje, że faktura nie będzie miała wskazanego terminu płatności. Jeśli natomiast podamy "other_date", wówczas sami będziemy mogli zadeklarować ostateczną datę zapłaty poprzez uzupełnienie parametru "payment_to".
"payment_to" : "2013-01-16",
"status" : "issued",
"paid" : "0,00",
"oid" : "zamowienie10021", - numer zamówienia (np z zewnętrznego systemu zamówień)
"oid_unique" : jeśli to pole będzie ustawione na 'yes' wtedy nie system nie pozwoli stworzyc 2 faktur o takim samym OID (może to być przydatne w synchronizacji ze sklepem internetowym)
"warehouse_id" : "1090",
"seller_person" : imię i nazwisko wystawcy np.: "Imię Nazwisko",
"buyer_person": imię i nazwisko odbiorcy np.: "Imię Nazwisko". Jeśli pole "buyer_person" nie zostanie przesłane, będzie ono uzupełnione automatycznie danymi nabywcy ("buyer_first_name" i "buyer_last_name"). Jeśli jednak nie chcemy mieć podpisu odbiorcy na fakturze, możemy w żądaniu przesłać "buyer_person": "".
"buyer_first_name" : "Imie",
"buyer_last_name" : "Nazwisko",
"paid_date" : "",
"currency" : "PLN",
"lang" : "pl",
"use_oss" (wcześniej "use_moss"): "1", - 1 lub 0 w zależności, czy dokument ma zostać  sklasyfikowany jako sprzedaż "OSS" (dowiedz się więcej tutaj: https://fakturownia.pl/oss-zamiast-moss-czy-ciebie-takze-dotkna-zmiany-w-prawie).
"exchange_currency" : "", - przeliczona waluta (przeliczanie sumy i podatku na inną walutę), np. "PLN"
"exchange_kind" : "", - źródło kursu do przeliczenia waluty ("ecb", "nbp", "cbr", "nbu", "nbg", "own")
"exchange_currency_rate" : "", - własny kurs przeliczenia waluty (używany, gdy parametr exchange_kind ustawiony jest na "own")
"exchange_note": "", - notatka do kursu, generowana automatycznie dla kursów innych niż "own", dla "own" należy podać własną notatkę
"invoice_template_id" : "1",
"description" : "", - uwagi na fakturze
"description_footer" : "", - opis umieszczony w stopce faktury
"description_long" : "", - opis umieszczony na odwrocie faktury
"invoice_id" : "" - pole z id powiązanego dokumentu, np. id zamówienia przy zaliczce albo id wzorcowej faktury przy fakturze cyklicznej,
"from_invoice_id" : "" - id faktury na podstawie której faktura została wygenerowana (przydatne np. w przypadku generacji Faktura VAT z Faktury Proforma),
"delivery_date" : "" - data wpłynięcia dokumentu (tylko przy wydatkach),
"buyer_company" : "1" - czy klient jest firmą
"additional_invoice_field" : "" - wartość dodatkowego pola na fakturze, Ustawienia > Ustawienia Konta > Konfiguracja > Faktury i dokumenty > Dodatkowe pole na fakturze
"internal_note" : "" - treść notatki prywatnej na fakturze, niewidoczna na wydruku.
"exclude_from_stock_level" : "" - informacja, czy system powinien liczyć tę fakturę do stanów magazynowych (true np., gdy faktura wystawiona na podstawie paragonu)
"procedure_designations" : [] - oznaczenia dotyczące procedur
"positions":
        "product_id" : "1",
        "name" : "Fakturownia Start",
        "additional_info" : "", - dodatkowa informacja na pozycji faktury (np. PKWiU)
        "discount_percent" : "", - zniżka procentowa (uwaga: aby rabat był wyliczany trzeba ustawić pole: 'show_discount' na '1' oraz przed wywołaniem należy sprawdzić czy w Ustawieniach Konta pole: "Jak obliczać rabat" ustawione jest na "procentowo")
        "discount" : "", - zniżka kwotowa (uwaga: aby rabat był wyliczany trzeba ustawić pole: 'show_discount' na 1 oraz przed wywołaniem należy sprawdzić czy w Ustawieniach Konta pole: "Jak obliczać rabat" ustawione jest na "kwotowo")
        "quantity" : "1",
        "quantity_unit" : "szt",
        "price_net" : "59,00", - jeśli nie jest podana to zostanie wyliczona
        "tax" : "23", - może być stawka lub "np" - dla nie podlega, "zw" - dla zwolniona
        "price_gross" : "72,57", - jeśli nie jest podana to zostanie wyliczona
        "total_price_net" : "59,00", - jeśli nie jest podana to zostanie wyliczona
        "total_price_gross" : "72,57",
        "description" : opis pozycji faktury
        "code" : "" - kod produktu,
        "gtu_code" : "" - kod GTU produktu,
        "lump_sum_tax" : "17", - stawka ryczałtu (możliwa do ustawienia jedynie, gdy wystawiamy fakturę dla działu lub firmy z włączoną opcją "Płatnik zryczałtowanego podatku dochodowego")
"calculating_strategy":
{
  "position": "default" lub "keep_gross" - metoda wyliczania kwot na pozycjach faktury
  "sum": "sum" lub "keep_gross" lub "keep_net" - metoda sumowania kwot z pozycji
  "invoice_form_price_kind": "net" lub "gross" - cena jednostkowa na formatce faktury
},
"split_payment" : "1" - 1 lub 0 w zależności, czy faktura podlega pod split payment, czy nie
"accounting_vat_tax_date": "2020-12-18", Data księgowania podatku VAT (jeśli włączono w ustawieniach)
"accounting_income_tax_date": "2020-12-18", Data księgowania podatku dochodowego (jeśli włączono w ustawieniach)
"skonto_active": "1" - 1 lub 0 w zależności, czy faktura skonto ma być aktywne, czy nie
"skonto_discount_date": "2021-08-13", Termin płatności dla skonta
"skonto_discount_value": "10", Procent upustu
"exempt_tax_kind": "", Podstawa zwolnienia z podatku VAT (stosowana, gdy pozycja ma tax="zw", wcześniej należy również włączyć opcję "Wybór podstawy zastosowania stawki zw (zwolnione z opodatkowania) na fakturze" w ustawieniach konta)
"np_tax_kind": "", Podstawa zastosowania stawki NP (nie podlega) na fakturze
"reverse_charge": false, Odwrotne obciążenie. Oznaczenie faktury jako 'Odwrotne obciążenie' spowoduje wymuszenie na pozycjach (positions) odpowiedniej stawki podatku (tax) w zależności od kraju nabywcy (buyer_country): 'oo' dla 'PL' lub 'np' w pozostałych przypadkach
"corrected_content_before": "", Treść korygowana (pole ma zastosowanie dla faktur korygujących)
"corrected_content_after": "", Treść prawidłowa (pole ma zastosowanie dla faktur korygujących)
"accounting_note_kind": "credit" lub "debit", w zależności, czy Nota księgowa jest obciążąjąca czy uznaniowa (pole ma zastosowanie tylko dla not księgowych)
"procedure_vat_margin": pole wymagane dla faktur Marża, przyjmuje jedną z 4 wartości:
	"procedura marży dla biur podróży"
	"procedura marży – towary używane"
	"procedura marży – dzieła sztuki"
    "procedura marży – przedmioty kolekcjonerskie i antyki"
```

Wartości pól

Pole: `kind`
```shell
	"vat" - faktura VAT
	"proforma" - faktura Proforma
	"bill" - rachunek
	"receipt" - paragon
	"advance" - faktura zaliczkowa
	"final" - faktura końcowa
	"correction" - faktura korekta
	"invoice_other" - inna faktura
	"vat_margin" - faktura marża
	"kp" - kasa przyjmie
	"kw" - kasa wyda
	"estimate" - zamówienie
	"vat_mp" - faktura MP
	"vat_rr" - faktura RR
	"correction_note" - nota korygująca
	"accounting_note" - nota księgowa
	"client_order" - własny dokument nieksięgowy
	"dw" - dowód wewnętrzny
	"wnt" - Wewnątrzwspólnotowe Nabycie Towarów
	"wdt" - Wewnątrzwspólnotowa Dostawa Towarów
	"import_service" - import usług
	"import_service_eu" - import usług z UE
	"import_products" - import towarów - procedura uproszczona
	"export_products" - eksport towarów
```

Pole: `lang`
```shell
	"pl" - faktura w języku polskim
	"en" - język angielski
	"en-GB" - język angielski UK
	"de" - język niemiecki
	"fr" - język francuski
	"cz" - język czeski
	"ru" - język rosyjski
	"es" - język hiszpański
	"it" - język włoski
	"nl" - język niderlandzki
	"hr" - język chorwacki
	"ar" - język arabski
	"sk" - język słowacki
	"sl" - język słoweński
	"el" - język grecki
	"et" - język estoński
	"cn" - język chiński
	"hu" - język węgierski
	"tr" - język turecki
	"fa" - język perski

	można tworzyć faktury dwujęzyczne łącząc symbole dwóch języków przy pomocy ukośnika, np:
	"pl/en" - język polski i angielski
```

Pole: `income`
```shell
	"1" - fakura przychodwa
	"0" - faktura kosztowa
```

Pole: `accounting_kind`
```shell
  "purchases" - Zakup towarów i materiałów
  "expenses" - Koszty prowadzenia działalności
  "media" - Media i usługi telekomunikacyjne
  "salary" - Wynagrodzenia
  "incident" - Koszty uboczne zakupu
  "fuel0" - Zakup paliwa do pojazdów 0%
  "fuel_expl75" - Zakup paliwa i eksploatacja pojazdu 75%
  "fuel_expl100" - Zakup paliwa i eksploatacja pojazdu 100%
  "fixed_assets" - Środki trwałe
  "fixed_assets50" - Środki trwałe 50%
  "no_vat_deduction" - Bez możliwości odliczenia podatku VAT
```

Pole: `payment_type`
```shell
	"transfer" - przelew
	"card" - karta płatnicza
	"cash" -  gotówka
	"barter" - barter
	"cheque" - czek
	"bill_of_exchange" - weksel
	"cash_on_delivery" - opłata za pobraniem
	"compensation" - kompensata
	"letter_of_credit" - akredytywa
	"payu" - PayU
	"paypal" - PayPal
	"off" - "nie wyświetlaj"
	"dowolny_inny_wpis_tekstowy"
```

Pole: `status`
```shell
	"issued" - wystawiona
	"sent" - wysłana
	"paid" - opłacona
	"partial" - częściowo opłacona
	"rejected" - odrzucona
```

Pole: `discount_kind` - rodzaj rabatu
```shell
	"percent_unit" - liczony od ceny jednostkowej netto
    "percent_unit_gross" - liczony od ceny jednostkowej brutto
	"percent_total" - liczony od ceny całkowitej
	"amount" - kwotowy
```

Pole: `np_tax_kind` - podstawa zastosowania stawki NP
> Uwaga! Dla każdej pozycji, która nie podlega opodatkowaniu VAT należy podać jako stawkę podatku jeden z wariantów stawki "np" (przykład: "tax": "na").

> Warianty stawki "np" rozpoznawane przez system: "np", "n/a", "nie podlega", "not applicable", "na" - lub ich wersje pisane z wielkich liter.

```shell
    "export_service" - dostawa towarów oraz świadczenie usług poza terytorium kraju
    "export_service_eu" - w tym świadczenie usług, o których mowa w art.100 ust.1 pkt 4 ustawy
    "not_specified" - nie określono
```

> Wraz z wyborem `export_service_eu`, zgodnie z przepisami, należy również oznaczyć fakturę jako 'Odwrotne obciążenie'
> (`"reverse_charge": true`).

Pole: `procedure_designations` - oznaczenia dotyczące procedur
```shell
  "SW" - Dostawa w ramach sprzedaży wysyłkowej z terytorium kraju, o której mowa w art. 23 ustawy,
  "EE" - Świadczenie usług telekomunikacyjnych, nadawczych i elektronicznych, o których mowa w art. 28k ustawy,
  "TP" - Istniejące powiązania między nabywcą a dokonującym dostawy towarów lub usługodawcą, o których mowa w art. 32 ust. 2 pkt 1 ustawy,
  "TT_WNT" - Wewnątrzwspólnotowe nabycie towarów dokonane przez drugiego w kolejności podatnika VAT w ramach transakcji trójstronnej w procedurze uproszczonej, o której mowa w dziale XII rozdziale 8 ustawy,
  "TT_D" - Dostawa towarów poza terytorium kraju dokonana przez drugiego w kolejności podatnika VAT w ramach transakcji trójstronnej w procedurze uproszczonej, o której mowa w dziale XII rozdziale 8 ustawy,
  "MR_T" - Świadczenie usług turystyki opodatkowane na zasadach marży zgodnie z art. 119 ustawy,
  "MR_UZ" - Dostawa towarów używanych, dzieł sztuki, przedmiotów kolekcjonerskich i antyków, opodatkowana na zasadach marży zgodnie z art. 120 ustawy,
  "I_42" - Wewnątrzwspólnotowa dostawa towarów następująca po imporcie tych towarów w ramach procedury celnej 42 (import),
  "I_63" - Wewnątrzwspólnotowa dostawa towarów następująca po imporcie tych towarów w ramach procedury celnej 63 (import),
  "B_SPV" - Transfer bonu jednego przeznaczenia dokonany przez podatnika działającego we własnym imieniu, opodatkowany zgodnie z art. 8a ust. 1 ustawy,
  "B_SPV_DOSTAWA" - Dostawa towarów oraz świadczenie usług, których dotyczy bon jednego przeznaczenia na rzecz podatnika, który wyemitował bon zgodnie z art. 8a ust. 4 ustawy,
  "B_MPV_PROWIZJA" - Świadczenie usług pośrednictwa oraz innych usług dotyczących transferu bonu różnego przeznaczenia, opodatkowane zgodnie z art. 8b ust. 2 ustawy,
  "MPP" - Transakcja objęta obowiązkiem stosowania mechanizmu podzielonej płatności
```

## Faktury - kody GTU
Więcej informacji o kodach GTU można znaleźć na naszej stronie pomocy: https://pomoc.fakturownia.pl/78131182-Kody-GTU-grupowanie-towarow-i-uslug  
Jeśli podczas tworzenia nowej faktury chcemy umieścic na niej kody GTU, możemy to zrobić na kilka sposobów.

* `Automatyczne pobieranie kodów z produktów istniejących` - jeśli dodajemy pozycję na fakturze korzystając z ID produktu, które już ma zapisany kod GTU w systemie, wtedy nowa faktura automatycznie pobierze kody GTU wszystkich produktów i wyświetli je na wydruku (jeśli tylko jest włączona opcja zamieszczenia kodów na wydruku faktury)  

* `Podanie kodów wraz z pozycjami na fakturze` - możemy podać kod GTU bezpośrednio dla każdej pozycji na fakturze korzystając z pola `gtu_code`

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/invoices.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"api_token": "API_TOKEN",
        "invoice": {
            "payment_to_kind": 5,
            "client_id": 1,
            "positions":[
                {"name":"Produkt A1", "tax":23, "total_price_gross":10.23, "quantity":1, "gtu_code": "GTU_01"},
                {"name":"Produkt A2", "tax":0, "total_price_gross":50, "quantity":3,  "gtu_code": "GTU_04"}
            ]
        }}'
```

Pole: `gtu_codes` - typy kodów GTU
```shell
Dla produktów:
"GTU_01" - Dostawa napojów alkoholowych - alkoholu etylowego, piwa, wina, napojów fermentowanych i wyrobów pośrednich, w rozumieniu przepisów o podatku akcyzowym
"GTU_02" - Dostawa towarów, o których mowa w art. 103 ust. 5aa ustawy
"GTU_03" - Dostawa oleju opałowego w rozumieniu przepisów o podatku akcyzowym oraz olejów smarowych, pozostałych olejów o kodach CN od 2710 19 71 do 2710 19 99, z wyłączeniem wyrobów o kodzie CN 2710 19 85 (oleje białe, parafina ciekła) oraz smarów plastycznych zaliczanych do kodu CN 2710 19 99, olejów smarowych o kodzie CN 2710 20 90, preparatów smarowych objętych pozycją CN 3403, z wyłączeniem smarów plastycznych objętych tą pozycją
"GTU_04" - Dostawa wyrobów tytoniowych, suszu tytoniowego, płynu do papierosów elektronicznych i wyrobów nowatorskich, w rozumieniu przepisów o podatku akcyzowym
"GTU_05" - Dostawa odpadów - wyłącznie określonych w poz. 79-91 załącznika nr 15 do ustawy
"GTU_06" - Dostawa urządzeń elektronicznych oraz części i materiałów do nich, wyłącznie określonych w poz. 7-9, 59-63, 65, 66, 69 i 94-96 załącznika nr 15 do ustawy
"GTU_07" - Dostawa pojazdów oraz części samochodowych o kodach wyłącznie CN 8701 - 8708 oraz CN 8708 10
"GTU_08" - Dostawa metali szlachetnych oraz nieszlachetnych - wyłącznie określonych w poz. 1-3 załącznika nr 12 do ustawy oraz w poz. 12-25, 33-40, 45, 46, 56 i 78 załącznika nr 15 do ustawy
"GTU_09" - Dostawa leków oraz wyrobów medycznych - produktów leczniczych, środków spożywczych specjalnego przeznaczenia żywieniowego oraz wyrobów medycznych, objętych obowiązkiem zgłoszenia, o którym mowa w art. 37av ust. 1 ustawy z dnia 6 września 2001 r. - Prawo farmaceutyczne (Dz. U. z 2019 r. poz. 499, z późn. zm.)
"GTU_10" - Dostawa budynków, budowli i gruntów

Dla usług:
"GTU_11" - Świadczenie usług w zakresie przenoszenia uprawnień do emisji gazów cieplarnianych, o których mowa w ustawie z dnia 12 czerwca 2015 r. o systemie handlu uprawnieniami do emisji gazów cieplarnianych (Dz. U. z 2018 r. poz. 1201 i 2538 oraz z 2019 r. poz. 730, 1501 i 1532)
"GTU_12" - Świadczenie usług o charakterze niematerialnym - wyłącznie: doradczych, księgowych, prawnych, zarządczych, szkoleniowych, marketingowych, firm centralnych (head offices), reklamowych, badania rynku i opinii publicznej, w zakresie badań naukowych i prac rozwojowych
"GTU_13" - Świadczenie usług transportowych i gospodarki magazynowej - Sekcja H PKWiU 2015 symbol ex 49.4, ex 52.1
```

<a name="clients"></a>

## Klienci

<a name="k1"></a>
Lista klientów

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/clients.json?api_token=API_TOKEN&page=1"
```

<a name="k1b"></a>
Wyszukiwanie klientów po nazwie, mailu, nazwie skróconej lub numerze NIP

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/clients.json?api_token=API_TOKEN&name=CLIENT_NAME"
curl "https://YOUR_DOMAIN.fakturownia.pl/clients.json?api_token=API_TOKEN&email=EMAIL_ADDRESS"
curl "https://YOUR_DOMAIN.fakturownia.pl/clients.json?api_token=API_TOKEN&shortcut=SHORT_NAME"
curl "https://YOUR_DOMAIN.fakturownia.pl/clients.json?api_token=API_TOKEN&tax_no=TAX_NO"
```

<a name="k2"></a>
Pobranie wybranego klienta po ID

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/clients/100.json?api_token=API_TOKEN"
```

<a name="k2b"></a>
Pobranie wybranego klienta po zewnętrznym ID

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/clients.json?external_id=100&api_token=API_TOKEN"
```

<a name="k3"></a>
Dodanie klienta

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/clients.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"api_token": "API_TOKEN",
        "client": {
            "name": "Klient1",
            "tax_no": "6272616681",
            "bank" : "bank1",
            "bank_account" : "bank_account1",
            "city" : "city1",
            "country" : "",
            "email" : "email@gmail.com",
            "person" : "person1",
            "post_code" : "post-code1",
            "phone" : "phone1",
            "street" : "street1"
        }}'
```

Tylko parametr "name" jest obowiązkowy. Domyślnie każdy nowy klient ma status firmy ("company": true). Aby utworzyć klienta ze wskazaniem, że jest to osoba prywatna należy przesłać parametr  ```company``` (o wartości „false”) oraz parametr ```last_name``` (nazwisko):

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/clients.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"api_token": "API_TOKEN",
        "client": {
            "last_name": "LAST_NAME",
            "company": false
        }}'
```

Pola klienta

```shell
    "name": "Klient testowy" - nazwa klienta
    "shortcut": "Klient" - skrócona nazwa klienta
    "tax_no_kind": "NIP" - rodzaj numeru identyfikacyjnego np.: "NIP", "PESEL" itd.; po wejściu KSeF jedynymi dopuszczalnymi wartościami (oprócz pustego pola) będą: "nip_ue" (NIP UE), "other" (Numer identyfikacji podatkowej), "empty" (Brak nr. id. podatkowej)
    "tax_no": "1234567890" - numer identyfikacyjny
    "register_number": "123456789" - numer REGON
    "accounting_id": "" - identyfikator w programie księgowym
    "post_code": "00-100" - kod pocztowy
    "city": "Warszawa" - miasto
    "street": "Długa 1" - ulica
    "country": "PL" - kraj nabywcy (ISO 3166)
    "use_delivery_address": "1" lub "0", jeśli "1" wówczas można podać inny adres korespondencyjny w parametrze "delivery_address"
    "delivery_address": "" - inny adres korespondencyjny
    "first_name": "" - imię
    "last_name": "" - nazwisko
    "email": "" - email
    "phone": "" - telefon
    "mobile_phone": "" - telefon komórkowy
    "www": "" - strona www
    "fax": "" - fax
    "note": "" - dodatkowy opis klienta
    "tag_list": ["tag1", "tag2"] - lista tagów
    "company": "1" lub "0" (domyślna wartość tego parametru to "1"), użyj "1" - gdy klient jest firmą lub "0" - gdy klient jest osobą prywatną
    "kind": rodzaj klienta, możliwe opcje do wyboru:
        "buyer" - kupujący
        "seller" - sprzedający
        "both" - kupujący lub sprzedający
    "category_id": "" - id kategorii,
    "bank": "" - nazwa banku,
    "bank_account": "" - numer rachunku bankowego,
    "discount": "10" - domyślny rabat wyrażony w procentach, podajemy tylko liczbę np.: 15, oznacza to 15% rabatu
    "default_tax": "23" - domyślny podatek, podajemy wartość liczbową np.: 23
    "price_list_id": "" - domyślny cennik, podajemy id cennika
    "payment_to_kind": domyślny termin płatności, możliwe opcje do wyboru:
        liczba całkowita np.: "30" - co oznacza 30-dniowy termin płatności
        "0" - natychmiast
        "off" - nie wyświetlaj
        dowolna data np.: "2022-12-31"
    "default_payment_type": domyślny rodzaj płatności, możliwe opcje do wyboru:
        "transfer" - przelew
        "card" - karta płatnicza
        "cash" -  gotówka
        "barter" - barter
        "cheque" - czek
        "bill_of_exchange" - weksel
        "cash_on_delivery" - opłata za pobraniem
        "compensation" - kompensata
        "letter_of_credit" - akredytywa
        "payu" - PayU
        "paypal" - PayPal
        "off" - "nie wyświetlaj"
        "dowolny_inny_wpis_tekstowy"
    "disable_auto_reminders": "1" lub "0" - nie wysyłaj automatycznych przypomnień (domyślnie "0")
    "person": "Imię Nazwisko" - osoba przyjmująca fakturę
    "buyer_id": "" - powiązany nabywca, należy podać jego id
    "mass_payment_code": "" - indywidualne konto bankowe (lub końcówka konta)
    "external_id": "" - id klienta,
    "tp_client_connection": "1" lub "0"  - powiązania pomiędzy podmiotami (automatyczne dodanie kodu TP do dokumentu) (domyślnie "0")
```

<a name="k4"></a>
Aktualizacja klienta

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/clients/111.json \
    -X PUT \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json'  \
    -d '{"api_token": "API_TOKEN",
        "client": {
            "name": "Klient2",
            "tax_no": "62726166812",
            "bank" : "bank2",
            "bank_account" : "bank_account2",
            "city" : "city2",
            "country" : "PL",
            "email" : "email@gmail.com",
            "person" : "person2",
            "post_code" : "post-code2",
            "phone" : "phone2",
            "street" : "street2"
        }}'
```
<a name="k5"></a>
Usunięcie klienta

```shell
curl -X DELETE "https://YOUR_DOMAIN.fakturownia.pl/clients/CLIENT_ID.json?api_token=API_TOKEN"
```

<a name="products"></a>

## Produkty

<a name="p1"></a>
Lista produktów

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/products.json?api_token=API_TOKEN&page=1"
```

Lista dodanych/zmienionych produktów (np. dostępna ilość, nazwa, cena) po wskazanej dacie np. 2025-11-01

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/products.json?api_token=API_TOKEN&date_from=DATA&page=1"
```


<a name="p2"></a>
Lista produktów ze stanem magazynowym podanego magazynu

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/products.json?api_token=API_TOKEN&warehouse_id=WAREHOUSE_ID&page=1"
```

<a name="p3"></a>
Pobranie wybranego produktu po ID

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/products/100.json?api_token=API_TOKEN"
```

<a name="p4"></a>
Pobranie wybranego produktu po ID ze stanem magazynowym podanego magazynu

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/products/100.json?api_token=API_TOKEN&warehouse_id=WAREHOUSE_ID"
```

<a name="p5"></a>
Dodanie produktu

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/products.json \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json'  \
    -d '{"api_token": "API_TOKEN",
        "product": {
            "name": "PoroductAA",
            "code": "A001",
            "price_net": "100",
            "tax": "23"
        }}'
```

<a name="p5b"></a>
Dodanie produktu, który jest zestawem

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/products.json \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json'  \
    -d '{"api_token": "API_TOKEN",
        "product": {
            "name": "zestaw",
            "price_net": "100",
            "tax": "23",
            "service": "true",
            "package": "true",
            "package_products_details": {
                "0": {
                    "quantity": 1,
                    "id": PRODUCT_ID
                },
                "1": {
                    "quantity": 1,
                    "id": PRODUCT_ID
                },
                "2": {
                    "quantity": 1,
                    "id": PRODUCT_ID
                }
            },
        }}'
```

Pola produktu

```shell
    "name": "Produkt testowy" - nazwa
    "code": "PT35610" - kod produktu
    "ean_code": "5901296385074"- kod EAN
    "description": "Opis produktu" - opis
    "price_net": "100" - cenna netto
    "tax": "23" - podatek VAT może być wyrażony jako konkretna stawka np.: "5", "17" lub:
        "np" - nie podlega
        "zw" - zwolniony
        "disabled" - nie wyświetlaj
    "price_gross": "123" - cenna brutto
    "currency": "PLN" - waluta
    "category_id": "" - id kategorii
    "tag_list": ["tag1", "tag2"] - lista tagów
    "service": "1" lub "0" - czy produkt jest usługą
    "electronic_service": "1" lub "0" - czy produkt jest usługą elektroniczną
    "gtu_codes": ["GTU_01"] - kod GTU
    "limited": "1" lub "0" - ograniczenie ilościowe (magazynowe)
    "stock_level": "9.0" - dostępna ilość
    "purchase_price_net": "10" - cena zakupu netto
    "purchase_tax": "23" - podatek VAT
    "purchase_price_gross": "12.30" - cena zakupu brutto
    "package": "1" lub "0" - czy jest zestawem
    "quantity_unit": "szt" - jednostka
    "quantity": "1.0" - domyślnie sprzedawana ilość
    "additional_info": "" - PKWiU
    "supplier_code": "" - kod u dostawcy
    "accounting_id": "" - kod księgowy (sprzedaż)
    "disabled": "1" lub "0" - czy nieaktywny
    "use_moss": "1" lub "0" - czy podlega pod OSS
    "use_product_warehouses": "1" lub "0" - czy osobne ceny sprzedaży dla magazynów
    "size": "" - rozmiar
    "size_width": "" - szerokość
    "size_height": "" - wysokość
    "size_unit": "m" lub "cm" - jednostka wysokości/szerokości
    "weight": "" - waga
    "weight_unit": "kg" lub "g" - jednostka wagi
```

<a name="p6"></a>
Aktualizacja produktu

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/products/333.json \
    -X PUT \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json'  \
    -d '{"api_token": "API_TOKEN",
        "product": {
            "name": "PoroductAA2",
            "code": "A0012",
            "price_gross": "102",
	    "tax": "23"
        }}'
```
**Uwaga:** Cenna netto jest wyliczana na podstawie wartości ceny brutto oraz podatku, nie można jej edytować wprost przez API.


<a name="price_lists"></a>

## Cenniki

<a name="warehouse_documents"></a>

<a name="pricel1"></a>
Lista cenników

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/price_lists.json?api_token=API_TOKEN"
```
można przekazywać takie same parametry jakie są przekazywane w aplikacji (na stronie listy faktur)

<a name="pricel2"></a>
Dodanie cennika

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/price_lists.json
                -H 'Accept: application/json'
                -H 'Content-Type: application/json'
                -d '{
                "api_token": "API_TOKEN",
                "price_list": {
                    "name": "Nazwa cennika",
		    "description": "Opis",
		    "currency": "PLN",
                    "price_list_positions_attributes": {
		    	"0": {
				"priceable_id": "ID produktu",
				"priceable_name": "Nazwa produktu",
				"priceable_type": "Product",
				"use_percentage": "0",
				"percentage": "",
				"price_net": "111.0",
				"price_gross": "136.53",
				"use_tax": "1",
				"tax": "23"
			}
		    }
                }}'
```

<a name="pricel3"></a>
Aktualizacja cennika

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/price_lists/100.json
		-X PUT
                -H 'Accept: application/json'
                -H 'Content-Type: application/json'
                -d '{
                "api_token": "API_TOKEN",
                "price_list": {
                    "name": "Nazwa cennika",
                    "description": "Opis",
                    "currency": "PLN",
                    "price_list_positions_attributes": {
                        "0": {
                            "id": "ID pozycji",
                            "priceable_id": "ID produktu",
                            "price_net": "10.0",
                            "price_gross": "10.80"
                            "use_tax": "1",
                            "tax": "8"
                        }
                    }
                }}'
```

<a name="pricel4"></a>
Usunięcie cennika

```shell
curl -X DELETE "https://YOUR_DOMAIN.fakturownia.pl/price_lists/100.json?api_token=API_TOKEN"
```

## Dokumenty magazynowe

<a name="wd1"></a>
Wszystkie dokumenty magazynowe

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/warehouse_documents.json?api_token=API_TOKEN"
```
można przekazywać takie same parametry jakie są przekazywane w aplikacji (na stronie listy faktur)

<a name="wd2"></a>
Pobranie wybranego dokumentu po ID

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/warehouse_documents/555.json?api_token=API_TOKEN"
```

<a name="wd3a"></a>
Dodanie dokumentu magazynowego MM

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/warehouse_documents.json
                -H 'Accept: application/json'
                -H 'Content-Type: application/json'
                -d '{
                "api_token": "API_TOKEN",
                "warehouse_document": {
                    "kind":"mm",
                    "number": null,
                    "warehouse_id": "1",
                    "issue_date": "2017-10-23",
                    "department_name": "Department1 SA",
                    "client_name": "Client1 SA",
                    "warehouse_actions":[
                        {"product_name":"Produkt A1", "purchase_tax":23, "purchase_price_net":10.23, "quantity":1, "warehouse2_id":13}
                    ]
                }}'
```

<a name="wd3"></a>
Dodanie dokumentu magazynowego PZ

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/warehouse_documents.json
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{
				"api_token": "API_TOKEN",
				"warehouse_document": {
					"kind":"pz",
					"number": null,
					"warehouse_id": "1",
					"issue_date": "2017-10-23",
					"department_name": "Department1 SA",
					"client_name": "Client1 SA",
					"warehouse_actions":[
						{"product_name":"Produkt A1", "purchase_tax":23, "purchase_price_net":10.23, "quantity":1},
						{"product_name":"Produkt A2", "purchase_tax":0, "purchase_price_net":50, "quantity":2}
					]
				}}'
```

<a name="wd4"></a>
Dodanie dokumentu magazynowego WZ

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/warehouse_documents.json
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{
				"api_token": "API_TOKEN",
				"warehouse_document": {
					"kind":"wz",
					"number": null,
					"warehouse_id": "1",
					"issue_date": "2017-10-23",
					"department_name": "Department1 SA",
					"client_name": "Client1 SA",
					"warehouse_actions":[
						{"product_id":"333", "tax":23, "price_net":10.23, "quantity":1},
						{"product_id":"333", "tax":0, "price_net":50, "quantity":2}
					]
				}}'
```

<a name="wd5"></a>
Dodanie dokumentu magazynowego PZ dla istniejącego klienta, działu i produktu

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/warehouse_documents.json
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{
				"api_token": "API_TOKEN",
				"warehouse_document": {
					"kind":"pz",
					"number": null,
					"warehouse_id": "1",
					"issue_date": "2017-10-23",
					"department_id": "222",
					"client_id": "111",
					"warehouse_actions":[
						{"product_id":"333", "purchase_tax":23, "price_net":10.23, "quantity":1},
						{"product_id":"333", "purchase_tax":0, "price_net":50, "quantity":2}
					]
				}}'
```

<a name="wd6"></a>
Aktualizacja dokumentu

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/warehouse_documents/555.json
			 	-X PUT
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{"api_token": "API_TOKEN",
					"warehouse_document": {
						"client_name": "New client name SA"
				    }}'
```

<a name="wd7"></a>
Usunięcie dokumentu

```shell
curl -X DELETE "https://YOUR_DOMAIN.fakturownia.pl/warehouse_documents/100.json?api_token=API_TOKEN"
```

<a name="wd8"></a>
Połączenie istniejących faktur i dokumentu magazynowego

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/warehouse_documents/555.json
				-X PUT
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{"api_token": "API_TOKEN",
					"warehouse_document": {
						"invoice_ids": [
							100,
							111
						]
					}}'
```

<a name="payments"></a>

## Płatności

<a name="pl1"></a>
Wszystkie płatności

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/banking/payments.json?api_token=API_TOKEN"
```

można przekazywać takie same parametry jakie są przekazywane w aplikacji (na stronie listy płatności)


<a name="pl2"></a>
Pobranie wybranej płatności po ID

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/banking/payment/100.json?api_token=API_TOKEN"
```

<a name="pl3"></a>
Dodawanie nowej płatności

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/banking/payments.json \
				-H 'Accept: application/json' \
				-H 'Content-Type: application/json' \
				-d '{
					"api_token": "API_TOKEN",
					"banking_payment": {
						"name":"Payment 001",
						"price": 100.05,
						"invoice_id": null,
						"paid":true,
						"kind": "api"
				    }}'
```

<a name="pl4"></a>
Pobranie płatności wraz z danymi przypiętych faktur

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/banking/payments.json?include=invoices&api_token=API_TOKEN"
```
<a name="pl5"></a>
Dodanie nowej płatności powiązanej z istniejącymi fakturami

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/banking/payments.json \
				-H 'Accept: application/json' \
				-H 'Content-Type: application/json' \
				-d '{
					"api_token": "API_TOKEN",
					"banking_payment": {
						"name":"Payment 003",
						"price": 200,
						"invoice_ids": [555, 666],
						"paid":true,
						"kind": "api"
						}}'
```

Trzeba pamiętać, że faktury zostaną opłacone w takiej kolejności, w jakiej zostały podane w atrybucie `invoice_ids` - jeśli faktura o id = 555 została wystawiona na kwotę 100 zł, a faktura o id = 666 na 200 zł, to po dodaniu płatności pierwsza faktura zostanie opłacona w całości, natomiast druga zostanie opłacona w połowie.

<a name="pl6"></a>
Aktualizacja płatności

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/banking/payments/555.json
				-X PATCH
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{"api_token": "API_TOKEN",
					"banking_payment": {
						"name": "New payment name",
						"price": 100
						}}'
```

<a name="pl7"></a>
Usuwanie płatności

```shell
curl -X DELETE "https://YOUR_DOMAIN.fakturownia.pl/banking/payments/555.json?api_token=API_TOKEN"
```

<a name="categories"></a>

## Kategorie

<a name="cat1"></a>
Lista wszystkich kategorii

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/categories.json?api_token=API_TOKEN"
```

<a name="cat2"></a>
Pobranie pojedycznej kategorii po ID

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/categories/100.json?api_token=API_TOKEN"
```

<a name="cat3"></a>
Dodanie nowej kategorii

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/categories.json
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{
				"api_token": "API_TOKEN",
				"category": {
					"name":"my_category",
					"description": null
				}}'
```

<a name="cat4"></a>
Aktualizacja kategorii

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/categories/100.json
				-X PUT
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{
				"api_token": "API_TOKEN",
				"category": {
					"name":"my_category",
					"description": "new_description"
				}}'
```


<a name="cat5"></a>
Usunięcie kategorii o podanym ID

```shell
curl -X DELETE "https://YOUR_DOMAIN.fakturownia.pl/categories/100.json?api_token=API_TOKEN"
```

<a name="warehouses"></a>

## Magazyny

<a name="wh1"></a>
Lista wszystkich magazynów

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/warehouses.json?api_token=API_TOKEN"
```

<a name="wh2"></a>
Pobranie pojedycznego magazynu po ID

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/warehouses/100.json?api_token=API_TOKEN"
```

<a name="wh3"></a>
Dodanie nowego magazynu

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/warehouses.json
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{
				"api_token": "API_TOKEN",
				"warehouse": {
					"name":"my_warehouse",
					"kind": null,
					"description": null
				}}'
```

<a name="wh4"></a>
Aktualizacja magazynu

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/warehouses/100.json
				-X PUT
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{
				"api_token": "API_TOKEN",
				"warehouse": {
					"name":"my_category",
					"kind": null,
					"description": "new_description"
				}}'
```


<a name="wh5"></a>
Usunięcie magazynu o podanym ID

```shell
curl -X DELETE "https://YOUR_DOMAIN.fakturownia.pl/warehouses/100.json?api_token=API_TOKEN"
```

<a name="warehouse_actions"></a>

## Akcje magazynowe

<a name="wa1"></a>
Lista wszystkich akcji magazynowych

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/warehouse_actions.json?api_token=API_TOKEN"
```

Do wywołań można przekazywać dodatkowe parametry - takie same, które są używane w aplikacji, np. `page=`, `per_page=` itp.

Parametr `warehouse_id=` wypisze tylko akcje dla danego id magazynu

Parametr `kind=` wypisze tylko akcje danego rodzaju

Parametr `product_id=` wypisze tylko akcje dla danego id produktu

Parametr `date_from=` akcje utworzone po wybranej dacie

Parametr `date_to=` akcje utworzone przed wybraną datą

Parametr `from_warehouse_document=` akcje wydań połączone do wybranego dokumentu magazynowego

Parametr `to_warehouse_document=` akcje przyjęcia połączone do wybranego dokumentu magazynowego

Parametr `warehouse_document_id=` wszystkie akcje magazynowego dla wybranego dokumentu magazynowego

<a name="departments"></a>

## Działy

<a name="dep1"></a>
Lista wszystkich działów

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/departments.json?api_token=API_TOKEN"
```

<a name="dep2"></a>
Pobranie pojedycznego działu po ID

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/departments/100.json?api_token=API_TOKEN"
```

<a name="dep3"></a>
Dodanie nowego działu

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/departments.json
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{
				"api_token": "API_TOKEN",
				"department": {
					"name":"my_warehouse",
					"shortcut": "short_name",
					"tax_no": "-"
				}}'
```

<a name="dep4"></a>
Aktualizacja działu

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/departments/100.json
        -X PUT
        -H 'Accept: application/json'
        -H 'Content-Type: application/json'
        -d '{
        "api_token": "API_TOKEN",
        "department": {
          "name":"new_name",
          "shortcut": "new_short_name",
          "tax_no": "xxx-xxx-xx-xx"
        }}'
```

<a name="dep5"></a>
Usunięcie działu o podanym ID

```shell
curl -X DELETE "https://YOUR_DOMAIN.fakturownia.pl/departments/100.json?api_token=API_TOKEN"
```

<a name="dep6"></a>
Dodanie logo

```shell
curl -X PUT  https://YOUR_DOMAIN.fakturownia.pl/departments/DEPARTMENT_ID.json \
    -F 'api_token=API_TOKEN' \
    -F 'department[logo]=@/file_path/logo.png'
```
<a name="issuers"></a>

## Wystawcy

<a name="issuers1"></a>
Lista wszystkich wystawców

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/issuers.json?api_token=API_TOKEN"
```

<a name="issuers2"></a>
Pobranie wystawcy po ID

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/issuers/1.json?api_token=API_TOKEN"
```

<a name="issuers3"></a>
Dodanie nowego wystawcy

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/issuers.json
				-H 'Accept: application/json'
				-H 'Content-Type: application/json'
				-d '{
				"api_token": "API_TOKEN",
				"issuer": {
					"name":"Issuer",
					"tax_no": "4170106662"
				}}'
```

<a name="issuers4"></a>
Aktualizacja wystawcy

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/issuers/1.json
        -X PUT
        -H 'Accept: application/json'
        -H 'Content-Type: application/json'
        -d '{
        "api_token": "API_TOKEN",
        "issuer": {
          "name":"new_name",
        }}'
```

<a name="issuers5"></a>
Usunięcie wystawcy po ID

```shell
curl -X DELETE "https://YOUR_DOMAIN.fakturownia.pl/issuers/1.json?api_token=API_TOKEN"
```

<a name="get_token_by_api"></a>

## Logowanie i pobranie danych przez API

```shell
curl https://app.fakturownia.pl/login.json \
    -H 'Accept: application/json'  \
    -H 'Content-Type: application/json' \
    -d '{
            "login": "login_or_email",
            "password": "password",
	    "integration_token": ""
    }'
```

To zapytanie zwraca token i informacje o URL konta w Fakturowni (pola `prefix` i `url`):

```shell
{
	"login":"marcin",
	"email":"email@test.pl",
	"prefix":"YYYYYYY",
	"url":"https://YYYYYYY.fakturownia.pl",
	"first_name":"Jan",
	"last_name":"Kowalski",
	"api_token":"XXXXXXXXXXXXXX"
}
```

UWAGA: api_token jest zwracany tylko jeśli dany użytkownik ma wygenerowany API Token (użytkownik może go dodać w ustawieniach konta)


<a name="usersystem"></a>

## Dodawanie użytkowników

Po utworzeniu konta API i określeniu właściciela (patrz wyżej), możesz dodać innych użytkowników do konta poprzez API i zdefiniować ich rolę.<br>
Aby dodać użytkownika do konta, musisz wysłać:
   - kod API Twojego konta (```api_token```)
   - Twój kod do umieszczenia na stronie (```integration_token```). Aby go otrzymać skontaktuj się z nami poprzez wiadomość e-mail info@fakturownia.pl.
   - określenia parametru ```invite``` :
	  - jeśli użytkownik musi zostać stworzony ("false"): oprócz przesłania adresu e-mail należy także wybrać hasło
	  - jeśli użytkownik już istnieje i jest powiązany z kontem w Fakturowni ("true"): wymagany jest tylko jego adres e-mail
   - rola użytkownika (```role```) 
	  - dla jednej z domyślnych ról wybierz wartość: "member" dla zwykłego użytkownika, "admin" dla administratora lub "accountant" dla księgowego.
	  - w przypadku niestandardowej roli wpisz wartość "role_1234" lub 1234, która reprezentuje niestandardowy identyfikator roli konta.
   - identyfikatory działu (```department_ids```), do których ma dostęp użytkownik nie będący administratorem.

Aby dowiedzieć się więcej o rolach użytkowników zapraszamy do bazy wiedzy: https://pomoc.fakturownia.pl/28889135-Wlasne-role-uprawnienia-uzytkownika-w-Fakturowni.<br>

```shell
POST https://YOUR_DOMAIN.fakturownia.pl/account/add_user.json
Content-Type: application/json
{
  "api_token": "API_TOKEN",
  "integration_token": "INTEGRATION_TOKEN",
  "user": {
    "invite": true,
    "email": "email@test.pl",
    "password": "Password123",
    "role": "member",
    "department_ids": []
  }
}
```


<a name="accounts"></a>

## Konta Systemowe

<a name="a1"></a>

### Zakładanie konta

Jest to opcja dla Partnerów, którzy chcą zakładać konta Fakturowni z poziomu swojej aplikacji. Np. mogą to być
dostawcy sklepów internetowych, systemów rezerwacji itp lub innych systemów którzy chcą udostępnić swoim użytkownikom funkcjonalność wystawiania faktur.

Klient w portalu Partnera jednym przyciskiem może założyć konto i od razu zacząć wystawiać faktury (nie musi samodzielnie zakładać konta w Fakturownia.pl)

Pola: user.login, user.from_partner, user, company nie są wymagane

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/account.json \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
            "api_token": "API_TOKEN",
            "account": {
                "prefix": "prefix1",
		"lang": "pl"
            },
            "user": {
                "login": "login1",
                "email": "email1@email.pl",
                "password": "password1",
                "from_partner": "PARTNER_CODE"
            },
            "company": {
                "name": "Company1",
                "tax_no": "5252445700",
                "post_code": "00-112",
                "city": "Warsaw",
                "street": "Street 1/10",
                "person": "Jan Nowak",
                "bank": "Bank1",
                "bank_account": "111222333444555666111"
            },
	    "integration_token": ""
        }'

```

UWAGA: parametr ```integration_token``` jest wymagany, jeśli chcemy pobrać aktualny api_token użytkownika (aby otrzymać integration_token dla Twojej zintegrowanej aplikacji prosimy o kontakt z nami)


Po utworzeniu konta zwracane są:

```shell

{
	"prefix":"prefix126", - prefix utworzonego konta (moze byc innny niz podany, gdy podany już istniał)
	"api_token":"62YPJfIekoo111111", - kod dostepu do utworzonego konta
	"url":"https://prefix126.fakturownia.pl", - url utworzonego konta
	"login":"login1", - login użytkownika  (moze byc innny niz podany, gdy podany już istniał)
	"email":"email1@email.pl"
}
```

Inne pola dostępne przy tworzeniu nowego konta (pomocne przy integracji)

```shell
	"account": {
		"prefix": "prefix-konta",
		"lang": "pl",
		"integration_fast_login": true - umożliwia automatyczne logowanie Twoich użytkowników w Fakturowni
		"integration_logout_url": "http://twojastrona.pl/" - umożliwia powrót Twoich użytkowników na Twoją stronę po ich wylogowaniu się z Fakturowni
	}
```

<a name="a2"></a>

### Pobranie informacji o koncie:

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/account.json?api_token=API_TOKEN&integration_token="
```

<a name="a3"></a>

### Usuwanie konta

Po wysłaniu żądania dalsza procedura usunięcia konta jest identyczna, jak przy zrobieniu tego przez aplikację tj. zostanie wysłany e-mail z linkiem potwierdzającym usunięcie konta.

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/account/delete.json \
    -X POST \
    -H 'Accept:application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN"
    }'
```

przykład odpowiedzi:

```shell
{
    "code": "success",
    "message": "Link do usunięcia konta wysłany!"
}
```


<a name="a4"></a>

### Odłączanie konta

Ten endpoint służy do odłączania konta (dalej SUB_DOMAIN) od biura księgowego.

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/account/unlink.json \
    -X PATCH \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "prefix": "SUB_DOMAIN_1"
    }'
```

albo

```shell
curl https://YOUR_DOMAIN.fakturownia.pl/account/unlink.json \
    -X PATCH \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "api_token": "API_TOKEN",
        "prefix": ["SUB_DOMAIN_1", "SUB_DOMAIN_2", "SUB_DOMAIN_3"]
    }'
```

przykłady odpowiedzi:

SUB_DOMAIN_3 nie było podpięte
```shell
{
    "code": "success",
    "message": "Konta odłączone",
    "result": {
        "unlinked": [
            "SUB_DOMAIN_1",
            "SUB_DOMAIN_2"
        ],
        "not_unlinked": [
            "SUB_DOMAIN_3"
        ]
    }
}
```

żadne konto nie było podpięte
```shell
{
    "code": "error",
    "message": "Brak kont do odłączenia",
    "result": {
        "not_unlinked": [
            "SUB_DOMAIN_1",
            "SUB_DOMAIN_2",
            "SUB_DOMAIN_3"
        ]
    }
}
```

<a name="codes"></a>

## Przykłady w PHP i Ruby

<https://github.com/radgost/fakturownia-api/blob/master/example1.php></a>

<https://github.com/radgost/fakturownia-api/blob/master/example1.rb></a>

Ruby Gem do integracji z Fakturownia.pl: <https://github.com/kkempin/fakturownia></a>

<a name="webhooks"></a>

## Webhooki

* `GET /webhooks.json` - pobranie listy webhooków
* `GET /webhooks/1.json` - pobranie webhooka
* `POST /webhooks.json` - dodanie nowego webhooka
* `PUT /webhooks/1.json` - aktualizacja webhooka
* `DELETE /webhooks/1.json` - skasowanie webhooka

Przykład:

```shell
curl "https://YOUR_DOMAIN.fakturownia.pl/webhooks.json?api_token=API_TOKEN"
```

<a name="eparagony"></a>

## E-paragony i Paragony papierowe

tu opis: https://github.com/e-paragony/api
