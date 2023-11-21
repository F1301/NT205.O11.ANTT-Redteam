param
(
    [string]$Password = "maimaiyeuem",
    [string]$user = "testuser"
)
Write-Host -ForegroundColor Green "Adding_AD_Users $user"
$pass=ConvertTo-SecureString $Password -AsPlainText -Force
New-ADUser -Name $user -AccountPassword $pass -Enabled $true