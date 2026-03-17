# ============================================================================
# AGENT 4 - INTERACTION - OTOMASYON SCRİPTİ
# Proje: Online Tavla (3D)
# ============================================================================

$projeKlasor = "online_tavla"
$agentNo = 4
$promptDosya = "prompts/agent4_prompts.txt"
$sinyalKlasor = "sinyaller"

$tumFazlar = @("A4-1","A4-2","A4-3","A4-4","A4-5","A4-6","A4-7","A4-8","A4-9","A4-10","A4-11","A4-12","A4-13","A4-14","A4-15","A4-16","A4-17","A4-18")

$dalgaAdimFaz = @{
    1  = @{ adim=2; fazlar=@("A4-1");  bekle=@(1,2,3,5) }
    2  = @{ adim=3; fazlar=@("A4-2");  bekle=@(1,3) }
    3  = @{ adim=3; fazlar=@("A4-3");  bekle=@(1,3) }
    4  = @{ adim=3; fazlar=@("A4-4");  bekle=@(1) }
    5  = @{ adim=3; fazlar=@("A4-5");  bekle=@(1) }
    6  = @{ adim=1; fazlar=@("A4-6");  bekle=@() }
    7  = @{ adim=3; fazlar=@("A4-7");  bekle=@(1,3) }
    8  = @{ adim=3; fazlar=@("A4-8");  bekle=@(1,3) }
    9  = @{ adim=3; fazlar=@("A4-9");  bekle=@(1,3) }
    10 = @{ adim=3; fazlar=@("A4-10"); bekle=@(1) }
    11 = @{ adim=3; fazlar=@("A4-11"); bekle=@(1) }
    12 = @{ adim=1; fazlar=@("A4-12"); bekle=@() }
    13 = @{ adim=3; fazlar=@("A4-13"); bekle=@(1,3) }
    14 = @{ adim=3; fazlar=@("A4-14"); bekle=@(1,3) }
    15 = @{ adim=3; fazlar=@("A4-15"); bekle=@(1,3) }
    16 = @{ adim=3; fazlar=@("A4-16"); bekle=@(1) }
    17 = @{ adim=3; fazlar=@("A4-17"); bekle=@(1) }
    18 = @{ adim=1; fazlar=@("A4-18"); bekle=@() }
}

function Bekle-Sinyal {
    param([int]$dalga, [int]$adim, [int[]]$agentler)
    foreach ($a in $agentler) {
        $sinyalDosya = "$sinyalKlasor/dalga_${dalga}_adim_${adim}_agent_${a}_tamam.txt"
        while (-not (Test-Path $sinyalDosya)) {
            Write-Host "Agent $agentNo: Dalga $dalga - Agent $a sinyali bekleniyor..."
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
        Write-Host "Agent $agentNo: Faz $faz calistiriliyor..."
        Write-Host "Agent $agentNo: Faz $faz TAMAMLANDI."
        Gonder-FazSinyal -faz $faz
    }

    Gonder-Sinyal -dalga $dalga -adim $bilgi.adim
    Bekle-DalgaGecis -dalga $dalga
}

Write-Host "`nAgent $agentNo: TUM DALGALAR TAMAMLANDI!"