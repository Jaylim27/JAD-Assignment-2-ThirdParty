<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Booking Confirmed | ABC Silver Care</title>
<style>

/* Global Resets & Base */
* {
  box-sizing: border-box;
}

html, body {
  height: 100%;
  margin: 0;
  padding: 0;
}

body {
  font-family: system-ui, -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
  background: var(--bg);
  color: var(--text);
  line-height: 1.5;
}

/* Layout */
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
  padding: 20px 16px 40px;
}

/* Breadcrumbs */
.crumbRow {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
  margin-bottom: 20px;
}

.crumb {
  color: var(--muted);
  font-size: 13.5px;
  font-weight: 600;
}

.crumb a {
  color: var(--muted);
  text-decoration: none;
  font-weight: 800;
}

.crumb a:hover {
  color: var(--text);
}

/* Buttons */
.btn {
  border: none;
  cursor: pointer;
  padding: 10px 18px;
  border-radius: 12px;
  font-weight: 800;
  font-size: 14px;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: var(--transition);
}

.btn.primary {
  background: linear-gradient(135deg, var(--brand), #38bdf8);
  box-shadow: 0 8px 16px rgba(14, 165, 233, 0.18);
}

.btn.primary:hover {
  background: linear-gradient(135deg, var(--brand-dark), var(--brand));
  transform: translateY(-1px);
  box-shadow: 0 12px 24px rgba(14, 165, 233, 0.25);
}

/* Cards */
.card {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  overflow: hidden;
}

.cardBody {
  padding: 28px 24px;
  text-align: center;
}

/* Messages / Success styling */
.success-icon {
  font-size: 80px;
  color: var(--success);
  margin-bottom: 20px;
  line-height: 1;
}

h1 {
  margin: 0 0 12px;
  font-size: 28px;
}

.subline {
  margin: 0 0 24px;
  color: var(--muted);
  font-size: 16px;
}

.success-subline {
  font-size: 16px;
  margin: 0 0 32px;
}

/* Summary Box */
.summary-box {
  background: #f9fafb;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  padding: 24px;
  margin: 32px auto;
  max-width: 500px;
}

.summary-box h2 {
  font-size: 18px;
  margin: 0 0 20px;
  color: var(--text);
}

.detailsBlock {
  display: grid;
  gap: 12px;
  font-size: 14px;
  color: var(--muted);
}

.detailRow {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.detailLabel {
  font-weight: 700;
  color: var(--text);
}

.detailValue {
  font-weight: 600;
  color: var(--muted);
}

/* Next Steps */
.next-steps {
  margin: 32px 0;
  color: var(--muted);
}

.next-steps p {
  font-weight: 600;
  margin-bottom: 12px;
}

.next-steps ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.next-steps li {
  margin-bottom: 10px;
  padding-left: 24px;
  position: relative;
}

/* Action Buttons */
.formActions {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  justify-content: center;
  margin-top: 32px;
}
</style>
</head>
<body class="page-layout">

	<jsp:include page="/WEB-INF/components/navbar.jsp" />

	<main class="page-content">
		<div class="container">

			<!-- Breadcrumbs -->
			<div class="crumbRow">
				<div class="crumbLeft">
					<div class="crumb">
						<a href="${pageContext.request.contextPath}/index.jsp">Home</a> /
						<a href="${pageContext.request.contextPath}/GetProductList">Services</a>
						/ Payment Success
					</div>
				</div>
			</div>

			<!-- Success Message Card -->
			<div class="card success-card">
				<div class="cardBody text-center">
					<div class="success-icon">✓</div>
					<h1>Booking Confirmed!</h1>
					<p class="subline success-subline">
						Thank you for choosing ABC Silver Care.<br> Your payment was
						successful and your care service has been booked.
					</p>

					<!-- Booking Summary -->
					<div class="summary-box">
						<h2>Booking Total</h2>

						<div class="detailsBlock">
							<div class="detailRow">
								<span class="detailLabel">Amount Paid:</span> <span
									class="detailValue"> SGD <%=request.getAttribute("total")%>
								</span>
							</div>
						</div>
					</div>

					<!-- Next Steps -->
					<div class="next-steps">
						<p>What happens next?</p>
						<ul>
							<li>You will receive a confirmation email shortly.</li>
							<li>Our team will contact you to confirm details.</li>
							<li>You can view your booking history in your account.</li>
						</ul>
					</div>

					<!-- Action Buttons -->
					<div class="formActions">
						<a href="${pageContext.request.contextPath}/GetProductList"
							class="btn primary">Browse More Services</a>
					</div>
				</div>
			</div>

		</div>
	</main>

	<jsp:include page="/WEB-INF/components/footer.jsp" />

</body>
</html>