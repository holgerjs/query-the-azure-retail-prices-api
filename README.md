# Query the Azure Retail Rates Prices API
This repository contains scripts (for now, only one) to query the Azure Retail Rates Prices API.

The code is based upon the REST API that is [described here in full detail](https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices) [1].

The preview API is not reflected so far, although it should be relatively easy to implement. The purpose of this repository and the code is to test and query Azure prices from the API.

The sample code makes use of three libraries:
- [`requests`](https://pypi.org/project/requests/), which is an HTTP library used to send HTTP/1.1 requests. [2]
- [`tabulate`](https://pypi.org/project/tabulate/), which is a library to pretty-print tabular data in Python. [3]
- [`json`](https://docs.python.org/3/library/json.html#module-json), which is a libary used to encode/decode data with JSON

For following along and test the code (or parts of it), it might be required to install (except _json_ since it is part of Python anyways) and import aforementioned libraries. 

The versions with which the code samples were tested is contained in the [requirements.txt](requirements.txt) file.

## Samples

Some code samples on how the `AzureRetailPricesApi` class could be used.

### Sample #1

- List all prices for _P10 Disks_ in the _West Europe_ Azure Region
- Return them as dictionary

```python
from AzureRetailPricesApi import AzureRetailPricesClient
api = AzureRetailPricesClient()
data = api.query(armSkuName='Premium_SSD_Managed_Disk_P10', armRegionName='westeurope')
print(data)
```

Output:

```python
[{'currencyCode': 'USD', 'tierMinimumUnits': 0.0, 'retailPrice': 21.68, 'unitPrice': 21.68, 'armRegionName': 'westeurope', 'location': 'EU West', 'effectiveStartDate': '2018-05-01T00:00:00Z', 'meterId': '137d3f72-fe0e-4a78-b5d0-92d704aa3cac', 'meterName': 'P10 LRS Disk', 'productId': 'DZH318Z0BP04', 'skuId': 'DZH318Z0BP04/0080', 'availabilityId': None, 'productName': 'Premium SSD Managed Disks', 'skuName': 'P10 LRS', 'serviceName': 'Storage', 'serviceId': 'DZH317F1HKN0', 'serviceFamily': 'Storage', 'unitOfMeasure': '1/Month', 'type': 'Consumption', 'isPrimaryMeterRegion': True, 'armSkuName': 'Premium_SSD_Managed_Disk_P10'}, ...] 
```

### Sample #2

- List all _reservation_ prices for _Standard_M8ms_ VMs in the _East US_ Azure Region
- Return them as json

```python
from AzureRetailPricesApi import AzureRetailPricesClient
api = AzureRetailPricesClient()
api.format = 'json'
data = api.query(armSkuName='Standard_M8ms', armRegionName='eastus', priceType='Reservation')
print(data)
```

Output:

```json
[
  {
    "armRegionName": "eastus",
    "armSkuName": "Standard_M8ms",
    "availabilityId": null,
    "currencyCode": "USD",
    "effectiveStartDate": "2018-05-01T00:00:00Z",
    "isPrimaryMeterRegion": true,
    "location": "US East",
    "meterId": "005c7d8a-2d63-4d43-bf78-c75346687b0e",
    "meterName": "M8ms",
    "productId": "DZH318Z0BQ4W",
    "productName": "Virtual Machines MS Series",
    "reservationTerm": "3 Years",
    "retailPrice": 11297.0,
    "serviceFamily": "Compute",
    "serviceId": "DZH313Z7MMC8",
    "serviceName": "Virtual Machines",
    "skuId": "DZH318Z0BQ4W/00H3",
    "skuName": "M8ms",
    "tierMinimumUnits": 0.0,
    "type": "Reservation",
    "unitOfMeasure": "1 Hour",
    "unitPrice": 11297.0
  },
  {
    "armRegionName": "eastus",
    "armSkuName": "Standard_M8ms",
    "availabilityId": null,
    "currencyCode": "USD",
    "effectiveStartDate": "2018-05-01T00:00:00Z",
    "isPrimaryMeterRegion": true,
    "location": "US East",
    "meterId": "005c7d8a-2d63-4d43-bf78-c75346687b0e",
    "meterName": "M8ms",
    "productId": "DZH318Z0BQ4W",
    "productName": "Virtual Machines MS Series",
    "reservationTerm": "1 Year",
    "retailPrice": 7740.0,
    "serviceFamily": "Compute",
    "serviceId": "DZH313Z7MMC8",
    "serviceName": "Virtual Machines",
    "skuId": "DZH318Z0BQ4W/00FV",
    "skuName": "M8ms",
    "tierMinimumUnits": 0.0,
    "type": "Reservation",
    "unitOfMeasure": "1 Hour",
    "unitPrice": 7740.0
  }
]
```

### Sample #3

- List all _consumption_ prices for _Standard_B2ms_ VMs in the _Southeast Asia_ Azure Region
- Limit the output to certain properties
- Return them as table

```python
from AzureRetailPricesApi import AzureRetailPricesClient
api = AzureRetailPricesClient()
api.format = 'table'
api.return_values = ['currencyCode', 'unitOfMeasure', 'retailPrice', 'unitPrice', 'armRegionName', 'type', 'meterName', 'skuName', 'productName']
data = api.query(armSkuName='Standard_B2ms', armRegionName='southeastasia', priceType='Consumption', serviceFamily='Compute')
print(data)
```

Output:

```text
currencyCode    unitOfMeasure      retailPrice    unitPrice  armRegionName    type         meterName    skuName    productName
--------------  ---------------  -------------  -----------  ---------------  -----------  -----------  ---------  ----------------------------------
USD             1 Hour                   0.114        0.114  southeastasia    Consumption  B2ms         B2ms       Virtual Machines BS Series Windows
USD             1 Hour                   0.106        0.106  southeastasia    Consumption  B2ms         B2ms       Virtual Machines BS Series
```

## Issues / Potential Enhancements

- The code is lacking logging and error-handling capabilities.
- There are no query-meachanisms beyond those that are provided by the API already. 

## References

| #    | Title                        | URL                                                                                          |
| :--- | :---                         | :---                                                                                         |
| 1    | Azure Retail Prices overview | https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices |
| 2    | Requests                     | https://pypi.org/project/requests/                                                           |
| 3    | python-tabulate              | https://pypi.org/project/tabulate/                                                           |