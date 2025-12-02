# calculate the path to the Modules folder in the current project folder where the notebook is located
$modulePath = Join-Path $pwd "Modules"

function findGitignore {
    # this function will try to locate the .gitignore file in the current folder or any parent folder
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$path
    )
    Write-Verbose "Checking $path"
    if ( Get-ChildItem $path ".gitignore" -Force -ErrorAction SilentlyContinue ) {
        $error.Clear()
        return $path
    } else {
        findGitignore $(Split-Path $path)
    }
}

# checking that the .gitignore file exists in the current folder or any parent folder
try { $projectRoot = findGitignore -path $modulePath -Verbose } catch {}
Write-Host "Project root: $projectRoot"

# if the .gitignore file is found, then add the Modules folder to the PSModulePath
if ($null -ne $projectRoot) {
    $modulePath = Join-Path $projectRoot "Modules"
    # create the Modules folder if it does not exist
    if (-not (Test-Path -Path $modulePath)) {
        New-Item -Path $modulePath -ItemType Directory -Force | Out-Null
    }
    # and we will also remove any duplicates and OneDrive paths
    $env:PSModulePath = ($env:PSModulePath.Split([System.IO.Path]::PathSeparator) | Sort-Object -Unique | Where-Object {-not $_.Contains("OneDrive")}) -join [System.IO.Path]::PathSeparator
    
    # Add the $modulePath folder to the PSModulePath
    # we will add it to the front of the PSModulePath so that it will have priority over any other modules with the same name
    # this is useful for development purposes, so that we can test the modules without having to
    # install them globally or in the user profile
    $env:PSModulePath = "$modulePath$([System.IO.Path]::PathSeparator)$env:PSModulePath"
}

# setting the default value for the Connect-MgGraph:ContextScope parameter to 'Process' so Notebooks won't share the same context
$PSDefaultParameterValues["Connect-MgGraph:ContextScope"] = 'Process'

try { Set-MgGraphOption -EnableLoginByWAM $false } catch {}


# SIG # Begin signature block
# MIISDwYJKoZIhvcNAQcCoIISADCCEfwCAQMxDTALBglghkgBZQMEAgEwewYKKwYB
# BAGCNwIBBKBtBGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDCaSIvIHD5yIit
# eVZuuQOxycQZV38tdg7azzMtnwFmy6CCDkMwggawMIIEmKADAgECAhAIrUCyYNKc
# TJ9ezam9k67ZMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNV
# BAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0z
# NjA0MjgyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQDVtC9C0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0
# JAfhS0/TeEP0F9ce2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJr
# Q5qZ8sU7H/Lvy0daE6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhF
# LqGfLOEYwhrMxe6TSXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+F
# LEikVoQ11vkunKoAFdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh
# 3K3kGKDYwSNHR7OhD26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJ
# wZPt4bRc4G/rJvmM1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQay
# g9Rc9hUZTO1i4F4z8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbI
# YViY9XwCFjyDKK05huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchAp
# QfDVxW0mdmgRQRNYmtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRro
# OBl8ZhzNeDhFMJlP/2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IB
# WTCCAVUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+
# YXsIiGX0TkIwHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0P
# AQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAC
# hjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9v
# dEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAED
# MAgGBmeBDAEEATANBgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql
# +Eg08yy25nRm95RysQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFF
# UP2cvbaF4HZ+N3HLIvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1h
# mYFW9snjdufE5BtfQ/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3Ryw
# YFzzDaju4ImhvTnhOE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5Ubdld
# AhQfQDN8A+KVssIhdXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw
# 8MzK7/0pNVwfiThV9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnP
# LqR0kq3bPKSchh/jwVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatE
# QOON8BUozu3xGFYHKi8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bn
# KD+sEq6lLyJsQfmCXBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQji
# WQ1tygVQK+pKHJ6l/aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbq
# yK+p/pQd52MbOoZWeE4wggeLMIIFc6ADAgECAhAOC0Wi/VwBV7P98KrZvnGAMA0G
# CSqGSIb3DQEBDQUAMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwHhcNMjUxMTI4MDAwMDAwWhcNMjYxMjAx
# MjM1OTU5WjB4MQswCQYDVQQGEwJDSDEQMA4GA1UEBwwHWsO8cmljaDEPMA0GA1UE
# ChMGU1dJVENIMRYwFAYDVQQLEw1Db21tdW5pdHkgU09DMQ8wDQYDVQQDEwZTV0lU
# Q0gxHTAbBgkqhkiG9w0BCQEWDmNzb2NAc3dpdGNoLmNoMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAy0m9JatRa0j2BFjVUccf/AQkDEbDgUdwTEFguiqt
# L+dJSnHNzkSiwmbWJ653UTzAYlOLPrXZl9AFWKt789SV5+PKXUp39TozKCn+K4iY
# stf05O3vRoLV1Y9glII0hvNRFTr0VWXdNhJXiGqJm/mXdWoqJjF7Djq1xawIft1P
# HEukoFpaT7NZsxNPtTNk/AKappEtF5CaUyGbjI4x9ql8fMFCz0AN3mVj9playpwl
# Y5OFzfvQPWcdI3DpdeqMSksI5PdIuguqg5H0GSts+m9SUQ5KILXVaCFxHpei3cZT
# WzSHlIBJtatf0rFn7JKusSdIiadHWh8mEcuDi1y9TbT+QKd3BmUN3yEmz4AOZcAY
# 6BTtut1hTgNCsboKS6hfpKSJ0LtG5MRUDANWmRGzSEiJj2sP0yMgCWFWQxeZOeeM
# rpMffbOU6MatGvJvlxjLtuefX9XkYD69TNTpAe7CgqVEhyVG4hzd+TxzzwDHuL6N
# Q1Jg3JSGMvkM+QW4QMaDLEP3MtXbLuMd8YyucPvtiO3e/7dBSpMLTfxfpefIwPlt
# 2Vq8/XwULkPswkKOU+yFZ5y+s0rwgXy9tBAaTBJ0YdnU4LMjXFAQT0WEFerO1pMQ
# 7bFFwyyApAW1oFszajRz09RSe/6fzLaYPnQ0x50asi9oLQhqBaV92JrKIvMlPnSi
# PU8CAwEAAaOCAh4wggIaMB8GA1UdIwQYMBaAFGg34Ou2O/hfEYb7/mF7CIhl9E5C
# MB0GA1UdDgQWBBRyglgSm+3gDR/s3VQaQF7nC6N6DjAZBgNVHREEEjAQgQ5jc29j
# QHN3aXRjaC5jaDA+BgNVHSAENzA1MDMGBmeBDAEEATApMCcGCCsGAQUFBwIBFhto
# dHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwDgYDVR0PAQH/BAQDAgeAMBMGA1Ud
# JQQMMAoGCCsGAQUFBwMDMIG1BgNVHR8Ega0wgaowU6BRoE+GTWh0dHA6Ly9jcmwz
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENvZGVTaWduaW5nUlNBNDA5
# NlNIQTM4NDIwMjFDQTEuY3JsMFOgUaBPhk1odHRwOi8vY3JsNC5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JTQTQwOTZTSEEzODQyMDIx
# Q0ExLmNybDCBlAYIKwYBBQUHAQEEgYcwgYQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9v
# Y3NwLmRpZ2ljZXJ0LmNvbTBcBggrBgEFBQcwAoZQaHR0cDovL2NhY2VydHMuZGln
# aWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hB
# Mzg0MjAyMUNBMS5jcnQwCQYDVR0TBAIwADANBgkqhkiG9w0BAQ0FAAOCAgEAkSq/
# r5sLIMbvBC5vezpu/xLrw8ZkzV6rTWfup7J+cE7egKee5STETklGhr4oA/4yvYrc
# BivJIoVB+yZchGUJaMj30e+fKZoQmxEqbVC/eP0AhRmXRkMPVwVU4LVszBDPmsRN
# MfuZ0jfwaDlWahlLnt/0VTCYPp3zJrEQI8bwI5w5Zi0rOsEkNCxWZmig5Z6RgfwS
# t0j1wVRQQjt7ByoCJpXveuq9UKfQkQj+Yagx9YaFarezMeWte3FiOW/f4PxMfQJJ
# HpoJSxBEWBADCX2jYxChDACDPMkNVwZiyAm3rV/yJ5cscufieEvF4NOplYe4jEJL
# /pJp8kKdKD/m57pIMKpURtV5NmkWzl3AflFbaPwea37ViMeZ3iPewbhNbFw0NuPT
# W9hMs22k3jUBeBQLgSAraSEDdT6g4XQjPlE2Txy/BEe6AJVFv60NLvGCHI3IFMC2
# Rf1dAupjAlVnZF7QWA4fndf+m/J9L3hm+VUuTCG9zyNrGvEVdyf+uQX2hyCvRYiy
# j6as1YhJF5E2LrUroTyHvHWxGjXmMQ7RXtFdFJMZhucoojKSDzu4zq9LL2TdYMWO
# NzuHqEGN8oOLuM71cYspI8f7R6i1g9mJCRUuE8t53m6Hk1qISF97JQ4rto+Za2fl
# WtZ+as09pJOCrhEqVJYh8Jott5ypXJxqZu/BAZ8xggMiMIIDHgIBATB9MGkxCzAJ
# BgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4RGln
# aUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEzODQgMjAy
# MSBDQTECEA4LRaL9XAFXs/3wqtm+cYAwCwYJYIZIAWUDBAIBoHwwEAYKKwYBBAGC
# NwIBDDECMAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIB
# CzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIE5bqVX4Qfeglhj+s75r
# v4lybfGqEqor/lV4kexjquqXMAsGCSqGSIb3DQEBAQSCAgBKDjyLtiptqEAT1Dbj
# 4OaFhMAWbteMmjoRuJh1Z4dpmb4cHwVxv/GXQL2JKO2IUDHvgXIAajUMiPwIXqOk
# k16B9OlqFlpM0Qt4fH6GjNDyJIIvhNJtfMIkLD6bhUs//ZTfNYNNMqZDkTHmmNzd
# +cRz89zP3wy/mPxoFIM2VjmwaNH0bZYHLQWa6d73gK32oOsv98dyK8BhhK3uIswT
# Jw7zB9Zllc+DorHG6DhP/5/jmAXaOrvZ6vCYLF3XttvxALAfkC0oo1XESE79AIi3
# O1mHjGz7wga7r8lJJXlrIW7+GWV4loEk79nZ3NCrtTkOvP94W55X6pRw6MceE93N
# SsGGBfBtMqOWti8Ubc9mRpaMqHNq51KYNj9Dh67UZqxP7sVF+3s2yCaLJGayb5Re
# ljKYjIeShoZlbJJjv/MxXAjGL9br4fHVcTH1Rc2c9JChDkl4f51tM/qhaOKP3bK8
# K/tRpE8722IrEs1TUcsiE+sQjZxFEf/79CfJGUgGTQTRyhF4sMIPpCg7SGj1/9sa
# YxkYEu4l63dMS+62kifs0rG6nQQCAC7qvXEVuOm+KWMlDoIOgrdDTr2fpHhwICMR
# asNe5YRgpeAQqpfYQM1yo7g3NHdWeUI947+Krg53olHAeNqyWiIEPF5YneFjLJKR
# B2T3ER8hATks6X77fJG0haIX6w==
# SIG # End signature block
