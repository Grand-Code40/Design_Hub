$ErrorActionPreference = 'Stop'
$cookScript = Join-Path $PSScriptRoot '../vendor/cook/scripts/side-by-side.mjs'
$node = Get-Command node -CommandType Application -TotalCount 1 -ErrorAction Stop

if ($args -contains '--help' -or $args -contains '-h') {
    & $node.Source $cookScript @args
    exit $LASTEXITCODE
}

$originalPath = $env:Path
try {
    if (-not (Get-Command ffmpeg -CommandType Application -ErrorAction SilentlyContinue)) {
        $ffmpegBin = 'D:\DrawingAI_runs\design-hub-tools-2026-11-22\ffmpeg-9.1-essentials_build\bin'
        if (-not (Test-Path -LiteralPath (Join-Path $ffmpegBin 'ffmpeg.exe') -PathType Leaf)) {
            throw 'Cook requires ffmpeg on PATH or in the Design Hub tools directory on D:.'
        }
        $env:Path = "$ffmpegBin;$originalPath"
    }
    & $node.Source $cookScript @args
    $cookExit = $LASTEXITCODE
} finally {
    $env:Path = $originalPath
}
exit $cookExit
