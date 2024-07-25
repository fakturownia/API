#!/usr/bin/env ruby


#zobacz GEM na: https://github.com/kkempin/fakturownia
require 'net/https'
require 'uri'
require 'json'


endpoint = 'http://YOUR_DOMAIN.fakturownia.pl/invoices.json'
uri = URI.parse(endpoint)

json_params = {
"api_token" => "YOUR_TOKEN_FROM_APP_SETTINGS",
"invoice" => {
  "kind" =>"vat", 
	"number" => nil, 
	"sell_date" => "2013-07-19", 
	"issue_date" => "2013-07-19", 
	"payment_to" => "2013-07-26",
	"seller_name" => "Wystawca Sp. z o.o.", 
	"seller_tax_no" => "6272616681", 
	"buyer_name" => "Klient1 Sp. z o.o.",
	"buyer_tax_no" => "6272616681",
	"positions" =>[
		{"name" =>"Produkt A1", "tax" =>23, "total_price_gross" =>10.23, "quantity" =>1},
		{"name" =>"Produkt A2", "tax" =>0, "total_price_gross" =>50, "quantity" =>3}
	]		
}}

request = Net::HTTP::Post.new(uri.path)
request.body = JSON.generate(json_params)
request["Content-Type"] = "application/json"

http = Net::HTTP.new(uri.host, uri.port)
response = http.start {|h| h.request(request)}

if response.code == '201'
	ret = JSON.parse(response.body)    
else
	ret = response.body
end

puts ret.to_json

