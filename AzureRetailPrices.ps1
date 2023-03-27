function Get-AzureRetailPrice {
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

    $requestUrl = $apiUrl + $filter

    while ($requestUrl) {
        $temporaryResponse = Invoke-RestMethod -Method $restMethod -Uri $requestUrl
        $response += $temporaryResponse.Items
        $requestUrl = $temporaryResponse.NextPageLink
    }

    return $response
}