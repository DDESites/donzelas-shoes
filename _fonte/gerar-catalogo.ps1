# Gera o array PRODUTOS do catalogo a partir da caminhada do Facebook
# Acentos via escapes \uXXXX (o PowerShell 5.1 le .ps1 sem BOM como ANSI)
$raiz = "C:\Users\Bruno\Desktop\donzelas-shoes"
$dataJs = Join-Path $raiz "assets\js\data.js"

function Dec([string]$s) {
  [regex]::Replace($s, '\\u([0-9a-fA-F]{4})', {
    param($mm) [char][Convert]::ToUInt16($mm.Groups[1].Value, 16)
  })
}

$m = Import-Csv (Join-Path $raiz "_fonte\manifesto.csv") -Encoding UTF8
$map = @{}
foreach ($l in $m) { $map[[int]$l.ordem] = $l.fbid }

function Post([int]$ord) {
  if (-not $map.ContainsKey($ord)) { return "null" }
  return '"https://www.facebook.com/photo/?fbid={0}&set=a.316825618109401"' -f $map[$ord]
}
function JsArr($v) {
  if (-not $v -or @($v).Count -eq 0) { return "[]" }
  return "[" + ((@($v) | ForEach-Object { '"{0}"' -f (Dec $_) }) -join ", ") + "]"
}
function JsFotos($ords) {
  $f = @($ords | Where-Object { $map.ContainsKey([int]$_) } | ForEach-Object { "assets/img/produtos/$($map[[int]$_]).jpg" })
  if ($f.Count -eq 0) { return "[]" }
  return "[" + (($f | ForEach-Object { '"{0}"' -f $_ }) -join ", ") + "]"
}

# id, nome, marca, tipo, cores, fotos(ordens), destaque, novidade
$P = @(
  @("rasteira-santa-lolla-tiras","Rasteira Santa Lolla de tiras finas","santalolla","rasteiras",@("Prata","Preto"),@(1,2),$true,$false),
  @("rasteira-arezzo-branca","Rasteira Arezzo branca com fivela dourada","arezzo","rasteiras",@("Branco"),@(3,4),$true,$false),
  @("rasteira-arezzo-marrom","Rasteira Arezzo marrom com fivela dourada","arezzo","rasteiras",@("Marrom"),@(5,6),$false,$false),
  @("mule-arezzo-prata","Mule Arezzo prata","arezzo","mules",@("Prata"),@(9,10,14),$true,$false),
  @("bolsa-santa-lolla-prata","Bolsa Santa Lolla prata com corrente","santalolla","bolsas",@("Prata"),@(11,13,73,74),$false,$false),
  @("sandalia-bloco-dourada","Sand\u00E1lia de salto bloco dourada",@(),"sandalias",@("Dourado"),@(7,8,17),$false,$false),
  @("sandalia-espadrela-dourada","Sand\u00E1lia espadrela dourada",@(),"sandalias",@("Dourado"),@(15,16),$false,$false),
  @("mocassim-santa-lolla-prata","Mocassim Santa Lolla prata","santalolla","mocassims",@("Prata"),@(40,41),$true,$false),
  @("slide-anacapri-dourado","Slide Anacapri dourado com cristais","anacapri","chinelos",@("Dourado"),@(42,43,44),$false,$false),
  @("sandalia-anacapri-dourada-laco","Sand\u00E1lia Anacapri dourada com la\u00E7o","anacapri","sandalias",@("Dourado"),@(45,46,47),$true,$false),
  @("mule-arezzo-preto-esferico","Mule Arezzo preto com salto esf\u00E9rico dourado","arezzo","mules",@("Preto"),@(48,49,50),$false,$false),
  @("sandalia-arezzo-preto-esferico","Sand\u00E1lia Arezzo preta com salto esf\u00E9rico dourado","arezzo","sandalias",@("Preto"),@(51,52,53,54),$true,$false),
  @("tenis-animal-print","T\u00EAnis branco com detalhe animal print",@(),"tenis",@("Branco","Preto","Estampado"),@(55,56,57,58,59),$false,$false),
  @("sandalia-santa-lolla-cristais","Sand\u00E1lia Santa Lolla com cristais e salto transparente","santalolla","sandalias",@("Prata"),@(66,67,68,69,70),$false,$false),
  @("sandalia-santa-lolla-prata-bloco","Sand\u00E1lia Santa Lolla prata de salto bloco","santalolla","sandalias",@("Prata"),@(61,63,64,65,71,72),$false,$false),
  @("sandalia-santa-lolla-dourada-bloco","Sand\u00E1lia Santa Lolla dourada de salto bloco","santalolla","sandalias",@("Dourado"),@(75,76,77),$true,$false),
  @("carteira-santa-lolla","Carteira Santa Lolla","santalolla","bolsas",@("Caramelo","Preto","Prata","Off-white"),@(78,79,80),$false,$false),
  @("bolsa-santa-lolla-mini","Bolsa Santa Lolla mini com al\u00E7a","santalolla","bolsas",@("Dourado","Preto","Off-white","Caramelo"),@(81,82,83,84),$false,$false),
  @("papete-cristais","Papete com faixa de cristais",@(),"chinelos",@("Dourado","Off-white"),@(85,86),$false,$false),
  @("chinelo-santa-lolla-logo","Chinelo Santa Lolla com logo","santalolla","chinelos",@("Marrom","Preto"),@(87,88),$false,$false),
  @("sandalia-arezzo-folhas","Sand\u00E1lia Arezzo de folhas douradas","arezzo","sandalias",@("Dourado","Nude"),@(89,90,91,93,205,208),$true,$false),
  @("sandalia-preto-corrente","Sand\u00E1lia preta com corrente dourada",@(),"sandalias",@("Preto"),@(94,95,96,97),$false,$false),
  @("sandalia-preto-bloco","Sand\u00E1lia preta de salto bloco",@(),"sandalias",@("Preto"),@(98,99,109,110),$false,$false),
  @("bolsa-shopper-preta","Bolsa shopper preta com porta-cart\u00F5es",@(),"bolsas",@("Preto"),@(100,101,102,103),$false,$false),
  @("bolsa-tote-grafite","Bolsa tote grafite",@(),"bolsas",@("Grafite"),@(104,105,106,107),$false,$false),
  @("papete-brizza-dourado","Papete Brizza com detalhe dourado","brizza","chinelos",@("Off-white"),@(111,112),$true,$false),
  @("tenis-arezzo-animal","T\u00EAnis Arezzo estampa animal","arezzo","tenis",@("Estampado","Branco"),@(113,114),$true,$false),
  @("tenis-santa-lolla","T\u00EAnis Santa Lolla","santalolla","tenis",@("Prata","Verde"),@(115,116),$false,$false),
  @("mochila-arezzo-nude","Mochila Arezzo nude","arezzo","bolsas",@("Nude"),@(117,118,119,120),$true,$false),
  @("mochila-arezzo-preta","Mochila Arezzo preta","arezzo","bolsas",@("Preto"),@(121),$false,$false),
  @("cinto-anacapri-redondo","Cinto Anacapri com passador redondo dourado","anacapri","acessorios",@("Off-white","Caramelo"),@(122,123,124),$false,$false),
  @("sandalia-bloco-prata-trancada","Sand\u00E1lia de salto bloco prata com tiras tran\u00E7adas",@(),"sandalias",@("Prata"),@(127,130,136,137),$false,$false),
  @("sandalia-bloco-animal-trancada","Sand\u00E1lia de salto bloco estampada com tiras tran\u00E7adas",@(),"sandalias",@("Estampado"),@(125,126),$false,$false),
  @("scarpin-dourado-trancado","Scarpin dourado com tiras tran\u00E7adas",@(),"scarpins",@("Dourado"),@(128,131),$false,$false),
  @("sandalia-plataforma-animal","Sand\u00E1lia plataforma palha estampada",@(),"sandalias",@("Estampado"),@(132,133,134),$false,$false),
  @("sandalia-plataforma-prata","Sand\u00E1lia plataforma prata de salto palha",@(),"sandalias",@("Prata"),@(139),$false,$false),
  @("tenis-offwhite-dourado","T\u00EAnis off-white com detalhe dourado",@(),"tenis",@("Off-white"),@(142,146),$false,$false),
  @("chinelo-flat-brizza","Chinelo flat Brizza Arezzo","brizza","chinelos",@("Rosa"),@(149,150,151,152),$true,$false),
  @("flatform-brizza","Flatform Brizza","brizza","chinelos",@("Rosa"),@(153),$false,$false),
  @("tenis-anacapri-rosa","T\u00EAnis Anacapri rosa","anacapri","tenis",@("Rosa","Azul"),@(154,155,158),$false,$false),
  @("papete-anacapri","Papete Anacapri","anacapri","chinelos",@("Caramelo"),@(156,157),$false,$false),
  @("cinto-arezzo-fivela-dourada","Cinto Arezzo com fivela dourada","arezzo","acessorios",@("Off-white","Caramelo","Mostarda","Preto","Vinho"),@(173,174,175,177,178,179),$false,$false),
  @("sandalia-arezzo-bloco-prata","Sand\u00E1lia Arezzo prata de salto bloco","arezzo","sandalias",@("Prata"),@(173,176),$false,$false),
  @("scarpin-arezzo-vinho","Scarpin Arezzo vinho de salto bloco","arezzo","scarpins",@("Vinho"),@(180),$true,$false),
  @("cinto-anacapri-quadrado","Cinto Anacapri com fivela quadrada","anacapri","acessorios",@("Preto","Branco","Caramelo"),@(181,182,183),$false,$false),
  @("mochila-brizza-preta","Mochila Brizza preta","brizza","bolsas",@("Preto"),@(188),$false,$false),
  @("mocassim-anacapri-bicolour","Mocassim Anacapri bicolour com slingback","anacapri","mocassims",@("Preto","Branco"),@(189,190,191,192),$true,$false),
  @("slide-anacapri-glitter","Slide Anacapri caramelo glitter","anacapri","chinelos",@("Caramelo"),@(193,194,195),$false,$false),
  @("slide-anacapri-turquesa","Slide Anacapri caramelo com rebites turquesa","anacapri","chinelos",@("Caramelo"),@(196,197,198,199),$false,$false),
  @("sandalia-bloco-caramelo","Sand\u00E1lia de salto bloco caramelo com cordas tran\u00E7adas",@(),"sandalias",@("Caramelo"),@(200,201,202,203,204),$false,$false),
  @("slide-arezzo-offwhite","Slide Arezzo off-white com rebites dourados","arezzo","chinelos",@("Off-white"),@(210),$false,$false),
  @("bolsa-tote-offwhite","Bolsa tote off-white",@(),"bolsas",@("Off-white"),@(211),$false,$false),
  @("sandalia-anacapri-offwhite-bloco","Sand\u00E1lia Anacapri off-white de salto bloco","anacapri","sandalias",@("Off-white"),@(212,213,214,215,216),$true,$false),
  @("brizza-marrocos-slide","Chinelo Brizza Marrocos Slide","brizza","chinelos",@("Off-white","Rosa","Preto"),@(217,218,219),$true,$false),
  @("brizza-marrocos-flat","Chinelo Brizza Marrocos Flat","brizza","chinelos",@("Off-white","Amarelo"),@(220,221,222),$false,$false),
  @("brizza-marrocos-mid","Chinelo Brizza Marrocos Mid","brizza","chinelos",@("F\u00FAcsia","Preto"),@(224,225),$false,$false),
  @("brizza-marrocos-dedo","Chinelo de dedo Brizza Marrocos","brizza","chinelos",@("Rosa","Preto"),@(223,241,242),$false,$false),
  @("bolsa-preta-rebites","Bolsa preta estruturada com rebites dourados",@(),"bolsas",@("Preto"),@(231,232,233,234,235,236),$false,$false),
  @("tamanco-anacapri","Tamanco Anacapri","anacapri","sandalias",@("Preto"),@(237),$false,$false),
  @("mule-anacapri-bloco","Mule Anacapri de saltinho bloco","anacapri","mules",@("Preto"),@(238),$false,$false),
  @("slide-brizza-marrocos-preto","Chinelo Brizza Marrocos preto e off-white","brizza","chinelos",@("Preto","Off-white"),@(239,240),$false,$false),
  @("sandalia-bloco-flores","Sand\u00E1lia de salto bloco com flores",@(),"sandalias",@("Prata"),@(243,244,245,246),$false,$false),
  @("scarpin-nude-laco","Scarpin nude com la\u00E7o frontal",@(),"scarpins",@("Nude"),@(251,252,253,254),$false,$false),
  @("sandalia-anacapri-flores","Sand\u00E1lia Anacapri branca com aplica\u00E7\u00E3o de flor","anacapri","sandalias",@("Branco"),@(255,256,257),$true,$false),
  @("sandalia-bloco-flor-espiral","Sand\u00E1lia de salto bloco off-white com flor em espiral",@(),"sandalias",@("Off-white"),@(258,259,260,261,262,263),$false,$false),
  @("bolsa-shopping-grande","Bolsa Shopping Grande Maxi Barbicacho",@(),"bolsas",@("Caramelo"),@(266,267,268,269),$false,$false),
  @("tenis-animal-print-laco","T\u00EAnis estampa animal print",@(),"tenis",@("Estampado"),@(265),$false,$false),
  @("sandalia-brizza-animal","Sand\u00E1lia Brizza estampa animal","brizza","sandalias",@("Estampado","Salm\u00E3o"),@(273),$false,$false),
  @("flatform-brizza-arezzo","Flatform Brizza Arezzo","brizza","chinelos",@("Branco","Preto"),@(274),$false,$false),
  @("bota-arezzo-bloco","Bota Arezzo de salto bloco","arezzo","botas",@("Preto","Caramelo"),@(275),$true,$false),
  @("bota-anacapri","Bota Anacapri","anacapri","botas",@("Caramelo"),@(276,281),$false,$false),
  @("bota-meia-arezzo","Bota cano meia Arezzo","arezzo","botas",@("Preto"),@(278),$false,$false),
  @("bolsa-arezzo-caramelo","Bolsa Arezzo caramelo","arezzo","bolsas",@("Caramelo"),@(279),$false,$false),
  @("coturno-anacapri","Coturno Anacapri","anacapri","botas",@("Preto"),@(283),$false,$false),
  @("bolsa-round-caramelo","Bolsa round caramelo",@(),"bolsas",@("Caramelo"),@(284,288),$false,$false),
  @("bota-cano-curto","Bota de cano curto com solado grosso",@(),"botas",@("Preto","Caramelo"),@(286,287,290),$false,$false),
  @("bota-chelsea","Bota chelsea com rebites prata",@(),"botas",@("Preto","Caramelo"),@(291,292,293,294),$false,$false),
  @("bota-cano-meia","Bota cano meia ajustada ao p\u00E9",@(),"botas",@("Preto"),@(298,299),$false,$false),
  @("sandalia-namorados","Sand\u00E1lia com cristais \u2014 cole\u00E7\u00E3o Dia dos Namorados",@(),"sandalias",@("Preto","Nude"),@(303,304),$false,$false),
  @("sandalia-arezzo-vermelha","Sand\u00E1lia Arezzo vermelha de salto bloco","arezzo","sandalias",@("Vermelho"),@(307,308),$true,$false),
  @("bota-caramelo-fivela","Bota caramelo de cano curto com fivela",@(),"botas",@("Caramelo"),@(309,310),$false,$false),
  @("tenis-anacapri-branco","T\u00EAnis Anacapri branco","anacapri","tenis",@("Branco"),@(313,314,316),$false,$false),
  @("mochila-preta-estruturada","Mochila preta estruturada",@(),"bolsas",@("Preto"),@(318),$false,$false),
  @("bolsa-crossbody-preta","Bolsa crossbody preta quilted",@(),"bolsas",@("Preto"),@(319),$true,$false),
  @("chinelo-rasteira-brizza","Chinelos estilo rasteira Brizza Arezzo","brizza","chinelos",@("Preto","Off-white","Verde-\u00E1gua","Rosa"),@(320,321),$false,$false)
)

$blocos = foreach ($p in $P) {
  $id=$p[0]; $nome=Dec $p[1]; $marca=$p[2]; $tipo=$p[3]; $cores=$p[4]; $fotos=@($p[5]); $destaque=[bool]$p[6]; $novidade=[bool]$p[7]
  $marcaJs = if ($marca) { '"{0}"' -f $marca } else { "null" }
  $postJs  = if ($fotos.Count) { Post ([int]$fotos[0]) } else { "null" }
  @"
    {
      id: "$id",
      nome: "$nome",
      marca: $marcaJs,
      tipo: "$tipo",
      preco: null,
      precoAntigo: null,
      tamanhos: [],
      cores: $(JsArr $cores),
      fotos: $(JsFotos $fotos),
      post: $postJs,
      destaque: $(if($destaque){"true"}else{"false"}),
      novidade: $(if($novidade){"true"}else{"false"})
    }
"@
}

$novo = "const PRODUTOS = [`n" + ($blocos -join ",`n") + "`n];"

$bytes = [System.IO.File]::ReadAllBytes($dataJs)
$temBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
$txt = [System.IO.File]::ReadAllText($dataJs)
$avaliador = [System.Text.RegularExpressions.MatchEvaluator]{ param($mm) $novo }
$txtNovo = [regex]::Replace($txt, "const PRODUTOS = \[\];", $avaliador)
if ($txtNovo -eq $txt) { Write-Output "ERRO: marcador PRODUTOS nao encontrado"; exit 1 }
$enc = New-Object System.Text.UTF8Encoding($temBom)
[System.IO.File]::WriteAllText($dataJs, $txtNovo, $enc)
$nFotos = @($P | ForEach-Object { $_[5] } | ForEach-Object { $_ } | Where-Object { $map.ContainsKey([int]$_) }).Count
Write-Output "PRODUTOS gravados: $($P.Count) | fotos referenciadas: $nFotos | BOM: $temBom"
