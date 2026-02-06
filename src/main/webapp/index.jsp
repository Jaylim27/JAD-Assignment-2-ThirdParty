<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Community Club | Home</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
  :root{
    --bg:#f6f8fb;
    --card:#ffffff;
    --text:#1f2937;
    --muted:#6b7280;
    --line:#e5e7eb;
    --brand:#0ea5e9;
    --brand2:#22c55e;
    --shadow: 0 10px 30px rgba(0,0,0,.08);
    --radius: 16px;
  }

  *{ box-sizing:border-box; }
  body{
    margin:0;
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    background: var(--bg);
    color: var(--text);
  }

  .container{
    max-width:1100px;
    margin:0 auto;
    padding: 0 16px;
  }

  .hero{
    padding: 22px 0 10px;
  }
  .heroCard{
    display:grid;
    grid-template-columns: 1.15fr .85fr;
    gap:16px;
    padding:18px;
    background: linear-gradient(135deg, #ffffff, #f0fbff);
    border:1px solid var(--line);
    border-radius: var(--radius);
    box-shadow: var(--shadow);
  }
  .hero h1{
    margin:0 0 6px;
    font-size:30px;
    letter-spacing:.2px;
  }
  .hero p{
    margin:0;
    color:var(--muted);
    line-height:1.6;
    font-size:14.5px;
  }

  .quickPanel{
    background:#ffffff;
    border:1px solid var(--line);
    border-radius: var(--radius);
    padding:14px;
  }
  .quickPanel h3{
    margin:0 0 10px;
    font-size:14px;
  }
  .quickPanel ul{
    margin:0;
    padding-left:18px;
    color:var(--muted);
    font-size:13.5px;
    line-height:1.6;
  }

  .section{
    padding: 14px 0 34px;
  }
  .sectionTitle{
    display:flex;
    justify-content:space-between;
    align-items:flex-end;
    gap:12px;
    flex-wrap:wrap;
    margin: 14px 0 12px;
  }
  .sectionTitle h2{
    margin:0;
    font-size:18px;
  }
  .sectionTitle p{
    margin:0;
    color:var(--muted);
    font-size:13.5px;
  }

  .grid{
    display:grid;
    grid-template-columns: repeat(3, 1fr);
    gap:14px;
  }
  @media (max-width: 980px){
    .heroCard{ grid-template-columns: 1fr; }
    .grid{ grid-template-columns: repeat(2, 1fr); }
  }
  @media (max-width: 640px){
    .grid{ grid-template-columns: 1fr; }
  }

  .card{
    background: var(--card);
    border:1px solid var(--line);
    border-radius: var(--radius);
    box-shadow: 0 10px 20px rgba(0,0,0,.05);
    overflow:hidden;
    min-height: 220px;
    display:flex;
    flex-direction:column;
  }

  /* Image header for each card */
  .cardTop{
    height:120px;
    border-bottom:1px solid var(--line);
    position:relative;
    overflow:hidden;
    background:#eef2ff;
  }
  .cardTop img{
    width:100%;
    height:100%;
    object-fit:cover;     /* fills the top area, no white borders */
    display:block;
  }
  .cardTop::after{
    content:"";
    position:absolute;
    inset:0;
    background: linear-gradient(180deg, rgba(0,0,0,0.0), rgba(0,0,0,0.20));
    pointer-events:none;
  }

  .pill{
    position:absolute;
    top:12px; left:12px;
    background:#fff;
    border:1px solid var(--line);
    border-radius:999px;
    padding:6px 10px;
    font-size:12px;
    font-weight:800;
    color:var(--muted);
    z-index:2;
  }

  .cardBody{
    padding:12px 14px 14px;
    display:flex;
    flex-direction:column;
    gap:8px;
    flex:1;
  }
  .cardBody h3{
    margin:0;
    font-size:16px;
    line-height:1.2;
  }
  .cardBody p{
    margin:0;
    color:var(--muted);
    font-size:13.5px;
    line-height:1.5;
  }

  .ctaRow{
    margin-top: 14px;
    display:flex;
    gap:10px;
    flex-wrap:wrap;
  }
  .btn{
    border:none;
    cursor:pointer;
    padding:10px 14px;
    border-radius:12px;
    font-weight:800;
    font-size:14px;
    white-space:nowrap;
    text-decoration:none;
    display:inline-block;
  }
  .btn.primary{
    background: linear-gradient(135deg, var(--brand), #38bdf8);
    color:#fff;
    box-shadow: 0 10px 18px rgba(14,165,233,.18);
  }
  .btn.ghost{
    background:#fff;
    border:1px solid var(--line);
    color:var(--text);
    font-weight:800;
  }

  html, body {
    height: 100%;
    margin: 0;
  }

  .page-layout {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }

  .page-content {
    flex: 1;
  }
</style>
</head>

<body class="page-layout">

<!-- Navbar component -->
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<main class="page-content">
<div class="container">

  <section class="hero">
    <div class="heroCard">
      <div>
        <h1>Welcome to ABC Community Club</h1>
        <p>
          Discover programmes, classes, and services for residents. View upcoming events, explore key services,
          and stay connected with what’s happening in the community.
        </p>

        <div class="ctaRow">
          <a class="btn primary" href="<%= request.getContextPath() %>/GetEventList">Browse events</a>
          <a class="btn ghost" href="<%= request.getContextPath() %>/GetProductList">Explore services</a>
        </div>
      </div>

      <div class="quickPanel">
        <h3>Quick info</h3>
        <ul>
          <li>Open daily: 9am–9pm</li>
          <li>Programmes for all ages</li>
          <li>Bookings available!</li>
        </ul>
      </div>
    </div>
  </section>

  <section class="section">
    <div class="sectionTitle">
      <div>
        <h2>Highlights</h2>
        <p>New activities and services for you to discover!</p>
      </div>
    </div>

    <div class="grid">
      <!-- EVENTS CARD -->
      <div class="card">
        <div class="cardTop">
          <div class="pill">Events</div>
          <!-- Put your events image here (save it in /assets or /images) -->
          <img
            src="<%= request.getContextPath() %>/images/events.png"
            alt="Community events">
        </div>
        <div class="cardBody">
          <h3>Upcoming activities</h3>
          <p>Workshops, interest groups, family activities, community drives, and more.</p>
        </div>
      </div>

      <!-- SERVICES CARD -->
      <div class="card">
        <div class="cardTop">
          <div class="pill">Services</div>
          <!-- Put your services image here (save it in /assets or /images) -->
          <img
            src="<%= request.getContextPath() %>/images/services.png"
            alt="Community services">
        </div>
        <div class="cardBody">
          <h3>Resident support</h3>
          <p>Assistance and information for community resources, programmes, and outreach.</p>
        </div>
      </div>
    </div>
  </section>
</div>
</main>

<!-- Footer component -->
<jsp:include page="/WEB-INF/components/footer.jsp" />

</body>
</html>
