<!DOCTYPE html>
<html lang="hi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Study Hub - Education Portal</title>

<style>
*{box-sizing:border-box}
body{
 margin:0;
 font-family:Arial,sans-serif;
 background:#f1f5f9;
 color:#172033
}
header{
 background:#1769e0;
 color:white;
 padding:25px 18px;
}
header h1{margin:0;font-size:30px}
header p{margin:10px 0 0}
.wrap{max-width:1000px;margin:auto;padding:18px}
.controls{
 display:flex;gap:12px;flex-wrap:wrap;
 margin:18px 0
}
select,button{
 padding:13px;
 border:1px solid #ccd4e0;
 border-radius:10px;
 font-size:16px;
}
select{background:white;flex:1;min-width:130px}
button{cursor:pointer}
.tabs{
 display:flex;gap:8px;flex-wrap:wrap;
 margin:18px 0
}
.tabs button{
 background:white;color:#1769e0;
 border:1px solid #1769e0
}
.tabs button.active{
 background:#1769e0;color:white
}
.card{
 background:white;
 border-radius:15px;
 padding:18px;
 margin:13px 0;
 box-shadow:0 3px 14px #0001
}
.card h2{margin-top:0}
.tag{
 display:inline-block;
 background:#e8f0ff;
 color:#1769e0;
 padding:7px 10px;
 border-radius:20px;
 margin:3px;
 font-size:13px
}
.primary{
 background:#1769e0;
 color:white;
 border:0;
 padding:12px 18px
}
.small{color:#667085;font-size:14px}
.subjects{
 display:grid;
 grid-template-columns:repeat(auto-fit,minmax(140px,1fr));
 gap:10px
}
.subject{
 background:#f0f5ff;
 border:1px solid #d7e5ff;
 padding:15px;
 border-radius:12px;
 text-align:center;
 cursor:pointer
}
.subject:hover{background:#dceaff}
footer{text-align:center;padding:25px;color:#667085}
</style>
</head>

<body>

<header>
<h1>📚 Study Hub</h1>
<p>Classes 9–12 • All Boards • Notes • Papers • DPP • Tests</p>
</header>

<main class="wrap">

<div class="controls">
<select id="cls" onchange="render()">
<option value="9">Class 9</option>
<option value="10">Class 10</option>
<option value="11">Class 11</option>
<option value="12">Class 12</option>
</select>

<select id="board" onchange="render()">
<option>UP Board</option>
<option>MP Board</option>
<option>CBSE</option>
<option>Bihar Board</option>
<option>Jharkhand Board</option>
<option>Rajasthan Board</option>
<option>Maharashtra Board</option>
</select>
</div>

<div class="card">
<h2>🎓 आपका Study Dashboard</h2>
<p id="welcome"></p>
<span class="tag">Free Demo</span>
<span class="tag">Hindi + English</span>
<span class="tag">Class 9–12</span>
</div>

<div class="tabs">
<button class="active" onclick="showTab('subjects',this)">📚 Subjects</button>
<button onclick="showTab('notes',this)">📝 Notes</button>
<button onclick="showTab('papers',this)">📄 Papers</button>
<button onclick="showTab('dpp',this)">📘 DPP</button>
<button onclick="showTab('tests',this)">🧪 Tests</button>
<button onclick="showTab('neet',this)">🎯 NEET</button>
</div>

<div id="content"></div>

</main>

<footer>
<p>📚 Study Hub — Learn Every Day</p>
<p>Educational Demo Website</p>
</footer>

<script>
const data={
9:["गणित","विज्ञान","हिंदी","अंग्रेजी","सामाजिक विज्ञान","संस्कृत"],
10:["गणित","विज्ञान","हिंदी","अंग्रेजी","सामाजिक विज्ञान","संस्कृत"],
11:["भौतिक विज्ञान","रसायन विज्ञान","जीव विज्ञान","गणित","हिंदी","अंग्रेजी"],
12:["भौतिक विज्ञान","रसायन विज्ञान","जीव विज्ञान","गणित","हिंदी","अंग्रेजी"]
};

let current="subjects";

function render(){
 const c=document.getElementById("cls").value;
 const b=document.getElementById("board").value;

 document.getElementById("welcome").innerText=
 "आप कक्षा "+c+" और "+b+" चुन चुके हैं। अपना विषय और पढ़ाई का सेक्शन चुनें।";

 showTab(current,document.querySelector(".tabs button.active"));
}

function showTab(tab,btn){
 current=tab;

 document.querySelectorAll(".tabs button").forEach(x=>{
 x.classList.remove("active");
 });

 if(btn)btn.classList.add("active");

 const c=document.getElementById("cls").value;
 const b=document.getElementById("board").value;
 const box=document.getElementById("content");

 if(tab==="subjects"){
 box.innerHTML=`
 <div class="card">
 <h2>📚 अपने विषय चुनें</h2>
 <div class="subjects">
 ${data[c].map(s=>`<div class="subject" onclick="subjectInfo('${s}')">📖<br><b>${s}</b></div>`).join("")}
 </div>
 </div>`;
 }

 if(tab==="notes"){
 box.innerHTML=`
 <div class="card">
 <h2>📝 Handwritten Notes</h2>
 <p>कक्षा ${c} • ${b}</p>
 <p>अपने विषय के नोट्स देखने के लिए विषय चुनें।</p>
 ${data[c].map(s=>`<p>📘 ${s} — नोट्स जल्द जोड़े जाएँगे।</p>`).join("")}
 </div>`;
 }

 if(tab==="papers"){
 box.innerHTML=`
 <div class="card">
 <h2>📄 Previous Year Papers</h2>
 <p>कक्षा ${c} • ${b}</p>
 <p>पुराने प्रश्नपत्रों का सेक्शन।</p>
 ${data[c].map(s=>`<p>📄 ${s} — प्रश्नपत्र जल्द जोड़े जाएँगे।</p>`).join("")}
 </div>`;
 }

 if(tab==="dpp"){
 box.innerHTML=`
 <div class="card">
 <h2>📘 Daily Practice Problems</h2>
 <p>आज के अभ्यास के लिए अपना विषय चुनें।</p>
 ${data[c].map(s=>`<p>✏️ ${s} — अभ्यास प्रश्न जल्द जोड़े जाएँगे।</p>`).join("")}
 </div>`;
 }

 if(tab==="tests"){
 box.innerHTML=`
 <div class="card">
 <h2>🧪 Online Practice Test</h2>
 <p>यह एक छोटा Demo Test है।</p>
 <p><b>प्रश्न:</b> पानी का रासायनिक सूत्र क्या है?</p>
 <button class="primary" onclick="check('H2O')">H₂O</button>
 <button onclick="check('CO2')">CO₂</button>
 <button onclick="check('O2')">O₂</button>
 <p id="result"></p>
 </div>`;
 }

 if(tab==="neet"){
 box.innerHTML=`
 <div class="card">
 <h2>🎯 NEET Preparation</h2>
 <p>NEET की तैयारी के लिए मुख्य विषय:</p>
 <p>📗 Physics</p>
 <p>📗 Chemistry</p>
 <p>📗 Biology</p>
 <p class="small">अध्यायवार नोट्स, अभ्यास प्रश्न और टेस्ट जल्द जोड़े जाएँगे।</p>
 </div>`;
 }
}

function subjectInfo(s){
 alert(s+" के अध्याय और अध्ययन सामग्री जल्द जोड़ी जाएगी।");
}

function check(answer){
 document.getElementById("result").innerText=
 answer==="H2O"?"✅ सही जवाब!":"❌ सही जवाब H₂O है।";
}

render();
</script>

</body>
</html>
