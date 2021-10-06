param (
  $SrvFile
)

$inFile = Resolve-Path $SrvFile

$xml = [xml](Get-Content $inFile)

$lines = $xml.transcript.text | ForEach-Object {
  if ($_.'#text') {
    $_.'#text'.Replace("&#39;", "'")
  }
}

$SrvFileName = Split-Path $SrvFile -Leaf

$isAMatch = $SrvFileName -imatch '^(\d{6}|[0-9a-zA-Z]{8})\s+(.*)\s_\s_\s.*\s_\s_\s.*$'
if (-not $isAMatch) {
  Write-Host -ForegroundColor Yellow "...$($SrvFileName) does not match expected format"
  return
}

$audioInfo = @{
  dateId = $Matches[1].Trim()
  title = $Matches[2].Trim()
  youTubeId = $SrvFileName.Substring($SrvFileName.Length - 18, 11)
  author = 'Ṭhānissaro Bhikkhu'
  channel = 'Dhamma Talks'
  contents = ($lines -join ' ')
}
$json = ConvertTo-Json $audioInfo

$outFile = [IO.Path]::ChangeExtension($inFile, ".json")
[IO.File]::WriteAllText($outFile, $json)
