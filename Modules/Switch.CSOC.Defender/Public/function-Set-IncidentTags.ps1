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
function Set-IncidentTags {
    [CmdletBinding()]
    param()
        if ($swIncidents.count -gt 0) {
            $swIncidents.Values.GetEnumerator() | foreach {
            $incID = $_.incId
            $ogTags = New-Object System.Collections.ArrayList
            $newTags = New-Object System.Collections.ArrayList
            $_.customTags | % { $null = $ogTags.add($_); $null = $newTags.add($_) }
            
            $incidentsForMailingTeam = @('Suspicious email sending patterns detected','User restricted from sending email')
            
            switch ($_.dAccountType) { 
                "Student" { #$params = @{ customTags = @( "Student")}; 
                    if ($newTags.Contains("Student")) {}
                    else {$null = $newTags.add("Student")}
                    Write-Host "." -NoNewline }
                "Faculty" { #$params = @{ customTags = @( "Faculty")}; 
                    if ($newTags.Contains("Faculty")) {}
                    else {$null = $newTags.add("Faculty")}
                    Write-Host "." -NoNewline }
                "Faculty, Student" { #$params = @{ customTags = @( "Faculty", "Student")}; 
                    if ($newTags.Contains("Faculty") -and $newTags.Contains("Student")) {}
                    else {$null = $newTags.add("Faculty");$null = $newTags.add("Student")}
                    Write-Host "." -NoNewline }
                "Admin"   { #$params = @{ customTags = @( "Admin")}; 
                    if ($newTags.Contains("Admin")) {}
                    else {$null = $newTags.add("Admin")}
                    Write-Host "." -NoNewline }
                "Guest"   { #$params = @{ customTags = @( "Guest")}; 
                    if ($newTags.Contains("Guest")) {}
                    else {$null = $newTags.add("Guest")}
                    Write-Host "." -NoNewline }
                "ServiceAccount" { #$params = @{ customTags = @( "ServiceAccount")}; 
                    if ($newTags.Contains("ServiceAccount")) {}
                    else {$null = $newTags.add("ServiceAccount")}
                    Write-Host "." -NoNewline }
                default { Write-Host ":" -NoNewline }
            }
        
            if ($_.xIP) {
                if (-not $newTags.Contains($_.xIP) ) {
                    $null = $newTags.Add($_.xIP); Write-Host "X" -NoNewline
                }
                if ($_.xVPN) {
                    if (-not $newTags.Contains($_.xVPN) ) {
                        $null = $newTags.add($_.xVPN)
                    }
                }
            }
            
            $OK = $false
            if ( $newTags.Count -eq 0 -and $ogTags.Count -eq 0) { $OK = $true } 
            elseif ($newTags.Count -eq 1 -and $ogTags.Count -eq 1 -and $ogTags.Contains($newTags[0])) { $OK = $true  }
            elseif ( $newTags.Count -ne $ogTags.Count ) { }
            elseif ( -not ($newTags.ToArray() | Compare-Object $ogTags.ToArray()) -as [bool] ) { $OK = $true }
            else {    write-host "$incID | $ogTags | $newTags" -ForegroundColor Red}
            if (!$OK) {
                $params = @{ customTags = $($newTags.ToArray() | ?{$_ -ne $null})};
                if ($null -ne $params) {
                    try  { 
                        Update-MgSecurityIncident -IncidentId $_.incId -BodyParameter $params -ErrorAction Stop | Out-Null
                    } catch {
                        Write-Host "<$incID>`t$_" -ForegroundColor Yellow
                    }
                }
            }
        }
    } else {
        Write-Warning "No incidents found"
    }
}