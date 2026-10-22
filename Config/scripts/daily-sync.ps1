# daily-sync.ps1 - Personal Agent OS daily git sync
# ASCII only. Pull first, report conflicts, then commit and push.
# Usage: powershell -ExecutionPolicy Bypass -File Config\scripts\daily-sync.ps1 -Message "what changed"
# Track A stage 1. Never writes ledgers or authority sources.

param(
    [string]$Message = 'routine sync',
    [string]$Node = 'home'   # home or office, used as commit prefix
)

$root = 'D:\Personal-Agent-OS'
Set-Location $root

Write-Host '=== daily-sync ===' -ForegroundColor Cyan

git pull --no-rebase 2>&1 | Out-Host
if ($LASTEXITCODE -ne 0) {
    Write-Host 'PULL FAILED or conflicts present. Resolve manually, do not force push.' -ForegroundColor Red
    exit 1
}

$conflicts = Get-ChildItem "$root\Vault" -Recurse -Filter '*conflicted*' -ErrorAction SilentlyContinue
$conflicts += Get-ChildItem "$root\Vault" -Recurse -Filter '*冲突*' -ErrorAction SilentlyContinue
if ($conflicts) {
    Write-Host "OneDrive conflict copies found: $($conflicts.Count). Merge them before continuing." -ForegroundColor Yellow
    $conflicts | ForEach-Object { Write-Host "  $($_.FullName)" }
    exit 2
}

$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host 'Nothing to commit. Working tree clean.' -ForegroundColor Green
    exit 0
}

git add . 2>&1 | Out-Host
git commit -m "[$Node] $Message" 2>&1 | Out-Host
git push 2>&1 | Out-Host

if ($LASTEXITCODE -eq 0) { Write-Host 'SYNC: PASS' -ForegroundColor Green; exit 0 }
else { Write-Host 'SYNC: FAIL (push rejected or auth failed)' -ForegroundColor Red; exit 1 }
