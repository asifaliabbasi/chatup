# Java JDK Installation and JAVA_HOME Setup Script
# Run this script as Administrator after installing Java JDK

Write-Host "Setting up JAVA_HOME for Flutter Android development..." -ForegroundColor Green

# Common Java installation paths
$possiblePaths = @(
    "C:\Program Files\Java\jdk-21",
    "C:\Program Files\Java\jdk-21.0.1",
    "C:\Program Files\Java\jdk-21.0.2",
    "C:\Program Files\Java\jdk-17",
    "C:\Program Files\Java\jdk-17.0.1",
    "C:\Program Files\Java\jdk-17.0.2",
    "C:\Program Files\Eclipse Adoptium\jdk-21",
    "C:\Program Files\Eclipse Adoptium\jdk-17"
)

$javaHome = $null

# Find Java installation
foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $javaHome = $path
        Write-Host "Found Java installation at: $javaHome" -ForegroundColor Yellow
        break
    }
}

if ($javaHome -eq $null) {
    Write-Host "Java JDK not found in common locations. Please install Java JDK first." -ForegroundColor Red
    Write-Host "Download from: https://www.oracle.com/java/technologies/downloads/" -ForegroundColor Cyan
    exit 1
}

# Set JAVA_HOME environment variable
try {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, "Machine")
    Write-Host "JAVA_HOME set to: $javaHome" -ForegroundColor Green
    
    # Add Java to PATH
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    $javaBinPath = "$javaHome\bin"
    
    if ($currentPath -notlike "*$javaBinPath*") {
        $newPath = $currentPath + ";" + $javaBinPath
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
        Write-Host "Added Java to PATH: $javaBinPath" -ForegroundColor Green
    }
    
    Write-Host "`nJava setup completed successfully!" -ForegroundColor Green
    Write-Host "Please restart your terminal/PowerShell for changes to take effect." -ForegroundColor Yellow
    
} catch {
    Write-Host "Error setting environment variables: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please run this script as Administrator" -ForegroundColor Yellow
}

# Test Java installation
Write-Host "`nTesting Java installation..." -ForegroundColor Cyan
try {
    $env:JAVA_HOME = $javaHome
    $env:PATH = "$javaHome\bin;" + $env:PATH
    
    $javaVersion = & "$javaHome\bin\java.exe" -version 2>&1
    Write-Host "Java version:" -ForegroundColor Green
    Write-Host $javaVersion -ForegroundColor White
    
    Write-Host "`nJAVA_HOME verification:" -ForegroundColor Green
    Write-Host "JAVA_HOME = $env:JAVA_HOME" -ForegroundColor White
    
} catch {
    Write-Host "Error testing Java: $($_.Exception.Message)" -ForegroundColor Red
}
