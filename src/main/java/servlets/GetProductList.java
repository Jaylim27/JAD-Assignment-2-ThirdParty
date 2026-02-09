package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;         
import java.util.Map; 

import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.client.Invocation;

import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.GenericType;
import dbaccess.Product;

/**
 * Servlet implementation class GetProductList
 */
@WebServlet("/GetProductList")
public class GetProductList extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    /* =========================
    Product Image Map
    ========================= */
	private Map<Integer, String> buildProductImageMap(HttpServletRequest request) {  // CHANGED: new helper
     Map<Integer, String> m = new HashMap<>();
     String p = request.getContextPath() + "/images/services/";

     m.put(1,  p + "personalCare.png");        // Personal Care – 2H
     m.put(2,  p + "personalCare.png");        // Personal Care – 4H
     m.put(3,  p + "medicalMonitoring.png");   // Medical Monitoring – 4H
     m.put(4,  p + "medication.png");          // Medication Management
     m.put(5,  p + "companionship.png");       // Companionship – 2H
     m.put(6,  p + "companionship.png");       // Companionship – 4H
     m.put(7,  p + "housekeeping.png");        // Light Housekeeping
     m.put(8,  p + "mealPrep.png");            // Meal Preparation
     m.put(9,  p + "transportMed.png");        // Medical Transport
     m.put(10, p + "transportShop.png");       // Shopping Transport

     return m;
 }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String search = request.getParameter("search");
		String productIdStr = request.getParameter("productId");

		Client client = ClientBuilder.newClient();

		try {
			// ===========================
			// 1) GET Product BY ID
			// ===========================

			if (productIdStr != null && !productIdStr.trim().isEmpty()) {
				int productId;

				try {
					productId = Integer.parseInt(productIdStr.trim());
				} catch (NumberFormatException ex) {
					request.setAttribute("err", "InvalidId");
					RequestDispatcher rd = request.getRequestDispatcher("products/details.jsp");
					rd.forward(request, response);
					return;
				}

				String restUrl = "http://localhost:8081/services/" + productId;
				WebTarget target = client.target(restUrl);

				Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
				Response resp = invocationBuilder.get();

				System.out.println("GET BY ID status: " + resp.getStatus());

				if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
					Product product = resp.readEntity(Product.class);

					request.setAttribute("product", product);
					request.setAttribute("productId", productId);
					
				    request.setAttribute("productImageMap", buildProductImageMap(request));
				    request.setAttribute("defaultImg", request.getContextPath() + "/images/services/default.png");

					RequestDispatcher rd = request.getRequestDispatcher("products/details.jsp");
					rd.forward(request, response);
					return;
				} else if (resp.getStatus() == Response.Status.NOT_FOUND.getStatusCode()) {
					request.setAttribute("err", "NotFound");
					request.setAttribute("productId", productId);

					RequestDispatcher rd = request.getRequestDispatcher("products/details.jsp");
					rd.forward(request, response);
					return;
				} else {
					request.setAttribute("err", "ApiError");
					request.setAttribute("productId", productId);

					RequestDispatcher rd = request.getRequestDispatcher("products/details.jsp");
					rd.forward(request, response);
					return;
				}
			}

			// ===========================
			// 2) GET ALL PRODUCTS
			// ===========================
			String restUrl = "http://localhost:8081/services";
			WebTarget target = client.target(restUrl);

			if (search != null && !search.trim().isEmpty()) {
				target = target.queryParam("search", search.trim());
			}

			Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
			Response resp = invocationBuilder.get();

			System.out.println("GET ALL status: " + resp.getStatus());

			if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
				ArrayList<Product> products = resp.readEntity(new GenericType<ArrayList<Product>>() {
				});

				request.setAttribute("ProductArray", products);
				request.setAttribute("search", search);
				
                request.setAttribute("productImageMap", buildProductImageMap(request));
                request.setAttribute("defaultImg",
                request.getContextPath() + "/images/services/default.png");

				RequestDispatcher rd = request.getRequestDispatcher("products/index.jsp");
				rd.forward(request, response);

			} else {
				request.setAttribute("err", "NotFound");
				request.setAttribute("search", search);

				RequestDispatcher rd = request.getRequestDispatcher("products/index.jsp");
				rd.forward(request, response);
			}

		} catch (Exception e) {
			e.printStackTrace();

			request.setAttribute("err", "ServerError");

			// If you were trying to load a single event, go details; else go index.
			if (productIdStr != null && !productIdStr.trim().isEmpty()) {
				RequestDispatcher rd = request.getRequestDispatcher("products/details.jsp");
				rd.forward(request, response);
			} else {
				RequestDispatcher rd = request.getRequestDispatcher("products/index.jsp");
				rd.forward(request, response);
			}
		} finally {
			try {
				client.close();
			} catch (Exception ignored) {
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
