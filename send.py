import requests
import json

new_parcel_data = {
  "parcel": {
    "name": "Thomas Sarafian",
    "company_name": "Rock Don't Stock",
    "address": "rue Dugas Montbel",
    "house_number": "30",
    "city": "Lyon",
    "postal_code": "69002",
    "telephone": "+33606860076",
    "request_label": True,
    "email": "thomassarafian@gmail.com",
    "data": [],
    "country": "FR",
    "shipment": {
      "id": 8,
      "name": "Mondial Relay Home International 0.5-1kg"
    },
    "weight": "1.000",
    "order_number": "1234567890",
    "insured_value": 2000,
    "total_order_value_currency": "EUR",
    "total_order_value": "200",
    "quantity": 1,
  }
}

response = requests.post(
  'https://panel.sendcloud.sc/api/v2/parcels',
  json=new_parcel_data,
  auth=('e8c6942325754f2ea2d6c34f03afe5cf', 'eced3bd8318f4bb7ad481bcc920800dc')
)

#print(response.text);
print(json.dumps(response.json(), indent=2))
