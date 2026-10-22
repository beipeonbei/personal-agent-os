# OpenHands run.ps1 - start the Agent execution centre
# ASCII only. Verified working configuration (2026-10-22).
# Container: openhands   Image: ghcr.io/openhands/agent-canvas:1.27.1
# Mount: D:\Personal-Agent-OS -> /projects  (the whole OS tree, fixed 2026-10-19)

param(
    [int]$Port = 8000,
    [switch]$Detached
)

Remove-Item Env:DOCKER_HOST -ErrorAction SilentlyContinue

$root = 'D:\Personal-Agent-OS'
$projects = Join-Path $root 'Projects'
$stateHome = 'C:\Users\Administrator\.openhands'
$image = 'ghcr.io/openhands/agent-canvas:1.27.1'

New-Item -ItemType Directory -Force -Path $projects, $stateHome | Out-Null

$args = @(
    'run',
    '--restart', 'unless-stopped',
    '-p', "127.0.0.1:${Port}:8000",
    '-e', 'AGENT_CANVAS_ALLOW_LAN_SESSION_KEY=true',
    '-v', "${stateHome}:/home/openhands/.openhands",
    '-v', "${root}:/projects",
    '--name', 'openhands',
    $image
)

if ($Detached) { $args = @('run', '-d') + $args[1..($args.Count - 1)] }

Write-Host '=== OpenHands start ===' -ForegroundColor Cyan
Write-Host "port     : $Port"
Write-Host "projects : $root -> /projects"
Write-Host "image    : $image"
if (-not $Detached) { Write-Host 'mode     : foreground (Ctrl+C to stop)' }

& docker @args

# Notes
# - Stop: docker stop openhands ; remove: docker rm openhands
# - Port busy: run with -Port 8001 then open http://localhost:8001/canvas
# - Detached mode: .\run.ps1 -Detached  (survives shell exit, restarts with Docker via unless-stopped)
# - Verify: docker ps --filter name=openhands
#            (Invoke-WebRequest 'http://localhost:8000/canvas' -UseBasicParsing).StatusCode
