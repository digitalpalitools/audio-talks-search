param (
  $SrvFile
)

Write-Host -ForegroundColor Green "Converting $SrvFile"
$inFile = Resolve-Path $SrvFile

$xml = [xml](Get-Content $inFile)

$lines = $xml.transcript.text | ForEach-Object {
  if ($_.'#text') {
    $_.'#text'.Replace("&#39;", "'")
  }
}

$outFile = [IO.Path]::ChangeExtension($inFile, ".txt")
[IO.File]::WriteAllText($outFile, ($lines -join ' '))
Write-Host -ForegroundColor Green "... done!"
