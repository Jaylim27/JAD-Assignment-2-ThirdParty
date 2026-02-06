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
		
		HttpSession httpSession = request.getSession();
		double total = (double) httpSession.getAttribute("total");
		String productId = (String) httpSession.getAttribute("productId");
		String firstName = (String) httpSession.getAttribute("firstName");
		String lastName = (String) httpSession.getAttribute("lastName");
		String dob = (String) httpSession.getAttribute("dob");
		String gender = (String) httpSession.getAttribute("gender");
		String phone = (String) httpSession.getAttribute("phone");
		String email = (String) httpSession.getAttribute("email");
		String timeslot = (String) httpSession.getAttribute("timeslot");
		
		Map<String, String> bookingData = new HashMap<>();
    bookingData.put("firstName", firstName);
    bookingData.put("lastName", lastName);
    bookingData.put("dob", dob);
    bookingData.put("gender", gender);
    bookingData.put("phone", phone);
    bookingData.put("email", email);
    bookingData.put("timeslot", timeslot);
		
		Client client = ClientBuilder.newClient();
		String url = "http://localhost:8081/services/book/" + productId;
		WebTarget target = client.target(url);
		Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
		
		Response resp = invocationBuilder.post(Entity.json(bookingData));
		
		if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
			httpSession.invalidate();
			
			request.setAttribute("total", total);
			
			RequestDispatcher rd = request.getRequestDispatcher("products/payment-success.jsp");
			rd.forward(request, response);
		} else {
			RequestDispatcher rd = request.getRequestDispatcher("products/index.jsp");
			rd.forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
