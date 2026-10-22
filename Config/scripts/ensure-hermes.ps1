# ensure-hermes.ps1 - Hermes keepalive (W13 fix, approved 2026-10-22)
# ASCII only. Purpose: start Hermes when it is not running. Nothing else.
# RULE: the ONLY legal start source is the desktop shortcut Hermes.lnk.
#       Never run 'hermes gateway run' manually - a second entry kills the
#       first one (double-boss). This script only starts, never repairs.
# Logging: appends one line per action to Logs\ensure-hermes.log
#          (Logs/ is gitignored, so this never enters the repository).

$ErrorActionPreference = 'SilentlyContinue'

$shortcut = 'C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Hermes.lnk'
$logDir = 'D:\Personal-Agent-OS\Logs'
$logFile = Join-Path $logDir 'ensure-hermes.log'

if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

function Write-Trace {
    param($message)
    $line = "{0}  {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $message
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}

$running = (Get-Process Hermes, hermes -ErrorAction SilentlyContinue | Measure-Object).Count

if ($running -gt 0) {
    Write-Trace "OK hermes running (processes=$running)"
    exit 0
}

if (-not (Test-Path $shortcut)) {
    Write-Trace "FAIL shortcut missing: $shortcut"
    exit 1
}

Start-Process $shortcut
Start-Sleep -Seconds 20

$after = (Get-Process Hermes, hermes -ErrorAction SilentlyContinue | Measure-Object).Count
if ($after -gt 0) {
    Write-Trace "STARTED hermes via Hermes.lnk (processes=$after)"
    exit 0
} else {
    Write-Trace "FAIL start attempted via Hermes.lnk but no process after 20s"
    exit 1
}
