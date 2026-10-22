# backup-vault.ps1 - Vault backup with date stamp and file count check
# ASCII only. Copies Vault to Backups\<date>\ and verifies the copy by file count.
# Track A stage 1. Read-only against the source; writes only into Backups (gitignored area).
# Run this BEFORE any Vault relocation (e.g. OneDrive junction).

$root = 'D:\Personal-Agent-OS'
$src = Join-Path $root 'Vault'
$stamp = Get-Date -Format 'yyyy-MM-dd'
$dest = Join-Path $root "Backups\$stamp"

if (-not (Test-Path $src)) { Write-Host 'Vault not found.' -ForegroundColor Red; exit 1 }

if (Test-Path $dest) {
    $i = 2
    while (Test-Path "$dest-r$i") { $i++ }
    $dest = "$dest-r$i"
}

New-Item -ItemType Directory -Path $dest -Force | Out-Null
Copy-Item -Path (Join-Path $src '*') -Destination $dest -Recurse -Force

$srcCount = (Get-ChildItem $src -Recurse -File | Measure-Object).Count
$dstCount = (Get-ChildItem $dest -Recurse -File | Measure-Object).Count

Write-Host "=== backup-vault ===" -ForegroundColor Cyan
Write-Host "source files : $srcCount"
Write-Host "backup files : $dstCount"
Write-Host "destination  : $dest"

if ($srcCount -eq $dstCount -and $srcCount -gt 0) {
    Write-Host 'BACKUP: PASS' -ForegroundColor Green; exit 0
} else {
    Write-Host 'BACKUP: FAIL (count mismatch or empty)' -ForegroundColor Red; exit 1
}
