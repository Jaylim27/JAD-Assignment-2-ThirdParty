<%--
 - Name: Lim Song Chern Jayden
 - Admin No: P2424093
 - Class: DIT/FT/2B/01
 - Last Edited: 9/2/2026
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- Page directive:
     - language="java": JSP scripting uses Java
     - contentType + pageEncoding: ensures UTF-8 output to support special characters properly -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Community Club | Home</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- meta viewport ensures the page scales correctly on mobile devices -->

<style>
  /*
    CSS variables (theme tokens):
    - Used across the site for consistent colors and spacing.
  */
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

  /* Global box sizing; prevents padding/borders from breaking element widths */
  *{ box-sizing:border-box; }

  /* Base body styling */
  body{
    margin:0;
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    background: var(--bg);
    color: var(--text);
  }

  /* Main container centers content and sets max width */
  .container{
    max-width:1100px;
    margin:0 auto;
    padding: 0 16px;
  }

  /*
    Hero section (top of page):
    - Contains welcome message, CTAs, and a quick info panel.
  */
  .hero{
    padding: 22px 0 10px;
  }

  /* Hero card uses a two-column grid (text + quick info) on large screens */
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

  /* Quick info panel on the right side of hero (or below on smaller screens) */
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

  /* Section wrapper for the content below hero */
  .section{
    padding: 14px 0 34px;
  }

  /* Section title row (heading + description) */
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

  /* Grid for highlight cards */
  .grid{
    display:grid;
    grid-template-columns: repeat(3, 1fr);
    gap:14px;
  }

  /*
    Responsive behavior:
    - On <= 980px: hero switches to 1 column and grid becomes 2 columns
    - On <= 640px: grid becomes 1 column
  */
  @media (max-width: 980px){
    .heroCard{ grid-template-columns: 1fr; }
    .grid{ grid-template-columns: repeat(2, 1fr); }
  }
  @media (max-width: 640px){
    .grid{ grid-template-columns: 1fr; }
  }

  /* Base card styling used for Highlights */
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

  /* Image fills the top area; cover crops if needed to avoid white borders */
  .cardTop img{
    width:100%;
    height:100%;
    object-fit:cover;
    display:block;
  }

  /* Dark gradient overlay to improve readability of text/labels over the image */
  .cardTop::after{
    content:"";
    position:absolute;
    inset:0;
    background: linear-gradient(180deg, rgba(0,0,0,0.0), rgba(0,0,0,0.20));
    pointer-events:none;
  }

  /* Pill label (e.g., "Events", "Services") positioned over image */
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
    z-index:2; /* ensures pill sits above overlay */
  }

  /* Card body text area */
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

  /* CTA row used in hero section for primary actions */
  .ctaRow{
    margin-top: 14px;
    display:flex;
    gap:10px;
    flex-wrap:wrap;
  }

  /* Base button styling */
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

  /* Primary button with gradient + shadow */
  .btn.primary{
    background: linear-gradient(135deg, var(--brand), #38bdf8);
    color:#fff;
    box-shadow: 0 10px 18px rgba(14,165,233,.18);
  }

  /* Ghost button with border */
  .btn.ghost{
    background:#fff;
    border:1px solid var(--line);
    color:var(--text);
    font-weight:800;
  }

  /*
    Full height page layout helpers:
    - Allows footer to stay at bottom even if content is short.
  */
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

<!-- Navbar component included from /WEB-INF (not directly accessible via URL) -->
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<main class="page-content">
<div class="container">

  <!-- HERO SECTION: intro + buttons + quick info -->
  <section class="hero">
    <div class="heroCard">
      <div>
        <h1>Welcome to ABC Community Club</h1>
        <p>
          Discover programmes, classes, and services for residents. View upcoming events, explore key services,
          and stay connected with what’s happening in the community.
        </p>

        <!-- CTA links:
             request.getContextPath() ensures correct path regardless of deployment context -->
        <div class="ctaRow">
          <a class="btn primary" href="<%= request.getContextPath() %>/GetEventList">Browse events</a>
          <a class="btn ghost" href="<%= request.getContextPath() %>/GetProductList">Explore services</a>
        </div>
      </div>

      <!-- Quick info panel (static content) -->
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

  <!-- HIGHLIGHTS SECTION: cards that introduce major site areas -->
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

          <!-- Static image path:
               Ensure /images/events.png exists in your web app (e.g., /webapp/images/) -->
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

          <!-- Static image path:
               Ensure /images/services.png exists in your web app -->
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

<!-- Footer component included from /WEB-INF -->
<jsp:include page="/WEB-INF/components/footer.jsp" />

</body>
</html>
