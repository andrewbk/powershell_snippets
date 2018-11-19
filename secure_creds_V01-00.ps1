$keypath = "C:\OSD\DpAutomation\BuildDP\DEV\aes.key"
$passpath = "C:\DpAutomation\BuildDP\DEV\pass.dat"
$certpasswordpath = "C:\DpAutomation\BuildDP\DEV\certpass.dat"

# create the 256-bit aes encryption key

#$Key = New-Object Byte[] 32
#[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
#$Key | out-file $keypath

# create a password with the key hash
#(Get-Credential).Password | ConvertFrom-SecureString -key (get-content $keypath) | set-content $passpath

#$password = Get-Content $passpath | ConvertTo-SecureString -Key (Get-Content $keypath)
#$credential = New-Object System.Management.Automation.PsCredential("EUCLab\LABAdmin",$password)

# do cert pass
#$certpassword = Read-Host -AsSecureString 
#$certpassword | ConvertFrom-SecureString -key (get-content $keypath) | Set-Content $certpasswordpath