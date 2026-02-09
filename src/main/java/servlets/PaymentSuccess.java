package servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import dbaccess.Product;
import dbaccess.Timeslot;

/**
 * Servlet implementation class PaymentSuccess
 */
@WebServlet("/PaymentSuccess")
public class PaymentSuccess extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public PaymentSuccess() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String stripeSessionId = (String) request.getParameter("stripeSessionId");
		if (stripeSessionId == null) {
			response.sendRedirect(request.getContextPath() + "/");
			return;
		}
		
		String url;
		WebTarget target;
		Invocation.Builder invocationBuilder;
		
		HttpSession httpSession = request.getSession();
		double total = (double) httpSession.getAttribute("total");
		String productId = (String) httpSession.getAttribute("productId");
		String firstName = (String) httpSession.getAttribute("firstName");
		String lastName = (String) httpSession.getAttribute("lastName");
		String dob = (String) httpSession.getAttribute("dob");
		String gender = (String) httpSession.getAttribute("gender");
		String phone = (String) httpSession.getAttribute("phone");
		String email = (String) httpSession.getAttribute("email");
		String timeslotId = (String) httpSession.getAttribute("timeslot");
		
		Client client = ClientBuilder.newClient();
		url = "http://localhost:8081/services/timeslots/" + timeslotId;
		target = client.target(url);
		invocationBuilder = target.request(MediaType.APPLICATION_JSON);
		Response timeslotData = invocationBuilder.get();
		Timeslot timeslot = timeslotData.readEntity(Timeslot.class);
		Map<String, String> bookingData = new HashMap<>();
    bookingData.put("firstName", firstName);
    bookingData.put("lastName", lastName);
    bookingData.put("dob", dob);
    bookingData.put("gender", gender);
    bookingData.put("phone", phone);
    bookingData.put("email", email);
    String datePart = timeslot.getAvailabilityDate() != null ?
        timeslot.getAvailabilityDate().substring(0, 10) : "N/A";
    bookingData.put("bookingTimeslot", datePart + " " + timeslot.getStartTime());
    bookingData.put("caregiverId", timeslot.getCaregiverId() + "");
    
    System.out.println(bookingData);
		
		url = "http://localhost:8081/services/book/" + productId;
		target = client.target(url);
		invocationBuilder = target.request(MediaType.APPLICATION_JSON);
		Response bookingResp = invocationBuilder.post(Entity.json(bookingData));
		
		System.out.println("POST /booking: " + bookingResp.getStatus());
		
		if (bookingResp.getStatus() == Response.Status.CREATED.getStatusCode()) {
			request.setAttribute("total", total);
			RequestDispatcher rd = request.getRequestDispatcher("products/payment-success.jsp");
			rd.forward(request, response);
		} else {
			RequestDispatcher rd = request.getRequestDispatcher("/GetProductList");
			rd.forward(request, response);
		}
		
		httpSession.invalidate();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
