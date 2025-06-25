<#
.Synopsis
   Connect to Defender using Microsoft Graph PowerShell SDK
.DESCRIPTION
   Connect to Defender using Microsoft Graph PowerShell SDK by hiding away complexity.
.EXAMPLE
   Connect-Defender -TenantId $tenantId
.EXAMPLE
   Connect-Defender -TenantId $tenantId -ClientID $clientID -PassThru | Format-List
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Connect-Defender {
    [CmdletBinding()]
    param (
        # Tenant Id of the tenant we want to connect to
        [Parameter(Mandatory = $true)]
        [string]$TenantId,
        # Client Id of Enterprice Application (MSSP Prod vaule set as defult)
        [Parameter(Mandatory = $false)]
        [string]$ClientID = '879865d3-7605-4289-b30b-98345ad880a8', 
        # To return the connected user object
        [Parameter(Mandatory = $false)]
        [switch]$PassThru = $false
    )
    
    begin {
        
    }
    
    process {
        Connect-MgGraph -TenantId $TenantId -ClientId $ClientID -UseDeviceCode:$false -NoWelcome -Scopes "Application.Read.All", "Device.Read.All", "email", "Group.Read.All", "GroupMember.Read.All", "IdentityRiskyUser.Read.All", "openid", "profile", "SecurityAlert.ReadWrite.All", "SecurityIncident.ReadWrite.All", "ThreatHunting.Read.All", "User.Read", "User.Read.All", "User.ReadBasic.All"

        $scopes = Get-MgContext | Select-Object -ExpandProperty Scopes

        $me = Invoke-MgGraphRequest -Method GET -Uri /v1.0/me | Select-Object -Property id, displayName, userPrincipalName, mail

        if ($PassThru) {
            # This should show your details
            $me
        }
    }
    
    end {
        
    }
}