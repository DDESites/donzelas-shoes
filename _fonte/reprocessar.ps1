# Redimensiona as fotos publicadas a partir dos originais em _fonte/fotos
# Correcao: usar 1.0 (double) em Min, senao o PowerShell converte para int
# e a escala vira 1 (fica na resolucao original).
$raiz  = "C:\Users\Bruno\Desktop\donzelas-shoes"
$fotos = Join-Path $raiz "_fonte\fotos"
$site  = Join-Path $raiz "assets\img\produtos"

Add-Type -AssemblyName System.Drawing

$tamanhoMax = 1100   # maior lado da imagem publicada
$qualidade  = 82

$alvos = Get-ChildItem $site -Filter *.jpg | Sort-Object Name
Write-Output ("Fotos a reprocessar: {0}" -f $alvos.Count)

$total = 0; $erros = 0
foreach ($f in $alvos) {
  $orig = Join-Path $fotos $f.Name
  if (-not (Test-Path $orig)) { Write-Output ("  sem original: {0}" -f $f.Name); $erros++; continue }
  try {
    $img = [System.Drawing.Image]::FromFile($orig)
    $lado = [Math]::Max($img.Width, $img.Height)
    $escala = [Math]::Min(1.0, [double]$tamanhoMax / [double]$lado)
    $w = [int]($img.Width * $escala); $h = [int]($img.Height * $escala)
    if ($w -lt 1) { $w = 1 }; if ($h -lt 1) { $h = 1 }
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($img, 0, 0, $w, $h)
    $g.Dispose()
    $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
    $params = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$qualidade)
    $bmp.Save($f.FullName, $codec, $params)
    $img.Dispose(); $bmp.Dispose()
    $total += (Get-Item $f.FullName).Length
  } catch {
    Write-Output ("  erro {0}: {1}" -f $f.Name, $_.Exception.Message); $erros++
  }
}
Write-Output ("Reprocessadas: {0} | erros: {1}" -f ($alvos.Count - $erros), $erros)
Write-Output ("Total: {0} MB" -f [math]::Round($total/1MB, 1))

# conferencia de dimensoes
Add-Type -AssemblyName System.Drawing
$amostra = Get-ChildItem $site -Filter *.jpg | Select-Object -First 5
foreach ($f in $amostra) {
  $i = [System.Drawing.Image]::FromFile($f.FullName)
  Write-Output ("  {0}  {1}x{2}  {3} KB" -f $f.Name, $i.Width, $i.Height, [math]::Round($f.Length/1KB))
  $i.Dispose()
}
