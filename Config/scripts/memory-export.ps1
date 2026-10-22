# memory-export.ps1 - export Hermes memory snapshot into Vault (C-3 compliant)
# ASCII only.
# STATUS: PARTIAL. Mechanism exists, signature and source verification do NOT.
# Never mark this as Enforced. (Enforced needs rule + mechanism + auto block + bypass tests all FAIL.)
#
# C-3 compensation rules, all four are enforced inside this script:
#   1. Directory isolation: writes ONLY into Vault\AgentOS\memory-export\.
#      It must never touch identity.md, USER.md, GOALS.md, RULES.md or the knowledge areas.
#   2. Append only: file name is YYYY-MM-DD.md; a second run on the same day writes -r2, -r3...
#   3. Self-tracing header: each file records generation time, source paths and Hermes process id.
#      This is NOT a signature. It only leaves a clue for later reconciliation.
#   4. The exception itself must be registered in Vault\AgentOS\CONSTITUTION.md.

$root = 'D:\Personal-Agent-OS'
$exportDir = Join-Path $root 'Vault\AgentOS\memory-export'
$hermesHome = 'C:\Users\Administrator\AppData\Local\hermes'
$srcMemory = Join-Path $hermesHome 'memories\MEMORY.md'
$srcUser = Join-Path $hermesHome 'memories\USER.md'

if (-not (Test-Path $exportDir)) { New-Item -ItemType Directory -Path $exportDir -Force | Out-Null }

$stamp = Get-Date -Format 'yyyy-MM-dd'
$base = Join-Path $exportDir "$stamp.md"
$target = $base
$i = 2
while (Test-Path $target) { $target = Join-Path $exportDir "$stamp-r$i.md"; $i++ }

$procId = (Get-Process Hermes, hermes -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Id)
$genTime = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')

$lines = @()
$lines += '# Hermes memory export'
$lines += ''
$lines += 'generated_utc : ' + $genTime
$lines += 'source_memory : ' + $srcMemory
$lines += 'source_user   : ' + $srcUser
$lines += 'hermes_pid    : ' + $(if ($procId) { $procId } else { 'none (hermes not running)' })
$lines += 'status        : PARTIAL (no signature yet; see C-3 in CONSTITUTION.md)'
$lines += ''
$lines += '## MEMORY.md'
$lines += ''
if (Test-Path $srcMemory) { $lines += (Get-Content $srcMemory) } else { $lines += '(source missing)' }
$lines += ''
$lines += '## USER.md'
$lines += ''
if (Test-Path $srcUser) { $lines += (Get-Content $srcUser) } else { $lines += '(source missing)' }

Set-Content -Path $target -Value ($lines -join "`n") -Encoding UTF8

Write-Host "=== memory-export ===" -ForegroundColor Cyan
Write-Host "written: $target"
Write-Host 'status : PARTIAL (signature pending)'
exit 0
