# ============================================================================
# AGENT 6 - ORCHESTRATOR - OTOMASYON SCRİPTİ (FARKLI YAPI!)
# Proje: Online Tavla (3D)
# ============================================================================

$projeKlasor = "online_tavla"
$agentNo = 6
$promptDosya = "prompts/agent6_prompts.txt"
$sinyalKlasor = "sinyaller"

$tumFazlar = @("A6-1","A6-2","A6-3","A6-4","A6-5","A6-6","A6-7","A6-8","A6-9","A6-10","A6-11","A6-12","A6-13","A6-14","A6-15","A6-16","A6-17","A6-18")

# Her dalga için adım-agent haritası (diğer agent'ların yapısını yansıtır)
$dalgaAdimHaritasi = @{
    1  = @{ 1=@(1,2,3,5); 2=@(4) }
    2  = @{ 1=@(2,5); 2=@(1,3); 3=@(4) }
    3  = @{ 1=@(2,5); 2=@(1,3); 3=@(4) }
    4  = @{ 1=@(2,3,5); 2=@(1); 3=@(4) }
    5  = @{ 1=@(2,3,5); 2=@(1); 3=@(4) }
    6  = @{ 1=@(1,2,3,4,5) }
    7  = @{ 1=@(2,5); 2=@(1,3); 3=@(4) }
    8  = @{ 1=@(2,5); 2=@(1,3); 3=@(4) }
    9  = @{ 1=@(2,5); 2=@(1,3); 3=@(4) }
    10 = @{ 1=@(2,3,5); 2=@(1); 3=@(4) }
    11 = @{ 1=@(2,3,5); 2=@(1); 3=@(4) }
    12 = @{ 1=@(1,2,3,4,5) }
    13 = @{ 1=@(2,5); 2=@(1,3); 3=@(4) }
    14 = @{ 1=@(2,5); 2=@(1,3); 3=@(4) }
    15 = @{ 1=@(2,5); 2=@(1,3); 3=@(4) }
    16 = @{ 1=@(2,3,5); 2=@(1); 3=@(4) }
    17 = @{ 1=@(2,3,5); 2=@(1); 3=@(4) }
    18 = @{ 1=@(1,2,3,4,5) }
}

# Her dalga için Agent 6'nın fazları
$dalgaFazlari = @{
    1="A6-1"; 2="A6-2"; 3="A6-3"; 4="A6-4"; 5="A6-5"; 6="A6-6"
    7="A6-7"; 8="A6-8"; 9="A6-9"; 10="A6-10"; 11="A6-11"; 12="A6-12"
    13="A6-13"; 14="A6-14"; 15="A6-15"; 16="A6-16"; 17="A6-17"; 18="A6-18"
}

# Tüm adımların tamamlanmasını bekle
function Bekle-TumAdimlar {
    param([int]$dalga)
    $adimHaritasi = $dalgaAdimHaritasi[$dalga]
    foreach ($adim in ($adimHaritasi.Keys | Sort-Object)) {
        $agentler = $adimHaritasi[$adim]
        foreach ($a in $agentler) {
            $sinyalDosya = "$sinyalKlasor/dalga_${dalga}_adim_${adim}_agent_${a}_tamam.txt"
            while (-not (Test-Path $sinyalDosya)) {
                Write-Host "Agent 6: Dalga $dalga Adim $adim - Agent $a bekleniyor..."
                Start-Sleep -Seconds 5
            }
            Write-Host "Agent 6: Agent $a Adim $adim TAMAM."
        }
    }
    Write-Host "Agent 6: Dalga $dalga TUM ADIMLAR TAMAMLANDI."
}

# Geçiş raporu yaz
function Yaz-GecisRaporu {
    param([int]$dalga, [string]$durum)
    $raporKlasor = "agent6_orchestrator"
    if (-not (Test-Path $raporKlasor)) { New-Item -ItemType Directory -Path $raporKlasor -Force }
    $raporDosya = "$raporKlasor/dalga_gecis_raporu_${dalga}.txt"
    $icerik = @"
DALGA $dalga GECIS RAPORU
Tarih: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Durum: $durum
Agent 6 Faz: $($dalgaFazlari[$dalga])
---
Tum agent'lar gorevlerini tamamladi.
Dalga $dalga $durum.
"@
    $icerik | Out-File $raporDosya -Encoding UTF8
    Write-Host "Agent 6: Dalga $dalga gecis raporu yazildi: $durum"
}

function Gonder-FazSinyal {
    param([string]$faz)
    if (-not (Test-Path $sinyalKlasor)) { New-Item -ItemType Directory -Path $sinyalKlasor -Force }
    "TAMAM" | Out-File "$sinyalKlasor/faz_${faz}_tamam.txt" -Encoding UTF8
}

# ANA DÖNGÜ
foreach ($dalga in 1..18) {
    Write-Host "`n========== AGENT 6 ORCHESTRATOR - DALGA $dalga =========="

    # Tüm agent'ların tüm adımlarını bekle
    Bekle-TumAdimlar -dalga $dalga

    # Denetim fazını çalıştır
    $faz = $dalgaFazlari[$dalga]
    Write-Host "Agent 6: Faz $faz - Denetim basliyor..."
    # BURAYA AI DENETIM PROMPT'U GELECEK
    Write-Host "Agent 6: Faz $faz - Denetim TAMAMLANDI."
    Gonder-FazSinyal -faz $faz

    # Geçiş raporu yaz
    Yaz-GecisRaporu -dalga $dalga -durum "GECILEBILIR"
}

Write-Host "`nAgent 6: TUM DALGALAR DENETLENDI VE TAMAMLANDI!"