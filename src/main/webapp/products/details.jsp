<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="dbaccess.Product"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ABC Community Club | Service Details</title>
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

* {
	box-sizing: border-box;
}

html, body {
	height: 100%;
	margin: 0;
}

body {
	font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial,
		sans-serif;
	background: var(--bg);
	color: var(--text);
}

.page-layout {
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}

.page-content {
	flex: 1;
}

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

.crumb a:hover {
	color: var(--text);
}

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

.detailsGrid {
	display: grid;
	grid-template-columns: 1.25fr .75fr;
	gap: 14px;
}

@media ( max-width : 980px) {
	.detailsGrid {
		grid-template-columns: 1fr;
	}
}

.card {
	background: var(--card);
	border: 1px solid var(--line);
	border-radius: var(--radius);
	box-shadow: var(--shadow);
	overflow: hidden;
}

.heroTop {
	height: 140px;
	background: linear-gradient(135deg, rgba(14, 165, 233, .18),
		rgba(34, 197, 94, .18));
	border-bottom: 1px solid var(--line);
	position: relative;
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

.infoCard {
	padding: 14px 16px 16px;
}

.infoCard h2 {
	margin: 0 0 10px;
	font-size: 14px;
	letter-spacing: .2px;
}

.detailsBlock {
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

.sideActions {
	margin-top: 14px;
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

			<div class="crumbRow">
				<div class="crumbLeft">
					<div class="crumb">
						<a href="<%=request.getContextPath()%>/index.jsp">Home</a> / <a
							href="<%=request.getContextPath()%>/GetProductList">Services</a>
						/ Details
					</div>
				</div>

				<a class="btn ghost"
					href="<%=request.getContextPath()%>/GetProductList">← Back to
					services</a>
			</div>

			<%
			String err = (String) request.getAttribute("err");
			Product product = (Product) request.getAttribute("product");
			Object productIdObj = request.getAttribute("productId");
			String productIdText = (productIdObj != null) ? String.valueOf(productIdObj) : null;

			if (err != null) {
				String msg = "Error loading service details. Please try again.";
				if ("NotFound".equals(err))
					msg = "Service not found.";
				if ("InvalidId".equals(err))
					msg = "Invalid Service ID.";
				if ("ApiError".equals(err))
					msg = "Unable to load service details from API.";
			%>
			<div class="msg error"><%=msg%></div>
			<a class="btn primary"
				href="<%=request.getContextPath()%>/GetProductList">Return to
				services</a>
			<%
			} else if (product == null) {
			%>
			<div class="msg error">No service selected.</div>
			<a class="btn primary"
				href="<%=request.getContextPath()%>/GetProductList">Return to
				services</a>
			<%
			} else {
			%>

			<div class="detailsGrid">

				<!-- Main details -->
				<div class="card">
					<div class="heroTop">
						<div class="idTag">
							Service ID:
							<%=product.getProductId()%></div>
					</div>

					<div class="cardBody">
						<div class="titleRow">
							<h1><%=product.getName()%></h1>
						</div>

						<p class="subline"><%=product.getCategory()%></p>

						<%
						String desc = product.getDescription();
						if (desc != null && !desc.trim().isEmpty()) {
						%>
						<p class="desc"><%=desc%></p>
						<%
						} else {
						%>
						<p class="desc" style="color: var(--muted);">No description
							provided.</p>
						<%
						}
						%>
					</div>
				</div>

				<!-- Side info -->
				<div class="card">
					<div class="infoCard">
						<h2>Service info</h2>

						<div class="detailsBlock">
							<div class="detailRow">
								<span class="detailLabel">Price:</span> <span
									class="detailValue">$<%=String.format("%.2f", product.getPrice())%></span>
							</div>

							<div class="detailRow">
								<span class="detailLabel">Status:</span> <span
									class="detailValue"><%=product.isActive() ? "Active" : "Inactive"%></span>
							</div>
						</div>

						<div class="sideActions">
							<a class="btn primary"
								href="<%=request.getContextPath()%>/GetProductBookingDetails?productId=<%= product.getProductId() %>">Book
								Now!</a>
						</div>
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
