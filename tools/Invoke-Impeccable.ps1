$ErrorActionPreference = 'Stop'
$skillRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../vendor/impeccable')).Path
$engineVersion = (Get-Content -Raw -LiteralPath (Join-Path $skillRoot 'scripts/VERSION')).Trim()
$engineHome = 'D:/DrawingAI_runs/design-hub-tools-2026-11-22/impeccable'
$engine = Join-Path $engineHome "bin/$engineVersion/impeccable.exe"
if (-not (Test-Path -LiteralPath $engine -PathType Leaf)) {
    throw "Impeccable engine $engineVersion not found at $engine"
}

$settings = @{
    IMPECCABLE_SKILL_DIR = $skillRoot
    IMPECCABLE_HOME = $engineHome
    IMPECCABLE_LIVE_COPY_AGENT = 'chat'
}
$previous = @{}
try {
    foreach ($name in $settings.Keys) {
        $previous[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
        [Environment]::SetEnvironmentVariable($name, $settings[$name], 'Process')
    }
    if ($MyInvocation.ExpectingInput) {
        $input | & $engine @args
    } else {
        & $engine @args
    }
    $engineExit = $LASTEXITCODE
} finally {
    foreach ($name in $previous.Keys) {
        if ($null -eq $previous[$name]) {
            Remove-Item -LiteralPath "Env:$name" -ErrorAction SilentlyContinue
        } else {
            [Environment]::SetEnvironmentVariable($name, $previous[$name], 'Process')
        }
    }
}
exit $engineExit
