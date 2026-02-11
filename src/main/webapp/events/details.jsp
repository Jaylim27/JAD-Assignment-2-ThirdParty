<%--
 - Name: Lim Song Chern Jayden
 - Admin No: P2424093
 - Class: DIT/FT/2B/01
 - Last Edited: 9/2/2026
--%>
 
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="dbaccess.Event" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ABC Community Club | Event Details</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
  :root{
    --bg:#f6f8fb;
    --card:#ffffff;
    --text:#1f2937;
    --muted:#6b7280;
    --line:#e5e7eb;
    --brand:#0ea5e9;
    --shadow: 0 10px 30px rgba(0,0,0,.08);
    --radius: 16px;
  }

  /* Global reset for consistent layout */
  *{ box-sizing:border-box; }
  html, body { height:100%; margin:0; }

  /* Page base styling */
  body{
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    background: var(--bg);
    color: var(--text);
  }

  /* Layout wrapper to keep footer at bottom */
  .page-layout{
    min-height:100vh;
    display:flex;
    flex-direction:column;
  }
  /* Main content grows to fill remaining space */
  .page-content{ flex:1; }

  /* Centered container */
  .container{
    max-width:1100px;
    margin:0 auto;
    padding: 18px 16px 34px;
  }

  /* Breadcrumb row + right-side button row */
  .crumbRow{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:12px;
    flex-wrap:wrap;
    margin-bottom:14px;
  }

  /* Left breadcrumb block */
  .crumbLeft{
    display:flex;
    flex-direction:column;
    gap:6px;
  }

  /* Breadcrumb text */
  .crumb{
    color:var(--muted);
    font-size:13.5px;
  }

  /* Breadcrumb links */
  .crumb a{
    color:var(--muted);
    text-decoration:none;
    font-weight:800;
  }
  .crumb a:hover{ color:var(--text); }

  /* Button base */
  .btn{
    border:none;
    cursor:pointer;
    padding:10px 14px;
    border-radius:12px;
    font-weight:800;
    font-size:14px;
    white-space:nowrap;
    text-decoration:none;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:8px;
  }

  /* Primary call-to-action */
  .btn.primary{
    background: linear-gradient(135deg, var(--brand), #38bdf8);
    color:#fff;
    box-shadow: 0 10px 18px rgba(14,165,233,.18);
  }

  /* Secondary/ghost button */
  .btn.ghost{
    background:#fff;
    border:1px solid var(--line);
    color:var(--text);
  }

  /* Message banner base */
  .msg{
    border-radius: 12px;
    padding: 12px 14px;
    font-weight: 800;
    font-size: 13.5px;
    margin-bottom: 14px;
    border: 1px solid;
  }

  /* Error banner styling */
  .msg.error{
    color:#991b1b;
    background:#fee2e2;
    border-color:#fecaca;
  }

  /* Two-column layout: main details + side info */
  .detailsGrid{
    display:grid;
    grid-template-columns: 1.25fr .75fr;
    gap:14px;
  }

  /* Responsive: stack to one column */
  @media (max-width: 980px){
    .detailsGrid{ grid-template-columns: 1fr; }
  }

  /* Card container */
  .card{
    background: var(--card);
    border:1px solid var(--line);
    border-radius: var(--radius);
    box-shadow: var(--shadow);
    overflow:hidden;
  }

  /* Hero top area for image */
  .heroTop{
    height: 180px;
    background: linear-gradient(135deg, rgba(14,165,233,.18), rgba(34,197,94,.18));
    border-bottom:1px solid var(--line);
    position:relative;
  }

  /* Ensure hero image fills container without distortion */
  .heroTop img{
    width:100%;
    height:100%;
    object-fit:cover;
    display:block;
  }

  /* Event ID pill shown on hero */
  .idTag{
    position:absolute;
    top:12px; left:12px;
    background:#fff;
    border:1px solid var(--line);
    border-radius:999px;
    padding:6px 10px;
    font-size:12px;
    font-weight:900;
    color:var(--muted);
  }

  /* Card padding */
  .cardBody{
    padding: 14px 16px 16px;
  }

  /* Title area layout */
  .titleRow{
    display:flex;
    align-items:flex-start;
    justify-content:space-between;
    gap:12px;
    flex-wrap:wrap;
    margin-bottom:8px;
  }

  /* Main heading */
  h1{
    margin:0;
    font-size:22px;
    letter-spacing:.2px;
    line-height:1.2;
  }

  /* Location line */
  .location{
    margin:0;
    color:var(--muted);
    font-size:14px;
    line-height:1.4;
  }

  /* Description paragraph */
  .desc{
    margin:12px 0 0;
    color:var(--text);
    font-size:14px;
    line-height:1.7;
  }

  /* Side info card padding */
  .infoCard{
    padding: 14px 16px 16px;
  }

  /* Side info heading */
  .infoCard h2{
    margin:0 0 10px;
    font-size:14px;
    letter-spacing:.2px;
  }

  /* Key-value block styling */
  .detailsBlock{
    padding-top:10px;
    border-top:1px solid var(--line);
    display:grid;
    gap:8px;
    color:var(--muted);
    font-size:13.5px;
  }

  .detailRow{
    display:flex;
    align-items:baseline;
    gap:8px;
  }

  .detailLabel{
    font-weight:800;
    color:#374151;
    min-width:84px;
  }

  .detailValue{
    color:var(--muted);
    word-break:break-word;
  }

  /* Container for side actions (Book button) */
  .sideActions{
    margin-top:14px;
    display:flex;
    flex-direction:column;
    gap:10px;
  }
</style>
</head>

<body class="page-layout">

<!-- Shared site navbar -->
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<main class="page-content">
  <div class="container">

    <!-- Breadcrumbs + back to list -->
    <div class="crumbRow">
      <div class="crumbLeft">
        <div class="crumb">
          <!-- Home -->
          <a href="<%= request.getContextPath() %>/index.jsp">Home</a> /
          <!-- Event listing page -->
          <a href="<%= request.getContextPath() %>/GetEventList">Events</a> /
          <!-- Current page -->
          Details
        </div>
      </div>

      <!-- Back to all events -->
      <a class="btn ghost" href="<%= request.getContextPath() %>/GetEventList">← Back to events</a>
    </div>

    <%
      // Error flag set by servlet (e.g., NotFound, InvalidId, ApiError, ServerError)
      String err = (String) request.getAttribute("err");

      // Event object set by servlet when GET by ID succeeds
      Event event = (Event) request.getAttribute("event");

      // Pre-formatted display strings set by servlet (avoid formatting in JSP)
      String startTimeDisplay = (String) request.getAttribute("startTimeDisplay");
      String endTimeDisplay   = (String) request.getAttribute("endTimeDisplay");
      String createdAtDisplay = (String) request.getAttribute("createdAtDisplay");
      String updatedAtDisplay = (String) request.getAttribute("updatedAtDisplay");

      // Defensive fallbacks so the UI never shows null/blank
      if (startTimeDisplay == null || startTimeDisplay.isBlank()) startTimeDisplay = "-";
      if (endTimeDisplay == null || endTimeDisplay.isBlank()) endTimeDisplay = "-";
      if (createdAtDisplay == null || createdAtDisplay.isBlank()) createdAtDisplay = "-";
      if (updatedAtDisplay == null || updatedAtDisplay.isBlank()) updatedAtDisplay = "-";

      // Image URL set by servlet; fallback to default image if missing
      String imgSrc = (String) request.getAttribute("imgSrc");
      if (imgSrc == null || imgSrc.isBlank()) {
        imgSrc = request.getContextPath() + "/images/events/default.png";
      }

      // Optional: eventId attribute set by servlet (not used in UI right now)
      Object eventIdObj = request.getAttribute("eventId");
      String eventIdText = (eventIdObj != null) ? String.valueOf(eventIdObj) : null;

      // If servlet reported an error, show a user-friendly message
      if (err != null) {
        String msg = "Error loading event details. Please try again.";
        if ("NotFound".equals(err)) msg = "Event not found.";
        if ("InvalidId".equals(err)) msg = "Invalid Event ID.";
        if ("ApiError".equals(err)) msg = "Unable to load event details from API.";
    %>
      <div class="msg error"><%= msg %></div>
      <!-- Offer a path back to the events list -->
      <a class="btn primary" href="<%= request.getContextPath() %>/GetEventList">Return to events</a>
    <%
      // If no error but event is missing, show a safe fallback message
      } else if (event == null) {
    %>
      <div class="msg error">No event selected.</div>
      <a class="btn primary" href="<%= request.getContextPath() %>/GetEventList">Return to events</a>
    <%
      // Success state: render the event details UI
      } else {
    %>

    <div class="detailsGrid">

      <!-- Left: Main details card -->
      <div class="card">
        <div class="heroTop">
          <!-- Event image -->
          <img src="<%= imgSrc %>" alt="Event image">
          <!-- Event ID badge -->
          <div class="idTag">Event ID: <%= event.getEventId() %></div>
        </div>

        <div class="cardBody">
          <div class="titleRow">
            <!-- Event title -->
            <h1><%= event.getTitle() %></h1>
          </div>

          <!-- Event location -->
          <p class="location"><%= event.getLocation() %></p>

          <%
            // Event description is optional; show placeholder if missing
            String desc = event.getDescription();
            if (desc != null && !desc.trim().isEmpty()) {
          %>
            <p class="desc"><%= desc %></p>
          <%
            } else {
          %>
            <p class="desc" style="color: var(--muted);">No description provided.</p>
          <%
            }
          %>
        </div>
      </div>

      <!-- Right: Side info card -->
      <div class="card">
        <div class="infoCard">
          <h2>Event info</h2>

          <div class="detailsBlock">
            <!-- Start time (pre-formatted) -->
            <div class="detailRow">
              <span class="detailLabel">Start:</span>
              <span class="detailValue"><%= startTimeDisplay %></span>
            </div>

            <!-- End time (pre-formatted) -->
            <div class="detailRow">
              <span class="detailLabel">End:</span>
              <span class="detailValue"><%= endTimeDisplay %></span>
            </div>

            <!-- Capacity -->
            <div class="detailRow">
              <span class="detailLabel">Capacity:</span>
              <span class="detailValue"><%= event.getCapacity() %></span>
            </div>

            <!-- Actions: go to booking servlet with eventId -->
            <div class="sideActions">
              <a class="btn primary"
                 href="<%=request.getContextPath()%>/GetEventBookingDetails?eventId=<%= event.getEventId() %>">
                 Book Now!
              </a>
            </div>
          </div>
        </div>
      </div>

    </div>

    <%
      }
    %>

  </div>
</main>

<!-- Shared site footer -->
<jsp:include page="/WEB-INF/components/footer.jsp" />

</body>
</html>
