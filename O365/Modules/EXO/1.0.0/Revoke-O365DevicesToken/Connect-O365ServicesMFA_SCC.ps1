. "$PSScriptRoot\Connect-O365Services_All.ps1"
#Region Function Connect-O365SPOService

function Connect-O365SServicesMFA_SCC {
    [CmdletBinding()]
    param (

        # [Parameter(Mandatory = $true, Position = 0)]
        # [string] $OrgName
        # [Parameter(Mandatory=$true, Position=1)]
        # [int] $Id
        
    )
    
    begin {

        $Service = "Exchange"

    }
    
    process {


        try {

            Connect-Office365 -Service $Service -MFA
            Write-Host "Connected to" $Service -ForegroundColor Green
        }
        catch {

            Write-Host "A Terminating Error (Exception) happened" -ForegroundColor Magenta
            Write-Host "Displaying the Catch Statement ErrorCode" -ForegroundColor Yellow
            Write-host $PSItem -ForegroundColor Red
            $PSItem
            Write-host $PSItem.ScriptStackTrace -ForegroundColor Red

        }

        finally {

            # Write-Host "Displaying the Final Statement" -ForegroundColor Yellow
        }

        
        
    }
    
    end {
        
        
    }

}

#endRegion Function Connect-O365SPOService

# Connect-O365SPOService -OrgName "bwpremierwinnipeg"
# Connect-O365SServicesMFA_SCC