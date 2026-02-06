<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="dbaccess.Event" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ABC Community Club | Events</title>
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

  *{ box-sizing:border-box; }
  html, body { height:100%; margin:0; }
  body{
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    background: var(--bg);
    color: var(--text);
  }

  .page-layout{
    min-height:100vh;
    display:flex;
    flex-direction:column;
  }
  .page-content{ flex:1; }

  .container{
    max-width:1100px;
    margin:0 auto;
    padding: 18px 16px 34px;
  }

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

  .grid{
    display:grid;
    grid-template-columns: repeat(3, 1fr);
    gap:14px;
  }
  @media (max-width: 980px){
    .grid{ grid-template-columns: repeat(2, 1fr); }
  }
  @media (max-width: 640px){
    .grid{ grid-template-columns: 1fr; }
  }

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
  .eventTop{
    height: 110px;
    background: linear-gradient(135deg, rgba(14,165,233,.18), rgba(34,197,94,.18));
    border-bottom:1px solid var(--line);
    position:relative;
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
  }
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

  .cardActions{
    margin-top:auto;
    padding-top:10px;
    display:flex;
    flex-wrap:wrap;
    justify-content:flex-end;
  }

  .btn.small{
    padding:9px 12px;
    font-size:13.5px;
    border-radius:12px;
  }

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

<jsp:include page="/WEB-INF/components/navbar.jsp" />

<main class="page-content">
  <div class="container">

    <div class="headerRow">
      <div>
        <h1>Events</h1>
        <p>Browse upcoming community activities and programmes.</p>
      </div>
    </div>

    <form class="searchCard" method="get" action="<%= request.getContextPath() %>/GetEventList">
      <div class="searchLeft">
        <input class="searchInput" type="text" name="search"
          placeholder="Search by title, description, or location..."
          value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">
        <button class="btn primary" type="submit">Search</button>
        <a class="btn ghost" href="<%= request.getContextPath() %>/GetEventList">Reset</a>
      </div>
    </form>

    <%
      String err = (String) request.getAttribute("err");
      if (err != null) {
    %>
      <div class="msg error">Error loading events. Please try again.</div>
    <%
      }
    %>

    <%
      @SuppressWarnings("unchecked")
      List<Event> events = (List<Event>) request.getAttribute("eventArray");
    		  
      @SuppressWarnings("unchecked")
      Map<Integer, String> startMap = (Map<Integer, String>) request.getAttribute("startTimeDisplayMap");

      @SuppressWarnings("unchecked")
      Map<Integer, String> endMap = (Map<Integer, String>) request.getAttribute("endTimeDisplayMap");


      if (events == null || events.isEmpty()) {
    %>
      <div class="empty">No events found.</div>
    <%
      } else {
    %>

      <div class="grid">
        <%
          for (Event e : events) {
        %>
          <div class="eventCard">
            <div class="eventTop">
              <div class="pill">Event ID: <%= e.getEventId() %></div>
            </div>

            <div class="eventBody">
              <h3 class="eventTitle"><%= e.getTitle() %></h3>
              <p class="eventMeta"><%= e.getLocation() %></p>
              
              <%
				  String startDisplay = (startMap != null) ? startMap.get(e.getEventId()) : null;
				  if (startDisplay == null || startDisplay.isBlank()) startDisplay = "-";
				
				  String endDisplay = (endMap != null) ? endMap.get(e.getEventId()) : null;
				  if (endDisplay == null || endDisplay.isBlank()) endDisplay = "-";
				%>
              
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
              

              <div class="cardActions">
                <a class="btn ghost small"
                   href="<%= request.getContextPath() %>/GetEventList?eventId=<%= e.getEventId() %>">
                  View details
                </a>
              </div>
            </div>
          </div>
        <%
          }
        %>
      </div>

    <%
      }
    %>

  </div>
</main>

<jsp:include page="/WEB-INF/components/footer.jsp" />

</body>
</html>
