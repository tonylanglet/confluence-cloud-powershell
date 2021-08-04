
function Update-ConfluencePage {
Param(
    [string]$PageId,
    [string]$PageBody,
    [psobject]$AuthObject
)
    # Get confluence page
    $OriginalPage = Search-ConfluencePage -PageId $PageId -AuthObject $AuthObject 

    # Update Confluence page
    $Request = @{
        URI = "https://$($AuthObject.Site)/wiki/rest/api/content/$PageId"
        Method = "PUT"
        ContentType = "application/json"
        Header = @{
            'Authorization' = "Basic $($AuthObject.AuthToken)"
            'Content-Type'  = 'application/json'
            'Accept'        = 'application/json'
        }
        Body = @{
            type = "$($OriginalPage.type)"
            title = "$($OriginalPage.title)"
            version = [PSObject]@{
                number = [int]$($OriginalPage.version.number + 1)
            }
            body = [PSObject]@{
                storage = [PSObject]@{
                    value = $PageBody
                    representation = 'storage'
                }
            }
        } | ConvertTo-Json
    }

    $Response = Invoke-RestMethod @Request

return $Response

}
