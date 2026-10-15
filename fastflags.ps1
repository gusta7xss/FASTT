# ============================================================
#  FAST FLAGS MANAGER - ROBLOX
#  Compativel com:  irm <url> | iex
# ============================================================

$ErrorActionPreference = "SilentlyContinue"
$Host.UI.RawUI.WindowTitle = "Fast Flags Manager"
try { $Host.UI.RawUI.BackgroundColor = "Black" } catch {}
try { [Console]::CursorVisible = $false } catch {}

$BAR_FULL  = [string][char]0x2588
$BAR_EMPTY = [string][char]0x2591
$LINE      = [string][char]0x2500
$TL = [string][char]0x250C; $TR = [string][char]0x2510
$BL = [string][char]0x2514; $BR = [string][char]0x2518
$VL = [string][char]0x2502
$CHECK = [string][char]0x2713
$W = 54

# ---------------- Catalogo de fast flags ----------------
$Catalogo = @(
    @{ Nome = "FPS ilimitado";           Desc = "Remove o limite de FPS";                   Flags = [ordered]@{ "DFIntTaskSchedulerTargetFps" = 9999 } },
    @{ Nome = "Forcar DirectX 11";       Desc = "Mais estabilidade e desempenho";           Flags = [ordered]@{ "FFlagDebugGraphicsPreferD3D11" = "True" } },
    @{ Nome = "Desligar Anti-Aliasing";  Desc = "Menos carga na placa de video";            Flags = [ordered]@{ "FIntDebugForceMSAASamples" = 0 } },
    @{ Nome = "Graficos no minimo";      Desc = "Qualidade grafica nivel 1";                Flags = [ordered]@{ "FIntRomarkStartWithGraphicQualityLevel" = 1; "DFIntDebugFRMQualityLevelOverride" = 1 } },
    @{ Nome = "Remover grama";           Desc = "Tira a grama do mapa (mais FPS)";          Flags = [ordered]@{ "FIntFRMMinGrassDistance" = 0; "FIntFRMMaxGrassDistance" = 0; "FIntRenderGrassDetailStrands" = 0; "FIntRenderGrassHeightScaler" = 0 } },
    @{ Nome = "Sem efeitos e sombras";   Desc = "Sem pos-processamento, blur, sombras e ceu"; Flags = [ordered]@{ "FFlagDisablePostFx" = "True"; "FIntRobloxGuiBlurIntensity" = 0; "FIntRenderShadowIntensity" = 0; "FFlagDebugSkyGray" = "True" } },
    @{ Nome = "LOD agressivo";           Desc = "Objetos distantes ficam simples (mais FPS)"; Flags = [ordered]@{ "DFIntCSGLevelOfDetailSwitchingDistance" = 0; "DFIntCSGLevelOfDetailSwitchingDistanceL12" = 0; "DFIntCSGLevelOfDetailSwitchingDistanceL23" = 0; "DFIntCSGLevelOfDetailSwitchingDistanceL34" = 0 } },
    @{ Nome = "Texturas leves";          Desc = "Texturas baixas (visual mais borrado)";    Flags = [ordered]@{ "DFFlagTextureQualityOverrideEnabled" = "True"; "DFIntTextureQualityOverride" = 0; "FIntDebugTextureManagerSkipMips" = 3 } },
    @{ Nome = "Rede (experimental)";     Desc = "Pode ajudar o ping; efeito varia";         Flags = [ordered]@{ "DFIntRakNetResendRttMultiple" = 1; "DFIntRaknetBandwidthPingSendEveryXSeconds" = 1; "DFIntClientPacketMaxDelayMs" = 1 } }
)
$Sel = @{}
for ($i = 0; $i -lt $Catalogo.Count; $i++) { $Sel[$i] = $true }
$Sel[7] = $false   # texturas leves: desligado por padrao
$Sel[8] = $false   # rede experimental: desligado por padrao

# ---------------- Utilidades visuais ----------------
function Digitar($texto, $cor = "White", $atraso = 12) {
    foreach ($c in $texto.ToCharArray()) {
        Write-Host $c -NoNewline -ForegroundColor $cor
        Start-Sleep -Milliseconds $atraso
    }
    Write-Host ""
}

function Linha($texto = "", $cor = "Gray", $corBorda = "DarkCyan") {
    $pad = $W - 2 - $texto.Length
    if ($pad -lt 0) { $pad = 0 }
    Write-Host $VL -NoNewline -ForegroundColor $corBorda
    Write-Host (" " + $texto + (" " * ($pad - 0))) -NoNewline -ForegroundColor $cor
    Write-Host $VL -ForegroundColor $corBorda
}

function Topo   { Write-Host ($TL + ($LINE * $W) + $TR) -ForegroundColor DarkCyan }
function Base   { Write-Host ($BL + ($LINE * $W) + $BR) -ForegroundColor DarkCyan }
function Divisoria { Write-Host ([string][char]0x251C + ($LINE * $W) + [string][char]0x2524) -ForegroundColor DarkCyan }

$Arte = @(
    '  ______        _     ______ _                 ',
    ' |  ____|      | |   |  ____| |                ',
    ' | |__ __ _ ___| |_  | |__  | | __ _  __ _ ___ ',
    ' |  __/ _` / __| __| |  __| | |/ _` |/ _` / __|',
    ' | | | (_| \__ \ |_  | |    | | (_| | (_| \__ \',
    ' |_|  \__,_|___/\__| |_|    |_|\__,_|\__, |___/',
    '                                      __/ |    ',
    '                                     |___/     '
)

function Mostrar-Banner($cor = "Cyan") {
    Write-Host ""
    foreach ($l in $Arte) { Write-Host ("  " + $l) -ForegroundColor $cor }
    Write-Host ""
}

function Intro {
    Clear-Host
    $cores = @("DarkCyan", "Cyan", "White", "Cyan")
    foreach ($c in $cores) {
        [Console]::SetCursorPosition(0, 0)
        Mostrar-Banner $c
        Start-Sleep -Milliseconds 120
    }
    Digitar "  Roblox Fast Flags Manager  |  by gusta7xss" "DarkGray" 15
    Write-Host ""
    Barra "Carregando" 22 12
    Start-Sleep -Milliseconds 250
}

function Barra($rotulo, $tam = 30, $atraso = 20) {
    for ($i = 0; $i -le $tam; $i++) {
        $pct = [int](($i / $tam) * 100)
        $barra = ($BAR_FULL * $i) + ($BAR_EMPTY * ($tam - $i))
        Write-Host ("`r  {0} " -f $rotulo) -NoNewline -ForegroundColor Gray
        Write-Host $barra -NoNewline -ForegroundColor Cyan
        Write-Host (" {0,3}%" -f $pct) -NoNewline -ForegroundColor White
        Start-Sleep -Milliseconds $atraso
    }
    Write-Host ""
}

function Girar($rotulo, $ms = 900) {
    $frames = @("|", "/", "-", "\")
    $fim = (Get-Date).AddMilliseconds($ms)
    $i = 0
    while ((Get-Date) -lt $fim) {
        Write-Host ("`r  {0} {1}" -f $frames[$i % 4], $rotulo) -NoNewline -ForegroundColor Cyan
        Start-Sleep -Milliseconds 80
        $i++
    }
    Write-Host ("`r  " + $CHECK + " " + $rotulo + "      ") -ForegroundColor Green
}

function Msg($tipo, $texto) {
    switch ($tipo) {
        "ok"   { Write-Host ("  [ OK ] " + $texto) -ForegroundColor Green }
        "erro" { Write-Host ("  [ !! ] " + $texto) -ForegroundColor Red }
        "aviso"{ Write-Host ("  [ !  ] " + $texto) -ForegroundColor Yellow }
        default{ Write-Host ("  [ i  ] " + $texto) -ForegroundColor Cyan }
    }
}

function Pausa($texto = "Pressione qualquer tecla para voltar...") {
    Write-Host ""
    Write-Host ("  " + $texto) -ForegroundColor DarkGray
    [void][Console]::ReadKey($true)
}

# ---------------- Logica ----------------
function Get-Versoes {
    $bases = @(
        (Join-Path $env:LOCALAPPDATA "Roblox\Versions"),
        (Join-Path ${env:ProgramFiles(x86)} "Roblox\Versions")
    )
    $lista = @()
    foreach ($b in $bases) {
        if (Test-Path $b) {
            $lista += Get-ChildItem $b -Directory | Where-Object { Test-Path (Join-Path $_.FullName "RobloxPlayerBeta.exe") }
        }
    }
    return @($lista | Sort-Object LastWriteTime -Descending)
}

function Get-VersaoOnline {
    try { return Invoke-RestMethod "https://clientsettings.roblox.com/v2/client-version/WindowsPlayer" -TimeoutSec 6 }
    catch { return $null }
}

function Tela-Versoes {
    Clear-Host; Mostrar-Banner "DarkCyan"
    Girar "Verificando versoes instaladas" 700
    $v = Get-Versoes
    Girar "Consultando versao mais recente" 700
    $online = Get-VersaoOnline

    Write-Host ""
    Topo
    Linha "VERSOES DO ROBLOX" "White"
    Divisoria
    if ($online) {
        Linha "Mais recente (servidor):" "Gray"
        Linha ("  " + $online.clientVersionUpload) "Cyan"
        Linha ("  Numero: " + $online.version) "DarkGray"
    } else {
        Linha "Servidor: nao foi possivel consultar (sem internet?)" "Yellow"
    }
    Divisoria
    Linha ("Instaladas neste PC: " + $v.Count) "Gray"
    $n = 0
    foreach ($x in $v) {
        $n++
        $tags = @()
        if ($n -eq 1) { $tags += "mais nova" }
        if ($online -and $x.Name -eq $online.clientVersionUpload) { $tags += "atualizada" }
        if (Test-Path (Join-Path $x.FullName "ClientSettings\ClientAppSettings.json")) { $tags += "flags ativos" }
        Linha ("{0}. {1}" -f $n, $x.Name) "Cyan"
        Linha ("   Modificada: {0}" -f $x.LastWriteTime.ToString("dd/MM/yyyy HH:mm")) "DarkGray"
        if ($tags.Count -gt 0) { Linha ("   " + ($tags -join " | ")) "Green" }
    }
    Divisoria
    if ($v.Count -eq 0) {
        Linha "Nenhuma versao encontrada. Instale o Roblox pelo site." "Red"
    } else {
        if ($v.Count -gt 1) {
            Linha "Ha mais de uma versao instalada." "Yellow"
            Linha "Os fast flags sao aplicados em todas." "Yellow"
        }
        if ($online -and $v[0].Name -ne $online.clientVersionUpload) {
            Linha "Roblox desatualizado: ao abrir ele vai baixar" "Yellow"
            Linha ("a versao " + $online.clientVersionUpload) "Yellow"
            Linha "Depois, reaplique os fast flags." "Yellow"
        } elseif ($online) {
            Linha "Seu Roblox esta na versao mais recente." "Green"
        }
    }
    Base
    Pausa
}

function Roblox-Aberto { return [bool](Get-Process -Name "RobloxPlayerBeta" -ErrorAction SilentlyContinue) }

function Qtd-Selecionados { return @($Sel.Keys | Where-Object { $Sel[$_] }).Count }

function Status-Atual {
    $v = Get-Versoes
    foreach ($x in $v) {
        if (Test-Path (Join-Path $x.FullName "ClientSettings\ClientAppSettings.json")) { return $true }
    }
    return $false
}

function Aplicar {
    Clear-Host; Mostrar-Banner "DarkCyan"
    if (Roblox-Aberto) { Msg "aviso" "Feche o Roblox antes de aplicar."; Pausa; return }
    if ((Qtd-Selecionados) -eq 0) { Msg "aviso" "Nenhum fast flag selecionado. Va em [2]."; Pausa; return }
    $versoes = Get-Versoes
    if ($versoes.Count -eq 0) { Msg "erro" "Roblox nao encontrado (precisa ser a versao do site)."; Pausa; return }

    $final = [ordered]@{}
    for ($i = 0; $i -lt $Catalogo.Count; $i++) {
        if ($Sel[$i]) { foreach ($k in $Catalogo[$i].Flags.Keys) { $final[$k] = $Catalogo[$i].Flags[$k] } }
    }
    $json = $final | ConvertTo-Json

    Girar "Localizando o Roblox" 700
    Girar "Montando configuracao" 700
    foreach ($v in $versoes) {
        $dir = Join-Path $v.FullName "ClientSettings"
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Set-Content -Path (Join-Path $dir "ClientAppSettings.json") -Value $json -Encoding UTF8
    }
    Barra "Aplicando    " 26 25
    Write-Host ""
    Msg "ok" ("{0} fast flag(s) aplicados em {1} versao(oes) do Roblox." -f $final.Count, $versoes.Count)
    if ($versoes.Count -gt 1) { Msg "aviso" "Mais de uma versao instalada: todas foram atualizadas." }
    Pausa
}

function Remover {
    Clear-Host; Mostrar-Banner "DarkCyan"
    if (Roblox-Aberto) { Msg "aviso" "Feche o Roblox antes de remover."; Pausa; return }
    $versoes = Get-Versoes
    $achou = $false
    Girar "Procurando configuracoes" 700
    foreach ($v in $versoes) {
        $arq = Join-Path $v.FullName "ClientSettings\ClientAppSettings.json"
        if (Test-Path $arq) { Remove-Item $arq -Force; $achou = $true }
    }
    if ($achou) { Msg "ok" "Fast flags removidos. Roblox voltou ao padrao." } else { Msg "info" "Nao havia fast flags aplicados." }
    Pausa
}

function Abrir {
    Clear-Host; Mostrar-Banner "DarkCyan"
    Girar "Iniciando o Roblox" 900
    try { Start-Process "roblox://"; Msg "ok" "Roblox aberto." }
    catch { Msg "erro" "Nao consegui abrir. Abra pelo atalho." }
    Start-Sleep -Seconds 2
}

function Tela-Flags {
    while ($true) {
        Clear-Host
        Mostrar-Banner "DarkCyan"
        Topo
        Linha "ESCOLHA OS FAST FLAGS" "White"
        Divisoria
        for ($i = 0; $i -lt $Catalogo.Count; $i++) {
            $c = $Catalogo[$i]
            $marca = if ($Sel[$i]) { "[" + $CHECK + "]" } else { "[ ]" }
            $cor   = if ($Sel[$i]) { "Green" } else { "DarkGray" }
            Linha ("{0}  {1} {2}" -f ($i + 1), $marca, $c.Nome) $cor
            Linha ("       " + $c.Desc) "DarkGray"
            $detalhe = ($c.Flags.Keys | ForEach-Object { "$_ = $($c.Flags[$_])" }) -join ", "
            if ($detalhe.Length -gt ($W - 10)) { $detalhe = $detalhe.Substring(0, $W - 13) + "..." }
            Linha ("       " + $detalhe) "DarkCyan"
        }
        Divisoria
        Linha "[1-9] Ligar/Desligar   [A] Todos   [N] Nenhum" "Gray"
        Linha "[V] Voltar ao menu" "Gray"
        Base

        $k = [Console]::ReadKey($true).KeyChar.ToString().ToUpper()
        if ($k -match '^[1-9]$') {
            $idx = [int]$k - 1
            if ($idx -lt $Catalogo.Count) { $Sel[$idx] = -not $Sel[$idx] }
        }
        elseif ($k -eq "A") { for ($i = 0; $i -lt $Catalogo.Count; $i++) { $Sel[$i] = $true } }
        elseif ($k -eq "N") { for ($i = 0; $i -lt $Catalogo.Count; $i++) { $Sel[$i] = $false } }
        elseif ($k -eq "V") { return }
    }
}

function Menu {
    while ($true) {
        Clear-Host
        Mostrar-Banner "Cyan"
        $ativo = Status-Atual
        $statusTxt = if ($ativo) { "ATIVOS no Roblox" } else { "nao aplicados" }
        $statusCor = if ($ativo) { "Green" } else { "Yellow" }
        $robloxTxt = if (Roblox-Aberto) { "aberto (feche para aplicar)" } else { "fechado" }

        Topo
        Linha "MENU PRINCIPAL" "White"
        Divisoria
        Linha ("Fast flags: " + $statusTxt) $statusCor
        Linha ("Selecionados: {0}/{1}     Roblox: {2}" -f (Qtd-Selecionados), $Catalogo.Count, $robloxTxt) "Gray"
        $nv = (Get-Versoes).Count
        if ($nv -gt 1) { Linha ("Versoes instaladas: {0}  (atencao: mais de uma)" -f $nv) "Yellow" }
        elseif ($nv -eq 1) { Linha "Versoes instaladas: 1" "Gray" }
        else { Linha "Roblox nao encontrado neste PC" "Red" }
        Divisoria
        Linha "[1]  Aplicar fast flags selecionados" "Cyan"
        Linha "[2]  Escolher / ver fast flags" "Cyan"
        Linha "[3]  Abrir Roblox" "Cyan"
        Linha "[4]  Remover fast flags (voltar ao padrao)" "Cyan"
        Linha "[5]  Versoes do Roblox (instaladas / mais recente)" "Cyan"
        Linha "[0]  Sair" "DarkGray"
        Base

        $k = [Console]::ReadKey($true).KeyChar.ToString()
        switch ($k) {
            "1" { Aplicar }
            "2" { Tela-Flags }
            "3" { Abrir }
            "4" { Remover }
            "5" { Tela-Versoes }
            "0" { return }
        }
    }
}

# ---------------- Execucao ----------------
Intro
Menu
Clear-Host
try { [Console]::CursorVisible = $true } catch {}
Write-Host ""
Digitar "  Ate a proxima!" "Cyan" 25
Start-Sleep -Milliseconds 500
Clear-Host
Stop-Process -Id $PID
