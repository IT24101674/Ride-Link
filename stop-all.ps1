<#
.SYNOPSIS
    Stops all 4 RideLink microservices (ports 8081-8084).
#>

Write-Host "Stopping all RideLink microservices (ports 8081-8084)..." -ForegroundColor Yellow

8081..8084 | ForEach-Object {
    $port = $_
    $conns = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($conns) {
        $pids = $conns | Select-Object -ExpandProperty OwningProcess -Unique
        foreach ($pidToKill in $pids) {
            Stop-Process -Id $pidToKill -Force -ErrorAction SilentlyContinue
            Write-Host "Stopped process $pidToKill listening on port $port" -ForegroundColor Green
        }
    } else {
        Write-Host "Port $port is already free." -ForegroundColor DarkGray
    }
}

Write-Host "All RideLink services have been stopped." -ForegroundColor Cyan
