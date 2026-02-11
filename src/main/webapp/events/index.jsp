<%--
 - Name: Lim Song Chern Jayden
 - Admin No: P2424093
 - Class: DIT/FT/2B/01
 - Last Edited: 9/2/2026
 --%>
 
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>   <%-- For List<Event> --%>
<%@ page import="dbaccess.Event" %>  <%-- Event DTO/model used to render each card --%>
<%@ page import="java.util.Map" %>   <%-- For display maps (start/end times, images) --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ABC Community Club | Events</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
  :root{
    /* Theme variables reused across the page */
    --bg:#f6f8fb;
    --card:#ffffff;
    --text:#1f2937;
    --muted:#6b7280;
    --line:#e5e7eb;
    --brand:#0ea5e9;
    --shadow: 0 10px 30px rgba(0,0,0,.08);
    --radius: 16px;
  }

  /* Global reset for consistent sizing */
  *{ box-sizing:border-box; }
  html, body { height:100%; margin:0; }

  /* Base page styling */
  body{
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    background: var(--bg);
    color: var(--text);
  }

  /* Wrapper to keep footer pinned to bottom */
  .page-layout{
    min-height:100vh;
    display:flex;
    flex-direction:column;
  }
  .page-content{ flex:1; } /* Main content fills available height */

  /* Center content with max width */
  .container{
    max-width:1100px;
    margin:0 auto;
    padding: 18px 16px 34px;
  }

  /* Header row with page title */
  .headerRow{
    display:flex;
    justify-content:space-between;
    align-items:flex-end;
    gap:14px;
    flex-wrap:wrap;
    margin-bottom:14px;
  }
  .headerRow h1{
    margin:0;
    font-size:26px;
    letter-spacing:.2px;
  }
  .headerRow p{
    margin:6px 0 0;
    color:var(--muted);
    font-size:13.5px;
  }

  /* Search bar container */
  .searchCard{
    background: var(--card);
    border:1px solid var(--line);
    border-radius: var(--radius);
    box-shadow: var(--shadow);
    padding: 14px;
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    align-items:center;
    justify-content:space-between;
    margin-bottom: 16px;
  }
  .searchLeft{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    align-items:center;
    flex:1;
    min-width: 260px;
  }
  .searchInput{
    flex:1;
    min-width: 220px;
    border:1px solid var(--line);
    border-radius: 12px;
    padding: 10px 12px;
    font-size:14px;
    outline:none;
    background:#fff;
  }

  /* Reusable button styling */
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
  .btn.primary{
    background: linear-gradient(135deg, var(--brand), #38bdf8);
    color:#fff;
    box-shadow: 0 10px 18px rgba(14,165,233,.18);
  }
  .btn.ghost{
    background:#fff;
    border:1px solid var(--line);
    color:var(--text);
  }

  /* Status message banner */
  .msg{
    border-radius: 12px;
    padding: 12px 14px;
    font-weight: 800;
    font-size: 13.5px;
    margin-bottom: 14px;
    border: 1px solid;
  }
  .msg.error{
    color:#991b1b;
    background:#fee2e2;
    border-color:#fecaca;
  }

  /* Card grid layout */
  .grid{
    display:grid;
    grid-template-columns: repeat(3, 1fr);
    gap:14px;
  }
  /* Responsive breakpoints */
  @media (max-width: 980px){
    .grid{ grid-template-columns: repeat(2, 1fr); }
  }
  @media (max-width: 640px){
    .grid{ grid-template-columns: 1fr; }
  }

  /* Event card styling */
  .eventCard{
    background: var(--card);
    border:1px solid var(--line);
    border-radius: var(--radius);
    box-shadow: 0 10px 20px rgba(0,0,0,.05);
    overflow:hidden;
    display:flex;
    flex-direction:column;
    min-height: 240px;
  }

  /* Image header area of the event card */
  .eventTop{
    height: 110px;
    border-bottom:1px solid var(--line);
    position:relative;
    overflow:hidden;
  }
  .eventTop img{
    width:100%;
    height:100%;
    object-fit:cover; /* Fill image area without distortion */
  }

  /* Event ID pill overlay */
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
  }

  /* Content area of the event card */
  .eventBody{
    padding: 12px 14px 14px;
    display:flex;
    flex-direction:column;
    gap:8px;
    flex:1;
  }
  .eventTitle{
    margin:0;
    font-size:16px;
    line-height:1.2;
  }
  .eventMeta{
    margin:0;
    color: var(--muted);
    font-size: 13.5px;
    line-height: 1.5;
  }

  /* Start/End/Capacity block */
  .detailsBlock{
    margin-top:8px;
    padding-top:10px;
    border-top:1px solid var(--line);
    display:grid;
    gap:6px;
    color:var(--muted);
    font-size:13.5px;
  }
  .detailRow{
    display:flex;
    align-items:baseline;
    gap:8px;
  }
  .detailLabel{
    font-weight:700;
    color:#374151;
    min-width:80px;
  }
  .detailValue{
    color:var(--muted);
  }

  /* Bottom action row (View details button) */
  .cardActions{
    margin-top:auto;
    padding-top:10px;
    display:flex;
    flex-wrap:wrap;
    justify-content:flex-end;
  }

  /* Smaller button variant used on cards */
  .btn.small{
    padding:9px 12px;
    font-size:13.5px;
    border-radius:12px;
  }

  /* Empty-state styling when no events */
  .empty{
    background: var(--card);
    border:1px dashed var(--line);
    border-radius: var(--radius);
    padding: 18px;
    color: var(--muted);
  }
</style>
</head>

<body class="page-layout">

<%-- Shared navbar include --%>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<main class="page-content">
  <div class="container">

    <%-- Page heading --%>
    <div class="headerRow">
      <div>
        <h1>Events</h1>
        <p>Browse upcoming community activities and programmes.</p>
      </div>
    </div>

    <%-- Search form submits to GetEventList servlet (GET) --%>
    <form class="searchCard" method="get" action="<%= request.getContextPath() %>/GetEventList">
      <div class="searchLeft">
        <%-- Keep the search value after submitting (comes from servlet request attribute) --%>
        <input class="searchInput" type="text" name="search"
          placeholder="Search by title, description, or location..."
          value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">
        <button class="btn primary" type="submit">Search</button>
        <%-- Reset returns to /GetEventList without query params --%>
        <a class="btn ghost" href="<%= request.getContextPath() %>/GetEventList">Reset</a>
      </div>
    </form>

    <%
      // If servlet sets an error flag, display a generic banner
      String err = (String) request.getAttribute("err");
      if (err != null) {
    %>
      <div class="msg error">Error loading events. Please try again.</div>
    <%
      }
    %>

    <%
      // Event list set by servlet: request.setAttribute("eventArray", events)
      @SuppressWarnings("unchecked")
      List<Event> events = (List<Event>) request.getAttribute("eventArray");

      // Map of eventId -> formatted start time (SG display) set by servlet
      @SuppressWarnings("unchecked")
      Map<Integer, String> startMap = (Map<Integer, String>) request.getAttribute("startTimeDisplayMap");

      // Map of eventId -> formatted end time (SG display) set by servlet
      @SuppressWarnings("unchecked")
      Map<Integer, String> endMap = (Map<Integer, String>) request.getAttribute("endTimeDisplayMap");

      // Map of eventId -> image URL set by servlet (for card image)
      @SuppressWarnings("unchecked")
      Map<Integer,String> imageMap = (Map<Integer,String>) request.getAttribute("imageMap");

      // Default image URL set by servlet (fallback when no per-event image exists)
      String defaultImg = (String) request.getAttribute("defaultImg");

      // Empty state when no events returned (or servlet didn't set list)
      if (events == null || events.isEmpty()) {
    %>
      <div class="empty">No events found.</div>
    <%
      } else {
    %>

      <div class="grid">
        <%
          // Render one card per event
          for (Event e : events) {

          // Choose image based on eventId (fallback to defaultImg if not mapped)
          String img = (imageMap != null && imageMap.containsKey(e.getEventId()))
                ? imageMap.get(e.getEventId())
                : defaultImg;

          // Quick fallback values (not directly used below, but computed)
          String start = startMap != null ? startMap.get(e.getEventId()) : "-";
          String end = endMap != null ? endMap.get(e.getEventId()) : "-";
        %>
          <div class="eventCard">
            <div class="eventTop">
              <%-- Event card image --%>
              <img src="<%= img %>" alt="Event image">
              <%-- Event ID badge overlay --%>
              <div class="pill">Event ID: <%= e.getEventId() %></div>
            </div>

            <div class="eventBody">
              <%-- Event title and location --%>
              <h3 class="eventTitle"><%= e.getTitle() %></h3>
              <p class="eventMeta"><%= e.getLocation() %></p>

              <%
                  // Pull formatted start/end from the servlet-provided maps
                  // (Defensive fallback to "-" if missing)
                  String startDisplay = (startMap != null) ? startMap.get(e.getEventId()) : null;
                  if (startDisplay == null || startDisplay.isBlank()) startDisplay = "-";

                  String endDisplay = (endMap != null) ? endMap.get(e.getEventId()) : null;
                  if (endDisplay == null || endDisplay.isBlank()) endDisplay = "-";
              %>

              <%-- Time + capacity details --%>
              <div class="detailsBlock">
                <div class="detailRow">
                  <span class="detailLabel">Start: </span>
                  <span class="detailValue"><%= startDisplay %></span>
                </div>
                <div class="detailRow">
                  <span class="detailLabel">End: </span>
                  <span class="detailValue"><%= endDisplay %></span>
                </div>
                <div class="detailRow">
                  <span class="detailLabel">Capacity: </span>
                  <span class="detailValue"><%= e.getCapacity() %></span>
                </div>
              </div>

              <%-- Action: go to details view via GetEventList?eventId= --%>
              <div class="cardActions">
                <a class="btn ghost small"
                   href="<%= request.getContextPath() %>/GetEventList?eventId=<%= e.getEventId() %>">
                  View details
                </a>
              </div>
            </div>
          </div>
        <%
          } // end for
        %>
      </div>

    <%
      } // end else (events not empty)
    %>

  </div>
</main>

<%-- Shared footer include --%>
<jsp:include page="/WEB-INF/components/footer.jsp" />

</body>
</html>
