# ============================================================================
# AGENT 3 - UI_DESIGNER - OTOMASYON SCRİPTİ
# Proje: Online Tavla (3D)
# ============================================================================

$projeKlasor = "online_tavla"
$agentNo = 3
$promptDosya = "prompts/agent3_prompts.txt"
$sinyalKlasor = "sinyaller"

$tumFazlar = @("A3-1","A3-2","A3-3","A3-4","A3-5","A3-6","A3-7","A3-8","A3-9","A3-10","A3-11","A3-12","A3-13","A3-14","A3-15","A3-16","A3-17","A3-18")

$dalgaAdimFaz = @{
    1  = @{ adim=1; fazlar=@("A3-1");  bekle=@() }
    2  = @{ adim=2; fazlar=@("A3-2");  bekle=@(2,5) }
    3  = @{ adim=2; fazlar=@("A3-3");  bekle=@(2,5) }
    4  = @{ adim=1; fazlar=@("A3-4");  bekle=@() }
    5  = @{ adim=1; fazlar=@("A3-5");  bekle=@() }
    6  = @{ adim=1; fazlar=@("A3-6");  bekle=@() }
    7  = @{ adim=2; fazlar=@("A3-7");  bekle=@(2,5) }
    8  = @{ adim=2; fazlar=@("A3-8");  bekle=@(2,5) }
    9  = @{ adim=2; fazlar=@("A3-9");  bekle=@(2,5) }
    10 = @{ adim=1; fazlar=@("A3-10"); bekle=@() }
    11 = @{ adim=1; fazlar=@("A3-11"); bekle=@() }
    12 = @{ adim=1; fazlar=@("A3-12"); bekle=@() }
    13 = @{ adim=2; fazlar=@("A3-13"); bekle=@(2,5) }
    14 = @{ adim=2; fazlar=@("A3-14"); bekle=@(2,5) }
    15 = @{ adim=2; fazlar=@("A3-15"); bekle=@(2,5) }
    16 = @{ adim=1; fazlar=@("A3-16"); bekle=@() }
    17 = @{ adim=1; fazlar=@("A3-17"); bekle=@() }
    18 = @{ adim=1; fazlar=@("A3-18"); bekle=@() }
}

function Bekle-Sinyal {
    param([int]$dalga, [int]$adim, [int[]]$agentler)
    foreach ($a in $agentler) {
        $sinyalDosya = "$sinyalKlasor/dalga_${dalga}_adim_${adim}_agent_${a}_tamam.txt"
        while (-not (Test-Path $sinyalDosya)) {
            Write-Host "Agent ${agentNo}: Dalga $dalga - Agent $a sinyali bekleniyor..."
            Start-Sleep -Seconds 5
        }
    }
}

function Gonder-Sinyal {
    param([int]$dalga, [int]$adim)
    if (-not (Test-Path $sinyalKlasor)) { New-Item -ItemType Directory -Path $sinyalKlasor -Force }
    "TAMAM" | Out-File "$sinyalKlasor/dalga_${dalga}_adim_${adim}_agent_${agentNo}_tamam.txt" -Encoding UTF8
}

function Gonder-FazSinyal {
    param([string]$faz)
    if (-not (Test-Path $sinyalKlasor)) { New-Item -ItemType Directory -Path $sinyalKlasor -Force }
    "TAMAM" | Out-File "$sinyalKlasor/faz_${faz}_tamam.txt" -Encoding UTF8
}

function Bekle-DalgaGecis {
    param([int]$dalga)
    $raporDosya = "agent6_orchestrator/dalga_gecis_raporu_${dalga}.txt"
    while (-not (Test-Path $raporDosya)) {
        Start-Sleep -Seconds 10
    }
    return $true
}

foreach ($dalga in 1..18) {
    Write-Host "`n========== AGENT $agentNo - DALGA $dalga BASLIYOR =========="
    $bilgi = $dalgaAdimFaz[$dalga]

    if ($bilgi.bekle.Count -gt 0) {
        Bekle-Sinyal -dalga $dalga -adim ($bilgi.adim - 1) -agentler $bilgi.bekle
    }

    foreach ($faz in $bilgi.fazlar) {
        Write-Host "Agent ${agentNo}: Faz $faz calistiriliyor..."
        Write-Host "Agent ${agentNo}: Faz $faz TAMAMLANDI."
        Gonder-FazSinyal -faz $faz
    }

    Gonder-Sinyal -dalga $dalga -adim $bilgi.adim
    Bekle-DalgaGecis -dalga $dalga
}

Write-Host "`nAgent ${agentNo}: TUM DALGALAR TAMAMLANDI!"