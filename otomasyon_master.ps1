# ============================================================================
# MASTER OTOMASYON SCRİPTİ - TÜM AGENT'LARI BAŞLATIR
# Proje: Online Tavla (3D)
# ============================================================================

Write-Host "============================================"
Write-Host "  ONLINE TAVLA - MASTER OTOMASYON"
Write-Host "  6 Agent Paralel Baslatiliyor..."
Write-Host "============================================"

# Sinyal klasörünü temizle
$sinyalKlasor = "sinyaller"
if (Test-Path $sinyalKlasor) {
    Remove-Item -Recurse -Force $sinyalKlasor
}
New-Item -ItemType Directory -Path $sinyalKlasor -Force

# Agent 6 orchestrator klasörünü temizle
$orchKlasor = "agent6_orchestrator"
if (Test-Path $orchKlasor) {
    Remove-Item -Recurse -Force $orchKlasor
}
New-Item -ItemType Directory -Path $orchKlasor -Force

# Agent'ları paralel başlat
$jobs = @()

Write-Host "Agent 1 (SCENE_MASTER) baslatiliyor..."
$jobs += Start-Job -FilePath "otomasyon_agent1.ps1"

Write-Host "Agent 2 (OBJECT_ENGINE) baslatiliyor..."
$jobs += Start-Job -FilePath "otomasyon_agent2.ps1"

Write-Host "Agent 3 (UI_DESIGNER) baslatiliyor..."
$jobs += Start-Job -FilePath "otomasyon_agent3.ps1"

Write-Host "Agent 4 (INTERACTION) baslatiliyor..."
$jobs += Start-Job -FilePath "otomasyon_agent4.ps1"

Write-Host "Agent 5 (RESEARCHER_QA) baslatiliyor..."
$jobs += Start-Job -FilePath "otomasyon_agent5.ps1"

Write-Host "Agent 6 (ORCHESTRATOR) baslatiliyor..."
$jobs += Start-Job -FilePath "otomasyon_agent6.ps1"

Write-Host "`nTum agent'lar baslatildi. Bekleniyor..."

# Tüm job'ların bitmesini bekle
$jobs | Wait-Job

# Sonuçları göster
foreach ($job in $jobs) {
    Write-Host "`n--- Job $($job.Id) Sonucu ---"
    Receive-Job -Job $job
}

# Temizlik
$jobs | Remove-Job

Write-Host "`n============================================"
Write-Host "  ONLINE TAVLA - TUM ISLEMLER TAMAMLANDI!"
Write-Host "============================================"