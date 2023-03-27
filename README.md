# Query the Azure Retail Rates Prices API

## Content

- [Introduction](#introduction)
- [Python Client](#python-client)
    - [Samples](#samples)
        - [Sample #1](#sample-1)
        - [Sample #2](#sample-2)
        - [Sample #3](#sample-3)
- [PowerShell Function](#powershell-function)
    - [Samples](#samples-1)
        - [Sample #1](#sample-1-1)
        - [Sample #2](#sample-2-1)
        - [Sample #3](#sample-3-1)
- [Issues and Enhancements](#issues--potential-enhancements)
- [References](#references)

## Introduction

This repository contains scripts/code for *testing* and *learning* how to query the Azure Retail Rates Prices API.

The code is based upon the REST API that is [described here in full detail](https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices) [1].

The preview API is not reflected so far, although it should be relatively easy to implement. The purpose of this repository and the code is to test and learn how to query Azure prices from the API.

Code samples include Python and PowerShell.

## Python Client

The Python sample code makes use of three libraries:
- [`requests`](https://pypi.org/project/requests/), which is an HTTP library used to send HTTP/1.1 requests. [2]
- [`tabulate`](https://pypi.org/project/tabulate/), which is a library to pretty-print tabular data in Python. [3]
- [`json`](https://docs.python.org/3/library/json.html#module-json), which is a libary used to encode/decode data with JSON

For following along and test the code (or parts of it), it might be required to install (except _json_ since it is part of Python anyways) and import aforementioned libraries. 

The versions with which the code samples were tested is contained in the [requirements.txt](requirements.txt) file.

### Samples

Some code samples on how the `AzureRetailPricesClient` class could be used.

#### Sample #1

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

#### Sample #2

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

#### Sample #3

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

## PowerShell Function

The PowerShell function can be found in the [AzureRetailPrices.ps1](AzureRetailPrices.ps1) file. In order to be used it would have to be dot-sourced and then called accordingly.

```powershell
. .\AzureRetailPrices.ps1
```

The cmdlet syntax is outlined below.

```powershell
Get-AzureRetailPrice 
    [[-armRegionName] <string>] 
    [[-location] <string>] 
    [[-meterId] <string>] 
    [[-meterName] <string>] 
    [[-productId] <string>]
    [[-skuId] <string>] 
    [[-productName] <string>] 
    [[-skuName] <string>] 
    [[-serviceName] <string>] 
    [[-serviceId] <string>] 
    [[-serviceFamily] <string>] 
    [[-priceType] <string>] 
    [[-armSkuName] <string>] 
    [[-apiUrl] <string>] 
    [[-currencyCode] <string>] 
    [<CommonParameters>]
```

The parameters are based on the [API's supported query filters](https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices#api-filters). [5]

### Samples

#### Sample #1

- List all _consumption_ prices for _Standard_B2ms_ VMs in the _Southeast Asia_ Azure Region
- Limit the output to certain properties

```powershell
Get-AzureRetailPrice -armSkuName Standard_B2ms `
                     -armRegionName southeastasia `
                     -priceType Consumption `
                     -serviceFamily Compute
```

Output:

```powershell
currencyCode         : USD
tierMinimumUnits     : 0
retailPrice          : 0.114
unitPrice            : 0.114
armRegionName        : southeastasia
location             : AP Southeast
effectiveStartDate   : 01/11/2021 00:00:00
meterId              : 2cdd6a4a-3403-4e21-8221-14c505a99ffd
meterName            : B2ms
productId            : DZH318Z0BQNH
skuId                : DZH318Z0BQNH/006J
availabilityId       :
productName          : Virtual Machines BS Series Windows
skuName              : B2ms
serviceName          : Virtual Machines
serviceId            : DZH313Z7MMC8
serviceFamily        : Compute
unitOfMeasure        : 1 Hour
type                 : Consumption
isPrimaryMeterRegion : True
armSkuName           : Standard_B2ms

currencyCode         : USD
tierMinimumUnits     : 0
retailPrice          : 0.106
unitPrice            : 0.106
armRegionName        : southeastasia
location             : AP Southeast
effectiveStartDate   : 01/11/2021 00:00:00
meterId              : 9cd6a144-e063-431e-9b28-5159c0db3f51
meterName            : B2ms
productId            : DZH318Z0BQ35
skuId                : DZH318Z0BQ35/00N1
availabilityId       :
productName          : Virtual Machines BS Series
skuName              : B2ms
serviceName          : Virtual Machines
serviceId            : DZH313Z7MMC8
serviceFamily        : Compute
unitOfMeasure        : 1 Hour
type                 : Consumption
isPrimaryMeterRegion : True
armSkuName           : Standard_B2ms
```

#### Sample #2

- List all prices for _P10 LRS Disks_ across all Azure Regions
- Limit the output to _location_, _meterName_, _unitOfMeasure_ and _retailPrice_
- Sort _descending_ by _retailPrice_

```powershell
Get-AzureRetailPrice -meterName 'P10 LRS Disk' -productName 'Premium SSD Managed Disks' | Select-Object location, meterName, unitOfMeasure, retailPrice | Sort-Object retailPrice -Descending
```

Output:

```powershell
location         meterName    unitOfMeasure retailPrice
--------         ---------    ------------- -----------
BR Southeast     P10 LRS Disk 1/Month             44.27
BR South         P10 LRS Disk 1/Month             34.05
CH West          P10 LRS Disk 1/Month             31.00
FR South         P10 LRS Disk 1/Month             31.00
NO West          P10 LRS Disk 1/Month             31.00
ZA West          P10 LRS Disk 1/Month             30.11
DE North         P10 LRS Disk 1/Month             28.18
SE South         P10 LRS Disk 1/Month             28.18
AE Central       P10 LRS Disk 1/Month             27.96
ZA North         P10 LRS Disk 1/Month             24.01
PL Central       P10 LRS Disk 1/Month             23.85
UK West          P10 LRS Disk 1/Month             23.85
CH North         P10 LRS Disk 1/Month             23.85
NO East          P10 LRS Disk 1/Month             23.85
FR Central       P10 LRS Disk 1/Month             23.85
UK South         P10 LRS Disk 1/Month             23.85
JA East          P10 LRS Disk 1/Month             22.67
DE West Central  P10 LRS Disk 1/Month             21.68
AP East          P10 LRS Disk 1/Month             21.68
SE Central       P10 LRS Disk 1/Month             21.68
EU West          P10 LRS Disk 1/Month             21.68
QA Central       P10 LRS Disk 1/Month             21.50
AE North         P10 LRS Disk 1/Month             21.50
JA West          P10 LRS Disk 1/Month             20.61
CA East          P10 LRS Disk 1/Month             19.71
CA Central       P10 LRS Disk 1/Month             19.71
US East          P10 LRS Disk 1/Month             19.71
AU East          P10 LRS Disk 1/Month             19.71
AU Southeast     P10 LRS Disk 1/Month             19.71
AP Southeast     P10 LRS Disk 1/Month             19.71
KR Central       P10 LRS Disk 1/Month             19.71
EU North         P10 LRS Disk 1/Month             19.71
US Central       P10 LRS Disk 1/Month             19.71
IN Central Jio   P10 LRS Disk 1/Month             19.71
IN Central       P10 LRS Disk 1/Month             19.71
AU Central       P10 LRS Disk 1/Month             19.71
US West          P10 LRS Disk 1/Month             19.71
US Gov Virginia  P10 LRS Disk 1/Month             19.71
KR South         P10 LRS Disk 1/Month             19.71
US Gov TX        P10 LRS Disk 1/Month             19.71
IN West          P10 LRS Disk 1/Month             19.71
IN West Jio      P10 LRS Disk 1/Month             19.71
US Gov AZ        P10 LRS Disk 1/Month             19.71
AU Central 2     P10 LRS Disk 1/Month             19.71
US North Central P10 LRS Disk 1/Month             19.71
ATT Dallas 1     P10 LRS Disk 1/Month             17.92
US West Central  P10 LRS Disk 1/Month             17.92
US South Central P10 LRS Disk 1/Month             17.92
US East 2        P10 LRS Disk 1/Month             17.92
ATT Atlanta 1    P10 LRS Disk 1/Month             17.92
US West 2        P10 LRS Disk 1/Month             17.92
US West 3        P10 LRS Disk 1/Month             17.92
IN South         P10 LRS Disk 1/Month             17.74
```

#### Sample #3

- List all _reservation_ prices for _Standard_M8ms_ VMs in the _East US_ Azure Region
- Return them as json

```powershell
Get-AzureRetailPrice -armSkuName Standard_M8ms -armRegionName eastus -priceType Reservation | ConvertTo-Json
```

Output:

```json
[
  {
    "currencyCode": "USD",
    "tierMinimumUnits": 0.0,
    "reservationTerm": "3 Years",
    "retailPrice": 11297.0,
    "unitPrice": 11297.0,
    "armRegionName": "eastus",
    "location": "US East",
    "effectiveStartDate": "2018-05-01T00:00:00Z",
    "meterId": "005c7d8a-2d63-4d43-bf78-c75346687b0e",
    "meterName": "M8ms",
    "productId": "DZH318Z0BQ4W",
    "skuId": "DZH318Z0BQ4W/00H3",
    "availabilityId": null,
    "productName": "Virtual Machines MS Series",
    "skuName": "M8ms",
    "serviceName": "Virtual Machines",
    "serviceId": "DZH313Z7MMC8",
    "serviceFamily": "Compute",
    "unitOfMeasure": "1 Hour",
    "type": "Reservation",
    "isPrimaryMeterRegion": true,
    "armSkuName": "Standard_M8ms"
  },
  {
    "currencyCode": "USD",
    "tierMinimumUnits": 0.0,
    "reservationTerm": "1 Year",
    "retailPrice": 7740.0,
    "unitPrice": 7740.0,
    "armRegionName": "eastus",
    "location": "US East",
    "effectiveStartDate": "2018-05-01T00:00:00Z",
    "meterId": "005c7d8a-2d63-4d43-bf78-c75346687b0e",
    "meterName": "M8ms",
    "productId": "DZH318Z0BQ4W",
    "skuId": "DZH318Z0BQ4W/00FV",
    "availabilityId": null,
    "productName": "Virtual Machines MS Series",
    "skuName": "M8ms",
    "serviceName": "Virtual Machines",
    "serviceId": "DZH313Z7MMC8",
    "serviceFamily": "Compute",
    "unitOfMeasure": "1 Hour",
    "type": "Reservation",
    "isPrimaryMeterRegion": true,
    "armSkuName": "Standard_M8ms"
  }
]
```

## Issues / Potential Enhancements

- The code is lacking logging and error-handling capabilities.
- There are no query-meachanisms beyond those that are provided by the API already. 

## References

| #    | Title                        | URL                                                                                                      |
| :--- | :---                         | :---                                                                                                     |
| 1    | Azure Retail Prices overview | https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices             |
| 2    | Requests                     | https://pypi.org/project/requests/                                                                       |
| 3    | python-tabulate              | https://pypi.org/project/tabulate/                                                                       |
| 5    | API filters                  | https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices#api-filters |
