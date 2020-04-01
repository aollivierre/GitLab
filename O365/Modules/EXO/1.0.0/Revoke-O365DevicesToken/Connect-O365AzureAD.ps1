<#      
.NOTES
#===========================================================================  
# Script:  
# Created With: 
# Author:  
# Date: 
# Organization:  
# File Name: 
# Comments:
#===========================================================================  
.DESCRIPTION  
    
#>  

#region Function Copy-Process

# if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
#     Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
# }

# $ExecutionPolicy = Get-ExecutionPolicy -Scope LocalMachine

# if ($ExecutionPolicy -ne 'unrestricted') {

    # Write-Host "The Execution Policy is currently set to" $ExecutionPolicy -ForegroundColor Magenta

    #setting ExecutionPolicy to unrestricted" on all other scopes
    # Set-ExecutionPolicy -ExecutionPolicy "undefined" -Scope "MachinePolicy" -Confirm:$false -Force
    # Set-ExecutionPolicy -ExecutionPolicy "undefined" -Scope "UserPolicy" -Confirm:$false -Force
    # Set-ExecutionPolicy -ExecutionPolicy "unrestricted" -Scope "Process" -Confirm:$false -Force
    # Set-ExecutionPolicy -ExecutionPolicy "unrestricted" -Scope "CurrentUser" -Confirm:$false -Force


    # Write-Host "Setting the Execution Policy to  unrestricted on the LocalMachine Scope" -ForegroundColor Magenta
    # Set-ExecutionPolicy -ExecutionPolicy "unrestricted" -Scope "LocalMachine" -Confirm:$false -Force

    # #Re Collecting the $ExecutionPolicy value
    # $ExecutionPolicy = Get-ExecutionPolicy -Scope LocalMachine
    # Write-Host "The Execution Policy is currently set to" $ExecutionPolicy "on the LocalMachine Scope" -ForegroundColor green
# }



function Connect-O365AzureAD {
    [CmdletBinding()]
    param (
    
        [Parameter(Mandatory = $false)]
        [string]$SourceComputer,
        [Parameter(Mandatory = $false, HelpMessage = 'Enter Help Message')]
        [Security.SecureString]$SecureKey,
        [pscredential]$Credential

    )
    
    begin {


        ## Get Start Time 
        # $startDTM = (Get-Date)


        # Closes one or more PowerShell sessions
        # Get-PSSession | Remove-PSSession -Verbose
        # Get-AzContext -ListAvailable:$True | Remove-AzContext -Force
        # Get-AzContext -ListAvailable:$True | Clear-AzContext -Force
        # Clear-AzContext -Force
        # Get-AzContext  -ListAvailable:$True | Disconnect-AzAccount -Scope CurrentUser
        # Disconnect-AzAccount -Scope CurrentUser
        # Disconnect-AzureAD
        # Set-AzContext -Context ([Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]::new())
        # Get-AzDefault | Clear-AzDefault
        # Disable-AzContextAutosave 

        $AzureADModuleExist = Get-Module -Name "AzureAD"
        if (!($AzureADModuleExist)) {

            Write-Host "No Azure Context is available in the session" -ForegroundColor Green
            # Azure Active Directory PowerShell for Graph module
            Install-Module -Name "AzureAD" -Verbose -Force -AllowClobber
            Import-Module -Name "AzureAD" -Verbose -Force
            Get-Module -Name "AzureAD"-ListAvailable | Select-object Name, Version
        }


        $currentAzureContext = ""
        $currentAzureContext = Get-AzContext
        $AzureSubscription = ""
        $subscriptionName = ""
        
    }
    
    process {


        try {
            
            If (!($currentAzureContext)) {
                Write-Host "No Azure Context is available in the session" -ForegroundColor Green
                Write-Host "Connecting to Azure" -ForegroundColor Green
                Write-Host "Push ALT+TAB and Select the Login Page and Provide creds" -ForegroundColor Green
                Connect-AzAccount
            }
            
            $AzureSubscription = Get-AzSubscription
            if ($AzureSubscription) {

                #This step is important if you are doing things against Azure (not Azure AD)
                #For example creating Resources and querying resources in Azure
                # Write-Host "Azure Subscription was found in the session" -ForegroundColor Green
                # Write-Host "setting the Azure Context to the Subscription named" $subscriptionName -ForegroundColor Green
                $subscriptionId = (Get-AzSubscription -SubscriptionName $subscriptionName).Id
                Set-AzContext -SubscriptionId $subscriptionId
            }

            Write-Host "Azure Context was found in the session" -ForegroundColor Green
            Write-Host "Storing Context" -ForegroundColor Green
            $currentAzureContext = Get-AzContext
            $TenantId = $currentAzureContext.Tenant.Id
            $accountId = $currentAzureContext.Account.Id
            
            Write-Host "Connecting to Azure AD" -ForegroundColor Green
            Write-Host "Push ALT+TAB and Select the Login Page and Provide creds" -ForegroundColor Green
            Connect-AzureAD -TenantId $TenantId -AccountId $accountId
        }
        catch {

            Write-Host "A Terminating Error (Exception) happened" -ForegroundColor Magenta
            Write-Host "Displaying the Catch Statement ErrorCode" -ForegroundColor Yellow
            Write-host $PSItem -ForegroundColor Red
            $PSItem
            Write-host $PSItem.ScriptStackTrace -ForegroundColor Red
            
        }
        finally {


            
            ## Get End Time 
            # $endDTM = (Get-Date)
             
            # ## Echo Time elapsed 
            # $Timemin = "Elapsed Time: $(($endDTM-$startDTM).totalminutes) minutes"
            # $Timesec = "Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds"

            # ## Provide time it took 
            # Write-host "" 
            # Write-host " Prcoess has been completed......" -fore Green -back black
            # Write-host " Process took $Timemin       ......" -fore Blue
            # Write-host " Process $Dest_PC took $Timesec        ......" -fore Blue
            
        }
        
    }
    
    end {

        
 
        
    }
}

# Connect-O365AzureAD