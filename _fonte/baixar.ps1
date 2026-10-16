# Baixa as fotos do album do Facebook com URL assinada (paralelo)
$dir  = "C:\Users\Bruno\Desktop\donzelas-shoes\_fonte"
$fotos = Join-Path $dir "fotos"
New-Item -ItemType Directory -Force -Path $fotos | Out-Null

$data = Get-Content (Join-Path $dir "produtos-assinados.json") -Raw | ConvertFrom-Json
$pend = @($data | Where-Object { $_.img -and $_.fbid } |
          Where-Object { -not (Test-Path (Join-Path $fotos "$($_.fbid).jpg")) })
Write-Output "Para baixar: $($pend.Count) de $($data.Count)"

$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
$pool = [runspacefactory]::CreateRunspacePool(1, 10)
$pool.Open()

$jobs = foreach ($p in $pend) {
  $ps = [powershell]::Create().AddScript({
    param($url, $out, $uagent)
    try {
      $wc = New-Object System.Net.WebClient
      $wc.Headers.Add("User-Agent", $uagent)
      $wc.Headers.Add("Referer", "https://www.facebook.com/")
      $b = $wc.DownloadData($url)
      if ($b.Length -gt 3000) { [System.IO.File]::WriteAllBytes($out, $b); "OK" } else { "PEQUENO" }
    } catch { "ERRO: $($_.Exception.Message)" }
  }).AddArgument($p.img).AddArgument((Join-Path $fotos "$($p.fbid).jpg")).AddArgument($ua)
  $ps.RunspacePool = $pool
  [pscustomobject]@{ Pipe = $ps; Handle = $ps.BeginInvoke(); Fbid = $p.fbid }
}

$ok = 0; $erro = 0
foreach ($j in $jobs) {
  $res = $j.Pipe.EndInvoke($j.Handle)
  if ("$res" -eq "OK") { $ok++ } else { $erro++; if ($erro -le 5) { Write-Output "  falha $($j.Fbid): $res" } }
  $j.Pipe.Dispose()
}
$pool.Close()
Write-Output "Baixadas: $ok | Falhas: $erro"
$tot = (Get-ChildItem $fotos -Filter *.jpg | Measure-Object -Property Length -Sum)
Write-Output "Total em disco: $([math]::Round($tot.Sum/1MB,1)) MB em $($tot.Count) arquivos"
