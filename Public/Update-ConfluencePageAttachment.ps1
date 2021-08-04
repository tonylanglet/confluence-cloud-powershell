
function Update-ConfluencePageAttachment {
Param(
    [string]$PageId,
    [string]$PageBody,
    [string]$filePath,
    [psobject]$AuthObject
)
# The content-type in the bodylines will have to change for the right content to be sent
# This might not be needed for the purpose of this script but its nice to keep for multipart/form-data

$fileName = $filePath.Split("\")[-1]

$fileBin = [System.IO.File]::ReadAlltext($filePath)
$boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"
$bodyLines = (
    "--$boundary",
    "Content-Disposition: form-data; name=`"file`"; filename=`"$fileName`"; minorEdit=`"true`"; comment=`"test`"",
    "Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet$LF",
    $fileBin,
    "--$boundary--$LF"
) -join $LF

    $Request = @{
        URI = "https://$($AuthObject.Site)/wiki/rest/api/content/$PageId/child/attachment"
        Method = "PUT"
        ContentType = "multipart/form-data; boundary=`"$boundary`""
        Header = @{
            'Authorization'     = "Basic $($AuthObject.AuthToken)"
            'X-Atlassian-Token' = 'nocheck'
            'Accept'            = 'application/json'
        }
        Body = $bodyLines
    }

    $Response = Invoke-RestMethod @Request

return $Response
}
