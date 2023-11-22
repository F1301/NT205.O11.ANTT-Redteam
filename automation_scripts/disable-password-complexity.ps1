
# Import the Active Directory module
Import-Module ActiveDirectory

# Get the domain policy
$domainPolicy = Get-ADDefaultDomainPasswordPolicy

# Disable password complexity
$domainPolicy.ComplexityEnabled = $false

# Set the new domain policy
Set-ADDefaultDomainPasswordPolicy -Identity $domainPolicy

# Print status message
Write-Host "Password complexity disabled"

# Print the new domain policy
Get-ADDefaultDomainPasswordPolicy
