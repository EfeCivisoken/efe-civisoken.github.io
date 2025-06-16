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
