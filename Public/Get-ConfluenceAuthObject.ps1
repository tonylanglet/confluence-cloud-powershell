
function Get-ConfluenceAuthObject {
Param(
    [String]$SiteName,
    [PSCredential]$Credentials    
)

    switch($SiteName) {
        ({$PSItem -like "*atlassian*"})      { $success = $false }
        ({$PSItem -like "*/*"})              { $success = $false }
        ({[string]::IsNullOrEmpty($PSItem)}) { $success = $false }
        default { 
            $uriSite = "$($SiteName).atlassian.net" 
            $success = $true
        }
    }
    

if($success) {

    $AuthToken = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($Credentials.UserName):$($Credentials.Password)"))

    $AuthObject = [PSOBject]@{
        AuthToken = $AuthToken
        Site = $uriSite
        Success = "true"
    }
} else {
    $AuthObject = [PSOBject]@{
        AuthToken = ""
        Site = ""
        Success = "false"
    }
    throw
}
