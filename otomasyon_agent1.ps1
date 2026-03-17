# ============================================================================
# AGENT 1 - SCENE_MASTER - OTOMASYON SCRİPTİ
# Proje: Online Tavla (3D)
# ============================================================================

$projeKlasor = "online_tavla"
$agentNo = 1
$promptDosya = "prompts/agent1_prompts.txt"
$sinyalKlasor = "sinyaller"

# Tüm fazlar sırasıyla
$tumFazlar = @("A1-1","A1-2","A1-3","A1-4","A1-5","A1-6","A1-7","A1-8","A1-9","A1-10","A1-11","A1-12","A1-13","A1-14","A1-15","A1-16","A1-17","A1-18")

# Dalga-Adım-Faz haritası
$dalgaAdimFaz = @{
    1  = @{ adim=1; fazlar=@("A1-1");  bekle=@() }
    2  = @{ adim=2; fazlar=@("A1-2");  bekle=@(2,5) }
    3  = @{ adim=2; fazlar=@("A1-3");  bekle=@(2,5) }
    4  = @{ adim=2; fazlar=@("A1-4");  bekle=@(2,3,5) }
    5  = @{ adim=2; fazlar=@("A1-5");  bekle=@(2,3,5) }
    6  = @{ adim=1; fazlar=@("A1-6");  bekle=@() }
    7  = @{ adim=2; fazlar=@("A1-7");  bekle=@(2,5) }
    8  = @{ adim=2; fazlar=@("A1-8");  bekle=@(2,5) }
    9  = @{ adim=2; fazlar=@("A1-9");  bekle=@(2,5) }
    10 = @{ adim=2; fazlar=@("A1-10"); bekle=@(2,3,5) }
    11 = @{ adim=2; fazlar=@("A1-11"); bekle=@(2,3,5) }
    12 = @{ adim=1; fazlar=@("A1-12"); bekle=@() }
    13 = @{ adim=2; fazlar=@("A1-13"); bekle=@(2,5) }
    14 = @{ adim=2; fazlar=@("A1-14"); bekle=@(2,5) }
    15 = @{ adim=2; fazlar=@("A1-15"); bekle=@(2,5) }
    16 = @{ adim=2; fazlar=@("A1-16"); bekle=@(2,3,5) }
    17 = @{ adim=2; fazlar=@("A1-17"); bekle=@(2,3,5) }
    18 = @{ adim=1; fazlar=@("A1-18"); bekle=@() }
}

# Sinyal bekleme fonksiyonu
function Bekle-Sinyal {
    param([int]$dalga, [int]$adim, [int[]]$agentler)
    foreach ($a in $agentler) {
        $sinyalDosya = "$sinyalKlasor/dalga_${dalga}_adim_${adim}_agent_${a}_tamam.txt"
        while (-not (Test-Path $sinyalDosya)) {
            Write-Host "Agent $agentNo: Dalga $dalga - Agent $a sinyali bekleniyor..."
            Start-Sleep -Seconds 5
        }
        Write-Host "Agent $agentNo: Agent $a sinyali alindi!"
    }
}

# Sinyal gönderme fonksiyonu
function Gonder-Sinyal {
    param([int]$dalga, [int]$adim)
    if (-not (Test-Path $sinyalKlasor)) { New-Item -ItemType Directory -Path $sinyalKlasor -Force }
    $sinyalDosya = "$sinyalKlasor/dalga_${dalga}_adim_${adim}_agent_${agentNo}_tamam.txt"
    "TAMAM" | Out-File $sinyalDosya -Encoding UTF8
    Write-Host "Agent $agentNo: Dalga $dalga Adim $adim sinyal gonderildi."
}

# Faz sinyal gönderme
function Gonder-FazSinyal {
    param([string]$faz)
    if (-not (Test-Path $sinyalKlasor)) { New-Item -ItemType Directory -Path $sinyalKlasor -Force }
    $sinyalDosya = "$sinyalKlasor/faz_${faz}_tamam.txt"
    "TAMAM" | Out-File $sinyalDosya -Encoding UTF8
    Write-Host "Agent $agentNo: Faz $faz sinyal gonderildi."
}

# Dalga geçiş onayı bekleme
function Bekle-DalgaGecis {
    param([int]$dalga)
    $raporDosya = "agent6_orchestrator/dalga_gecis_raporu_${dalga}.txt"
    while (-not (Test-Path $raporDosya)) {
        Write-Host "Agent $agentNo: Dalga $dalga gecis raporu bekleniyor..."
        Start-Sleep -Seconds 10
    }
    $icerik = Get-Content $raporDosya -Raw
    if ($icerik -match "GECILEBILIR") {
        Write-Host "Agent $agentNo: Dalga $dalga GECIS ONAYLANDI!"
        return $true
    } else {
        Write-Host "Agent $agentNo: Dalga $dalga KOSULLU GECIS - kontrol gerekli!"
        return $true
    }
}

# ANA DÖNGÜ
foreach ($dalga in 1..18) {
    Write-Host "`n========== AGENT $agentNo - DALGA $dalga BASLIYOR =========="

    $bilgi = $dalgaAdimFaz[$dalga]
    $adim = $bilgi.adim
    $fazlar = $bilgi.fazlar
    $bekle = $bilgi.bekle

    # Önceki adım agent'larını bekle
    if ($bekle.Count -gt 0) {
        $oncekiAdim = $adim - 1
        Bekle-Sinyal -dalga $dalga -adim $oncekiAdim -agentler $bekle
    }

    # Fazları çalıştır
    foreach ($faz in $fazlar) {
        Write-Host "Agent $agentNo: Faz $faz calistiriliyor..."
        # BURAYA AI PROMPT CALISTIRMA KODU GELECEK
        # Prompt dosyasından ilgili fazı oku ve AI'ya gönder
        Write-Host "Agent $agentNo: Faz $faz TAMAMLANDI."
        Gonder-FazSinyal -faz $faz
    }

    # Adım sinyali gönder
    Gonder-Sinyal -dalga $dalga -adim $adim

    # Dalga geçiş onayı bekle
    Bekle-DalgaGecis -dalga $dalga
}

Write-Host "`nAgent $agentNo: TUM DALGALAR TAMAMLANDI!"