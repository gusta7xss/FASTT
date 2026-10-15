# Menu de Fast Flags para Roblox
# Compativel com: irm <url> | iex  (nao usa "exit")

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

function Aplicar-FastFlags {
    if (Get-Process -Name "RobloxPlayerBeta" -ErrorAction SilentlyContinue) {
        Write-Host "`nFeche o Roblox antes de aplicar os fast flags." -ForegroundColor Yellow
        return
    }

    $base = Join-Path $env:LOCALAPPDATA "Roblox\Versions"
    if (-not (Test-Path $base)) {
        Write-Host "`nPasta do Roblox nao encontrada em $base" -ForegroundColor Red
        return
    }

    $versions = Get-ChildItem $base -Directory | Where-Object {
        Test-Path (Join-Path $_.FullName "RobloxPlayerBeta.exe")
    }
    if (-not $versions) {
        Write-Host "`nNenhuma versao do RobloxPlayerBeta.exe encontrada." -ForegroundColor Red
        return
    }

    foreach ($v in $versions) {
        $dir = Join-Path $v.FullName "ClientSettings"
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Set-Content -Path (Join-Path $dir "ClientAppSettings.json") -Value $flags -Encoding UTF8
        Write-Host "`nFast flags aplicados em: $dir" -ForegroundColor Green
    }
}

function Abrir-Roblox {
    try {
        Start-Process "roblox://"
        Write-Host "`nAbrindo o Roblox..." -ForegroundColor Green
    } catch {
        Write-Host "`nNao consegui abrir o Roblox. Abra manualmente pelo atalho." -ForegroundColor Red
    }
}

while ($true) {
    Clear-Host
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "      FAST FLAGS - ROBLOX       " -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [1] Aplicar Fast Flags"
    Write-Host "  [2] Abrir Roblox"
    Write-Host "  [0] Sair"
    Write-Host ""
    $op = Read-Host "Escolha uma opcao"

    switch ($op) {
        "1" { Aplicar-FastFlags; Start-Sleep -Seconds 2 }
        "2" { Abrir-Roblox; Start-Sleep -Seconds 2 }
        "0" { Write-Host "`nAte mais!"; break }
        default { Write-Host "`nOpcao invalida." -ForegroundColor Yellow; Start-Sleep -Seconds 1 }
    }
    if ($op -eq "0") { break }
}
