function Get-AzureRetailPrice {
    <#
    .SYNOPSIS
        Retrieve Azure Retail Prices from the Azure Retail Price API.
    .DESCRIPTION
        Query the Retail Rates Prices API to get retail prices for all Azure services.
        Reference: https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices
    .NOTES
        The function parameters represent the filter values that are documented with the API: https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices#api-filters
    .LINK
        N/A
    .EXAMPLE
        Get-AzureRetailPrice -armSkuName Standard_B2ms -armRegionName southeastasia -priceType Consumption -serviceFamily Compute
        
        - List all _consumption_ prices for _Standard_B2ms_ VMs in the _Southeast Asia_ Azure Region
        - Limit the output to certain properties
    .EXAMPLE
        Get-AzureRetailPrice -meterName 'P10 LRS Disk' -productName 'Premium SSD Managed Disks' | Select-Object location, meterName, unitOfMeasure, retailPrice | Sort-Object retailPrice -Descending

        - List all prices for _P10 LRS Disks_ across all Azure Regions
        - Limit the output to _location_, _meterName_, _unitOfMeasure_ and _retailPrice_
        - Sort _descending_ by _retailPrice_
    .EXAMPLE
        Get-AzureRetailPrice -armSkuName Standard_M8ms -armRegionName eastus -priceType Reservation | ConvertTo-Json

        - List all _reservation_ prices for _Standard_M8ms_ VMs in the _East US_ Azure Region
        - Return them as json
    #>    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $False)]
        [string]$armRegionName,
        [Parameter(Mandatory = $False)]
        [string]$location,
        [Parameter(Mandatory = $False)]
        [string]$meterId,
        [Parameter(Mandatory = $False)]
        [string]$meterName,
        [Parameter(Mandatory = $False)]
        [string]$productId,
        [Parameter(Mandatory = $False)]
        [string]$skuId,
        [Parameter(Mandatory = $False)]
        [string]$productName,
        [Parameter(Mandatory = $False)]
        [string]$skuName,
        [Parameter(Mandatory = $False)]
        [string]$serviceName,
        [Parameter(Mandatory = $False)]
        [string]$serviceId,
        [Parameter(Mandatory = $False)]
        [string]$serviceFamily,
        [Parameter(Mandatory = $False)]
        [string]$priceType,
        [Parameter(Mandatory = $False)]
        [string]$armSkuName,
        [Parameter(Mandatory = $False)]
        [string]$apiUrl = 'https://prices.azure.com/api/retail/prices',
        [Parameter(Mandatory = $False)]
        [string]$currencyCode = 'USD'
    )
    
    # Initialise Variables

    $query = ''
    $parameterCounter = 1
    $restMethod = 'GET'
    $response = $null

    # Check if Parameters were passed and iterate through them in order to generate the filter query string
    if($PSBoundParameters.count -gt 0) {
        $PSBoundParameters.GetEnumerator() | ForEach-Object {
            if($PSBoundParameters.count -ne $parameterCounter) {
                $query = $query + $_.Key + " eq '" + $_.Value + "' and "
            }
            else {
                $query = $query + $_.Key + " eq '" + $_.Value + "'"
            }
            $parameterCounter += 1
        }
        $filter = "?currencyCode='" + $currencyCode + "'&`$filter=" + $query
    }
    else {
        $filter = "?currencyCode='" + $currencyCode + "'"
    }

    # Generate URL
    $requestUrl = $apiUrl + $filter

    # Query REST API until no further NextPageLink is returned. This is required since the API returns only 100 results in one response.
    while ($requestUrl) {
        $temporaryResponse = Invoke-RestMethod -Method $restMethod -Uri $requestUrl
        $response += $temporaryResponse.Items
        $requestUrl = $temporaryResponse.NextPageLink
    }

    return $response
}