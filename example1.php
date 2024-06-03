<?php

$host = 'XXXXXX.fakturownia.pl';
$token = 'XXXXXXXXXX';
$json ='{ "api_token": "'.$token.'", "invoice": { "kind":"vat", "number": null, "sell_date": "2013-04-17", "issue_date": "2013-04-17", "payment_to": "2013-04-24", "seller_name": "Wystawca Sp. z o.o.", "seller_tax_no": "6272616681", "buyer_name": "Klient1 Sp. z o.o.", "buyer_tax_no": "6272616681", "positions":[ {"name":"Produkt A1", "tax":23, "total_price_gross":10.23, "quantity":1}, {"name":"Produkt A2", "tax":0, "total_price_gross":50, "quantity":3} ] }}';

$c = curl_init();
curl_setopt($c, CURLOPT_URL, 'https://'.$host.'/invoices.json');

$head[] ='Accept: application/json';
$head[] ='Content-Type: application/json';
curl_setopt($c, CURLOPT_HTTPHEADER, $head);
curl_setopt($c, CURLOPT_POSTFIELDS, $json);

curl_exec($c);

?>
