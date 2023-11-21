param
(
    [string]$adduser = "aduseer1",
    [string]$group_add = "Administrators",
    [string]$password = "haiphong"
)
Write-Host -ForegroundColor Green "[+] Adding as $adduser local User, In Group $group_add"

New-LocalUser `
    -Name $adduser `
    -AccountNeverExpires `
    -Password (ConvertTo-SecureString "$password" -AsPlainText -Force) `
    -PasswordNeverExpires:$true `
    
Add-LocalGroupMember -Group "$group_add" -Member "$adduser"