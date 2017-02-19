$ErrorActionPreference = 'Stop';
 
$packageName= 'sql-server-express-advance'
$url        = ''
$url64      = 'https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLEXPRADV_x64_ENU.exe'
$checksum   = '5207C66A4E68444F527A5D4CCAA33920'
$silentArgs = "/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /INSTANCEID=SQLEXPRESS /INSTANCENAME=SQLEXPRESS /UPDATEENABLED=FALSE /FEATURES=SQL,RS,Tools,FullText"
 
$tempDir = Join-Path (Get-Item $env:TEMP).FullName "$packageName"
if ($env:packageVersion -ne $null) {$tempDir = Join-Path $tempDir "$env:packageVersion"; }
 
if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }
$fileFullPath = "$tempDir\SQLEXPRADV_x64_ENU.exe"
 
Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $fileFullPath -Url $url -Url64bit $url64 -Checksum $checksum -ChecksumType 'sha1'
 
Write-Host "Extracting..."
$extractPath = "$tempDir\SQLEXPR"
Start-Process "$fileFullPath" "/Q /x:`"$extractPath`"" -Wait
 
Write-Host "Installing..."
$setupPath = "$extractPath\setup.exe"
Install-ChocolateyInstallPackage "$packageName" "EXE" "$silentArgs" "$setupPath" -validExitCodes @(0, 3010)
 
Write-Host "Removing extracted files..."
Remove-Item -Recurse "$extractPath"