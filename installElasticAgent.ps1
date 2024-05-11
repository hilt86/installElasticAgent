$AgentURL = 'https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.12.2-windows-x86_64.zip'
# Fill these in before running
$enrollmentToken = ''
$fleetUrl = ''
$elasticRunning = Get-Service | where {($_.Name -like "Elastic*") -and ($_.Status -eq "Running")}
If ($elasticRunning -eq $null)
{
    write-host 'Installing Elastic Agent'
    $randomString = -join ((65..90) + (97..122) | Get-Random -Count 15 | % {[char]$_})
    $tempDir = $env:TEMP + "\" + $randomString
    mkdir $tempDir
    $zipFile = $tempDir + "\" + "elastic-agent.zip"
    write-host $zipFile
    Start-BitsTransfer -Source $AgentURL -Destination $zipFile
    Expand-Archive -LiteralPath $zipFile -DestinationPath $tempDir
    $exeFile = $tempDir + "\" + "elastic-agent-8.12.2-windows-x86_64" + "\" + "elastic-agent.exe"
    Start-Process -FilePath $exeFile -ArgumentList "install","-f","--url=$fleetUrl","--enrollment-token=$enrollmentToken"
}
else
{
    write-host 'Elastic agent is already running, skipping'
}
