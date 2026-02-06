<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style>
  header{
    position:sticky;
    top:0;
    z-index:10;
    background:rgba(246,248,251,.85);
    backdrop-filter: blur(10px);
    border-bottom:1px solid #e5e7eb;
  }
  .nav{
    max-width:1100px;
    margin:0 auto;
    padding:14px 16px;
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:16px;
  }
  .brand{
    display:flex;
    align-items:center;
    gap:10px;
    text-decoration:none;
    color:#1f2937;
  }
  .logo{
	width:38px; height:38px;
	border-radius:12px;
	overflow:hidden;
	display:grid;
	place-items:center;
	background:#fff;
	border:1px solid #e5e7eb;
  }
  .logo img{
	width:100%;
	height:100%;
	object-fit:fill;
	display:block;
  }
  .brand .title{
    display:flex;
    flex-direction:column;
    line-height:1.1;
  }
  .brand .title strong{ font-size:15px; }
  .brand .title span{ font-size:12px; color:#6b7280; }

  .navlinks{
    display:flex;
    gap:14px;
    align-items:center;
    flex-wrap:wrap;
  }
  .navlinks a{
    text-decoration:none;
    color:#6b7280;
    font-weight:700;
    font-size:14px;
    padding:8px 10px;
    border-radius:10px;
  }
  .navlinks a:hover{ background:#fff; color:#1f2937; border:1px solid #e5e7eb; }

  /* Optional: highlight current page using request URI */
  .navlinks a.active{
    background:#fff;
    color:#1f2937;
    border:1px solid #e5e7eb;
  }
</style>

<%
  String uri = request.getRequestURI();
  String ctx = request.getContextPath();

  boolean isHome = false;
  boolean isEvents = false;
  boolean isServices = false;

  if (uri != null) {
    // Home ONLY if exactly the app root or /index.jsp
    if (uri.equals(ctx + "/") || uri.equals(ctx + "/index.jsp")) {
      isHome = true;

    // Events if servlet path OR events folder pages
    } else if (uri.startsWith(ctx + "/GetEventList") || uri.startsWith(ctx + "/events/")) {
      isEvents = true;

    // Services if services folder pages (adjust path if needed)
    } else if (uri.startsWith(ctx + "/services/")) {
      isServices = true;
    }
  }
%>


<header>
  <div class="nav">
    <a class="brand" href="<%= request.getContextPath() %>/index.jsp">
      <div class="logo">
      <img src="<%=request.getContextPath()%>/images/ABClogo.png" alt="ABC Community Club logo">
      </div>
      <div class="title">
        <strong>ABC Community Club</strong>
        <span>Home • Events • Services</span>
      </div>
    </a>

    <nav class="navlinks">
      <a class="<%= isHome ? "active" : "" %>" href="<%= request.getContextPath() %>/index.jsp">Home</a>
      <a class="<%= isEvents ? "active" : "" %>" href="<%= request.getContextPath() %>/GetEventList">Events</a>
      <a class="<%= isServices ? "active" : "" %>" href="<%= request.getContextPath() %>/GetProductList">Services</a>
    </nav>
  </div>
</header>
