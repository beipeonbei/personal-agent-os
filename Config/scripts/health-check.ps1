# health-check.ps1 - Personal Agent OS daily health check (READ ONLY)
# ASCII only. PowerShell 5.1 reads UTF-8 without BOM as GBK and garbles CJK text.
# This script NEVER writes, never repairs, never changes config. It only reports.
# Track A stage 1. Boundary rule: no ledger writes, no authority-source writes.

$ErrorActionPreference = 'SilentlyContinue'
Remove-Item Env:DOCKER_HOST -ErrorAction SilentlyContinue

$results = @()

function Add-Check {
    param($name, $ok, $detail)
    $script:results += [PSCustomObject]@{ Name = $name; Verdict = $(if ($ok) { 'PASS' } else { 'FAIL' }); Detail = $detail }
}

# 1. Docker engine
$dv = docker version --format '{{.Server.Version}}' 2>$null
if ($dv) { Add-Check 'docker_engine' $true "server=$dv" } else { Add-Check 'docker_engine' $false 'server not reachable' }

# 2. OpenHands container
$ps1 = docker ps --filter name=openhands --format '{{.Names}}|{{.Status}}' 2>$null
if ($ps1 -and $ps1 -match 'Up') { Add-Check 'openhands_container' $true $ps1 } else { Add-Check 'openhands_container' $false "not running ($ps1)" }

# 3. Canvas HTTP
try {
    $r = Invoke-WebRequest -Uri 'http://localhost:8000/canvas' -UseBasicParsing -TimeoutSec 10
    Add-Check 'canvas_http' ($r.StatusCode -eq 200) "status=$($r.StatusCode)"
} catch { Add-Check 'canvas_http' $false $_.Exception.Message }

# 4. Project mount
$mounts = docker inspect -f '{{json .Mounts}}' openhands 2>$null
if ($mounts -and $mounts -match 'Personal-Agent-OS') { Add-Check 'project_mount' $true 'D:\Personal-Agent-OS -> /projects' } else { Add-Check 'project_mount' $false 'mount missing or wrong' }

# 5. Hermes process
$hp = (Get-Process Hermes, hermes -ErrorAction SilentlyContinue | Measure-Object).Count
Add-Check 'hermes_process' ($hp -gt 0) "processes=$hp"

# 6. DSH port 8080
$c8080 = Get-NetTCPConnection -State Listen -LocalAddress 127.0.0.1 -LocalPort 8080 -ErrorAction SilentlyContinue
Add-Check 'dsh_8080' ([bool]$c8080) $(if ($c8080) { 'listening' } else { 'not listening' })

# Report
Write-Host '=== Personal Agent OS health check ===' -ForegroundColor Cyan
$results | ForEach-Object { Write-Host ("{0,-22} {1,-6} {2}" -f $_.Name, $_.Verdict, $_.Detail) }
$failed = ($results | Where-Object { $_.Verdict -eq 'FAIL' } | Measure-Object).Count
if ($failed -eq 0) { Write-Host 'OVERALL: PASS' -ForegroundColor Green; exit 0 }
else { Write-Host "OVERALL: FAIL ($failed item(s))" -ForegroundColor Red; exit 1 }
