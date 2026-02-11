<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="dbaccess.Product"%> <!-- Imports the Product model class for use in this JSP -->
<%@ page import="java.util.Map" %>    <!-- Imports Map so we can read productImageMap from request attributes -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ABC Community Club | Service Details</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
/* 
  CSS variables (theme tokens):
  - Keeps the styling consistent and easy to tweak in one place.
*/
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

/* Global box sizing so padding/borders don't break layout */
* {
	box-sizing: border-box;
}

/* Make the page take full height */
html, body {
	height: 100%;
	margin: 0;
}

/* Default page styling */
body {
	font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial,
		sans-serif;
	background: var(--bg);
	color: var(--text);
}

/* Page structure: navbar top, footer bottom, main grows */
.page-layout {
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}

/* Allows main content to expand and push footer down */
.page-content {
	flex: 1;
}

/* Main container width + padding */
.container {
	max-width: 1100px;
	margin: 0 auto;
	padding: 18px 16px 34px;
}

/* Breadcrumb row + back button row */
.crumbRow {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	flex-wrap: wrap;
	margin-bottom: 14px;
}

/* Left section of breadcrumb area (breadcrumb text) */
.crumbLeft {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

/* Breadcrumb styling */
.crumb {
	color: var(--muted);
	font-size: 13.5px;
}

/* Breadcrumb links (Home / Services) */
.crumb a {
	color: var(--muted);
	text-decoration: none;
	font-weight: 800;
}

.crumb a:hover {
	color: var(--text);
}

/* Base button styling */
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

/* Primary button with gradient + shadow */
.btn.primary {
	background: linear-gradient(135deg, var(--brand), #38bdf8);
	color: #fff;
	box-shadow: 0 10px 18px rgba(14, 165, 233, .18);
}

/* Ghost button (white background + border) */
.btn.ghost {
	background: #fff;
	border: 1px solid var(--line);
	color: var(--text);
}

/* Message banner base styling (used for errors) */
.msg {
	border-radius: 12px;
	padding: 12px 14px;
	font-weight: 800;
	font-size: 13.5px;
	margin-bottom: 14px;
	border: 1px solid;
}

/* Error message colors */
.msg.error {
	color: #991b1b;
	background: #fee2e2;
	border-color: #fecaca;
}

/* Main layout grid: left (details) + right (info/actions) */
.detailsGrid {
	display: grid;
	grid-template-columns: 1.25fr .75fr;
	gap: 14px;
}

/* Responsive: stack into 1 column on smaller screens */
@media ( max-width : 980px) {
	.detailsGrid {
		grid-template-columns: 1fr;
	}
}

/* Card container styling */
.card {
	background: var(--card);
	border: 1px solid var(--line);
	border-radius: var(--radius);
	box-shadow: var(--shadow);
	overflow: hidden;
}

/* "Hero" banner at top of the main card (image area) */
.heroTop {
	height: 140px;
	background: linear-gradient(135deg, rgba(14, 165, 233, .18),
		rgba(34, 197, 94, .18));
	border-bottom: 1px solid var(--line);
	position: relative; /* allows positioning the ID tag on top */
}

/* Service image styling */
.heroTop img { 
	width: 100%;
	height: 100%;
	object-fit: contain; /* keep full image visible without cropping */
	background: #fff;
	display: block;
}

/* Pill tag that displays the service ID on top of the image */
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

/* Body padding of main card */
.cardBody {
	padding: 14px 16px 16px;
}

/* Title row layout (flex) */
.titleRow {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 12px;
	flex-wrap: wrap;
	margin-bottom: 8px;
}

/* Main title */
h1 {
	margin: 0;
	font-size: 22px;
	letter-spacing: .2px;
	line-height: 1.2;
}

/* Category / subline text */
.subline {
	margin: 0;
	color: var(--muted);
	font-size: 14px;
	line-height: 1.4;
	font-weight: 800;
}

/* Description text */
.desc {
	margin: 12px 0 0;
	color: var(--text);
	font-size: 14px;
	line-height: 1.7;
}

/* Right-side card inner padding */
.infoCard {
	padding: 14px 16px 16px;
}

/* Right-side header styling */
.infoCard h2 {
	margin: 0 0 10px;
	font-size: 14px;
	letter-spacing: .2px;
}

/* Info rows container with top border */
.detailsBlock {
	padding-top: 10px;
	border-top: 1px solid var(--line);
	display: grid;
	gap: 8px;
	color: var(--muted);
	font-size: 13.5px;
}

/* One row of label/value */
.detailRow {
	display: flex;
	align-items: baseline;
	gap: 8px;
}

/* Label styling */
.detailLabel {
	font-weight: 800;
	color: #374151;
	min-width: 84px; /* keeps labels aligned */
}

/* Value styling */
.detailValue {
	color: var(--muted);
	word-break: break-word;
}

/* Column of action buttons (Book Now) */
.sideActions {
	margin-top: 14px;
	display: flex;
	flex-direction: column;
	gap: 10px;
}
</style>
</head>

<body class="page-layout">

	<!-- Shared navbar component -->
	<jsp:include page="/WEB-INF/components/navbar.jsp" />

	<main class="page-content">
		<div class="container">

			<!-- Breadcrumb navigation + back button -->
			<div class="crumbRow">
				<div class="crumbLeft">
					<div class="crumb">
						<!-- request.getContextPath() ensures links work even if app is deployed under a different context root -->
						<a href="<%=request.getContextPath()%>/index.jsp">Home</a> / <a
							href="<%=request.getContextPath()%>/GetProductList">Services</a>
						/ Details
					</div>
				</div>

				<!-- Back to Services list -->
				<a class="btn ghost"
					href="<%=request.getContextPath()%>/GetProductList">← Back to
					services</a>
			</div>

			<%
			/*
			  Read data prepared by the servlet/controller and stored in request attributes.

			  Expected attributes:
			  - productImageMap: Map<Integer, String> of productId -> image URL/path
			  - defaultImg: fallback image if no mapping exists
			  - err: error code string (e.g., "NotFound", "InvalidId", "ApiError")
			  - product: Product object to display
			  - productId: (optional) used for display/debug or identifying which product was requested
			*/

			@SuppressWarnings("unchecked")
			Map<Integer, String> productImageMap = (Map<Integer, String>) request.getAttribute("productImageMap"); 
			String defaultImg = (String) request.getAttribute("defaultImg");  

			// If the servlet didn't provide a usable default image, use the app's default file
			if (defaultImg == null || defaultImg.isBlank()) {
			    defaultImg = request.getContextPath() + "/images/services/default.png";
			}

			// Error code string set by backend (if something went wrong)
			String err = (String) request.getAttribute("err");

			// The main data object for this page
			Product product = (Product) request.getAttribute("product");

			// Optional: the productId originally requested (may help show correct ID even if product fails to load)
			Object productIdObj = request.getAttribute("productId");
			String productIdText = (productIdObj != null) ? String.valueOf(productIdObj) : null;

			/*
			  Render logic:
			  1) If there is an error code -> show a friendly error message + return button
			  2) Else if product is null -> show "No service selected"
			  3) Else -> show the product details UI
			*/
			if (err != null) {
				// Default message, then override based on specific error codes
				String msg = "Error loading service details. Please try again.";
				if ("NotFound".equals(err))
					msg = "Service not found.";
				if ("InvalidId".equals(err))
					msg = "Invalid Service ID.";
				if ("ApiError".equals(err))
					msg = "Unable to load service details from API.";
			%>
			<!-- Error UI -->
			<div class="msg error"><%=msg%></div>
			<a class="btn primary"
				href="<%=request.getContextPath()%>/GetProductList">Return to
				services</a>
			<%
			} else if (product == null) {
			%>
			<!-- Product missing (no selection or backend did not pass product) -->
			<div class="msg error">No service selected.</div>
			<a class="btn primary"
				href="<%=request.getContextPath()%>/GetProductList">Return to
				services</a>
			<%
			} else {
			    // Product exists: determine the best image to show
			    int pid = product.getProductId();
			    String imgSrc = defaultImg;

			    // If we have a specific image for this productId, use it; otherwise use default
			    if (productImageMap != null && productImageMap.containsKey(pid)) {
			        imgSrc = productImageMap.get(pid);
			    }
			%>

			<div class="detailsGrid">

				<!-- Main details card (left side) -->
				<div class="card">
					<div class="heroTop">
						<!-- Image source uses resolved imgSrc (mapped image or default image) -->
						<img src="<%= imgSrc %>" alt="Service image" />
						<div class="idTag">
							<!-- Always shows product.getProductId() from the Product object -->
							Service ID:
							<%=product.getProductId()%></div>
					</div>

					<div class="cardBody">
						<div class="titleRow">
							<!-- Service name -->
							<h1><%=product.getName()%></h1>
						</div>

						<!-- Service category -->
						<p class="subline"><%=product.getCategory()%></p>

						<%
						/*
						  Description handling:
						  - If description exists and not blank -> show it
						  - Else -> show a muted "No description provided."
						*/
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

				<!-- Side info card (right side): price, status, and booking action -->
				<div class="card">
					<div class="infoCard">
						<h2>Service info</h2>

						<div class="detailsBlock">
							<div class="detailRow">
								<span class="detailLabel">Price:</span>
								<!-- Format price to 2 decimal places -->
								<span class="detailValue">$<%=String.format("%.2f", product.getPrice())%></span>
							</div>

							<div class="detailRow">
								<span class="detailLabel">Status:</span>
								<!-- Display status based on isActive boolean -->
								<span class="detailValue"><%=product.isActive() ? "Active" : "Inactive"%></span>
							</div>
						</div>

						<div class="sideActions">
							<!-- Booking link includes productId as query parameter -->
							<a class="btn primary"
								href="<%=request.getContextPath()%>/GetProductBookingDetails?productId=<%= product.getProductId() %>">Book
								Now!</a>
						</div>
					</div>
				</div>

			</div>

			<%
			} // end: product exists branch
			%>

		</div>
	</main>

	<!-- Shared footer component -->
	<jsp:include page="/WEB-INF/components/footer.jsp" />

</body>
</html>
