# ============================================================================
# AGENT 2 - OBJECT_ENGINE - OTOMASYON SCRİPTİ
# Proje: Online Tavla (3D)
# ============================================================================

$projeKlasor = "online_tavla"
$agentNo = 2
$promptDosya = "prompts/agent2_prompts.txt"
$sinyalKlasor = "sinyaller"

$tumFazlar = @("A2-1","A2-2","A2-3","A2-4","A2-5","A2-6","A2-7","A2-8","A2-9","A2-10","A2-11","A2-12","A2-13","A2-14","A2-15","A2-16","A2-17","A2-18","A2-19","A2-20")

$dalgaAdimFaz = @{
    1  = @{ adim=1; fazlar=@("A2-1");       bekle=@() }
    2  = @{ adim=1; fazlar=@("A2-2","A2-3"); bekle=@() }
    3  = @{ adim=1; fazlar=@("A2-4");       bekle=@() }
    4  = @{ adim=1; fazlar=@("A2-5");       bekle=@() }
    5  = @{ adim=1; fazlar=@("A2-6");       bekle=@() }
    6  = @{ adim=1; fazlar=@("A2-7");       bekle=@() }
    7  = @{ adim=1; fazlar=@("A2-8");       bekle=@() }
    8  = @{ adim=1; fazlar=@("A2-9");       bekle=@() }
    9  = @{ adim=1; fazlar=@("A2-10");      bekle=@() }
    10 = @{ adim=1; fazlar=@("A2-11");      bekle=@() }
    11 = @{ adim=1; fazlar=@("A2-12");      bekle=@() }
    12 = @{ adim=1; fazlar=@("A2-13");      bekle=@() }
    13 = @{ adim=1; fazlar=@("A2-14");      bekle=@() }
    14 = @{ adim=1; fazlar=@("A2-15");      bekle=@() }
    15 = @{ adim=1; fazlar=@("A2-16");      bekle=@() }
    16 = @{ adim=1; fazlar=@("A2-17");      bekle=@() }
    17 = @{ adim=1; fazlar=@("A2-18");      bekle=@() }
    18 = @{ adim=1; fazlar=@("A2-19","A2-20"); bekle=@() }
}

# Sinyal bekleme fonksiyonu
function Bekle-Sinyal {
    param([int]$dalga, [int]$adim, [int[]]$agentler)
    foreach ($a in $agentler) {
        $sinyalDosya = "$sinyalKlasor/dalga_${dalga}_adim_${adim}_agent_${a}_tamam.txt"
        while (-not (Test-Path $sinyalDosya)) {
            Write-Host "Agent ${agentNo}: Dalga $dalga - Agent $a sinyali bekleniyor..."
            Start-Sleep -Seconds 5
        }
        Write-Host "Agent ${agentNo}: Agent $a sinyali alindi!"
    }
}

function Gonder-Sinyal {
    param([int]$dalga, [int]$adim)
    if (-not (Test-Path $sinyalKlasor)) { New-Item -ItemType Directory -Path $sinyalKlasor -Force }
    $sinyalDosya = "$sinyalKlasor/dalga_${dalga}_adim_${adim}_agent_${agentNo}_tamam.txt"
    "TAMAM" | Out-File $sinyalDosya -Encoding UTF8
    Write-Host "Agent ${agentNo}: Dalga $dalga Adim $adim sinyal gonderildi."
}

function Gonder-FazSinyal {
    param([string]$faz)
    if (-not (Test-Path $sinyalKlasor)) { New-Item -ItemType Directory -Path $sinyalKlasor -Force }
    $sinyalDosya = "$sinyalKlasor/faz_${faz}_tamam.txt"
    "TAMAM" | Out-File $sinyalDosya -Encoding UTF8
    Write-Host "Agent ${agentNo}: Faz $faz sinyal gonderildi."
}

function Bekle-DalgaGecis {
    param([int]$dalga)
    $raporDosya = "agent6_orchestrator/dalga_gecis_raporu_${dalga}.txt"
    while (-not (Test-Path $raporDosya)) {
        Write-Host "Agent ${agentNo}: Dalga $dalga gecis raporu bekleniyor..."
        Start-Sleep -Seconds 10
    }
    $icerik = Get-Content $raporDosya -Raw
    if ($icerik -match "GECILEBILIR") {
        Write-Host "Agent ${agentNo}: Dalga $dalga GECIS ONAYLANDI!"
    } else {
        Write-Host "Agent ${agentNo}: Dalga $dalga KOSULLU GECIS!"
    }
    return $true
}

# ANA DÖNGÜ
foreach ($dalga in 1..18) {
    Write-Host "`n========== AGENT $agentNo - DALGA $dalga BASLIYOR =========="
    $bilgi = $dalgaAdimFaz[$dalga]
    $adim = $bilgi.adim
    $fazlar = $bilgi.fazlar
    $bekle = $bilgi.bekle

    if ($bekle.Count -gt 0) {
        Bekle-Sinyal -dalga $dalga -adim ($adim - 1) -agentler $bekle
    }

    foreach ($faz in $fazlar) {
        Write-Host "Agent ${agentNo}: Faz $faz calistiriliyor..."
        Write-Host "Agent ${agentNo}: Faz $faz TAMAMLANDI."
        Gonder-FazSinyal -faz $faz
    }

    Gonder-Sinyal -dalga $dalga -adim $adim
    Bekle-DalgaGecis -dalga $dalga
}

Write-Host "`nAgent ${agentNo}: TUM DALGALAR TAMAMLANDI!"