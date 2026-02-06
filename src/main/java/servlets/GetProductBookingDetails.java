package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import dbaccess.Product;
import dbaccess.Timeslot;

/**
 * Servlet implementation class GetBookingForm
 */
@WebServlet("/GetProductBookingDetails")
public class GetProductBookingDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String productIdStr = request.getParameter("productId");

		Client client = ClientBuilder.newClient();

		try {
			if (productIdStr == null || productIdStr.trim().isEmpty()) {
				request.setAttribute("err", "InvalidId");
				RequestDispatcher rd = request.getRequestDispatcher("products/booking.jsp");
				rd.forward(request, response);
				return;
			}

			int productId = Integer.parseInt(productIdStr.trim());
			Invocation.Builder invocationBuilder = null;

			String restUrl = "http://localhost:8081/services/" + productId;
			WebTarget target = client.target(restUrl);

			invocationBuilder = target.request(MediaType.APPLICATION_JSON);
			Response resp = invocationBuilder.get();

			System.out.println("GET BY ID status: " + resp.getStatus());

			String timeslotRestUrl = "http://localhost:8081/services/" + productId + "/timeslots";
			WebTarget timeslotTarget = client.target(timeslotRestUrl);
			invocationBuilder = timeslotTarget.request(MediaType.APPLICATION_JSON);
			Response timeslotResp = invocationBuilder.get();

			System.out.println("GET timeslots BY ID status: " + timeslotResp.getStatus());

			if (resp.getStatus() == Response.Status.OK.getStatusCode()
			    && timeslotResp.getStatus() == Response.Status.OK.getStatusCode()) {
				Product product = resp.readEntity(Product.class);
				
		    ArrayList<Timeslot> timeslots = timeslotResp.readEntity(
		        new GenericType<ArrayList<Timeslot>>() {}
		    );

				request.setAttribute("product", product);
				request.setAttribute("timeslots", timeslots);
				request.setAttribute("productId", productId);

				RequestDispatcher rd = request.getRequestDispatcher("products/booking.jsp");
				rd.forward(request, response);
			} else if (resp.getStatus() == Response.Status.NOT_FOUND.getStatusCode()) {
				request.setAttribute("err", "NotFound");
				request.setAttribute("productId", productId);

				RequestDispatcher rd = request.getRequestDispatcher("products/booking.jsp");
				rd.forward(request, response);
			} else if (timeslotResp.getStatus() == Response.Status.NOT_FOUND.getStatusCode()) {
				request.setAttribute("err", "NotFound");
				request.setAttribute("productId", productId);

				RequestDispatcher rd = request.getRequestDispatcher("products/booking.jsp");
				rd.forward(request, response);
			} else {
				request.setAttribute("err", "ApiError");
				request.setAttribute("productId", productId);

				RequestDispatcher rd = request.getRequestDispatcher("products/booking.jsp");
				rd.forward(request, response);
			}

		} catch (NumberFormatException ex) {
			request.setAttribute("err", "InvalidId");
			RequestDispatcher rd = request.getRequestDispatcher("products/booking.jsp");
			rd.forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("err", "ServerError");
			RequestDispatcher rd = request.getRequestDispatcher("products/booking.jsp");
			rd.forward(request, response);
		} finally {
			try {
				client.close();
			} catch (Exception ignored) {
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}