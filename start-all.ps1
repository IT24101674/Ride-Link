<#
.SYNOPSIS
    Starts all 4 RideLink microservices in the background.
#>

$root = $PSScriptRoot

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Starting RideLink Microservices Platform              " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# 1. Account Service (8081)
$accountDir = Join-Path $root "account-service\account-service\account-service"
$accountJar = Join-Path $accountDir "target\account-service-0.0.1-SNAPSHOT.jar"
Write-Host "Starting [1/4] Account Service (Port 8081)..." -ForegroundColor Yellow
Start-Process -FilePath "java" -ArgumentList "-jar", "`"$accountJar`"" -WorkingDirectory $accountDir -WindowStyle Minimized

# 2. Driver & Vehicle Service (8082)
$driverDir = Join-Path $root "driver-vehicle-service\driver-vehicle-service\driver-vehicle-service"
$driverJar = Join-Path $driverDir "target\driver-vehicle-service-0.0.1-SNAPSHOT.jar"
Write-Host "Starting [2/4] Driver & Vehicle Service (Port 8082)..." -ForegroundColor Yellow
Start-Process -FilePath "java" -ArgumentList "-jar", "`"$driverJar`"" -WorkingDirectory $driverDir -WindowStyle Minimized

# 3. Ride Service (8083)
$rideDir = Join-Path $root "ride-service\ride-service\ride-service"
$rideJar = Join-Path $rideDir "target\ride-service-0.0.1-SNAPSHOT.jar"
Write-Host "Starting [3/4] Ride Management Service (Port 8083)..." -ForegroundColor Yellow
Start-Process -FilePath "java" -ArgumentList "-jar", "`"$rideJar`"" -WorkingDirectory $rideDir -WindowStyle Minimized

# 4. Fare & Payment Service (8084)
$fareDir = Join-Path $root "fare-payment-service\fare-payment-service"
$fareJar = Join-Path $fareDir "target\fare-payment-service-0.0.1-SNAPSHOT.jar"
Write-Host "Starting [4/4] Fare & Payment Service (Port 8084)..." -ForegroundColor Yellow
Start-Process -FilePath "java" -ArgumentList "-jar", "`"$fareJar`"" -WorkingDirectory $fareDir -WindowStyle Minimized

Write-Host "`nAll 4 microservices launched in the background!" -ForegroundColor Green
Write-Host "Waiting a few seconds for services to initialize..." -ForegroundColor DarkGray
Start-Sleep -Seconds 12

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "  Swagger UI Endpoints:                                 " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Account Service:        http://localhost:8081/swagger-ui/index.html" -ForegroundColor White
Write-Host "Driver & Vehicle:       http://localhost:8082/swagger-ui/index.html" -ForegroundColor White
Write-Host "Ride Management:        http://localhost:8083/swagger-ui/index.html" -ForegroundColor White
Write-Host "Fare & Payment:         http://localhost:8084/swagger-ui/index.html" -ForegroundColor White
Write-Host "========================================================" -ForegroundColor Cyan
