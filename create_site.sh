#!/usr/bin/env bash
set -e

### ─────────────────────────────────────────────
### CONFIG — change these if you want different names
ROOT_DIR=$(pwd)                                # run inside repo root
IMG_DIR="assets/imgs"
RESUME="assets/resume.pdf"
### ─────────────────────────────────────────────

echo "🔧 Creating folders ..."
mkdir -p "$IMG_DIR"

echo "📝 Writing index.html ..."
cat > index.html <<'HTML'
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Efe Civisoken</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <nav>
    <span class="logo">Efe</span>
    <ul>
      <li><a href="#about">About</a></li>
      <li><a href="#projects">Projects</a></li>
      <li><a href="#contact">Contact</a></li>
      <li><button id="modeToggle">🌙</button></li>
    </ul>
  </nav>

  <header class="hero">
    <img src="assets/imgs/avatar.jpg" alt="avatar">
    <h1>Hey, I’m Efe 👋</h1>
    <p>ECE + Econ @ Lafayette • quant-curious builder.</p>
    <div class="cta">
      <a class="btn" href="#projects">See my work</a>
      <a class="btn outline" href="assets/resume.pdf" target="_blank">Résumé</a>
    </div>
  </header>

  <section id="about">
    <h2>About me</h2>
    <p>I enjoy turning messy real-world problems into elegant technical solutions—from FPGA design to algorithmic trading.</p>
  </section>

  <section id="projects">
    <h2>Selected projects</h2>
    <div class="grid" id="projectGrid"></div>
  </section>

  <section id="contact">
    <h2>Let’s connect</h2>
    <p>
      <a href="mailto:efecivisoken@gmail.com">Email</a> •
      <a href="https://github.com/EfeCivisoken" target="_blank">GitHub</a> •
      <a href="https://linkedin.com/in/YOUR-LINK" target="_blank">LinkedIn</a>
    </p>
  </section>

  <footer>© <span id="year"></span> Efe Civisoken</footer>
  <script src="script.js"></script>
</body>
</html>
HTML

echo "📝 Writing style.css ..."
cat > style.css <<'CSS'
*{margin:0;padding:0;box-sizing:border-box}
:root{
 --bg:#fff;--text:#202124;--accent:#007acc;--card:#f5f5f5}
[data-theme='dark']{
 --bg:#0d1117;--text:#e6edf3;--accent:#58a6ff;--card:#161b22}
body{font-family:system-ui,sans-serif;background:var(--bg);color:var(--text);line-height:1.6}
nav{position:sticky;top:0;display:flex;justify-content:space-between;align-items:center;padding:.75rem 2rem;background:var(--bg);border-bottom:1px solid var(--card)}
nav .logo{font-weight:700;font-size:1.2rem}
nav ul{display:flex;gap:1rem;list-style:none}
nav a{color:var(--text);text-decoration:none}
nav a:hover{color:var(--accent)}
nav button{background:none;border:none;font-size:1.2rem;cursor:pointer}
.hero{text-align:center;padding:4rem 1rem 3rem}
.hero img{width:120px;height:120px;border-radius:50%;object-fit:cover}
.hero h1{margin:1rem 0;font-size:2.4rem}
.cta{margin-top:1rem;display:flex;gap:1rem;justify-content:center}
.btn{padding:.6rem 1.2rem;border-radius:6px;background:var(--accent);color:#fff;text-decoration:none;font-weight:500}
.btn.outline{background:transparent;border:2px solid var(--accent);color:var(--accent)}
section{padding:3rem 1rem;max-width:900px;margin:0 auto}
section h2{font-size:1.8rem;margin-bottom:1rem}
.grid{display:grid;gap:1.5rem;grid-template-columns:repeat(auto-fit,minmax(250px,1fr))}
.card{background:var(--card);padding:1.2rem;border-radius:12px;display:flex;flex-direction:column;gap:.8rem}
.card img{width:100%;border-radius:8px}
.card h3{margin:.4rem 0}
footer{text-align:center;padding:2rem 0;font-size:.9rem;opacity:.7}
CSS

echo "📝 Writing script.js ..."
cat > script.js <<'JS'
const btn=document.getElementById('modeToggle');
btn.onclick=()=>{
  const html=document.documentElement;
  const dark=html.getAttribute('data-theme')==='dark';
  html.setAttribute('data-theme',dark?'light':'dark');
  btn.textContent=dark?'🌙':'☀️';
};
document.getElementById('year').textContent=new Date().getFullYear();
fetch('projects.json').then(r=>r.ok?r.json():[]).then(ps=>{
  const grid=document.getElementById('projectGrid');if(!grid)return;
  ps.forEach(p=>grid.insertAdjacentHTML('beforeend',`
    <div class="card">
      <img src="${p.img}" alt="${p.title}">
      <h3>${p.title}</h3>
      <p>${p.desc}</p>
      <a class="btn outline" href="${p.link}" target="_blank">View</a>
    </div>`));});
JS

echo "📝 Writing projects.json ..."
cat > projects.json <<'JSON'
[
  {
    "title": "FPGA Traffic-Light",
    "desc": "One-hot FSM in Verilog; 50 MHz clock, debounced inputs.",
    "img": "assets/imgs/project-tl.png",
    "link": "https://github.com/EfeCivisoken/traffic-light"
  }
]
JSON

echo "🖼  Dropping placeholder avatar ..."
curl -s https://avatars.githubusercontent.com/u/583231?v=4 -o "$IMG_DIR/avatar.jpg" || true

echo "📦 Committing ..."
git add index.html style.css script.js projects.json "$IMG_DIR" || true
git commit -m "Scaffold portfolio site" || true
git push origin main

echo "✅ Done!  Visit https://efecivisoken.github.io in ~30 sec."
