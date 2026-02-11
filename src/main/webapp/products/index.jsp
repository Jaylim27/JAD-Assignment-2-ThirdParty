<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>     <!-- Import List to hold the list of Product objects from the servlet -->
<%@ page import="dbaccess.Product" %>   <!-- Import Product model for displaying service data -->
<%@ page import="java.util.Map" %>      <!-- Import Map to hold productId -> image URL mappings -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ABC Community Club | Services</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
  /*
    CSS variables (theme tokens) so colors and spacing are consistent across the page.
  */
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

  /* Global box sizing and full-height layout */
  *{ box-sizing:border-box; }
  html, body { height:100%; margin:0; }

  /* Base page styling */
  body{
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    background: var(--bg);
    color: var(--text);
  }

  /*
    Page layout uses flex so:
    - navbar stays at top
    - footer stays at bottom
    - main content expands in between
  */
  .page-layout{
    min-height:100vh;
    display:flex;
    flex-direction:column;
  }
  .page-content{ flex:1; }

  /* Centered container */
  .container{
    max-width:1100px;
    margin:0 auto;
    padding: 18px 16px 34px;
  }

  /* Page header layout */
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
  }
  .headerRow p{
    margin:6px 0 0;
    color:var(--muted);
    font-size:13.5px;
  }

  /*
    Search card:
    Contains search input + Search button + Reset link.
    Uses flex wrapping so it stays responsive.
  */
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

  /* Search input styling */
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

  /* Base button styles */
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
  }
  .btn.ghost{
    background:#fff;
    border:1px solid var(--line);
    color:var(--text);
  }

  /* Error/info message component */
  .msg{
    border-radius: 12px;
    padding: 12px 14px;
    font-weight:800;
    font-size:13.5px;
    margin-bottom:14px;
    border:1px solid;
  }
  .msg.error{
    color:#991b1b;
    background:#fee2e2;
    border-color:#fecaca;
  }

  /*
    Services grid layout:
    - 3 columns desktop
    - 2 columns tablet
    - 1 column mobile
  */
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

  /* Card styling for each service */
  .serviceCard{
    background: var(--card);
    border:1px solid var(--line);
    border-radius: var(--radius);
    box-shadow: 0 10px 20px rgba(0,0,0,.05);
    overflow:hidden;
    display:flex;
    flex-direction:column;
    min-height: 240px;
  }

  /* Top image area */
  .serviceTop{
    height: 200px;
    background: linear-gradient(135deg, rgba(14,165,233,.18), rgba(34,197,94,.18));
    border-bottom:1px solid var(--line);
    position:relative;
  }

  /* Service image fills the top block */
  .serviceTop img{
    width:100%;
    height:100%;
    object-fit:fill;
    display:block;
  }

  /* Service card body layout */
  .serviceBody{
    padding: 12px 14px 14px;
    display:flex;
    flex-direction:column;
    gap:8px;
    flex:1;
  }

  .serviceTitle{
    margin:0;
    font-size:16px;
    font-weight:900;
    line-height:1.2;
  }

  .serviceCategory{
    margin:0;
    color:var(--muted);
    font-size:13px;
    font-weight:800;
  }

  .serviceDesc{
    margin:0;
    color:var(--muted);
    font-size:13.5px;
    line-height:1.5;
  }

  /* Details section (e.g., price) */
  .detailsBlock{
    margin-top:8px;
    padding-top:10px;
    border-top:1px solid var(--line);
    display:grid;
    gap:6px;
    font-size:13.5px;
  }

  .detailRow{
    display:flex;
    gap:8px;
    align-items:flex-start;
  }
  .detailLabel{
    font-weight:900;
    min-width:70px;
    color:#374151;
  }
  .detailValue{
    color:var(--muted);
    word-break:break-word;
  }

  /* Card actions pinned to bottom by using margin-top:auto above */
  .cardActions{
    margin-top:auto;
    padding-top:10px;
    display:flex;
    justify-content:flex-end;
  }

  /* Smaller button variant */
  .btn.small{
    padding:9px 12px;
    font-size:13.5px;
    border-radius:12px;
  }

  /* Empty state container */
  .empty{
    background: var(--card);
    border:1px dashed var(--line);
    border-radius: var(--radius);
    padding:18px;
    color:var(--muted);
  }
</style>
</head>

<body class="page-layout">

<!-- Shared navbar component -->
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<main class="page-content">
  <div class="container">

    <!-- Page title -->
    <div class="headerRow">
      <div>
        <h1>Services</h1>
        <p>Browse community services and offerings.</p>
      </div>
    </div>

    <!--
      Search form:
      - method="get" so search shows up in the URL as a query string (?search=...)
      - action points to the servlet that loads the product list
      - Reset link calls the same servlet without search parameter
    -->
    <form class="searchCard" method="get" action="<%= request.getContextPath() %>/GetProductList">
      <div class="searchLeft">

        <!-- 
          Search input:
          - Name "search" must match what your servlet expects (request.getParameter("search"))
          - Value uses request attribute "search" (likely set by servlet to preserve typed text)
        -->
        <input class="searchInput" type="text" name="search"
          placeholder="Search by name, category..."
          value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">

        <!-- Submit triggers GET /GetProductList?search=... -->
        <button class="btn primary" type="submit">Search</button>

        <!-- Reset clears filters by going to servlet without params -->
        <a class="btn ghost" href="<%= request.getContextPath() %>/GetProductList">Reset</a>
      </div>
    </form>

    <%
      /*
        Error banner:
        If the servlet set "err" in request scope, show an error message.
        (The actual err codes/meaning depends on your servlet.)
      */
      String err = (String) request.getAttribute("err");
      if (err != null) {
    %>
      <div class="msg error">Error loading services.</div>
    <%
      }
    %>

    <%
      /*
        Read data prepared by the servlet:

        - "ProductArray": expected to be List<Product> (the list of services to display)
        - "productImageMap": Map<Integer, String> mapping productId -> image URL/path
        - "defaultImg": fallback image URL/path if no entry exists in productImageMap

        Note: These are request attributes (set by servlet via request.setAttribute()).
      */
      @SuppressWarnings("unchecked")
      List<Product> services = (List<Product>) request.getAttribute("ProductArray");
    
      @SuppressWarnings("unchecked")
      Map<Integer, String> imageMap = (Map<Integer, String>) request.getAttribute("productImageMap");

      String defaultImg = (String) request.getAttribute("defaultImg");

      /*
        Rendering logic:
        - If services list is null/empty -> show empty state
        - Else -> render a grid of service cards
      */
      if (services == null || services.isEmpty()) {
    %>
      <div class="empty">No services found.</div>
    <%
      } else {
    %>

      <div class="grid">
        <%
          /*
            Loop through all Product items and build a UI card for each service.
          */
          for (Product s : services) {
        	  
          // Determine which image to show:
          // - Use defaultImg by default
          // - If imageMap contains this productId, use that mapped image instead
          String imgSrc = defaultImg;
          if (imageMap != null && imageMap.containsKey(s.getProductId())) {
            imgSrc = imageMap.get(s.getProductId());
          }
        %>
          <div class="serviceCard">
            <div class="serviceTop">
            	<!-- Service image (either mapped or default) -->
            	<img src="<%= imgSrc %>" alt="Service image">
            </div>

            <div class="serviceBody">
              <!-- Service name -->
              <h3 class="serviceTitle"><%= s.getName() %></h3>

              <!-- Service category -->
              <p class="serviceCategory"><%= s.getCategory() %></p>

              <!-- Service description with fallback if empty -->
              <p class="serviceDesc">
                <%= (s.getDescription() != null && !s.getDescription().trim().isEmpty())
                      ? s.getDescription()
                      : "No description available." %>
              </p>

              <!-- Additional details block (currently only price) -->
              <div class="detailsBlock">
                <div class="detailRow">
                  <span class="detailLabel">Price:</span>
                  <!-- Displays price directly; formatting depends on getPrice() type -->
                  <span class="detailValue">$<%= s.getPrice() %></span>
                </div>
              </div>

              <div class="cardActions">
                <!--
                  "View details" link:
                  Sends productId as a query parameter.
                -->
                <a class="btn ghost small"
                   href="<%= request.getContextPath() %>/GetProductList?productId=<%= s.getProductId() %>">
                  View details
                </a>
              </div>
            </div>
          </div>
        <%
          } // end for loop
        %>
      </div>

    <%
      } // end else (services exists)
    %>

  </div>
</main>

<!-- Shared footer component -->
<jsp:include page="/WEB-INF/components/footer.jsp" />

</body>
</html>
