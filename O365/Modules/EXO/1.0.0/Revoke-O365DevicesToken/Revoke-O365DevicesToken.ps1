# Closes one or more PowerShell sessions
Get-PSSession | Remove-PSSession -Verbose
. "$PSScriptRoot\Connect-O365SPOService.ps1"
. "$PSScriptRoot\Connect-O365ServicesMFA_SCC.ps1"
# . "$PSScriptRoot\Generate-Password.ps1" # TODO: Still need to work on this
. "$PSScriptRoot\Connect-O365AzureAD.ps1"  # TODO: Still need to work on this

#region function Reset-Password
function Revoke-O365DevicesToken {
    [CmdletBinding()]
    param (


        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$MULTIPLE_USERS,
        [Parameter(Mandatory = $false, Position = 1)]
        [string] $OrgName


    )

    begin {

        # Disconnect-SPOService
        # Disconnect-AzureAD
        # Get-PSSession | Remove-PSSession -Verbose
        # Get-PSSession | Disconnect-PSSession
        

       
        Connect-O365SPOService -OrgName $OrgName
        Write-Host "Provide Credentials for SPO" -ForegroundColor Green

        
        Connect-O365SServicesMFA_SCC
        Write-Host "Provide Credentials for Exchange Online" -ForegroundColor Green

       
        Connect-O365AzureAD
        Write-Host "Provide Credentials for Azure AD" -ForegroundColor Green

     
        $Defaultdomain = $null
        $Defaultdomain = foreach ($AcceptedDomain in (Get-AcceptedDomain)) {
            # if (($AcceptedDomain.DomainType -eq 'Authoritative') -and ($AcceptedDomain.Default -eq $true)) {
            if (($AcceptedDomain.DomainType -eq 'Authoritative') -and ($AcceptedDomain.Default)) {
                # $AcceptedDomain
                $AcceptedDomain.name
            }
        }

        # $DefaultDomainName = ""
        # $DefaultDomainName = $DefualtDomain.Name
        # $User = "brandy"

        $objectID = $null
        # $objectID = "$($User)@$($DefaultDomainName)"
        $objectID = "$($User)@$($DefaultDomain)"
        # Generate-O365Password -length $length
        # $O365password = Generate-O365Password #Still need to work on this as it is not storing the output of the function in the $O365password variable
        # $O365password = 'Whatever your password is'
        # $O365passwordsec = $null
        # $O365passwordsec = ConvertTo-SecureString -String $O365password -AsPlainText -Force #$O365password is created and updated inside of Generate-Password.ps1 as a script

        # [Hashtable]$SetAzureADUserPasswordParam = @{ }
        # $SetAzureADUserPasswordParam =

        # @{
        #     # UserPrincipalName   = $Username
        #     objectId                     = $objectID
        #     Password                     = $O365passwordsec
        #     # TenantId = $TenantId
        #     ForceChangePasswordNextLogin = $false
        # }

    }

    process {

        try {

            foreach ($SINGLE_USER in $MULTIPLE_USERS)

            {

                $objectID = $null
                $objectID = "$($SINGLE_USER)@$($DefaultDomain)"
    
                # !Provides IT administrators the ability to invalidate a particular users' O365 sessions across all their devices.
    
                Write-Host "Revoking O365 sessions across all of the devices of the user" $objectID -ForegroundColor Green
                Revoke-SPOUserSession -User $objectID -Confirm:$True
    
                # You will get the following after a succesful Revoke-SPOUserSession
                # We successfully signed out user@domain.com from all devices.
    
                # !Invalidates the refresh tokens issued to applications for a user.
                Get-AzureADUser -SearchString $objectID | Revoke-AzureADUserAllRefreshToken
                Write-Host "Invalidated the refresh tokens issued to applications for the user" $objectID -ForegroundColor Green
                
                # Connect-O365AzureAD
    
                # Set-AzureADUserPassword @SetAzureADUserPasswordParam
                # Write-Host "Password has been reset for user" $objectID "to" $O365password -ForegroundColor Green

            }


            

        }
        catch {

            #just displaying the exception AKA terminating error that forced to exit the TRY block and enter the catch block
            Write-host $PSItem -ForegroundColor Red
            $PSItem
            Write-host $PSItem.ScriptStackTrace -ForegroundColor Red
        }
        finally {
            # Get-PSSession | Remove-PSSession -Verbose

            # Disconnect-SPOService
            # Disconnect-AzureAD
        
            # Get-PSSession | Disconnect-PSSession

        }

    }

    end {
        # Get-PSSession | Remove-PSSession -Verbose
        # Disconnect-SPOService
        # Get-PSSession | Disconnect-PSSession
        # # Closes one or more PowerShell sessions
        # Get-AzContext -ListAvailable:$True | Remove-AzContext -Force
        # Get-AzContext -ListAvailable:$True | Clear-AzContext -Force
        # Clear-AzContext -Force
        # Get-AzContext  -ListAvailable:$True | Disconnect-AzAccount -Scope CurrentUser
        # Disconnect-AzAccount -Scope CurrentUser
        # Disconnect-AzureAD
        # Set-AzContext -Context ([Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]::new())
        # Get-AzDefault | Clear-AzDefault
        # Disable-AzContextAutosave
        
    }
}
#endregion function Reset-Password

# Reset-Password -User "test" -OrgName "orgname"
# Reset-Password -User "ould.moulaye" -length 8
# Reset-Password -User "abdullah" -length 256 -OrgName "CanadaComputing"
# Reset-Password -User "salman.qureshi" -length 256 -OrgName "ManitobaIslamicAssocia"
# Reset-Password -User "salman.idris" -length 256 -OrgName "ManitobaIslamicAssocia"
# Reset-Password -User "imm" -length 16 -OrgName "alghoul"
# Reset-Password -User 'imm' 'isa' 'info' 'omar' 'hunter' 'oleksiy' 'samir' -length 16 -OrgName "alghoul"
Revoke-O365DevicesToken -MULTIPLE_USERS imm,isa,info,omar,hunter,oleksiy,samir,mazen -OrgName 'alghoul'

