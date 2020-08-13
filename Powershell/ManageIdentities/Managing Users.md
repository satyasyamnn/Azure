# Managing Users

Account in context need to have the following roles assigned

**Global Administrator**
**Cloud Device Administrator**
**Intune Service Administrator**

## New-AzureADUser

Mandatory command to run before using New-AzureADUser is **Connect-AzureAD**. When a normal global admin account, example <personal@gmail.com> is used tenant information will be blank.

[Connect Azure Ad Command](https://github.com/satyasyamnn/Azure/blob/master/Powershell/ManageIdentities/Images/ConnectAzureAdCommand.JPG)

Post running **New-AzureADUser** with all necessary details you will see authentication error.

[New Azure Ad User](https://github.com/satyasyamnn/Azure/blob/master/Powershell/ManageIdentities/Images/NewAzureAdUserCreation.JPG)

New-AzureADUser will work when tenant domain is mapped. Issues with tenant see this link [http://get-cmd.com/?p=4949].

### Example

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "password"

New-AzureADUser -DisplayName "New User" -PasswordProfile $PasswordProfile  -UserPrincipalName "NewUser@contoso.com" -AccountEnabled $true -MailNickName "Newuser"

## New-AzADUser

$SecureStringPassword = ConvertTo-SecureString -String "password" -AsPlainText -Force
New-AzADUser -DisplayName "NewUser1" -UserPrincipalName "user@domain.onmicrosoft.com" -MailNickname "NewUser1" -Password $SecureStringPassword
