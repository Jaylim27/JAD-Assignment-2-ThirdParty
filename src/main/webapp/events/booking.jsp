<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.Map" %>
<%@ page import="dbaccess.Event" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ABC Community Club | Book Event</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
:root {
  --bg: #f6f8fb;
  --card: #ffffff;
  --text: #1f2937;
  --muted: #6b7280;
  --line: #e5e7eb;
  --brand: #0ea5e9;
  --shadow: 0 10px 30px rgba(0, 0, 0, .08);
  --radius: 16px;
}

* { box-sizing: border-box; }
html, body { height: 100%; margin: 0; }

body {
  font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
  background: var(--bg);
  color: var(--text);
}

.page-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.page-content { flex: 1; }

.container {
  max-width: 1100px;
  margin: 0 auto;
  padding: 18px 16px 34px;
}

.crumbRow {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
  margin-bottom: 14px;
}

.crumbLeft {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.crumb {
  color: var(--muted);
  font-size: 13.5px;
}

.crumb a {
  color: var(--muted);
  text-decoration: none;
  font-weight: 800;
}

.crumb a:hover { color: var(--text); }

.btn {
  border: none;
  cursor: pointer;
  padding: 10px 14px;
  border-radius: 12px;
  font-weight: 800;
  font-size: 14px;
  white-space: nowrap;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.btn.primary {
  background: linear-gradient(135deg, var(--brand), #38bdf8);
  color: #fff;
  box-shadow: 0 10px 18px rgba(14, 165, 233, .18);
}

.btn.ghost {
  background: #fff;
  border: 1px solid var(--line);
  color: var(--text);
}

.msg {
  border-radius: 12px;
  padding: 12px 14px;
  font-weight: 800;
  font-size: 13.5px;
  margin-bottom: 14px;
  border: 1px solid;
}

.msg.error {
  color: #991b1b;
  background: #fee2e2;
  border-color: #fecaca;
}

.msg.success {
  color: #166534;
  background: #dcfce7;
  border-color: #bbf7d0;
}

.bookingGrid {
  display: grid;
  grid-template-columns: 1.25fr .75fr;
  gap: 14px;
}

@media (max-width: 980px) {
  .bookingGrid { grid-template-columns: 1fr; }
}

.card {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  overflow: hidden;
}

.heroTop{
  height: 180px;
  background: linear-gradient(135deg, rgba(14,165,233,.18), rgba(34,197,94,.18));
  border-bottom:1px solid var(--line);
  position:relative;
}
  
.heroTop img{
  width:100%;
  height:100%;
  object-fit:cover;
  display:block;
}

.idTag {
  position: absolute;
  top: 12px;
  left: 12px;
  background: #fff;
  border: 1px solid var(--line);
  border-radius: 999px;
  padding: 6px 10px;
  font-size: 12px;
  font-weight: 900;
  color: var(--muted);
}

.cardBody {
  padding: 14px 16px 16px;
}

.titleRow {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
  margin-bottom: 8px;
}

h1 {
  margin: 0;
  font-size: 22px;
  letter-spacing: .2px;
  line-height: 1.2;
}

.subline {
  margin: 0;
  color: var(--muted);
  font-size: 14px;
  line-height: 1.4;
  font-weight: 800;
}

.desc {
  margin: 12px 0 0;
  color: var(--text);
  font-size: 14px;
  line-height: 1.7;
}

.detailsBlock {
  margin-top: 12px;
  padding-top: 10px;
  border-top: 1px solid var(--line);
  display: grid;
  gap: 8px;
  color: var(--muted);
  font-size: 13.5px;
}

.detailRow {
  display: flex;
  align-items: baseline;
  gap: 8px;
}

.detailLabel {
  font-weight: 800;
  color: #374151;
  min-width: 84px;
}

.detailValue {
  color: var(--muted);
  word-break: break-word;
}

.formCard {
  padding: 14px 16px 16px;
}

.formCard h2 {
  margin: 0 0 14px;
  font-size: 18px;
  letter-spacing: .2px;
}

form { display: grid; gap: 14px; }

.formGroup {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

label {
  font-size: 13.5px;
  font-weight: 800;
  color: var(--text);
}

input {
  padding: 10px 12px;
  border: 1px solid var(--line);
  border-radius: 10px;
  font-size: 14px;
  background: #fff;
  color: var(--text);
}

input:focus {
  outline: none;
  border-color: var(--brand);
}

.formActions {
  margin-top: 10px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
</style>
</head>

<body class="page-layout">

<jsp:include page="/WEB-INF/components/navbar.jsp" />

<main class="page-content">
  <div class="container">

    <%
      // eventId in query string for breadcrumbs/back links
      String eventId = request.getParameter("eventId");
      if (eventId == null || eventId.trim().isEmpty()) {
        Object eventIdObj = request.getAttribute("eventId");
        eventId = (eventIdObj != null) ? String.valueOf(eventIdObj) : "";
      }
    %>

    <div class="crumbRow">
      <div class="crumbLeft">
        <div class="crumb">
          <a href="<%= request.getContextPath() %>/index.jsp">Home</a> /
          <a href="<%= request.getContextPath() %>/GetEventList">Events</a> /
          <a href="<%= request.getContextPath() %>/GetEventList?eventId=<%= eventId %>">Details</a> /
          Booking
        </div>
      </div>

      <a class="btn ghost"
         href="<%= request.getContextPath() %>/GetEventList?eventId=<%= eventId %>">← Back to details</a>
    </div>

    <%
      // From your booking servlet after POST:
      // request.setAttribute("apiStatus", resp.getStatus());
      // request.setAttribute("apiResult", apiResultMap);
      Integer apiStatus = (Integer) request.getAttribute("apiStatus");

      @SuppressWarnings("unchecked")
      Map<String, Object> apiResult = (Map<String, Object>) request.getAttribute("apiResult");

      // Event details (your servlet should load it for the left card)
      String err = (String) request.getAttribute("err");
      Event event = (Event) request.getAttribute("event");
    		  
      String imgSrc = (String) request.getAttribute("imgSrc");
      if (imgSrc == null || imgSrc.isBlank()) {
        imgSrc = request.getContextPath() + "/images/default.png";
      }
      
      String startTimeDisplay = (String) request.getAttribute("startTimeDisplay");
      String endTimeDisplay = (String) request.getAttribute("endTimeDisplay");
      if (startTimeDisplay == null || startTimeDisplay.isBlank())
		startTimeDisplay = "-";
      if (endTimeDisplay == null || endTimeDisplay.isBlank())
        endTimeDisplay = "-";

      // Show success/error banners from apiResult if present
      if (apiStatus != null && apiStatus == 201 && apiResult != null) {
    %>
      <div class="msg success">
        <%= apiResult.get("message") != null ? apiResult.get("message") : "Booking successful." %>
        <%
          if (apiResult.get("bookingId") != null) {
        %>
          <br>Booking ID: <%= apiResult.get("bookingId") %>
        <%
          }
        %>
      </div>
    <%
      } else if (apiResult != null && apiResult.get("error") != null) {
    %>
      <div class="msg error"><%= apiResult.get("error") %></div>
    <%
      }

      if (err != null) {
        String msg = "Error loading booking form. Please try again later.";
        if ("NotFound".equals(err)) msg = "Event not found.";
        if ("InvalidId".equals(err)) msg = "Invalid Event ID.";
        if ("ApiError".equals(err)) msg = "Unable to load event details from API.";
    %>
      <div class="msg error"><%= msg %></div>
      <a class="btn primary" href="<%= request.getContextPath() %>/GetEventList">Return to events</a>
    <%
      } else if (event == null) {
    %>
      <div class="msg error">No event selected.</div>
      <a class="btn primary" href="<%= request.getContextPath() %>/GetEventList">Return to events</a>
    <%
      } else {
    %>

    <div class="bookingGrid">

      <!-- Left: Event summary -->
      <div class="card">
        <div class="heroTop">
          <img src="<%= imgSrc %>" alt="Event image">
          <div class="idTag">Event ID: <%= event.getEventId() %></div>
        </div>

        <div class="cardBody">
          <div class="titleRow">
            <h1>Booking: <%= event.getTitle() %></h1>
          </div>

          <p class="subline"><%= event.getLocation() %></p>

          <%
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

          <div class="detailsBlock">
            <div class="detailRow">
              <span class="detailLabel">Start:</span>
              <span class="detailValue"><%= startTimeDisplay %></span>
            </div>
            <div class="detailRow">
              <span class="detailLabel">End:</span>
              <span class="detailValue"><%= endTimeDisplay %></span>
            </div>
            <div class="detailRow">
              <span class="detailLabel">Capacity:</span>
              <span class="detailValue"><%= event.getCapacity() %></span>
            </div>
          </div>
        </div>
      </div>

      <!-- Right: Booking form -->
      <div class="card">
        <div class="formCard">
          <h2>Guest Information</h2>

          <!-- IMPORTANT:
               Your booking servlet should POST to /services/events/book/{eventId}
               via Jersey client. This JSP should POST to your servlet, NOT directly to the API.
          -->
          <form action="<%= request.getContextPath() %>/GetEventBookingDetails" method="post">
            <input type="hidden" name="eventId" value="<%= event.getEventId() %>">

            <div class="formGroup">
              <label for="guestName">Guest Name</label>
              <input type="text" id="guestName" name="guestName" required>
            </div>

            <div class="formGroup">
              <label for="guestEmail">Guest Email</label>
              <input type="email" id="guestEmail" name="guestEmail" required>
            </div>

            <div class="formActions">
              <button type="submit" class="btn primary">Submit Booking</button>
            </div>
          </form>
        </div>
      </div>

    </div>

    <%
      }
    %>

  </div>
</main>

<jsp:include page="/WEB-INF/components/footer.jsp" />

</body>
</html>
