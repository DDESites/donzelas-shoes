# Redimensiona fotos para o site e gera folhas de contato (contact sheets)
$raiz    = "C:\Users\Bruno\Desktop\donzelas-shoes"
$fotos   = Join-Path $raiz "_fonte\fotos"
$site    = Join-Path $raiz "assets\img\produtos"
$folhas  = Join-Path $raiz "_fonte\folhas"
New-Item -ItemType Directory -Force -Path $site, $folhas | Out-Null

Add-Type -AssemblyName System.Drawing

# ---------- manifesto (ordem da caminhada) ----------
$data = Get-Content (Join-Path $raiz "_fonte\produtos-assinados.json") -Raw | ConvertFrom-Json
$manifesto = @()
$ordem = 0
foreach ($p in $data) {
  if (-not $p.fbid) { continue }
  $ordem++
  $segs = @()
  if ($p.cap) { $segs = ($p.cap -split '\s\|\s') | Where-Object { $_ -and $_ -notmatch '^\d{1,2} de \w+ de \d{4}$' -and $_ -notmatch 'ver post' -and $_.Length -gt 5 } }
  $manifesto += [pscustomobject]@{
    ordem = $ordem; fbid = $p.fbid; data = $p.date; legenda = ($segs -join ' ')
    arquivo = "$($p.fbid).jpg"
  }
}
$manifesto | Export-Csv (Join-Path $raiz "_fonte\manifesto.csv") -NoTypeInformation -Encoding UTF8
Write-Output "Manifesto: $($manifesto.Count) fotos"

# ---------- versao para o site (max 1000px, q82) ----------
$tamanhoSite = 1000
$nSite = 0
foreach ($m in $manifesto) {
  $orig = Join-Path $fotos $m.arquivo
  $dest = Join-Path $site $m.arquivo
  if (-not (Test-Path $orig)) { continue }
  try {
    $img = [System.Drawing.Image]::FromFile($orig)
    # 1.0 (double), senao o PowerShell converte a escala para int e vira 1
    $escala = [Math]::Min(1.0, $tamanhoSite / [Math]::Max($img.Width, $img.Height))
    $w = [int]($img.Width * $escala); $h = [int]($img.Height * $escala)
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($img, 0, 0, $w, $h)
    $g.Dispose()
    $bmp.Save($dest, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $img.Dispose(); $bmp.Dispose()
    $nSite++
  } catch { Write-Output "  erro $($m.arquivo): $($_.Exception.Message)" }
}
Write-Output "Site: $nSite fotos em assets\img\produtos"

# ---------- folhas de contato ----------
$porFolha = 30; $cols = 6; $cel = 290; $rotulo = 26
$linhasFolha = [Math]::Ceiling($porFolha / $cols)
$folha = 0
for ($i = 0; $i -lt $manifesto.Count; $i += $porFolha) {
  $fatia = @($manifesto[$i..([Math]::Min($i + $porFolha - 1, $manifesto.Count - 1))])
  $w = $cols * $cel; $h = $linhasFolha * ($cel + $rotulo)
  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.Clear([System.Drawing.Color]::FromArgb(255, 245, 241, 234))
  $fonte = New-Object System.Drawing.Font("Consolas", 15, [System.Drawing.FontStyle]::Bold)
  $pincel = [System.Drawing.Brushes]::Black
  for ($j = 0; $j -lt $fatia.Count; $j++) {
    $m = $fatia[$j]
    $orig = Join-Path $fotos $m.arquivo
    if (-not (Test-Path $orig)) { continue }
    $col = $j % $cols; $lin = [Math]::Floor($j / $cols)
    $x = $col * $cel; $y = $lin * ($cel + $rotulo)
    try {
      $img = [System.Drawing.Image]::FromFile($orig)
      $s = [Math]::Min(($cel - 6) / $img.Width, ($cel - 6) / $img.Height)
      $iw = [int]($img.Width * $s); $ih = [int]($img.Height * $s)
      $g.DrawImage($img, $x + 3 + [int](($cel - 6 - $iw) / 2), $y + 3 + [int](($cel - 6 - $ih) / 2), $iw, $ih)
      $img.Dispose()
    } catch {}
    $g.DrawString("#$($m.ordem)", $fonte, $pincel, ($x + 6), ($y + $cel - 2))
  }
  $g.Dispose()
  $folha++
  $destino = Join-Path $folhas ("folha-{0:d2}.png" -f $folha)
  $bmp.Save($destino, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}
Write-Output "Folhas de contato: $folha em _fonte\folhas"

# ---------- resumo em disco ----------
$t = (Get-ChildItem $site -Filter *.jpg | Measure-Object -Property Length -Sum)
Write-Output "Site total: $([math]::Round($t.Sum/1MB,1)) MB"
