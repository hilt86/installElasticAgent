$ServiceName = 'Elastic Endpoint'
$AgentURL = 'https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.13.4-windows-x86_64.zip'
$enrollmentToken = 'blah'
$fleetUrl = 'https://something.elastic-cloud.com:443'
$arrService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
$deploymentVersion = Get-ItemProperty 'HKLM:\Software\ElasticVersion'-ErrorAction SilentlyContinue |  Select-Object -ExpandProperty version -ErrorAction SilentlyContinue

If (-not $deploymentVersion -eq 2) 
{
write-host 'Installing Elastic Agent'
$randomString = -join ((65..90) + (97..122) | Get-Random -Count 15 | % {[char]$_})
$tempDir = $env:TEMP + "\" + $randomString 
mkdir $tempDir
$zipFile = $tempDir + "\" + "elastic-agent.zip"
write-host $zipFile
Start-BitsTransfer -Source "https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.13.4-windows-x86_64.zip" -Destination $zipFile
Expand-Archive -LiteralPath $zipFile -DestinationPath $tempDir
$exeFile = $tempDir + "\" + "elastic-agent-7.13.4-windows-x86_64" + "\" + "elastic-agent.exe"
Start-Process -FilePath $exeFile -ArgumentList "install","-f","--url=$fleetUrl","--enrollment-token=$enrollmentToken"
New-Item -Path 'HKLM:\Software\ElasticVersion' -ErrorAction SilentlyContinue
New-ItemProperty -Path 'HKLM:\Software\ElasticVersion' -Name "version" -Value 2 -Force -ErrorAction SilentlyContinue
}
elseif ($deploymentVersion -eq 2)
{
write-host 'deployment is current, skipping'
}
else
{
write-host 'deployment is unknown, skipping'
}

