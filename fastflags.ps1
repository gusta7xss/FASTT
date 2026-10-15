# Aplica fast flags no Roblox (execute com o Roblox fechado)
$flags = @'
{
  "DFIntTaskSchedulerTargetFps": 240,
  "FFlagDebugGraphicsPreferD3D11": "True",
  "FIntDebugForceMSAASamples": 0,
  "FIntRomarkStartWithGraphicQualityLevel": 1,
  "FIntFRMMinGrassDistance": 0,
  "FIntFRMMaxGrassDistance": 0
}
'@

$base = Join-Path $env:LOCALAPPDATA "Roblox\Versions"
if (-not (Test-Path $base)) {
    Write-Host "Pasta do Roblox nao encontrada em $base" -ForegroundColor Red
    exit 1
}

# Pega a(s) versao(oes) que contem o executavel do jogo
$versions = Get-ChildItem $base -Directory | Where-Object { Test-Path (Join-Path $_.FullName "RobloxPlayerBeta.exe") }
if (-not $versions) {
    Write-Host "Nenhuma versao do RobloxPlayerBeta.exe encontrada." -ForegroundColor Red
    return
}

foreach ($v in $versions) {
    $dir = Join-Path $v.FullName "ClientSettings"
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Set-Content -Path (Join-Path $dir "ClientAppSettings.json") -Value $flags -Encoding UTF8
    Write-Host "Fast flags aplicados em: $dir" -ForegroundColor Green
}

Write-Host "Pronto. Abra o Roblox normalmente."
