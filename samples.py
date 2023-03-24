### Sample #1
### List all prices for P10 Disks in the West Europe Azure Region
### Return them as dictionary

from AzureRetailPricesApi import AzureRetailPricesClient
api = AzureRetailPricesClient()
data = api.query(armSkuName='Premium_SSD_Managed_Disk_P10', armRegionName='westeurope')
print(data)


### Sample #2
### List all reservation prices for Standard_M8ms VMs in the East US Azure Region
### Return them as json

from AzureRetailPricesApi import AzureRetailPricesClient
api = AzureRetailPricesClient()
api.format = 'json'
data = api.query(armSkuName='Standard_M8ms', armRegionName='eastus', priceType='Reservation')
print(data)


### Sample #3
### List all consumption prices for Standard_B2ms VMs in the Southeast Asia Azure Region
### Limit the output to certain properties
### Return them as table

from AzureRetailPricesApi import AzureRetailPricesClient
api = AzureRetailPricesClient()
api.format = 'table'
api.return_values = ['currencyCode', 'unitOfMeasure', 'retailPrice', 'unitPrice', 'armRegionName', 'type', 'meterName', 'skuName', 'productName']
data = api.query(armSkuName='Standard_B2ms', armRegionName='southeastasia', priceType='Consumption', serviceFamily='Compute')
print(data)