param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$Path
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Path)) {
  [System.Windows.Forms.MessageBox]::Show("File not found:`n$Path", 'Markdown Viewer') | Out-Null
  exit 1
}

$resolved = (Resolve-Path -LiteralPath $Path).Path
$bytes = [System.IO.File]::ReadAllBytes($resolved)

# 1.5 MB cap — beyond that, base64 in a URL hash gets unreliable in some browsers.
if ($bytes.Length -gt 1572864) {
  Add-Type -AssemblyName System.Windows.Forms
  [System.Windows.Forms.MessageBox]::Show(
    "File is larger than 1.5 MB. Open it manually with the viewer's Open… button.",
    'Markdown Viewer') | Out-Null
  exit 1
}

# URL-safe base64 (no padding, +/ swapped for -_)
$b64 = [Convert]::ToBase64String($bytes).Replace('+','-').Replace('/','_').TrimEnd('=')
$name = [Uri]::EscapeDataString([System.IO.Path]::GetFileName($resolved))

$viewer = (Join-Path $PSScriptRoot 'index.html').Replace('\','/')
$url = "file:///$viewer#md=$b64&name=$name"

# Prefer Chrome → Edge → default browser. Use --app=URL when available so the viewer
# opens in a clean app window instead of a regular tab.
$chrome = @(
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

$edge = @(
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($chrome) {
  Start-Process -FilePath $chrome -ArgumentList "--app=$url"
} elseif ($edge) {
  Start-Process -FilePath $edge -ArgumentList "--app=$url"
} else {
  Start-Process $url
}
