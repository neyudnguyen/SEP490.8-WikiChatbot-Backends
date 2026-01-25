# Script ch?y WikiChatbot Backend
# Tác gi?: GitHub Copilot
# Ngày: 2024

Write-Host "=================================" -ForegroundColor Cyan
Write-Host "  WikiChatbot Backend Launcher  " -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Ki?m tra .NET SDK
Write-Host "?? Ki?m tra .NET SDK..." -ForegroundColor Yellow
$dotnetVersion = dotnet --version
if ($LASTEXITCODE -eq 0) {
    Write-Host "? .NET SDK: $dotnetVersion" -ForegroundColor Green
} else {
    Write-Host "? .NET SDK ch?a ???c cài ??t!" -ForegroundColor Red
    Write-Host "   Download t?i: https://dotnet.microsoft.com/download" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Ki?m tra PostgreSQL
Write-Host "?? Ki?m tra PostgreSQL..." -ForegroundColor Yellow
$pgTest = Test-NetConnection -ComputerName localhost -Port 5432 -InformationLevel Quiet -WarningAction SilentlyContinue

if ($pgTest) {
    Write-Host "? PostgreSQL ?ang ch?y trên port 5432" -ForegroundColor Green
} else {
    Write-Host "??  PostgreSQL ch?a ch?y!" -ForegroundColor Red
    Write-Host ""
    Write-Host "B?n có mu?n:" -ForegroundColor Yellow
    Write-Host "1. Ti?p t?c ch?y (n?u b?n ?ã cài PostgreSQL nh?ng dùng port khác)" -ForegroundColor White
    Write-Host "2. H??ng d?n cài ??t PostgreSQL" -ForegroundColor White
    Write-Host "3. Thoát" -ForegroundColor White
    Write-Host ""
    
    $choice = Read-Host "Nh?p l?a ch?n (1/2/3)"
    
    switch ($choice) {
        "1" {
            Write-Host "??  Ti?p t?c..." -ForegroundColor Yellow
        }
        "2" {
            Write-Host ""
            Write-Host "?? H??NG D?N CÀI ??T POSTGRESQL" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Cách 1: Dùng Docker (Khuy?n ngh?)" -ForegroundColor Green
            Write-Host "----------------------------------------"
            Write-Host "docker pull postgres:latest" -ForegroundColor White
            Write-Host "docker run --name wikichatbot-postgres -e POSTGRES_PASSWORD=123123 -p 5432:5432 -d postgres" -ForegroundColor White
            Write-Host "docker exec -it wikichatbot-postgres createdb -U postgres WikiChatbotDb_Dev" -ForegroundColor White
            Write-Host ""
            Write-Host "Cách 2: Cài ??t PostgreSQL" -ForegroundColor Green
            Write-Host "----------------------------------------"
            Write-Host "Download: https://www.postgresql.org/download/windows/" -ForegroundColor White
            Write-Host "Username: postgres, Password: 123123, Port: 5432" -ForegroundColor White
            Write-Host ""
            Write-Host "Sau khi cài xong, ch?y l?i script này!" -ForegroundColor Yellow
            exit 0
        }
        "3" {
            Write-Host "?? T?m bi?t!" -ForegroundColor Yellow
            exit 0
        }
        default {
            Write-Host "? L?a ch?n không h?p l?!" -ForegroundColor Red
            exit 1
        }
    }
}

Write-Host ""

# Thay ??i th? m?c
$projectPath = "E:\Project\WikiChatbot_Frontend\SEP490.8-WikiChatbot-Backends\src\WikiChatbotBackends.API"
Write-Host "?? Di chuy?n ??n th? m?c d? án..." -ForegroundColor Yellow
Set-Location $projectPath

if (-not (Test-Path "WikiChatbotBackends.API.csproj")) {
    Write-Host "? Không tìm th?y project file!" -ForegroundColor Red
    exit 1
}

Write-Host "? ?ã vào th? m?c: $projectPath" -ForegroundColor Green
Write-Host ""

# Restore packages
Write-Host "?? Restore NuGet packages..." -ForegroundColor Yellow
dotnet restore
if ($LASTEXITCODE -ne 0) {
    Write-Host "? Restore th?t b?i!" -ForegroundColor Red
    exit 1
}
Write-Host "? Restore thành công!" -ForegroundColor Green
Write-Host ""

# Build project
Write-Host "?? Build d? án..." -ForegroundColor Yellow
dotnet build --no-restore
if ($LASTEXITCODE -ne 0) {
    Write-Host "? Build th?t b?i!" -ForegroundColor Red
    exit 1
}
Write-Host "? Build thành công!" -ForegroundColor Green
Write-Host ""

# H?i ch? ?? ch?y
Write-Host "?? Ch?n ch? ?? ch?y:" -ForegroundColor Cyan
Write-Host "1. Run (dotnet run) - Ch?y thông th??ng" -ForegroundColor White
Write-Host "2. Watch (dotnet watch run) - T? ??ng reload khi có thay ??i" -ForegroundColor White
Write-Host ""

$runMode = Read-Host "Nh?p l?a ch?n (1/2) [m?c ??nh: 1]"
if ([string]::IsNullOrWhiteSpace($runMode)) {
    $runMode = "1"
}

Write-Host ""
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "  ?? ?ANG KH?I ??NG API..." -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "?? Swagger UI s? có t?i:" -ForegroundColor Yellow
Write-Host "   https://localhost:7001/swagger" -ForegroundColor White
Write-Host "   http://localhost:5001/swagger" -ForegroundColor White
Write-Host ""
Write-Host "??  Nh?n Ctrl+C ?? d?ng server" -ForegroundColor Yellow
Write-Host ""
Start-Sleep -Seconds 2

# Ch?y d? án
if ($runMode -eq "2") {
    Write-Host "?? Ch?y v?i Watch mode..." -ForegroundColor Cyan
    dotnet watch run
} else {
    Write-Host "??  Ch?y d? án..." -ForegroundColor Cyan
    dotnet run
}
