#########################################################################################
#
#    Query the Azure Retail Prices API
#    The class can be used like this (example):
#
#       from AzureRetailPricesApi import AzureRetailPricesClient
#       api = AzureRetailPricesClient()
#       api.format = 'table'
#       api.return_values = ['currencyCode', 'unitOfMeasure', 'retailPrice', 'unitPrice', 'armRegionName', 'type', 'meterName', 'skuName', 'productName']
#       data = api.query(armSkuName='Premium_SSD_Managed_Disk_P10', armRegionName='westeurope')
#       print(data)
#
#   The Azure Retail Rates Prices API is documented here: https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices
#
#########################################################################################

import requests
import json
from tabulate import tabulate

class AzureRetailPricesClient:    

    # Init Function
    def __init__(
            self,
            url: str = 'https://prices.azure.com/api/retail/prices',
            currency_code: str = 'USD',
            sort_by: str = 'armRegionName',
            format = None,
            return_values = None
            ) -> None:

        self.url = url
        self.currency_code = currency_code
        self.sort_by = sort_by
        self.format = format
        self.return_values = return_values

    # Relatively useless but just in case
    def as_dict(self) -> dict:
        return dict({
            'url': self.url,
            'currency_code': self.currency_code,
            'sort_by': self.sort_by,
            'format': self.format,
            'return_values': self.return_values
        })
    
    # String representation of some parameters
    def __str__(self) -> str:
        return f'(url: {self.url}, currency_code: {self.currency_code}, sort_by: {self.sort_by}, format: {self.format}, return_values: {self.return_values})'

    # Main function to query the API
    # API Parameters are listed here: https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices
    def query(
            self,
            armRegionName: str = None, 
            location: str = None, 
            meterId: str = None, 
            meterName: str = None, 
            productid: str = None, 
            skuId: str = None, 
            productName: str = None, 
            skuName: str = None,
            serviceName: str = None,
            serviceId: str = None,
            serviceFamily: str = None,
            priceType: str = None,
            armSkuName: str = None
            ) -> dict:
        '''
        Function to query the Azure Retail Prices API. See the API documentation at https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices for details.
        Possible filters are:
            armRegionName
            location
            meterId
            meterName
            productid
            skuId
            productName
            skuName
            serviceName
            serviceId
            serviceFamily
            priceType
            armSkuName
        '''

        parameters = locals()

        criterias = []
        for parameter_name, parameter_value in parameters.items():
            if parameter_name != 'self':
                if parameter_value is not None:
                    criterias.append(f"{parameter_name} eq '{parameter_value}'")

        if criterias:
            filter = f"?currencyCode='{self.currency_code}'&$filter="
            for criteria in criterias:
                if criteria != criterias[len(criterias)-1]:
                    filter += f"{criteria} and "
                else:
                    filter += f"{criteria}"
        else:
            filter = f"?currencyCode='{self.currency_code}'"

        url = self.url+filter

        all_price_records = []
        
        while True:
            if not url:
                break
            response = requests.get(url)
            if response.status_code == 200:
                json_data = response.json()
                url = json_data['NextPageLink'] # Fetch next link
                all_price_records = all_price_records + json_data['Items']
            else:
                print(response.status_code)
        
        return_price_records = []

        if self.return_values:
            for record in all_price_records:
                return_price_records.append({key: record[key] for key in self.return_values})
        else:
            return_price_records = all_price_records

        if self.format == 'table':
            headers = return_price_records[0].keys() # Here is an issue. Some datasets have a key called 'effectiveEndDate'. If this key is not included in the first record that is returned, then the values are not in the right column for some rows within this table. This is mainly the case with Spot instances since pricing is more short-lived for Spot instances.
            
            if self.sort_by is not None:
                sorted_data = sorted(return_price_records, key=lambda x: x[self.sort_by])
            else:
                sorted_data = return_price_records
            
            values = [item.values() for item in sorted_data]
            table = tabulate(values, headers=headers)
            return table
        
        elif self.format == 'json':
            return json.dumps(return_price_records, indent=2, sort_keys=True)
        
        else:
            return return_price_records

if __name__ == '__main__':
    from AzureRetailPricesApi import AzureRetailPricesClient
    api = AzureRetailPricesClient()
    print(api)