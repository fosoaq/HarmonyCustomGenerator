# Find MSBuild using vswhere
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (Test-Path $vswhere) {
    $vsPath = & $vswhere -latest -prerelease -products * -requires Microsoft.Component.MSBuild -property installationPath
    if ($vsPath) {
        $msbuild = Join-Path $vsPath "MSBuild\Current\Bin\MSBuild.exe"
    }
}

# Fallback to dotnet msbuild if vswhere not found
if (-not $msbuild -or -not (Test-Path $msbuild)) {
    Write-Host "Using dotnet msbuild..."
    $msbuild = "dotnet"
    $msbuildArgs = "msbuild"
} else {
    $msbuildArgs = ""
}

# Get project path relative to script location
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$project = Join-Path $scriptDir "CustomGenerator\CustomGenerator.csproj"

Write-Host "Building CustomGenerator..."
if ($msbuildArgs) {
    & $msbuild $msbuildArgs $project /p:Configuration=Release /v:minimal
} else {
    & $msbuild $project /p:Configuration=Release /v:minimal
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nBuild successful!" -ForegroundColor Green
    Write-Host "Output: CustomGenerator\bin\Release\CustomGenerator.dll"
} else {
    Write-Host "`nBuild failed!" -ForegroundColor Red
}
