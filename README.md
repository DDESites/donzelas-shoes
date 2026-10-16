# Donzelas Shoes — site institucional + catálogo (atendimento via WhatsApp)

Site estático da **Donzelas Shoes** (Águas Lindas de Goiás), revendedora autorizada e
exclusiva de **Arezzo, Anacapri, Brizza e Santa Lolla**. Sem build: abra `index.html`
ou sirva a pasta com qualquer servidor estático.

## Modelo de venda

**Catálogo + WhatsApp** (escolhido para o lançamento): o site mostra os produtos e
encaminha o pedido para o atendimento pelo WhatsApp — sem checkout online.
A estrutura comporta e-commerce no futuro, se a loja decidir.

## Dados da marca usados no site

Coletados do Instagram oficial [@donzelas.shoes](https://www.instagram.com/donzelas.shoes/),
do [Linktree](https://linktr.ee/donzelasshoes) e do **convite oficial do 4º aniversário** (set/2026):

- WhatsApp/vendas: **(61) 99125-1703** (`wa.me/61991251703`)
- Instagram: [@donzelas.shoes](https://www.instagram.com/donzelas.shoes/) · Facebook: [Donzelas Shoes](https://www.facebook.com/profile.php?id=100093458958698)
- Endereço: **Rua 10, Quadra A6, Lote 23 — Mansões Olinda, Águas Lindas de Goiás — GO, CEP 72910-000**
  (no Linktree aparece como "R. Dez, 201" — mesmo logradouro)
- Marcas: Arezzo, Anacapri, Brizza, Santa Lolla — "Revendedora autorizada e exclusiva"
- Envio para todo o Brasil · Retirada na loja
- Formas de pagamento citadas no material oficial: **Pix, cartão e dinheiro**
- Slogan do aniversário: "4 anos de sonhos, estilo e mulheres incríveis!"
- Loja completou **4 anos em setembro de 2026**

## Fotos

As imagens em `assets/img/instagram/` são **publicações oficiais da própria loja**
(comemoração de 4 anos, setembro/2026), baixadas do Instagram. Cada foto guarda o link
do post original no campo `post` em `assets/js/data.js`:

| Arquivo | Post original |
|---|---|
| aniv4-post1 (convite 4 anos) | instagram.com/p/DdfB6TeGtGB/ |
| aniv-post1 (logo na parede)  | instagram.com/p/Ddo8-Ujx7we/ |
| aniv4-post3 (balão "4")      | instagram.com/p/Ddhokk6Gkl_/ |
| aniv4-post4 (bolo rosa)      | instagram.com/p/DdfAbL5mtJT/ |
| aniv4-post2 (preto e branco) | instagram.com/p/Ddhr6K2n3yM/ |
| aniv-reel1 (convite no celular) | instagram.com/reel/DdpB1ePxluT/ |

`assets/img/marca/logo.jpg` é a foto do perfil oficial do Instagram (150 px — versão
provisória, substituir pela arte em alta).

**Marca:** a mulher de perfil com chapéu de aba larga do logotipo oficial foi
**recriada em SVG** (traço fino, fundo transparente) a partir dessa foto:
`LOGO_SVG` em `assets/js/app.js` (usada no cabeçalho, menu mobile e rodapé),
`assets/img/marca/favicon.svg` e `assets/img/marca/logo-donzelas.svg` (lockup
marca + lettering). É uma reprodução fiel em vetor, mas não substitui o arquivo
oficial — quando a loja enviar o vector/PNG em alta, basta trocar as três peças
(o texto "Donzelas Shoes" ao lado da marca continua em HTML, com fonte Parisienne).

## Catálogo publicado — 85 modelos reais

O catálogo deixou de ser um placeholder: são **85 modelos com fotos reais da loja**,
extraídas do **álbum "Fotos" (364 itens) da página oficial do Facebook**
(`facebook.com/profile.php?id=100093458958698`), que espelha os posts do Instagram —
o feed antigo do Instagram exige login, mas o álbum do Facebook abre sem sessão.
Foram baixadas **325 fotos** (dez/2022 a dez/2024), reorganizadas em `PRODUTOS` e
publicadas em `assets/img/produtos/` (1000 px, JPEG q82 — 233 arquivos, ~49 MB).

Como os dados foram tratados (critério de aceite: nada inventado):

- **Preços**: nenhuma publicação traz valor → `preco: null` em todos os itens, e o site
  mostra "Consulte no WhatsApp". **Nenhum preço foi inventado.**
- **Tamanhos**: não aparecem nas publicações → lista vazia (nada exibido).
- **Marca**: preenchida **só** quando a legenda da publicação nomeia a marca ou o logo
  aparece na foto (ex.: "Sandália Arezzo", tags ANACAPRI/SANTA LOLLA/BRIZZA no produto
  ou caixa). Nas demais, `marca: null` e o cartão não exibe marca — nunca se chutou.
- **Nome do produto**: descritivo, baseado na legenda oficial quando existe
  (ex.: "Chinelo Brizza Marrocos Slide", "Bolsa Shopping Grande Maxi Barbicacho")
  e, sem legenda, na descrição visual (ex.: "Sandália de salto bloco prata com tiras trançadas").
- **Origem**: cada produto guarda em `post` o link da foto de origem no Facebook
  (botão "Ver publicação original" na página do produto).
- 27 itens foram marcados `destaque: true` para a vitrine inicial; os cartões de tipo
  da home usam a primeira foto real daquele tipo.

Tipos novos em `TIPOS`: Tênis, Mocassims, Bolsas e mochilas, Cintos e acessórios
(o estoque real da loja inclui essas categorias).

### Reprodutir o catálogo

`_fonte/` guarda o material de origem e o pipeline (não é servido pelo site):

| Arquivo | O que é |
|---|---|
| `_fonte/produtos-assinados.json` | 325 registros coletados (fbid, data, legenda, URL assinada da foto) |
| `_fonte/manifesto.csv` | ordem da caminhada × fbid × data × legenda |
| `_fonte/fotos/` | originais em alta baixados do CDN (49 MB — pode apagar para economizar espaço; as URLs no JSON continuam válidas até 2027) |
| `_fonte/gerar-catalogo.ps1` | regenera o array `PRODUTOS` a partir do manifesto |
| `_fonte/baixar.ps1` / `processar.ps1` | baixa as fotos e gera as versões do site |

## Arquivos

- `index.html` — página inicial (banner, marcas, tipos com foto real, novidades, institucional, Instagram, confiança; JSON-LD da loja)
- `calcados.html` — catálogo com busca, filtros por marca e tipo, ordenação + estado vazio informativo
- `produto.html?id=<id>` — página de produto (galeria com todas as fotos do modelo, cor, CTA WhatsApp e link da publicação original)
- `sobre.html` — a história da loja e o passo a passo "Como comprar"
- `contato.html` — WhatsApp, Instagram, Facebook, endereço e mapa
- `politicas.html` — entrega, pagamento, trocas e privacidade (rascunho)
- `assets/css/style.css` — estilos (paleta grafite/creme/bege/rosa blush do PRD)
- `assets/js/data.js` — **configuração da loja + catálogo de 85 produtos** (arquivo a editar)
- `assets/js/app.js` — comportamento das páginas
- `assets/img/produtos/` — fotos dos produtos (1000 px)
- `_fonte/` — dados de origem e scripts do catálogo (não publicado no site)

## Antes de publicar (pendências)

1. **Aprovar o catálogo**: os 85 modelos vieram de publicações de 2022–2025. A loja deve
   confirmar quais ainda estão à venda (hoje o site publica todos, com aviso de que
   disponibilidade se confirma no WhatsApp).
2. **Preços e tamanhos reais** de cada modelo (hoje todos dizem "Consulte no WhatsApp").
   Com os valores em mãos, basta preencher `preco`/`tamanhos` em `assets/js/data.js`.
3. **Horário de funcionamento** da loja (`LOJA.horario` — hoje aparece "consulte pelo WhatsApp").
4. **Grafia oficial**: o perfil usa "Donzelas Shoes"; o letreiro pode parecer "Denzelas".
   Confirmar — a marca e o lettering do site são recriações em SVG (ver seção acima).
5. **Textos de políticas** em `politicas.html` — prazos de envio, trocas e devolução aprovados pela loja.
6. **Formas de pagamento**: confirmar se Pix, cartão e dinheiro valem para a operação diária
   (hoje vêm do convite oficial do aniversário).
7. **Foto do perfil em alta**: `assets/img/marca/logo.jpg` tem 150 px; pedir a arte original em PNG.
8. **Endereço**: confirmar se o número correto é "Rua 10, Quadra A6, Lote 23" ou "R. Dez, 201".

## Como rodar

Duplo clique em `index.html`, ou:

    npx serve donzelas-shoes
