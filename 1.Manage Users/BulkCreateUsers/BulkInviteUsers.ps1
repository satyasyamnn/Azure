## Reference: https://docs.microsoft.com/en-us/azure/active-directory/external-identities/code-samples

## Step 1 Login to Azure AD 

$cred = Get-Credential
Connect-AzureAD -Credential $cred

## Step 2 Read users to invite from CSV File 
$invitations = Import-Csv F:\LearningBase\Azure\AzureLearnings\Powershell\ManageIdentities\BulkCreateUsers\invitations.csv

## Step 3 Create Message to be sent to users 

$messageInfo = New-Object Microsoft.Open.MSGraph.Model.InvitedUserMessageInfo
$messageInfo.customizedMessageBody = "Hey there! Check this out. I created an invitation through PowerShell"

## Step4 Iterate through invitations and send email
foreach ($invite in $invitations) {
    New-AzureADMSInvitation -InvitedUserDisplayName $invite.Name  `
                            -InvitedUserEmailAddress $invite.InvitedUserEmailAddress `
                            -InvitedUserMessageInfo $messageInfo `
                            -SendInvitationMessage $true `
                            -InviteRedirectUrl https://wingtiptoysonline-dev-ed.my.salesforce.com   
}

