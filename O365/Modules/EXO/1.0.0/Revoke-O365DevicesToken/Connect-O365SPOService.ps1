#Region Function Connect-O365SPOService

function Connect-O365SPOService {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true, Position = 0)]
        [string] $OrgName
        # [Parameter(Mandatory=$true, Position=1)]
        # [int] $Id
        
    )
    
    begin {

        #Sharepoint Online Module
        # Install-Module -Name "Microsoft.Online.SharePoint.PowerShell" -verbose -Force -AllowClobber
        # Import-Module -Name "Microsoft.Online.SharePoint.PowerShell" -verbose -Force
        Import-Module -Name "Microsoft.Online.SharePoint.PowerShell" -Force #did not include verbose to make it run a little faster
        Get-Module -Name "Microsoft.Online.SharePoint.PowerShell" -ListAvailable | Select-object Name, Version

        # $orgName = "bwpremierwinnipeg"
    }
    
    process {


        try {

            Connect-SPOService -Url "https://$OrgName-admin.sharepoint.com"
            Write-Host "Connected to ShrePoint Online of" $OrgName -ForegroundColor Green
            
        }
        catch {

            Write-Host "A Terminating Error (Exception) happened" -ForegroundColor Magenta
            Write-Host "Displaying the Catch Statement ErrorCode" -ForegroundColor Yellow
            Write-host $PSItem -ForegroundColor Red
            $PSItem
            Write-host $PSItem.ScriptStackTrace -ForegroundColor Red

        }

        finally {

            Write-Host "Displaying the Final Statement" -ForegroundColor Yellow
        }

        
        
    }
    
    end {
        
        
    }

}

    #endRegion Function Connect-O365SPOService

    # Connect-O365SPOService -OrgName "bwpremierwinnipeg"
    # Connect-O365SPOService