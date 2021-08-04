
function New-ConfluencePage {
Param(
    [string]$Title,
    [string]$SpaceKey,
    [string]$Body,
    [string]$ParentId,
    [psobject]$AuthObject
)

# Create Confluence page
    $Content = [PSObject]@{
        type      = "page"
        space     = [PSObject]@{ key = ""}
        title     = "$Title"
        body      = [PSObject]@{
            storage = [PSObject]@{
                representation = 'storage'
            }
        }
        ancestors = @()
    }

    if(![string]::IsNullOrEmpty($ParentID)) { $Content.ancestors = @( @{ id = $ParentID } ) }
    if(![string]::IsNullOrEmpty($Body)) { $Content.body.storage.value = $Body }
    if(![string]::IsNullOrEmpty($SpaceKey)) { $Content.space = @{ key = $SpaceKey } }

    if (($ParentID) -and !($SpaceKey)) {
        $Content.space = @{ key = (Search-ConfluencePage -PageID $ParentID -AuthObject $AuthObject).Space.Key }
    }
    
    $Request = @{
        URI = "https://$($AuthObject.Site)/wiki/rest/api/content"
        Method = "POST"
        ContentType = "application/json"
        Header = @{
            'Authorization' = "Basic $($AuthObject.AuthToken)"
            'Content-Type'  = 'application/json'
            'Accept'        = 'application/json'
        }
        Body = $Content | ConvertTo-Json
    }

    $Response = Invoke-RestMethod @Request

return $Response

}
