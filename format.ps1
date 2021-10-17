param (
  [Parameter(Mandatory=$true)]$SrvFile
  , [ValidateSet("tsb", "ydb")] $Author
  , [ValidateSet("main", "dt", "sdt")] $Channel
)

$inFile = Resolve-Path $SrvFile

$xml = [xml](Get-Content $inFile)

$lines = $xml.transcript.text | ForEach-Object {
  if ($_.'#text') {
    $_.'#text'.Replace("&#39;", "'")
  }
}

$SrvFileName = Split-Path $SrvFile -Leaf

$audioInfo = @{
  title = $SrvFileName.Substring(0, $SrvFileName.Length - 20)
  youTubeId = $SrvFileName.Substring($SrvFileName.Length - 19, 11)
  author = $Author
  channel = $Channel
  subtitles = ($lines -join ' ')
}
$json = ConvertTo-Json $audioInfo

$outFile = [IO.Path]::ChangeExtension($inFile, ".json")
[IO.File]::WriteAllText($outFile, $json)
