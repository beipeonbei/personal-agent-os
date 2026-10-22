# verify-system.ps1 - Personal Agent OS consistency verification (READ ONLY)
# ASCII only. No writes, no repairs. Reports PASS/FAIL per rule.
# Track A stage 1. Includes boundary self-check: repo must contain ZERO .jsonl
# and no Runtime components (identity/budget/broker) until track B is ready.

$ErrorActionPreference = 'SilentlyContinue'
$root = 'D:\Personal-Agent-OS'
$results = @()

function Add-Check {
    param($name, $ok, $detail)
    $script:results += [PSCustomObject]@{ Name = $name; Verdict = $(if ($ok) { 'PASS' } else { 'FAIL' }); Detail = $detail }
}

# 1. Directory standard (12 top level dirs incl. Docs)
$expected = @('Vault', 'Projects', 'Agents', 'OpenHands', 'Hermes', 'Harness', 'MCP', 'Config', 'Prompts', 'Logs', 'Portal', 'Docs')
$missing = @()
foreach ($d in $expected) { if (-not (Test-Path (Join-Path $root $d))) { $missing += $d } }
Add-Check 'directory_standard' ($missing.Count -eq 0) $(if ($missing.Count -eq 0) { '12/12 present' } else { "missing: $($missing -join ',')" })

# 2. Config files present
$cfgOk = (Test-Path "$root\Config\system-state.yaml") -and (Test-Path "$root\Config\home-node.yaml") -and (Test-Path "$root\Config\office-node.yaml")
Add-Check 'config_files' $cfgOk 'system-state/home-node/office-node'

# 3. Authority sources present
$authOk = (Test-Path "$root\Vault\AgentOS\identity.md") -and (Test-Path "$root\Vault\AgentOS\USER.md")
Add-Check 'authority_sources' $authOk 'identity.md + USER.md'

# 4. Boundary self-check: zero .jsonl anywhere (ledgers belong to track B)
$jsonl = (Get-ChildItem $root -Recurse -File -Filter '*.jsonl' -ErrorAction SilentlyContinue | Measure-Object).Count
Add-Check 'boundary_no_jsonl' ($jsonl -eq 0) "jsonl_count=$jsonl (must be 0 before track B schema)"

# 5. Boundary self-check: no Runtime component dirs
$runtime = @()
foreach ($n in @('identity-runtime', 'budget-runtime', 'execution-broker', 'Identity-Runtime', 'Budget-Runtime', 'Execution-Broker')) {
    if (Test-Path (Join-Path $root $n)) { $runtime += $n }
}
Add-Check 'boundary_no_runtime' ($runtime.Count -eq 0) $(if ($runtime.Count -eq 0) { 'none' } else { "found: $($runtime -join ',')" })

# 6. Vault content: five dirs must hold real notes, not only .gitkeep
$emptyDirs = @()
foreach ($d in @('Inbox', 'Projects', 'Research', 'Startup', 'Daily')) {
    $real = Get-ChildItem (Join-Path "$root\Vault" $d) -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne '.gitkeep' }
    if (-not $real -or $real.Count -eq 0) { $emptyDirs += $d }
}
Add-Check 'vault_content' ($emptyDirs.Count -eq 0) $(if ($emptyDirs.Count -eq 0) { '5/5 have real notes' } else { "empty: $($emptyDirs -join ',')" })

# 7. Git working tree clean
$gs = git -C $root status --porcelain 2>$null
Add-Check 'git_clean' ([string]::IsNullOrWhiteSpace($gs)) $(if ([string]::IsNullOrWhiteSpace($gs)) { 'clean' } else { "$($gs.Split("`n").Count) change(s) pending" })

Write-Host '=== Personal Agent OS verify-system ===' -ForegroundColor Cyan
$results | ForEach-Object { Write-Host ("{0,-24} {1,-6} {2}" -f $_.Name, $_.Verdict, $_.Detail) }
$failed = ($results | Where-Object { $_.Verdict -eq 'FAIL' } | Measure-Object).Count
if ($failed -eq 0) { Write-Host 'OVERALL: PASS' -ForegroundColor Green; exit 0 }
else { Write-Host "OVERALL: FAIL ($failed item(s))" -ForegroundColor Red; exit 1 }
