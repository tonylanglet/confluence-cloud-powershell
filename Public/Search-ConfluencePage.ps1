
function Search-ConfluencePage {
Param(
    [string]$PageId,
    [psobject]$AuthObject 
)

    $Request = @{
        URI = "https://$($AuthObject.Site)/wiki/rest/api/content/$($PageId)"
        Method = "GET"
        Header = @{
            'Authorization' = "Basic $($AuthObject.AuthToken)"
            'Content-Type' = "application/json"
        }
    }
    $Response = Invoke-RestMethod @Request

return $Response
}
