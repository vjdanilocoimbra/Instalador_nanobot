Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ==================================================================
# NANOBOT - Instalador de Requisitos
# Instala: Python 3.12+  |  ffmpeg  |  Dependencias Python
# Baseado no instalador oficial @vjdanilocoimbra
# ==================================================================

$ErrorActionPreference = "SilentlyContinue"
[System.Windows.Forms.Application]::EnableVisualStyles()

# ==================================================================
# CORES
# ==================================================================
$C_BG     = [System.Drawing.Color]::FromArgb(10, 18, 32)
$C_CYAN   = [System.Drawing.Color]::FromArgb(0, 200, 240)
$C_TEAL   = [System.Drawing.Color]::FromArgb(29, 233, 182)
$C_DIM    = [System.Drawing.Color]::FromArgb(70, 100, 130)
$C_PANEL  = [System.Drawing.Color]::FromArgb(14, 26, 48)
$C_LINE   = [System.Drawing.Color]::FromArgb(25, 55, 85)
$C_BTN    = [System.Drawing.Color]::FromArgb(0, 55, 110)
$C_RED    = [System.Drawing.Color]::FromArgb(255, 85, 85)
$C_WHITE  = [System.Drawing.Color]::White
$C_LOG_BG = [System.Drawing.Color]::FromArgb(6, 12, 24)

# ==================================================================
# JANELA PRINCIPAL
# ==================================================================
$form = [System.Windows.Forms.Form]::new()
$form.Text            = "Nanobot - Instalador de Requisitos"
$form.ClientSize      = [System.Drawing.Size]::new(720, 600)
$form.StartPosition   = "CenterScreen"
$form.BackColor       = $C_BG
$form.ForeColor       = $C_CYAN
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox     = $false
$form.Font            = [System.Drawing.Font]::new("Consolas", 9)

# -- Titulo --
$lblTitle = [System.Windows.Forms.Label]::new()
$lblTitle.Text      = "NANOBOT"
$lblTitle.Font      = [System.Drawing.Font]::new("Consolas", 20, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = $C_CYAN
$lblTitle.BackColor = $C_BG
$lblTitle.AutoSize  = $true
$lblTitle.Location  = [System.Drawing.Point]::new(24, 14)
$form.Controls.Add($lblTitle)

$lblSub = [System.Windows.Forms.Label]::new()
$lblSub.Text      = "Instalador de Requisitos  -  Python e ffmpeg"
$lblSub.ForeColor = $C_DIM
$lblSub.BackColor = $C_BG
$lblSub.AutoSize  = $true
$lblSub.Location  = [System.Drawing.Point]::new(26, 52)
$form.Controls.Add($lblSub)

# Link clicavel pro Instagram do criador (igual ao instalador oficial)
$lnkInsta = [System.Windows.Forms.LinkLabel]::new()
$lnkInsta.Text            = "@vjdanilocoimbra"
$lnkInsta.Font            = [System.Drawing.Font]::new("Consolas", 9, [System.Drawing.FontStyle]::Bold)
$lnkInsta.LinkColor       = [System.Drawing.Color]::FromArgb(0, 212, 255)
$lnkInsta.ActiveLinkColor = [System.Drawing.Color]::FromArgb(29, 233, 182)
$lnkInsta.VisitedLinkColor = [System.Drawing.Color]::FromArgb(0, 212, 255)
$lnkInsta.BackColor       = $C_BG
$lnkInsta.AutoSize        = $true
$lnkInsta.Location        = [System.Drawing.Point]::new(560, 18)
$lnkInsta.Cursor          = [System.Windows.Forms.Cursors]::Hand
$lnkInsta.Add_LinkClicked({ Start-Process "https://www.instagram.com/vjdanilocoimbra/" })
$form.Controls.Add($lnkInsta)

# Animacao de pulso no link (mesmo efeito do instalador oficial)
$pulseTimer = [System.Windows.Forms.Timer]::new()
$pulseTimer.Interval = 50
$script:pulsePhase = 0.0
$pulseTimer.Add_Tick({
    $script:pulsePhase += 0.04
    $s = [Math]::Sin($script:pulsePhase)
    $lnkInsta.LinkColor = [System.Drawing.Color]::FromArgb(
        [Math]::Max(0, [Math]::Min(255, [int](0 + 29 * [Math]::Max(0, $s)))),
        [Math]::Max(0, [Math]::Min(255, [int](170 + 63 * $s))),
        [Math]::Max(0, [Math]::Min(255, [int](220 + 35 * $s))))
})
$pulseTimer.Start()

# Separador
$sep1 = [System.Windows.Forms.Panel]::new()
$sep1.BackColor = $C_LINE
$sep1.Size      = [System.Drawing.Size]::new(680, 1)
$sep1.Location  = [System.Drawing.Point]::new(20, 78)
$form.Controls.Add($sep1)

# ==================================================================
# PAINEL DE STATUS - 3 linhas (Python, ffmpeg, Dependencias)
# ==================================================================
$statusPanel = [System.Windows.Forms.Panel]::new()
$statusPanel.BackColor   = $C_PANEL
$statusPanel.Size        = [System.Drawing.Size]::new(680, 140)
$statusPanel.Location    = [System.Drawing.Point]::new(20, 88)
$statusPanel.BorderStyle = "None"
$form.Controls.Add($statusPanel)

# Cabecalho
foreach ($h in @(
    @{ T="COMPONENTE"; X=44 },
    @{ T="VERSAO MINIMA"; X=280 },
    @{ T="STATUS"; X=470 }
)) {
    $lbl = [System.Windows.Forms.Label]::new()
    $lbl.Text      = $h.T
    $lbl.ForeColor = $C_DIM
    $lbl.BackColor = $C_PANEL
    $lbl.Font      = [System.Drawing.Font]::new("Consolas", 8)
    $lbl.AutoSize  = $true
    $lbl.Location  = [System.Drawing.Point]::new($h.X, 8)
    $statusPanel.Controls.Add($lbl)
}

# Funcao para criar linha de status
function New-StatusRow {
    param($parent, $y, $name, $minVer)

    $dot = [System.Windows.Forms.Label]::new()
    $dot.Text      = ">>>"
    $dot.ForeColor = $C_DIM
    $dot.BackColor = $C_PANEL
    $dot.Font      = [System.Drawing.Font]::new("Consolas", 9, [System.Drawing.FontStyle]::Bold)
    $dot.AutoSize  = $true
    $dot.Location  = [System.Drawing.Point]::new(12, $y)
    $parent.Controls.Add($dot)

    $lbl = [System.Windows.Forms.Label]::new()
    $lbl.Text      = $name
    $lbl.ForeColor = $C_WHITE
    $lbl.BackColor = $C_PANEL
    $lbl.AutoSize  = $true
    $lbl.Location  = [System.Drawing.Point]::new(44, $y)
    $parent.Controls.Add($lbl)

    $min = [System.Windows.Forms.Label]::new()
    $min.Text      = $minVer
    $min.ForeColor = $C_DIM
    $min.BackColor = $C_PANEL
    $min.AutoSize  = $true
    $min.Location  = [System.Drawing.Point]::new(280, $y)
    $parent.Controls.Add($min)

    $st = [System.Windows.Forms.Label]::new()
    $st.Text      = "Verificando..."
    $st.ForeColor = $C_DIM
    $st.BackColor = $C_PANEL
    $st.AutoSize  = $false
    $st.Size      = [System.Drawing.Size]::new(200, 18)
    $st.Location  = [System.Drawing.Point]::new(470, $y)
    $parent.Controls.Add($st)

    return @{ Dot = $dot; Status = $st }
}

$pyRow   = New-StatusRow $statusPanel 32  "Python"                 "3.10+"
$ffRow   = New-StatusRow $statusPanel 58  "ffmpeg"                 "qualquer"
$depRow  = New-StatusRow $statusPanel 84  "Bibliotecas Python"     "pip"

# ==================================================================
# AREA DE LOG
# ==================================================================
$sep2 = [System.Windows.Forms.Panel]::new()
$sep2.BackColor = $C_LINE
$sep2.Size      = [System.Drawing.Size]::new(680, 1)
$sep2.Location  = [System.Drawing.Point]::new(20, 237)
$form.Controls.Add($sep2)

$logBox = [System.Windows.Forms.RichTextBox]::new()
$logBox.BackColor   = $C_LOG_BG
$logBox.ForeColor   = $C_CYAN
$logBox.Font        = [System.Drawing.Font]::new("Consolas", 9)
$logBox.ReadOnly    = $true
$logBox.BorderStyle = "None"
$logBox.Size        = [System.Drawing.Size]::new(680, 199)
$logBox.Location    = [System.Drawing.Point]::new(20, 245)
$logBox.ScrollBars  = "Vertical"
$form.Controls.Add($logBox)

# ==================================================================
# BARRA DE PROGRESSO
# ==================================================================
$pBarBg = [System.Windows.Forms.Panel]::new()
$pBarBg.BackColor = [System.Drawing.Color]::FromArgb(12, 28, 50)
$pBarBg.Size      = [System.Drawing.Size]::new(580, 10)
$pBarBg.Location  = [System.Drawing.Point]::new(20, 454)
$form.Controls.Add($pBarBg)

$pBarFill = [System.Windows.Forms.Panel]::new()
$pBarFill.BackColor = $C_CYAN
$pBarFill.Size      = [System.Drawing.Size]::new(0, 10)
$pBarFill.Location  = [System.Drawing.Point]::new(0, 0)
$pBarBg.Controls.Add($pBarFill)

$lblPct = [System.Windows.Forms.Label]::new()
$lblPct.Text      = ""
$lblPct.ForeColor = $C_DIM
$lblPct.BackColor = $C_BG
$lblPct.AutoSize  = $true
$lblPct.Location  = [System.Drawing.Point]::new(610, 452)
$form.Controls.Add($lblPct)

# ==================================================================
# BOTOES
# ==================================================================
$btnInstall = [System.Windows.Forms.Button]::new()
$btnInstall.Text      = "INSTALAR REQUISITOS"
$btnInstall.Size      = [System.Drawing.Size]::new(250, 40)
$btnInstall.Location  = [System.Drawing.Point]::new(220, 480)
$btnInstall.BackColor = $C_BTN
$btnInstall.ForeColor = $C_WHITE
$btnInstall.FlatStyle = "Flat"
$btnInstall.FlatAppearance.BorderColor = $C_CYAN
$btnInstall.FlatAppearance.BorderSize  = 1
$btnInstall.Font      = [System.Drawing.Font]::new("Consolas", 11, [System.Drawing.FontStyle]::Bold)
$btnInstall.Cursor    = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($btnInstall)

$btnClose = [System.Windows.Forms.Button]::new()
$btnClose.Text      = "FECHAR"
$btnClose.Size      = [System.Drawing.Size]::new(100, 40)
$btnClose.Location  = [System.Drawing.Point]::new(490, 480)
$btnClose.BackColor = [System.Drawing.Color]::FromArgb(40, 15, 15)
$btnClose.ForeColor = $C_DIM
$btnClose.FlatStyle = "Flat"
$btnClose.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(70, 35, 35)
$btnClose.FlatAppearance.BorderSize  = 1
$btnClose.Cursor    = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($btnClose)

# ==================================================================
# FUNCOES AUXILIARES
# ==================================================================
function Log($msg) {
    $logBox.AppendText("  > $msg`r`n")
    $logBox.SelectionStart = $logBox.TextLength
    $logBox.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

function Log-Blank { $logBox.AppendText("`r`n"); [System.Windows.Forms.Application]::DoEvents() }

function SetProgress($pct) {
    $w = [int]([Math]::Min($pct, 100) * $pBarBg.Width / 100)
    $pBarFill.Width = $w
    $lblPct.Text = "$pct%"
    [System.Windows.Forms.Application]::DoEvents()
}

function SetStatus($row, $text, $color) {
    $row.Status.Text      = $text
    $row.Status.ForeColor = $color
    $row.Dot.ForeColor    = $color
    [System.Windows.Forms.Application]::DoEvents()
}

function Refresh-EnvPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# Busca executavel no PATH e em diretorios conhecidos de instalacao
function Find-Exe($name, $knownPaths) {
    Refresh-EnvPath
    try {
        $psi = [System.Diagnostics.ProcessStartInfo]::new()
        $psi.FileName = "where.exe"
        $psi.Arguments = $name
        $psi.UseShellExecute = $false
        $psi.RedirectStandardOutput = $true
        $psi.CreateNoWindow = $true
        $p = [System.Diagnostics.Process]::Start($psi)
        $out = $p.StandardOutput.ReadToEnd().Trim()
        [void]$p.WaitForExit(5000)
        if ($p.ExitCode -eq 0 -and $out) {
            $first = ($out -split "`n")[0].Trim()
            if ($first -and ($first -notlike "*WindowsApps*")) {
                return $first
            }
        }
    } catch {}
    foreach ($dir in $knownPaths) {
        $full = Join-Path $dir $name
        if (Test-Path $full) { return $full }
    }
    return $null
}

function Get-CmdOutput($exePath, $arguments) {
    try {
        if (-not $exePath) { return $null }
        if (-not (Test-Path $exePath)) {
            $found = $null
            try {
                $psi2 = [System.Diagnostics.ProcessStartInfo]::new()
                $psi2.FileName = "where.exe"
                $psi2.Arguments = $exePath
                $psi2.UseShellExecute = $false
                $psi2.RedirectStandardOutput = $true
                $psi2.CreateNoWindow = $true
                $p2 = [System.Diagnostics.Process]::Start($psi2)
                $found = $p2.StandardOutput.ReadToEnd().Trim()
                [void]$p2.WaitForExit(5000)
                if ($p2.ExitCode -ne 0) { $found = $null }
            } catch {}
            if (-not $found) { return $null }
            $exePath = ($found -split "`n")[0].Trim()
        }
        $psi = [System.Diagnostics.ProcessStartInfo]::new()
        $psi.FileName               = $exePath
        $psi.Arguments              = $arguments
        $psi.UseShellExecute        = $false
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError  = $true
        $psi.CreateNoWindow         = $true
        $p = [System.Diagnostics.Process]::Start($psi)
        $out = $p.StandardOutput.ReadToEnd()
        if (-not $p.WaitForExit(10000)) { try { $p.Kill() } catch {} }
        if ($out) { return $out.Trim() }
        return $null
    } catch {
        return $null
    }
}

function Wait-Process-Responsive($proc) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    while (-not $proc.HasExited) {
        [System.Windows.Forms.Application]::DoEvents()
        Start-Sleep -Milliseconds 300
        if ($sw.Elapsed.TotalMinutes -gt 10) {
            try { $proc.Kill() } catch {}
            return -1
        }
    }
    return $proc.ExitCode
}

function Run-Silent($exe, $arguments) {
    try {
        $psi = [System.Diagnostics.ProcessStartInfo]::new()
        $psi.FileName        = $exe
        $psi.Arguments       = $arguments
        $psi.UseShellExecute = $true
        $psi.WindowStyle     = "Hidden"
        $p = [System.Diagnostics.Process]::Start($psi)
        return (Wait-Process-Responsive $p)
    } catch {
        Log "  Erro ao executar: $exe"
        return -1
    }
}

function Has-Winget {
    try {
        $r = Get-CmdOutput "winget.exe" "--version"
        return ($r -and $r -match "\d+\.\d+")
    } catch { return $false }
}

# ==================================================================
# DIRETORIOS CONHECIDOS DE INSTALACAO
# ==================================================================
$PYTHON_DIRS = @(
    "C:\Python312", "C:\Python311", "C:\Python310",
    "$env:LOCALAPPDATA\Programs\Python\Python312",
    "$env:LOCALAPPDATA\Programs\Python\Python311",
    "$env:LOCALAPPDATA\Programs\Python\Python310",
    "C:\Program Files\Python312", "C:\Program Files\Python311",
    "$env:ProgramFiles\Python312", "$env:ProgramFiles\Python311"
)

# ==================================================================
# VERIFICACAO DE COMPONENTES
# ==================================================================
function Check-Python {
    try {
        Refresh-EnvPath
        $exe = Find-Exe "python.exe" $PYTHON_DIRS
        if ($exe) {
            $v = Get-CmdOutput $exe "--version"
            if ($v -and ($v -match "Python\s+3\.(\d+)")) {
                if ($Matches -and $Matches[1]) {
                    $minor = [int]$Matches[1]
                    if ($minor -ge 10) { return $v.Trim() }
                }
            }
        }
        $py = Find-Exe "py.exe" @("C:\Windows")
        if ($py) {
            $v = Get-CmdOutput $py "-3 --version"
            if ($v -and ($v -match "Python\s+3\.(\d+)")) {
                if ($Matches -and $Matches[1]) {
                    $minor = [int]$Matches[1]
                    if ($minor -ge 10) { return $v.Trim() }
                }
            }
        }
        foreach ($dir in $PYTHON_DIRS) {
            $pyExe = Join-Path $dir "python.exe"
            if (Test-Path $pyExe) {
                $v = Get-CmdOutput $pyExe "--version"
                if ($v -and ($v -match "Python\s+3\.(\d+)")) {
                    if ($Matches -and $Matches[1]) {
                        $minor = [int]$Matches[1]
                        if ($minor -ge 10) {
                            $curPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
                            if ($curPath -notlike "*$dir*") {
                                [System.Environment]::SetEnvironmentVariable("Path", "$curPath;$dir;$dir\Scripts", "Machine")
                                Log "  Python encontrado em $dir - adicionado ao PATH"
                            }
                            Refresh-EnvPath
                            return $v.Trim()
                        }
                    }
                }
            }
        }
    } catch {}
    return $null
}

function Check-FFmpeg {
    try {
        Refresh-EnvPath
        $exe = Find-Exe "ffmpeg.exe" @("C:\ffmpeg\bin", "C:\ProgramData\chocolatey\bin")
        if ($exe) {
            $v = Get-CmdOutput $exe "-version"
            if ($v -and ($v -match "ffmpeg version")) { return "Instalado" }
        }
        if (Test-Path "C:\ffmpeg\bin\ffmpeg.exe") { return "Instalado (C:\ffmpeg)" }
    } catch {}
    return $null
}

# ==================================================================
# INSTALACAO DE COMPONENTES
# ==================================================================
function Install-PythonNow {
    Log "Instalando Python 3.12..."

    # Remove alias do Microsoft Store que interfere
    $aliases = "$env:LOCALAPPDATA\Microsoft\WindowsApps\python*.exe"
    Remove-Item $aliases -Force -ErrorAction SilentlyContinue
    $aliases3 = "$env:LOCALAPPDATA\Microsoft\WindowsApps\python3*.exe"
    Remove-Item $aliases3 -Force -ErrorAction SilentlyContinue

    $useWinget = Has-Winget
    if ($useWinget) {
        Log "  Usando winget (pode demorar 1-3 min)..."
        $code = Run-Silent "winget" "install Python.Python.3.12 --silent --accept-source-agreements --accept-package-agreements"
        Log "  winget finalizado (codigo: $code). Aguardando..."
        Start-Sleep -Seconds 5
        Refresh-EnvPath
        $check = Check-Python
        if ($check) { return $check }
        Log "  winget nao confirmou no PATH. Tentando download direto..."
    }

    Log "  Baixando Python 3.12.7 do site oficial..."
    $url = "https://www.python.org/ftp/python/3.12.7/python-3.12.7-amd64.exe"
    $tmp = "$env:TEMP\python-3.12.7-amd64.exe"
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $wc = [System.Net.WebClient]::new()
        $wc.DownloadFile($url, $tmp)
        Log "  Download OK. Instalando (aguarde ~1 min)..."
        $code = Run-Silent $tmp "/quiet InstallAllUsers=1 PrependPath=1 Include_pip=1 Include_launcher=1"
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    } catch {
        Log "  ERRO no download: $($_.Exception.Message)"
        return $null
    }

    Log "  Verificando instalacao..."
    for ($i = 1; $i -le 5; $i++) {
        Start-Sleep -Seconds 3
        Refresh-EnvPath
        [System.Windows.Forms.Application]::DoEvents()
        $check = Check-Python
        if ($check) { return $check }
        Log "  Tentativa $i/5 - ainda nao encontrado..."
    }
    return $null
}

function Install-FFmpegNow {
    Log "Instalando ffmpeg..."

    $useWinget = Has-Winget
    if ($useWinget) {
        Log "  Usando winget..."
        $code = Run-Silent "winget" "install Gyan.FFmpeg --silent --accept-source-agreements --accept-package-agreements"
        Start-Sleep -Seconds 3
        Refresh-EnvPath
        $check = Check-FFmpeg
        if ($check) { return $check }
        Log "  winget nao confirmou. Tentando download direto..."
    }

    Log "  Baixando ffmpeg do GitHub (pode demorar)..."
    $url = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
    $zipPath = "$env:TEMP\ffmpeg.zip"
    $extractPath = "C:\ffmpeg"
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $wc = [System.Net.WebClient]::new()
        $wc.DownloadFile($url, $zipPath)
        Log "  Download OK. Extraindo..."

        $tmpExtract = "$env:TEMP\ffmpeg_extract"
        if (Test-Path $tmpExtract) { Remove-Item $tmpExtract -Recurse -Force }
        Expand-Archive -Path $zipPath -DestinationPath $tmpExtract -Force

        $inner = Get-ChildItem $tmpExtract -Directory | Select-Object -First 1
        if (Test-Path $extractPath) { Remove-Item $extractPath -Recurse -Force }
        Move-Item $inner.FullName $extractPath -Force

        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
        Remove-Item $tmpExtract -Recurse -Force -ErrorAction SilentlyContinue

        $binPath = "$extractPath\bin"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($currentPath -notlike "*$binPath*") {
            [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$binPath", "Machine")
            Log "  ffmpeg adicionado ao PATH do sistema"
        }
        Refresh-EnvPath
        return Check-FFmpeg
    } catch {
        Log "  ERRO: $($_.Exception.Message)"
        return $null
    }
}

function Install-NanobotDeps {
    Log "Instalando Nanobot e bibliotecas Python..."
    Log "  Pode demorar 5 a 15 minutos. Aguarde sem fechar."

    $pyExe = Find-Exe "python.exe" $PYTHON_DIRS
    if (-not $pyExe) {
        Log "  ERRO: Python nao encontrado para instalar as libs."
        return $false
    }

    # Atualiza pip (MUITO importante pra pegar wheels mais novos)
    Log "  Atualizando pip..."
    $code = Run-Silent $pyExe "-m pip install --upgrade pip setuptools wheel --disable-pip-version-check --no-warn-script-location"

    # 1) NANOBOT-AI (o CLI principal) com TODOS os extras pra ter ferramentas
    Log ""
    Log "  [1/2] Instalando nanobot-ai (core + ferramentas)..."
    # [matrix] = integra com matrix/MCP pra habilitar tools filesystem, web, etc.
    $code = Run-Silent $pyExe "-m pip install nanobot-ai[matrix] --disable-pip-version-check --prefer-binary --no-warn-script-location"
    if ($code -ne 0) {
        # Se extras falharem, instala so o basico
        Log "    !! extras [matrix] falharam, instalando core basico..."
        $code = Run-Silent $pyExe "-m pip install nanobot-ai --disable-pip-version-check --prefer-binary --no-warn-script-location"
    }
    if ($code -eq 0) {
        Log "    OK - comando 'nanobot' disponivel"
    } else {
        Log "    !! Tentando sem cache..."
        $code = Run-Silent $pyExe "-m pip install nanobot-ai --disable-pip-version-check --no-cache-dir --prefer-binary --no-warn-script-location"
        if ($code -eq 0) {
            Log "    OK - instalado"
        } else {
            Log "    ERRO CRITICO: nanobot-ai nao instalou."
            return $false
        }
    }

    # Tools extras: busca web (duckduckgo), extracao de paginas, MCP servers
    Log ""
    Log "  Instalando bibliotecas extras para as ferramentas..."
    $toolLibs = "duckduckgo-search beautifulsoup4 lxml trafilatura mcp httpx-sse"
    $code = Run-Silent $pyExe "-m pip install $toolLibs --disable-pip-version-check --prefer-binary --no-warn-script-location"
    if ($code -eq 0) {
        Log "    OK - ferramentas de busca web instaladas"
    } else {
        Log "    !! algumas libs de ferramentas falharam (nanobot funciona, mas sem web search)"
    }

    # 2) DEPENDENCIAS DO VOICE SERVICE — uma por uma pra nao perder nada
    Log ""
    Log "  [2/2] Instalando bibliotecas Python (uma por uma)..."

    # Ordem estrategica: primeiro as faceis/rapidas, depois as que podem dar problema
    $packages = @(
        # Essenciais — quase nunca falham
        @{ Name="fastapi";          Spec="fastapi>=0.111.0";        Critical=$true },
        @{ Name="uvicorn";          Spec="uvicorn[standard]>=0.29.0"; Critical=$true },
        @{ Name="python-multipart"; Spec="python-multipart";         Critical=$false },
        @{ Name="python-dotenv";    Spec="python-dotenv";            Critical=$false },
        @{ Name="pydantic";         Spec="pydantic>=2.0.0";          Critical=$true },
        @{ Name="openai";           Spec="openai>=1.30.0";           Critical=$true },
        @{ Name="httpx";            Spec="httpx>=0.27.0";            Critical=$true },
        @{ Name="requests";         Spec="requests>=2.31.0";         Critical=$true },
        @{ Name="aiohttp";          Spec="aiohttp";                  Critical=$false },
        @{ Name="urllib3";          Spec="urllib3>=2.0.0";           Critical=$false },
        @{ Name="Pillow";           Spec="Pillow>=10.0.0";           Critical=$false },
        @{ Name="psutil";           Spec="psutil>=5.9.0";            Critical=$false },
        @{ Name="numpy";            Spec="numpy";                    Critical=$false },
        @{ Name="soundfile";        Spec="soundfile";                Critical=$false },
        @{ Name="pydub";            Spec="pydub>=0.25.1";            Critical=$false },
        @{ Name="edge-tts";         Spec="edge-tts>=6.1.0";          Critical=$false },
        @{ Name="spotipy";          Spec="spotipy>=2.23.0";          Critical=$false },
        # Problematicas — deixa por ultimo
        @{ Name="faster-whisper";   Spec="faster-whisper>=1.0.0";    Critical=$false },
        @{ Name="openwakeword";     Spec="openwakeword";             Critical=$false },
        @{ Name="pyaudio";          Spec="pyaudio";                  Critical=$false }
    )

    $totalPkgs = $packages.Count
    $okCount = 0
    $failedCritical = @()

    foreach ($pkg in $packages) {
        $n = $pkg.Name
        $s = $pkg.Spec

        # Tentativa 1: padrao com --prefer-binary (usa wheels pre-compilados)
        $c = Run-Silent $pyExe "-m pip install `"$s`" --disable-pip-version-check --prefer-binary --no-warn-script-location"

        if ($c -ne 0) {
            # Tentativa 2: so binary (fall back pra wheel puro)
            $c = Run-Silent $pyExe "-m pip install `"$s`" --disable-pip-version-check --only-binary :all: --no-warn-script-location"
        }

        if ($c -ne 0) {
            # Tentativa 3: sem cache + sem version check
            $c = Run-Silent $pyExe "-m pip install `"$s`" --disable-pip-version-check --no-cache-dir --prefer-binary --no-warn-script-location"
        }

        if ($c -eq 0) {
            Log "    OK  $n"
            $okCount++
        } else {
            Log "    !!  $n (falhou apos 3 tentativas)"
            if ($pkg.Critical) {
                $failedCritical += $n
            }
        }
    }

    Log ""
    Log "  Instaladas: $okCount de $totalPkgs bibliotecas"

    if ($failedCritical.Count -gt 0) {
        Log "  AVISO: pacotes CRITICOS falharam: $($failedCritical -join ', ')"
        Log "  A IA pode nao funcionar completamente."
    }

    # Verificacao do comando nanobot
    Log ""
    Log "  Verificando comando 'nanobot'..."
    Refresh-EnvPath
    Start-Sleep -Seconds 2

    $nanobotCmd = Get-CmdOutput "nanobot" "--version"
    if (-not $nanobotCmd) {
        $nanobotCmd = Get-CmdOutput $pyExe "-m nanobot --version"
    }

    if ($nanobotCmd) {
        Log "    OK - nanobot: $nanobotCmd"
    } else {
        Log "    AVISO: 'nanobot' nao encontrado no PATH ainda."
    }

    return $true
}

function Setup-NanobotConfig {
    Log "Configurando Nanobot..."

    # NAO criamos ia_settings.json custom — o nanobot-ai usa seu proprio
    # config.json (criado automaticamente pelo 'nanobot onboard').
    # Aqui so garantimos a pasta e preparamos o atalho de chat.

    $cfgDir = Join-Path $env:USERPROFILE ".nanobot"
    if (-not (Test-Path $cfgDir)) {
        New-Item -ItemType Directory -Path $cfgDir -Force | Out-Null
    }

    # Descobre o python.exe pra usar nos atalhos
    $pyExe = Find-Exe "python.exe" $PYTHON_DIRS
    if (-not $pyExe) {
        Log "  AVISO: python nao encontrado, atalhos nao serao criados"
        return $true
    }

    # Cria pasta C:\Nanobot com o script de chat
    $nanobotDir = "C:\Nanobot"
    if (-not (Test-Path $nanobotDir)) {
        New-Item -ItemType Directory -Path $nanobotDir -Force | Out-Null
    }

    # ==============================================================
    # Conversar.bat — UNICO atalho de chat pro usuario
    # Abre direto 'nanobot agent' pro pessoal conversar com a IA
    # (sem ponte PowerShell customizada, igual o nanobot original)
    # ==============================================================
    $convContent = "@echo off`r`n"
    $convContent += "chcp 65001 >nul 2>&1`r`n"
    $convContent += "title Nanobot - Chat`r`n"
    $convContent += "cd /d `"%USERPROFILE%`"`r`n"
    $convContent += "`r`n"
    $convContent += "cls`r`n"
    $convContent += "color 0B`r`n"
    $convContent += "echo.`r`n"
    $convContent += "echo    ##    ##     ###     ##    ##     #####      ######     #####      ######`r`n"
    $convContent += "echo    ###   ##    ## ##    ###   ##    ##   ##     ##   ##   ##   ##       ##`r`n"
    $convContent += "echo    ####  ##   ##   ##   ####  ##    ##   ##     ######    ##   ##       ##`r`n"
    $convContent += "echo    ## ## ##   #######   ## ## ##    ##   ##     ##   ##   ##   ##       ##`r`n"
    $convContent += "echo    ##  ####   ##   ##   ##  ####    ##   ##     ##   ##   ##   ##       ##`r`n"
    $convContent += "echo    ##   ###   ##   ##   ##   ###     #####      ######     #####        ##`r`n"
    $convContent += "echo.`r`n"
    $convContent += "echo    ----------------------------------------------------------------`r`n"
    $convContent += "echo         Guia de Instalacao Facil  by  @vjdanilocoimbra`r`n"
    $convContent += "echo    ----------------------------------------------------------------`r`n"
    $convContent += "echo.`r`n"
    $convContent += "echo.`r`n"
    $convContent += "echo   Digite sua mensagem e pressione ENTER.`r`n"
    $convContent += "echo   Digite ^`"sair^`" para fechar o chat.`r`n"
    $convContent += "echo.`r`n"
    $convContent += "`r`n"
    $convContent += ":LOOP`r`n"
    $convContent += "set `"MSG=`"`r`n"
    $convContent += "set /p MSG=  Voce: `r`n"
    $convContent += "if not defined MSG goto LOOP`r`n"
    $convContent += "if /i `"%MSG%`"==`"sair`" goto END`r`n"
    $convContent += "if /i `"%MSG%`"==`"exit`" goto END`r`n"
    $convContent += "echo.`r`n"
    $convContent += "python -m nanobot agent -m `"%MSG%`"`r`n"
    $convContent += "echo.`r`n"
    $convContent += "goto LOOP`r`n"
    $convContent += "`r`n"
    $convContent += ":END`r`n"
    $convContent += "echo.`r`n"
    $convContent += "echo   Ate logo!`r`n"
    $convContent += "timeout /t 1 /nobreak ^>nul`r`n"

    $convPath = Join-Path $nanobotDir "Conversar.bat"
    [System.IO.File]::WriteAllText($convPath, $convContent, [System.Text.Encoding]::Default)
    Log "  Script criado: $convPath"

    # Limpa scripts obsoletos (caso o aluno ja tivesse versao anterior)
    @(
        "Configurar_OpenRouter.ps1",
        "Trocar_Modelo.ps1",
        "Trocar_Modelo.bat"
    ) | ForEach-Object {
        $old = Join-Path $nanobotDir $_
        if (Test-Path $old) { Remove-Item $old -Force -EA SilentlyContinue }
    }

    # ==============================================================
    # Configurar_OpenAI.ps1 — forca provider=openai + model=gpt-4o-mini
    # Roda depois do 'nanobot onboard' pra GARANTIR que o config fica
    # com OpenAI (barato e estavel) ao inves do default do nanobot
    # (que as vezes e Claude Opus — muito caro).
    # ==============================================================
    $cfgOpenAIContent = @'
# Forca o config do Nanobot a usar OpenAI + gpt-4o-mini
# (barato, estavel, suporta tools)

$cfg = Join-Path $env:USERPROFILE ".nanobot\config.json"

if (-not (Test-Path $cfg)) {
    Write-Host "  [config.json nao encontrado, pulando]" -ForegroundColor Yellow
    exit 0
}

try {
    # Le como UTF-8 (ignora BOM se tiver)
    $content = [System.IO.File]::ReadAllText($cfg, [System.Text.UTF8Encoding]::new($false))

    # Substitui "provider": "..." por "provider": "openai"
    if ($content -match '"provider"\s*:\s*"[^"]*"') {
        $content = $content -replace '"provider"\s*:\s*"[^"]*"', '"provider": "openai"'
    }

    # Substitui "model": "..." por "model": "gpt-4o-mini"
    if ($content -match '"model"\s*:\s*"[^"]*"') {
        $content = $content -replace '"model"\s*:\s*"[^"]*"', '"model": "gpt-4o-mini"'
    }

    # CRITICO: salva SEM BOM (nanobot-ai nao aceita BOM no JSON)
    [System.IO.File]::WriteAllText($cfg, $content, [System.Text.UTF8Encoding]::new($false))

    Write-Host ""
    Write-Host "   Config ajustado:" -ForegroundColor Green
    Write-Host "     provider: openai" -ForegroundColor Cyan
    Write-Host "     model:    gpt-4o-mini" -ForegroundColor Cyan
    Write-Host "     (barato, rapido, com tools)" -ForegroundColor DarkGray
    Write-Host ""
} catch {
    Write-Host "  [Aviso: $($_.Exception.Message)]" -ForegroundColor Yellow
}
'@

    $cfgOpenAIPath = Join-Path $nanobotDir "Configurar_OpenAI.ps1"
    [System.IO.File]::WriteAllText($cfgOpenAIPath, $cfgOpenAIContent, [System.Text.UTF8Encoding]::new($true))
    Log "  Script criado: $cfgOpenAIPath"

    $trocarPsContent_DONTUSE = @'
    $trocarPsContent = @'
# Trocar modelo do Nanobot - BUSCA MODELOS EM TEMPO REAL da API do OpenRouter
# (nunca fica desatualizado — sempre mostra modelos que EXISTEM AGORA)
$cfg = Join-Path $env:USERPROFILE ".nanobot\config.json"

if (-not (Test-Path $cfg)) {
    Write-Host "  Config nao encontrado! Rode 'Conversar com Nanobot' primeiro." -ForegroundColor Red
    Read-Host "  Pressione ENTER pra fechar"
    exit 1
}

Clear-Host
Write-Host ""
Write-Host "  =================================================================" -ForegroundColor Cyan
Write-Host "     TROCAR MODELO DO NANOBOT  -  by @vjdanilocoimbra" -ForegroundColor Cyan
Write-Host "  =================================================================" -ForegroundColor Cyan
Write-Host ""

# Mostra modelo atual
try {
    $content = [System.IO.File]::ReadAllText($cfg, [System.Text.UTF8Encoding]::new($false))
    if ($content -match '"model"\s*:\s*"([^"]*)"') {
        Write-Host "  Modelo atual: " -NoNewline -ForegroundColor DarkGray
        Write-Host "$($Matches[1])" -ForegroundColor Yellow
        Write-Host ""
    }
} catch {}

# Busca modelos free ATUAIS do OpenRouter
Write-Host "  Buscando modelos gratuitos disponiveis no OpenRouter..." -ForegroundColor DarkGray
Write-Host ""

$modelos = @()
try {
    $r = Invoke-RestMethod -Uri "https://openrouter.ai/api/v1/models" -UseBasicParsing -TimeoutSec 15
    # Filtra so os :free E que suportam tools
    $freeList = $r.data | Where-Object {
        $_.id -match ':free$' -and
        $_.supported_parameters -contains 'tools'
    }

    # Ordena por nome (mais populares primeiro — Google, Meta, DeepSeek, Qwen, Mistral)
    $prioridade = @{
        'google'    = 1
        'deepseek'  = 2
        'meta-llama'= 3
        'qwen'      = 4
        'mistralai' = 5
    }
    $freeList = $freeList | Sort-Object @{
        Expression = {
            $fam = ($_.id -split '/')[0]
            if ($prioridade.ContainsKey($fam)) { $prioridade[$fam] } else { 99 }
        }
    }, id

    foreach ($m in $freeList) {
        $modelos += @{
            Id = $m.id
            Name = $m.name
            Context = $m.context_length
        }
    }
} catch {
    Write-Host "  [Aviso: nao consegui buscar lista atual, usando lista padrao]" -ForegroundColor Yellow
    # Fallback com modelos mais estaveis
    $modelos = @(
        @{ Id = 'google/gemini-2.0-flash-exp:free';           Name = 'Gemini 2.0 Flash Experimental'; Context = 1000000 },
        @{ Id = 'deepseek/deepseek-r1:free';                  Name = 'DeepSeek R1';                   Context = 128000 },
        @{ Id = 'meta-llama/llama-3.3-70b-instruct:free';    Name = 'Llama 3.3 70B Instruct';        Context = 131072 }
    )
}

if ($modelos.Count -eq 0) {
    Write-Host "  Nenhum modelo gratuito com tools encontrado!" -ForegroundColor Red
    Write-Host "  Verifique sua conexao com internet." -ForegroundColor Yellow
    Read-Host "  Pressione ENTER pra fechar"
    exit 1
}

Write-Host "  $($modelos.Count) modelos gratuitos encontrados (com suporte a ferramentas):" -ForegroundColor Green
Write-Host ""

# Limita a 15 pra nao poluir a tela
$maxMostrar = [Math]::Min(15, $modelos.Count)
for ($i = 0; $i -lt $maxMostrar; $i++) {
    $n = $i + 1
    $mod = $modelos[$i]
    $ctx = if ($mod.Context -ge 1000000) { "{0}M ctx" -f [int]($mod.Context/1000000) }
           elseif ($mod.Context -ge 1000) { "{0}K ctx" -f [int]($mod.Context/1000) }
           else { "{0} ctx" -f $mod.Context }

    Write-Host ("    [{0,2}] " -f $n) -NoNewline -ForegroundColor Cyan
    Write-Host ("{0,-40} " -f $mod.Name) -NoNewline -ForegroundColor White
    Write-Host ("({0})" -f $ctx) -ForegroundColor DarkGray
    Write-Host ("         " + $mod.Id) -ForegroundColor DarkGray
}

if ($modelos.Count -gt $maxMostrar) {
    Write-Host ""
    Write-Host "    (mostrando $maxMostrar de $($modelos.Count) — os mais confiaveis)" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "    [S] Sair (nao trocar)" -ForegroundColor DarkGray
Write-Host ""
$op = Read-Host "  Digite o numero"

if ($op -match '^[Ss]') {
    Write-Host "  Cancelado." -ForegroundColor DarkGray
    Start-Sleep -Seconds 1
    exit 0
}

if ($op -notmatch '^\d+$' -or [int]$op -lt 1 -or [int]$op -gt $maxMostrar) {
    Write-Host "  Opcao invalida!" -ForegroundColor Red
    Read-Host "  Pressione ENTER pra fechar"
    exit 1
}

$escolhido = $modelos[[int]$op - 1]

# Aplica troca
try {
    $content = [System.IO.File]::ReadAllText($cfg, [System.Text.UTF8Encoding]::new($false))
    $content = $content -replace '"model"\s*:\s*"[^"]*"', ('"model": "' + $escolhido.Id + '"')
    [System.IO.File]::WriteAllText($cfg, $content, [System.Text.UTF8Encoding]::new($false))

    Write-Host ""
    Write-Host "  =================================================================" -ForegroundColor Green
    Write-Host "     OK! Modelo trocado." -ForegroundColor Green
    Write-Host "  =================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "     Novo modelo: " -NoNewline
    Write-Host $escolhido.Id -ForegroundColor Cyan
    Write-Host ""
    Write-Host "     Feche o chat do Nanobot e abra de novo pelo atalho." -ForegroundColor Yellow
    Write-Host ""
} catch {
    Write-Host "  Erro ao editar config: $($_.Exception.Message)" -ForegroundColor Red
}

Read-Host "  Pressione ENTER pra fechar"
'@
    # Fim do bloco legacy — $trocarPsContent_DONTUSE nao e escrito em disco.

    # Script 1: Nanobot.bat (usa goto labels = ZERO problema de parenteses)
    # Usa "python" (sem caminho completo) porque quando o usuario clicar no
    # atalho, sera um novo cmd com PATH ja atualizado. Se Python nao estiver
    # no PATH, o ELSE faz fallback pro caminho completo descoberto pelo installer.
    $pyPath = if ($pyExe) { $pyExe } else { "python" }

    # Nanobot.bat — roda o onboard com banner bonito ANTES de criar os
    # arquivos SOUL/MEMORY/AGENTS. Depois abre o config.json do nanobot
    # pro usuario colar a chave (OpenRouter por padrao).
    $batContent = "@echo off`r`n"
    $batContent += "chcp 65001 >nul 2>&1`r`n"
    $batContent += "title Nanobot - Instalacao`r`n"
    $batContent += "cd /d `"%USERPROFILE%`"`r`n"
    $batContent += "color 0B`r`n"
    $batContent += "`r`n"
    $batContent += "REM Se ja tem config, nao precisa rodar onboard de novo`r`n"
    $batContent += "if exist `"%USERPROFILE%\.nanobot\config.json`" goto OPEN_CONFIG`r`n"
    $batContent += "`r`n"
    $batContent += ":BANNER`r`n"
    $batContent += "cls`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo    ##    ##     ###     ##    ##     #####      ######     #####      ######`r`n"
    $batContent += "echo    ###   ##    ## ##    ###   ##    ##   ##     ##   ##   ##   ##       ##`r`n"
    $batContent += "echo    ####  ##   ##   ##   ####  ##    ##   ##     ######    ##   ##       ##`r`n"
    $batContent += "echo    ## ## ##   #######   ## ## ##    ##   ##     ##   ##   ##   ##       ##`r`n"
    $batContent += "echo    ##  ####   ##   ##   ##  ####    ##   ##     ##   ##   ##   ##       ##`r`n"
    $batContent += "echo    ##   ###   ##   ##   ##   ###     #####      ######     #####        ##`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo    ----------------------------------------------------------------`r`n"
    $batContent += "echo         Guia de Instalacao Facil  by  @vjdanilocoimbra`r`n"
    $batContent += "echo    ----------------------------------------------------------------`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo   Preparando sua IA pessoal...`r`n"
    $batContent += "echo   Isso vai criar os arquivos base (SOUL, MEMORY, USER, etc.)`r`n"
    $batContent += "echo.`r`n"
    $batContent += "timeout /t 3 /nobreak >nul`r`n"
    $batContent += "`r`n"
    $batContent += ":ONBOARD`r`n"
    $batContent += "python -m nanobot onboard`r`n"
    $batContent += "if errorlevel 1 `"$pyPath`" -m nanobot onboard`r`n"
    $batContent += "`r`n"
    $batContent += "REM Forca config pra OpenAI + gpt-4o-mini (barato e estavel)`r`n"
    $batContent += "powershell -NoProfile -ExecutionPolicy Bypass -File `"C:\Nanobot\Configurar_OpenAI.ps1`"`r`n"
    $batContent += "`r`n"
    $batContent += ":OPEN_CONFIG`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo     --------------------------------------------------`r`n"
    $batContent += "echo       PASSO FINAL: colocar sua chave de API`r`n"
    $batContent += "echo     --------------------------------------------------`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo   O Nanobot usa OpenAI por padrao:`r`n"
    $batContent += "echo     provider: openai`r`n"
    $batContent += "echo     model:    gpt-4o-mini  (rapido, barato, eficaz)`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo   Com 5 dolares de credito na OpenAI da pra usar meses!`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo   Onde pegar a chave:`r`n"
    $batContent += "echo     https://platform.openai.com/api-keys`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo   Onde adicionar credito (minimo 5 dolares):`r`n"
    $batContent += "echo     https://platform.openai.com/settings/organization/billing`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo   Cola a chave no arquivo que vai abrir agora.`r`n"
    $batContent += "echo   Siga o tutorial do Danilo.`r`n"
    $batContent += "echo.`r`n"
    $batContent += "pause`r`n"
    $batContent += "notepad `"%USERPROFILE%\.nanobot\config.json`"`r`n"
    $batContent += "echo.`r`n"
    $batContent += "echo   Pronto! Para conversar com o Nanobot, use o atalho`r`n"
    $batContent += "echo   'Conversar com Nanobot' na Area de Trabalho.`r`n"
    $batContent += "echo.`r`n"
    $batContent += "timeout /t 5 /nobreak >nul`r`n"
    $batContent += "exit /b 0`r`n"

    $batPath = Join-Path $nanobotDir "Nanobot.bat"
    [System.IO.File]::WriteAllText($batPath, $batContent, [System.Text.Encoding]::Default)
    Log "  Script criado: $batPath"

    # (Reconfigurar nao e mais necessario — comando /config dentro do chat abre o JSON)

    # Procura o icone (pode estar na pasta do instalador)
    $icoPaths = @(
        (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "ia_icon.ico"),
        "C:\IA\ia-gui\ia_icon.ico",
        "C:\IA\ia_icon.ico"
    )
    $icoPath = $null
    foreach ($p in $icoPaths) {
        if (Test-Path $p) {
            $icoPath = Join-Path $nanobotDir "nanobot.ico"
            Copy-Item $p $icoPath -Force -EA SilentlyContinue
            break
        }
    }

    # Remove atalhos antigos (de versoes anteriores do instalador)
    try {
        @(
            (Join-Path ([Environment]::GetFolderPath("Desktop")) "Nanobot.lnk"),
            (Join-Path ([Environment]::GetFolderPath("CommonDesktopDirectory")) "Nanobot.lnk"),
            (Join-Path ([Environment]::GetFolderPath("Desktop")) "Conversar com Nanobot.lnk"),
            (Join-Path ([Environment]::GetFolderPath("CommonDesktopDirectory")) "Conversar com Nanobot.lnk"),
            (Join-Path ([Environment]::GetFolderPath("Desktop")) "Reconfigurar Nanobot.lnk")
        ) | ForEach-Object {
            if (Test-Path $_) { Remove-Item $_ -Force -EA SilentlyContinue }
        }
    } catch {}

    # Cria UM unico atalho: "Conversar com Nanobot" -> aponta pro Conversar.bat
    # (que chama 'python -m nanobot agent -m "..."' direto, sem ponte custom)
    try {
        $desktop = [Environment]::GetFolderPath("Desktop")
        if ($desktop) {
            $ws = New-Object -ComObject WScript.Shell
            $shortcut = Join-Path $desktop "Conversar com Nanobot.lnk"
            $s = $ws.CreateShortcut($shortcut)
            $s.TargetPath = $convPath
            $s.WorkingDirectory = $env:USERPROFILE
            $s.Description = "Conversar com Nanobot - IA Pessoal"
            if ($icoPath -and (Test-Path $icoPath)) {
                $s.IconLocation = $icoPath
            } else {
                $s.IconLocation = "$env:SystemRoot\System32\shell32.dll,13"
            }
            $s.Save()
            Log "  Atalho criado: Conversar com Nanobot (Area de Trabalho)"
        }
    } catch {
        Log "  Aviso ao criar atalho: $($_.Exception.Message)"
    }

    return $true
}

# ==================================================================
# FLUXO PRINCIPAL DE INSTALACAO
# ==================================================================
function Run-Installation {
    $btnInstall.Enabled = $false
    $btnClose.Enabled   = $false
    $script:allOK       = $true

    Log-Blank
    Log "Iniciando instalacao dos requisitos do Nanobot..."
    Log "========================================"
    Log-Blank
    SetProgress 5

    # -- Python --
    SetProgress 10
    $pyVer = Check-Python
    if ($pyVer) {
        Log "Python ja instalado: $pyVer"
        SetStatus $pyRow $pyVer $C_TEAL
    } else {
        SetStatus $pyRow "Instalando..." $C_CYAN
        $result = Install-PythonNow
        if ($result) {
            Log "Python instalado com sucesso: $result"
            SetStatus $pyRow $result $C_TEAL
        } else {
            Log "FALHA ao instalar Python!"
            Log "  Instale manualmente: https://python.org/downloads/"
            SetStatus $pyRow "FALHA" $C_RED
            $script:allOK = $false
        }
    }
    SetProgress 35

    # -- ffmpeg --
    $ffVer = Check-FFmpeg
    if ($ffVer) {
        Log "ffmpeg ja instalado."
        SetStatus $ffRow "Instalado" $C_TEAL
    } else {
        SetStatus $ffRow "Instalando..." $C_CYAN
        $result = Install-FFmpegNow
        if ($result) {
            Log "ffmpeg instalado com sucesso."
            SetStatus $ffRow "Instalado" $C_TEAL
        } else {
            Log "FALHA ao instalar ffmpeg!"
            Log "  Instale manualmente: https://ffmpeg.org/download.html"
            SetStatus $ffRow "FALHA" $C_RED
            $script:allOK = $false
        }
    }
    SetProgress 60

    # -- Bibliotecas Python --
    if ($script:allOK) {
        SetStatus $depRow "Instalando..." $C_CYAN
        $result = Install-NanobotDeps
        if ($result) {
            SetStatus $depRow "OK" $C_TEAL
        } else {
            Log "AVISO: algumas libs falharam (veja log acima)"
            SetStatus $depRow "PARCIAL" $C_RED
        }
    } else {
        SetStatus $depRow "Aguardando Python" $C_DIM
    }
    SetProgress 90

    # -- Configuracao do Nanobot --
    Setup-NanobotConfig

    # -- Verificacao final --
    Log-Blank
    Refresh-EnvPath
    Log "Verificacao final..."

    try { $pyOK = Check-Python } catch { $pyOK = $null }
    try { $ffOK = Check-FFmpeg } catch { $ffOK = $null }

    try {
        $pipOK = Get-CmdOutput "pip" "--version"
        if ($pipOK) { Log "pip: $pipOK" } else { Log "pip: nao encontrado" }
    } catch { Log "pip: nao disponivel" }

    SetProgress 100
    Log-Blank

    if ($pyOK -and $ffOK) {
        Log "========================================"
        Log "TUDO PRONTO!"
        Log "========================================"
        Log-Blank
        Log "Atalho 'Nanobot' foi criado na Area de Trabalho."
        Log "Iniciando o Nanobot em 3 segundos..."
        Log-Blank

        $btnInstall.Text      = "ABRINDO NANOBOT..."
        $btnInstall.BackColor = [System.Drawing.Color]::FromArgb(0, 60, 45)
        $btnInstall.FlatAppearance.BorderColor = $C_TEAL
        $pBarFill.BackColor = $C_TEAL

        Start-Sleep -Seconds 3

        # Executa o Nanobot.bat (que usa python -m nanobot, sempre funciona)
        $nanobotBat = "C:\Nanobot\Nanobot.bat"
        if (Test-Path $nanobotBat) {
            try {
                # Abre em PowerShell novo (nao-admin, com PATH limpo)
                Start-Process -FilePath "cmd.exe" -ArgumentList @("/c", "`"$nanobotBat`"")
                Log "Nanobot aberto! Siga as instrucoes na nova janela."
            } catch {
                Log "Nao foi possivel abrir automaticamente."
                Log "Clique duplo no atalho 'Nanobot' na Area de Trabalho."
            }
        } else {
            Log "Clique duplo no atalho 'Nanobot' na Area de Trabalho."
        }

        $btnInstall.Text = "FECHAR"
        $btnInstall.Enabled = $true
        # Marca estado como concluido — o Add_Click unico (ver EVENTOS)
        # vai apenas fechar a janela sem reexecutar a instalacao.
        $script:installState = "done"
    } else {
        Log "========================================"
        Log "ALGUNS REQUISITOS FALHARAM"
        Log "Verifique os erros acima e tente novamente."
        Log "========================================"
        $btnInstall.Text    = "TENTAR NOVAMENTE"
        $btnInstall.Enabled = $true
        $pBarFill.BackColor = $C_RED
    }

    $btnClose.Enabled = $true
}

# ==================================================================
# EVENTOS
# ==================================================================
# Controle de estado unico — evita que o botao reexecute Run-Installation
# depois que instalacao ja terminou (bug que abria o notepad 2x)
$script:installState = "ready"  # ready | running | done

$btnInstall.Add_Click({
    if ($script:installState -eq "done") {
        $form.Close()
        return
    }
    if ($script:installState -eq "running") {
        return
    }
    $script:installState = "running"
    Run-Installation
    # Run-Installation ajusta $script:installState = "done" ao terminar
})

$btnClose.Add_Click({ $form.Close() })

# ==================================================================
# AO ABRIR - verifica estado atual
# ==================================================================
$form.Add_Shown({
    Log "Nanobot - Instalador de Requisitos v1.0"
    Log "Verificando estado atual do sistema..."
    Log-Blank

    Refresh-EnvPath

    $py = Check-Python
    $ff = Check-FFmpeg

    if ($py) { SetStatus $pyRow $py $C_TEAL; Log "Python:  $py" }
    else     { SetStatus $pyRow "NAO INSTALADO" $C_RED; Log "Python:  nao encontrado" }

    if ($ff) { SetStatus $ffRow "Instalado" $C_TEAL; Log "ffmpeg:  ok" }
    else     { SetStatus $ffRow "NAO INSTALADO" $C_RED; Log "ffmpeg:  nao encontrado" }

    SetStatus $depRow "Pendente" $C_DIM

    Log-Blank
    Log "Clique em INSTALAR REQUISITOS para comecar."
})

[void]$form.ShowDialog()
