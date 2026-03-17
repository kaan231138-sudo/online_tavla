# ============================================================================
# AGENT 5 - RESEARCHER_QA - OTOMASYON SCRİPTİ
# Proje: Online Tavla (3D)
# ============================================================================

$projeKlasor = "online_tavla"
$agentNo = 5
$promptDosya = "prompts/agent5_prompts.txt"
$sinyalKlasor = "sinyaller"

$tumFazlar = @("A5-1","A5-2","A5-3","A5-4","A5-5","A5-6","A5-7","A5-8","A5-9","A5-10","A5-11","A5-12","A5-13","A5-14","A5-15","A5-16","A5-17","A5-18")

$dalgaAdimFaz = @{
    1  = @{ adim=1; fazlar=@("A5-1");  bekle=@() }
    2  = @{ adim=1; fazlar=@("A5-2");  bekle=@() }
    3  = @{ adim=1; fazlar=@("A5-3");  bekle=@() }
    4  = @{ adim=1; fazlar=@("A5-4");  bekle=@() }
    5  = @{ adim=1; fazlar=@("A5-5");  bekle=@() }
    6  = @{ adim=1; fazlar=@("A5-6");  bekle=@() }
    7  = @{ adim=1; fazlar=@("A5-7");  bekle=@() }
    8  = @{ adim=1; fazlar=@("A5-8");  bekle=@() }
    9  = @{ adim=1; fazlar=@("A5-9");  bekle=@() }
    10 = @{ adim=1; fazlar=@("A5-10"); bekle=@() }
    11 = @{ adim=1; fazlar=@("A5-11"); bekle=@() }
    12 = @{ adim=1; fazlar=@("A5-12"); bekle=@() }
    13 = @{ adim=1; fazlar=@("A5-13"); bekle=@() }
    14 = @{ adim=1; fazlar=@("A5-14"); bekle=@() }
    15 = @{ adim=1; fazlar=@("A5-15"); bekle=@() }
    16 = @{ adim=1; fazlar=@("A5-16"); bekle=@() }
    17 = @{ adim=1; fazlar=@("A5-17"); bekle=@() }
    18 = @{ adim=1; fazlar=@("A5-18"); bekle=@() }
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