

function Search-ConfluenceChildPage {
Param(
    [string]$PageId,
    [PSObject]$AuthToken
)
    # Get confluence page
    $Request = @{
        URI = "https://$($AuthObject.Site)/wiki/rest/api/content/$($PageId)/child/page"
        Method = "GET"
        Header = @{
            'Authorization' = "Basic $($AuthObject.AuthToken)"
            'Content-Type' = "application/json"
        }
    }
    $Response = Invoke-RestMethod @Request

return $Response
}
