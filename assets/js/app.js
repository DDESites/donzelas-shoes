/* ============================================================
   Donzelas Shoes — comportamento das páginas
   ============================================================ */

/* ---------- utilitários ---------- */
const $  = (sel, ctx = document) => ctx.querySelector(sel);
const $$ = (sel, ctx = document) => [...ctx.querySelectorAll(sel)];

const brl = v =>
  v == null ? "" : v.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });

function waLink(msg) {
  const base = `https://wa.me/${LOJA.whatsapp}?text=`;
  return base + encodeURIComponent(msg || "Olá! Vim pelo site da Donzelas Shoes. 🙂");
}

const PAGINA_ATUAL = document.body.dataset.page || "";

/* ---------- ícones ---------- */
const ICONS = {
  menu:  '<line x1="4" y1="7" x2="20" y2="7"/><line x1="4" y1="12" x2="20" y2="12"/><line x1="4" y1="17" x2="20" y2="17"/>',
  close: '<line x1="6" y1="6" x2="18" y2="18"/><line x1="18" y1="6" x2="6" y2="18"/>',
  search:'<circle cx="11" cy="11" r="7"/><line x1="16.5" y1="16.5" x2="21" y2="21"/>',
  bag:   '<path d="M5.6 8h12.8l1 12.5H4.6z"/><path d="M9 8V6.6a3 3 0 0 1 6 0V8"/>',
  arrow: '<line x1="4" y1="12" x2="19" y2="12"/><polyline points="13 6 19 12 13 18"/>',
  chat:  '<path d="M21 11.5a8.5 8.5 0 0 1-12.7 7.4L3.5 20.5l1.7-4.7A8.5 8.5 0 1 1 21 11.5z"/>',
  ig:    '<rect x="3.5" y="3.5" width="17" height="17" rx="4.5"/><circle cx="12" cy="12" r="3.8"/><circle cx="17.1" cy="6.9" r=".9" fill="currentColor" stroke="none"/>',
  fb:    '<path d="M14.5 8.5H17V5h-2.5A3.5 3.5 0 0 0 11 8.5V11H9v3.5h2V21h3.5v-6.5H17L17.5 11H14.5V9a.5.5 0 0 1 .5-.5z"/>',
  pin:   '<path d="M12 21s6.5-5.6 6.5-10.4A6.5 6.5 0 0 0 5.5 10.6C5.5 15.4 12 21 12 21z"/><circle cx="12" cy="10.4" r="2.4"/>',
  clock: '<circle cx="12" cy="12" r="8.5"/><polyline points="12 7 12 12 15.5 14"/>',
  truck: '<path d="M2.5 6.5h11v10h-11z"/><path d="M13.5 10h4l3 3v3.5h-7z"/><circle cx="7" cy="18.6" r="1.7"/><circle cx="17" cy="18.6" r="1.7"/>',
  card:  '<rect x="2.5" y="5.5" width="19" height="13" rx="1.5"/><line x1="2.5" y1="10" x2="21.5" y2="10"/>',
  swap:  '<path d="M4 8.5h13M13.5 5 17 8.5 13.5 12"/><path d="M20 15.5H7M10.5 12 7 15.5 10.5 19"/>',
  shoe:  '<path d="M3.5 16.5v-6h3l2.2 2.2h4.6c2.6 0 4.4 1.2 6.2 2.6 1 .8 1 2.2 1 3.2h-17z"/><path d="M6.5 10.5V7.8h2.6"/>',
  zoom:  '<circle cx="11" cy="11" r="7"/><line x1="16.5" y1="16.5" x2="21" y2="21"/><line x1="8.5" y1="11" x2="13.5" y1="11"/><line x1="11" y1="8.5" x2="11" y2="13.5"/>',
  mail:  '<rect x="2.5" y="5" width="19" height="14" rx="1.5"/><polyline points="3.8 6.5 12 13 20.2 6.5"/>'
};
const ic = n => `<svg class="ic" viewBox="0 0 24 24" aria-hidden="true" focusable="false">${ICONS[n]}</svg>`;

/* Marca da Donzelas: mulher de perfil (voltada para a esquerda) com chapéu de aba
   larga em laço oval inclinado, copa pousada na cabeça, cabelo preso com cacho e
   ombros — em traço fino, fiel ao logotipo oficial da loja */
const LOGO_SVG = `
<svg viewBox="0 0 176 178" aria-hidden="true" focusable="false" fill="none"
     stroke="currentColor" stroke-width="3.4" stroke-linecap="round" stroke-linejoin="round">
  <path d="M64.75 138.3A90 66 30 1 1 107.4 148.7"/>
  <path d="M58 60C53 40 70 30 86 32C101 34 109 50 108 68"/>
  <path d="M58 60C52 70 48 82 49 93C45.5 99 43 106 49 108C52.5 110 52 113 49 115C52.5 120 59 124 66 124C74 124 83 120 90 114C100 108 108.5 96 109 82C110 66 103 53 90 48C80 43 65 48 58 60"/>
  <path d="M58 60C69 68 78 82 81.5 96C83 105 87 110 90 114"/>
  <path d="M57 75C59 72.5 62 72.5 64.5 74"/>
  <path d="M59 81C61.5 78 66 79 68 83C65 85 61.5 84 59 81"/>
  <path d="M94 76C103 75 107 85 100 90C97 93 92 89 96 85"/>
  <path d="M66 124C67 130 67 134 65 138C58 144 44 149 29 152"/>
  <path d="M90 114C95 124 98 132 100 141C110 152 123 163 135 174"/>
</svg>`;

const NAV = [
  { id: "inicio",    href: "index.html",     label: "Início" },
  { id: "calcados",  href: "calcados.html",  label: "Calçados" },
  { id: "novidades", href: "calcados.html?ord=novidades", label: "Novidades" },
  { id: "ofertas",   href: "calcados.html?ord=ofertas",   label: "Ofertas" },
  { id: "sobre",     href: "sobre.html",     label: "Sobre a loja" },
  { id: "contato",   href: "contato.html",   label: "Contato" }
];

/* ---------- estrutura comum ---------- */
function montarShell() {
  const topbar = $("#topbar");
  if (topbar) {
    topbar.innerHTML = `
      <div class="container">
        <span>${LOJA.envio}</span><span class="sep">/</span>
        <a href="${waLink()}" target="_blank" rel="noopener">Atendimento pelo WhatsApp ${LOJA.whatsappExibicao}</a>
        <span class="sep">/</span>
        <a href="politicas.html#trocas">Trocas e retirada na loja</a>
      </div>`;
  }

  const header = $("#site-header");
  if (header) {
    header.innerHTML = `
      <div class="container header-inner">
        <button class="icon-btn menu-toggle" aria-expanded="false" aria-controls="menu-mobile" aria-label="Abrir menu">${ic("menu")}</button>
        <a class="logo" href="index.html" aria-label="${LOJA.nome} — página inicial">
          ${LOGO_SVG}
          <span class="logo-text"><span class="logo-script">Donzelas</span><span class="logo-sub">Shoes</span></span>
        </a>
        <nav class="nav" aria-label="Navegação principal"><ul>
          ${NAV.map(n => `<li><a href="${n.href}"${n.id === PAGINA_ATUAL ? ' aria-current="page"' : ""}>${n.label}</a></li>`).join("")}
        </ul></nav>
        <div class="header-actions">
          <button class="icon-btn" data-abrir-busca aria-label="Buscar produtos">${ic("search")}</button>
          <a class="icon-btn" href="${waLink("Olá! Queria atendimento no catálogo do site 🙂")}" target="_blank" rel="noopener" aria-label="Falar no WhatsApp">${ic("chat")}</a>
        </div>
      </div>`;
  }

  const menu = $("#menu-mobile");
  if (menu) {
    menu.innerHTML = `
      <div class="mm-top">
        <a class="logo" href="index.html">
          ${LOGO_SVG}
          <span class="logo-text"><span class="logo-script">Donzelas</span><span class="logo-sub">Shoes</span></span>
        </a>
        <button class="icon-btn" data-fechar-menu aria-label="Fechar menu">${ic("close")}</button>
      </div>
      <nav aria-label="Menu"><ul class="mm-list">
        ${NAV.map(n => `<li><a href="${n.href}">${n.label}</a></li>`).join("")}
        <li><a href="politicas.html">Entrega e trocas</a></li>
      </ul></nav>
      <div class="mm-extra">
        <a href="${waLink()}" target="_blank" rel="noopener">Falar no WhatsApp ${LOJA.whatsappExibicao}</a>
        <a href="${LOJA.instagram}" target="_blank" rel="noopener">Instagram ${LOJA.instagramHandle}</a>
      </div>`;
  }

  const busca = $("#busca-overlay");
  if (busca) {
    busca.innerHTML = `
      <div class="search-box" role="dialog" aria-modal="true" aria-label="Buscar no catálogo">
        <form id="form-busca">
          <input type="search" id="input-busca" placeholder="Buscar scarpin, sandália, marca…" autocomplete="off">
        </form>
        <div class="search-sug">
          ${["Scarpins","Sandálias","Mules","Botas","Rasteiras","Arezzo","Anacapri","Brizza","Santa Lolla"]
            .map(s => `<button type="button" data-termo="${s}">${s}</button>`).join("")}
        </div>
      </div>`;
  }

  const footer = $("#site-footer");
  if (footer) {
    footer.innerHTML = `
      <div class="container">
        <div class="footer-grid">
          <div class="footer-brand">
            <span class="logo" style="margin:0 0 .4rem">${LOGO_SVG}</span>
            <span class="logo-text"><span class="logo-script">Donzelas</span><span class="logo-sub">Shoes</span></span>
            <p>${LOJA.descricao}</p>
          </div>
          <div>
            <h3>Navegue</h3>
            <ul>
              ${NAV.map(n => `<li><a href="${n.href}">${n.label}</a></li>`).join("")}
              <li><a href="politicas.html">Entrega e trocas</a></li>
            </ul>
          </div>
          <div>
            <h3>Atendimento</h3>
            <ul>
              <li><a href="${waLink()}" target="_blank" rel="noopener">WhatsApp ${LOJA.whatsappExibicao}</a></li>
              <li><a href="${LOJA.instagram}" target="_blank" rel="noopener">Instagram ${LOJA.instagramHandle}</a></li>
              <li><a href="${LOJA.facebook}" target="_blank" rel="noopener">Facebook</a></li>
              <li>${LOJA.endereco} — ${LOJA.enderecoComplemento}</li>
            </ul>
          </div>
        </div>
        <div class="footer-bottom">
          <span>© <span data-ano></span> ${LOJA.nome}. Revendedora autorizada Arezzo, Anacapri, Brizza e Santa Lolla.</span>
          <span>Preços, tamanhos e condições: confirme pelo WhatsApp.</span>
        </div>
      </div>`;
  }

  const ano = $("[data-ano]");
  if (ano) ano.textContent = new Date().getFullYear();

  const wa = $("#wa-float");
  if (wa) {
    wa.href = waLink();
    wa.setAttribute("aria-label", "Falar com a loja no WhatsApp");
  }
}

/* ---------- comportamento do shell ---------- */
function ligarShell() {
  const btnMenu = $(".menu-toggle");
  const menu = $("#menu-mobile");
  if (btnMenu && menu) {
    btnMenu.addEventListener("click", () => {
      menu.hidden = false;
      btnMenu.setAttribute("aria-expanded", "true");
      document.body.style.overflow = "hidden";
      $("[data-fechar-menu]", menu)?.focus();
    });
    menu.addEventListener("click", e => {
      if (e.target.closest("[data-fechar-menu]") || e.target.closest("a")) {
        menu.hidden = true;
        btnMenu.setAttribute("aria-expanded", "false");
        document.body.style.overflow = "";
      }
    });
  }

  const overlay = $("#busca-overlay");
  if (overlay) {
    const abrir = () => { overlay.hidden = false; $("#input-busca")?.focus(); };
    const fechar = () => { overlay.hidden = true; };
    $$("[data-abrir-busca]").forEach(b => b.addEventListener("click", abrir));
    overlay.addEventListener("click", e => { if (e.target === overlay) fechar(); });
    document.addEventListener("keydown", e => { if (e.key === "Escape" && !overlay.hidden) fechar(); });

    overlay.addEventListener("submit", e => {
      e.preventDefault();
      const termo = $("#input-busca").value.trim();
      location.href = "calcados.html" + (termo ? `?q=${encodeURIComponent(termo)}` : "");
    });
    overlay.addEventListener("click", e => {
      const t = e.target.closest("[data-termo]");
      if (t) location.href = `calcados.html?q=${encodeURIComponent(t.dataset.termo)}`;
    });
  }
}

/* ---------- cartões ---------- */
function cardProduto(p) {
  const marca = LOJA.marcas.find(m => m.id === p.marca);
  const foto = (p.fotos && p.fotos[0])
    ? `<img src="${p.fotos[0]}" alt="${p.nome}" loading="lazy">`
    : `<span class="ph" aria-hidden="true">${ic("shoe")}</span>`;
  const selo = p.precoAntigo ? `<span class="card-tag card-tag--oferta">Oferta</span>`
            : p.novidade    ? `<span class="card-tag">Novidade</span>` : "";
  const preco = p.preco != null
    ? `${p.precoAntigo ? `<span class="de">${brl(p.precoAntigo)}</span>` : ""}${brl(p.preco)}`
    : "Consulte no WhatsApp";
  const tams = (p.tamanhos || []).length ? `Tamanhos: ${p.tamanhos.join(" · ")}` : "";
  return `
  <article class="card">
    <a class="card-media" href="produto.html?id=${encodeURIComponent(p.id)}" aria-label="Ver ${p.nome}">
      ${foto}${selo}
    </a>
    <div class="card-body">
      <span class="marca">${marca ? marca.nome : ""}</span>
      <h3><a href="produto.html?id=${encodeURIComponent(p.id)}" style="text-decoration:none">${p.nome}</a></h3>
      <p class="preco">${preco}</p>
      ${tams ? `<span class="tamanhos">${tams}</span>` : ""}
      <div class="card-foot">
        <a class="btn btn--sm btn--wa" href="${waLink(`Olá! Tenho interesse no ${p.nome} (${LOJA.nome}). Podem confirmar tamanho, cor e valor?`)}" target="_blank" rel="noopener">${ic("chat")} Comprar</a>
      </div>
    </div>
  </article>`;
}

function cardTipo(t) {
  const amostra = PRODUTOS.find(p => p.tipo === t.id && p.fotos && p.fotos[0]);
  const midia = amostra
    ? `<img src="${amostra.fotos[0]}" alt="${t.nome}" loading="lazy">`
    : `<span class="ph" aria-hidden="true">${ic("shoe")}</span>`;
  return `
  <article class="card">
    <a class="card-media" href="calcados.html?tipo=${t.id}" aria-label="Ver ${t.nome}">
      ${midia}
    </a>
    <div class="card-body">
      <h3><a href="calcados.html?tipo=${t.id}" style="text-decoration:none">${t.nome}</a></h3>
      <span class="tamanhos">${t.dica}</span>
      <div class="card-foot">
        <a class="btn btn--sm btn--ghost" href="calcados.html?tipo=${t.id}">Ver modelos ${ic("arrow")}</a>
      </div>
    </div>
  </article>`;
}

/* ---------- páginas ---------- */
function paginaInicio() {
  const marcas = $("#marcas");
  if (marcas) {
    marcas.innerHTML = LOJA.marcas.map(m => `
      <a class="marca-card" href="calcados.html?marca=${m.id}"><span>${m.nome}</span></a>`).join("");
  }

  const tipos = $("#tipos");
  if (tipos) tipos.innerHTML = TIPOS.map(cardTipo).join("");

  const grade = $("#vitrine");
  if (grade) {
    const dest = PRODUTOS.filter(p => p.destaque || p.novidade);
    if (dest.length) {
      grade.innerHTML = dest.slice(0, 8).map(cardProduto).join("");
    } else {
      grade.innerHTML = `
        <div class="vazio" style="grid-column:1/-1">
          ${ic("shoe")}
          <h3>A vitrine está sendo atualizada</h3>
          <p>Os modelos novos chegam toda semana e saem primeiro no Instagram. Fale com a gente e receba as fotos,
             tamanhos e valores dos calçados disponíveis agora.</p>
          <a class="btn btn--wa" href="${waLink("Olá! Quero ver os modelos disponíveis na Donzelas Shoes 🙂")}" target="_blank" rel="noopener">${ic("chat")} Ver modelos no WhatsApp</a>
        </div>`;
    }
  }

  const ig = $("#instafeed");
  if (ig) {
    ig.innerHTML = LOJA.instagramFeed.map(f => `
      <a href="${f.post}" target="_blank" rel="noopener" aria-label="Publicação no Instagram: ${f.alt}">
        <img src="${f.img}" alt="${f.alt}" loading="lazy">
      </a>`).join("");
  }

  const horario = $("#horario-loja");
  if (horario) {
    horario.textContent = LOJA.horario || "Consulte o horário pelo WhatsApp antes de vir";
  }
}

function paginaCalcados() {
  const params = new URLSearchParams(location.search);
  const estado = {
    q: params.get("q") || "",
    marca: params.get("marca") || "",
    tipo: params.get("tipo") || "",
    ord: params.get("ord") || "novos"
  };

  const chips = $("#filtro-marcas");
  if (chips) {
    const opcoes = [{ id: "", nome: "Todas as marcas" }, ...LOJA.marcas];
    chips.innerHTML = opcoes.map(m =>
      `<button class="chip" type="button" data-marca="${m.id}" aria-pressed="${estado.marca === m.id}">${m.nome}</button>`).join("");
    chips.addEventListener("click", e => {
      const b = e.target.closest("[data-marca]");
      if (!b) return;
      estado.marca = b.dataset.marca;
      $$("[data-marca]", chips).forEach(x => x.setAttribute("aria-pressed", x === b));
      aplicar();
    });
  }

  const selTipo = $("#filtro-tipo");
  if (selTipo) {
    selTipo.innerHTML = `<option value="">Todos os tipos</option>` +
      TIPOS.map(t => `<option value="${t.id}">${t.nome}</option>`).join("");
    selTipo.value = estado.tipo;
    selTipo.addEventListener("change", () => { estado.tipo = selTipo.value; aplicar(); });
  }

  const selOrd = $("#filtro-ord");
  if (selOrd) {
    selOrd.value = estado.ord;
    selOrd.addEventListener("change", () => { estado.ord = selOrd.value; aplicar(); });
  }

  function aplicar() {
    let lista = [...PRODUTOS];
    if (estado.marca) lista = lista.filter(p => p.marca === estado.marca);
    if (estado.tipo)  lista = lista.filter(p => p.tipo === estado.tipo);
    if (estado.q) {
      const q = estado.q.toLowerCase();
      lista = lista.filter(p =>
        p.nome.toLowerCase().includes(q) ||
        (LOJA.marcas.find(m => m.id === p.marca)?.nome.toLowerCase().includes(q)));
    }
    if (estado.ord === "preco-asc")  lista.sort((a, b) => (a.preco ?? 1e9) - (b.preco ?? 1e9));
    if (estado.ord === "preco-desc") lista.sort((a, b) => (b.preco ?? -1) - (a.preco ?? -1));
    if (estado.ord === "ofertas")    lista = lista.filter(p => p.precoAntigo);
    if (estado.ord === "novidades")  lista = lista.filter(p => p.novidade);

    const n = $("#contador");
    if (n) n.textContent = lista.length === 1 ? "1 produto" : `${lista.length} produtos`;

    const grade = $("#grade-produtos");
    const vazio = $("#estado-vazio");
    if (!grade) return;

    if (lista.length) {
      grade.innerHTML = lista.map(cardProduto).join("");
      grade.hidden = false;
      if (vazio) vazio.hidden = true;
    } else {
      grade.innerHTML = "";
      grade.hidden = true;
      if (vazio) {
        vazio.hidden = false;
        const temFiltro = estado.marca || estado.tipo || estado.q || estado.ord === "ofertas" || estado.ord === "novidades";
        $("#vazio-titulo", vazio).textContent = temFiltro
          ? "Nenhum produto encontrado com esses filtros"
          : "O catálogo está sendo montado";
        $("#vazio-texto", vazio).textContent = temFiltro
          ? "Ajuste os filtros ou fale com a gente: a vitrine muda toda semana e temos várias opções fora do site."
          : "As fotos e os valores dos calçados ainda não foram publicados aqui. Chame no WhatsApp e enviamos as opções disponíveis agora.";
        $("#vazio-cta", vazio).href = waLink(
          `Olá! Procurei no site${estado.q ? ` por "${estado.q}"` : ""} e não encontrei. Podem me mostrar as opções disponíveis?`);
      }
    }
  }

  aplicar();

  const buscaVitrine = $("#busca-vitrine");
  if (buscaVitrine && estado.q) {
    buscaVitrine.textContent = `Resultados para “${estado.q}”`;
    buscaVitrine.hidden = false;
  }
}

function paginaProduto() {
  const id = new URLSearchParams(location.search).get("id");
  const p = PRODUTOS.find(x => x.id === id);
  const root = $("#produto");

  if (!p) {
    root.innerHTML = `
      <div class="vazio" style="grid-column:1/-1">
        ${ic("shoe")}
        <h3>Produto não encontrado</h3>
        <p>Este produto pode ter saído de linha ou o catálogo ainda está sendo montado.
           Chame no WhatsApp que enviamos as fotos, tamanhos e valores disponíveis hoje.</p>
        <a class="btn btn--wa" href="${waLink("Olá! Vi um produto no site que não abriu. Podem me ajudar?")}" target="_blank" rel="noopener">${ic("chat")} Falar no WhatsApp</a>
      </div>`;
    return;
  }

  const marca = LOJA.marcas.find(m => m.id === p.marca);
  const tipo = TIPOS.find(t => t.id === p.tipo);
  const galeria = (p.fotos || []).length
    ? `<div class="produto-media"><img src="${p.fotos[0]}" alt="${p.nome}"></div>
       <div class="produto-thumbs">${p.fotos.map(f => `<img src="${f}" alt="">`).join("")}</div>`
    : `<div class="produto-media"><div class="sem-foto">${ic("zoom")}<strong>Foto a caminho</strong>
         <span>Consulte no WhatsApp para receber as fotos atuais deste modelo.</span></div></div>`;

  root.innerHTML = `
    <div>${galeria}</div>
    <div class="produto-info">
      <span class="marca">${[marca ? marca.nome : "", tipo ? tipo.nome : ""].filter(Boolean).join(" · ")}</span>
      <h1>${p.nome}</h1>
      <div class="preco-block">
        ${p.preco != null
          ? `<span class="preco">${brl(p.preco)}</span>${p.precoAntigo ? ` <s>${brl(p.precoAntigo)}</s>` : ""}`
          : `<span class="preco">Consulte no WhatsApp</span>`}
        <p class="tamanhos" style="margin:.4rem 0 0;color:var(--ink-soft)">
          Valores e condições podem variar por tamanho e cor — confirme com a gente.
        </p>
      </div>
      ${(p.tamanhos || []).length ? `
      <div class="variacao">
        <span class="lbl">Tamanho</span>
        <div class="opcoes" data-grupo="tamanho">
          ${p.tamanhos.map(t => `<button type="button" class="opcao" aria-pressed="false">${t}</button>`).join("")}
        </div>
      </div>` : ""}
      ${(p.cores || []).length ? `
      <div class="variacao">
        <span class="lbl">Cor</span>
        <div class="opcoes" data-grupo="cor">
          ${p.cores.map(c => `<button type="button" class="opcao" aria-pressed="false">${c}</button>`).join("")}
        </div>
      </div>` : ""}
      <div class="nota">Enviamos para todo o Brasil e fazemos retirada na loja, em Mansões Olinda.</div>
      <div class="produto-cta">
        <a class="btn btn--wa" id="cta-produto" href="${waLink(`Olá! Tenho interesse no ${p.nome}. Podem confirmar tamanho, cor e valor?`)}" target="_blank" rel="noopener">${ic("chat")} Comprar pelo WhatsApp</a>
        ${p.post ? `<a class="btn btn--ghost" href="${p.post}" target="_blank" rel="noopener">Ver publicação original</a>` : ""}
      </div>
    </div>`;

  $$(".opcoes", root).forEach(grupo => {
    grupo.addEventListener("click", e => {
      const b = e.target.closest(".opcao");
      if (!b) return;
      $$(".opcao", grupo).forEach(x => x.setAttribute("aria-pressed", x === b));
      const tam = $('[data-grupo="tamanho"] .opcao[aria-pressed="true"]', root)?.textContent;
      const cor = $('[data-grupo="cor"] .opcao[aria-pressed="true"]', root)?.textContent;
      $("#cta-produto", root).href = waLink(
        `Olá! Tenho interesse no ${p.nome}${tam ? ` — tamanho ${tam}` : ""}${cor ? `, cor ${cor}` : ""}. Podem confirmar disponibilidade e valor?`);
    });
  });
}

/* ---------- inicialização ---------- */
montarShell();
ligarShell();

switch (PAGINA_ATUAL) {
  case "inicio":   paginaInicio();   break;
  case "calcados": paginaCalcados(); break;
  case "produto":  paginaProduto();  break;
}
