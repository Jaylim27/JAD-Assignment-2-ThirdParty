package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.IOException;
import java.util.ArrayList;

import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;

import dbaccess.Product;

/**
 * Servlet implementation class Checkout
 */
@WebServlet("/Checkout")
public class Checkout extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Checkout() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get product details
		String productId = request.getParameter("productId");
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String dob = request.getParameter("dob");
		String gender = request.getParameter("gender");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String timeslot = request.getParameter("timeslot");
		
		Client client = ClientBuilder.newClient();
		
		String restUrl = "http://localhost:8081/services/" + productId;
		WebTarget target = client.target(restUrl);
		Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
		Response resp = invocationBuilder.get();
		Product product = resp.readEntity(Product.class);

		double GST = 0.09; // GST multiplier
		double priceAfterGST = 0;
		Stripe.apiKey = System.getenv("STRIPE_SECRET_KEY");

		try {
			// Build line items from cart (convert price to cents)
			ArrayList<SessionCreateParams.LineItem> lineItems = new ArrayList<>();
			
			priceAfterGST = (double) product.getPrice() * (1 + GST);
			long priceInCents = (long) priceAfterGST * 100;
			
			lineItems.add(
			    SessionCreateParams.LineItem.builder()
			        .setPriceData(
			            SessionCreateParams.LineItem.PriceData.builder()
			                .setCurrency("sgd")
			                .setUnitAmount(priceInCents)
			                .setProductData(
			                    SessionCreateParams.LineItem.PriceData.ProductData.builder()
			                        .setName(product.getName())
			                        .build())
			                .build())
			        .setQuantity((long) 1)
			        .build());

			String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			    + request.getContextPath();
			String successUrl = baseUrl + "/PaymentSuccess?stripeSessionId={CHECKOUT_SESSION_ID}";
			String cancelUrl = baseUrl + "/products?stripeSessionId={CHECKOUT_SESSION_ID}";

			// Create Checkout Session
			SessionCreateParams params = SessionCreateParams.builder()
			    .addPaymentMethodType(SessionCreateParams.PaymentMethodType.CARD)
			    .setMode(SessionCreateParams.Mode.PAYMENT)
			    .setSuccessUrl(successUrl)
			    .setCancelUrl(cancelUrl)
			    .addAllLineItem(lineItems)
			    .build();

			Session session = Session.create(params);
			
			HttpSession httpSession = request.getSession();
			httpSession.setAttribute("total", priceAfterGST);
			httpSession.setAttribute("productId", productId);
			httpSession.setAttribute("firstName", firstName);
			httpSession.setAttribute("lastName", lastName);
			httpSession.setAttribute("dob", dob);
			httpSession.setAttribute("gender", gender);
			httpSession.setAttribute("phone", phone);
			httpSession.setAttribute("email", email);
			httpSession.setAttribute("timeslot", timeslot);
			
			response.sendRedirect(session.getUrl());
			
		} catch (StripeException e) {
			e.printStackTrace();
			request.setAttribute("error", "Payment error: " + e.getMessage());
			request.getRequestDispatcher("/WEB-INF/components/product/viewCart.jsp").forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Internal server error");
			request.getRequestDispatcher("/WEB-INF/components/product/viewCart.jsp").forward(request, response);
		}
	}

}
