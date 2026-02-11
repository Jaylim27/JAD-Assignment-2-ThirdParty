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
	// Helper method to map productId -> image path, so JSP can show an image per product.
	// Uses request.getContextPath() so the generated URLs work regardless of deployment context.
	private Map<Integer, String> buildProductImageMap(HttpServletRequest request) {  // CHANGED: new helper
     Map<Integer, String> m = new HashMap<>();
     // Base directory for service images inside the webapp
     String p = request.getContextPath() + "/images/services/";

     // Mapping for each product ID
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

     // Return the completed map to be stored as a request attribute
     return m;
 }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Optional search keyword used when listing products
		String search = request.getParameter("search");

		// Optional product ID used to load the details page
		String productIdStr = request.getParameter("productId");

		// Create a JAX-RS client for calling the backend REST service
		Client client = ClientBuilder.newClient();

		try {
			// ===========================
			// 1) GET Product BY ID
			// ===========================
			// If productId is provided, this request will load a single product details page.
			if (productIdStr != null && !productIdStr.trim().isEmpty()) {
				int productId;

				// Validate productId is numeric
				try {
					productId = Integer.parseInt(productIdStr.trim());
				} catch (NumberFormatException ex) {
					// Invalid productId: forward to details.jsp with error flag
					request.setAttribute("err", "InvalidId");
					RequestDispatcher rd = request.getRequestDispatcher("products/details.jsp");
					rd.forward(request, response);
					return;
				}

				// Build REST URL for single product lookup
				// NOTE: This assumes your backend endpoint is "/services/{productId}"
				String restUrl = "http://localhost:8081/services/" + productId;
				WebTarget target = client.target(restUrl);

				// Request JSON response
				Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
				Response resp = invocationBuilder.get();

				System.out.println("GET BY ID status: " + resp.getStatus());

				if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
					// Deserialize JSON response into Product object
					Product product = resp.readEntity(Product.class);

					// Store product object and id so details.jsp can render them
					request.setAttribute("product", product);
					request.setAttribute("productId", productId);
					
					// Provide product image mapping + default image path to the JSP
				    request.setAttribute("productImageMap", buildProductImageMap(request));
				    request.setAttribute("defaultImg", request.getContextPath() + "/images/services/default.png");

					// Forward to product details page
					RequestDispatcher rd = request.getRequestDispatcher("products/details.jsp");
					rd.forward(request, response);
					return;

				} else if (resp.getStatus() == Response.Status.NOT_FOUND.getStatusCode()) {
					// Backend returned 404 for this product ID
					request.setAttribute("err", "NotFound");
					request.setAttribute("productId", productId);

					RequestDispatcher rd = request.getRequestDispatcher("products/details.jsp");
					rd.forward(request, response);
					return;

				} else {
					// Any other non-OK status treated as API error
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
			// If productId is not provided, load the products list page.
			String restUrl = "http://localhost:8081/services";
			WebTarget target = client.target(restUrl);

			// If search provided, attach it as query param to backend
			if (search != null && !search.trim().isEmpty()) {
				target = target.queryParam("search", search.trim());
			}

			// Request JSON response
			Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
			Response resp = invocationBuilder.get();

			System.out.println("GET ALL status: " + resp.getStatus());

			if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
				// Deserialize JSON array into ArrayList<Product>
				ArrayList<Product> products = resp.readEntity(new GenericType<ArrayList<Product>>() {
				});

				// Store list and search string so index.jsp can render/filter UI properly
				request.setAttribute("ProductArray", products);
				request.setAttribute("search", search);
				
				// Provide product image mapping + default image path to the JSP
                request.setAttribute("productImageMap", buildProductImageMap(request));
                request.setAttribute("defaultImg",
                request.getContextPath() + "/images/services/default.png");

				// Forward to products list page
				RequestDispatcher rd = request.getRequestDispatcher("products/index.jsp");
				rd.forward(request, response);

			} else {
				// Non-OK response treated as NotFound (or general load error)
				request.setAttribute("err", "NotFound");
				request.setAttribute("search", search);

				RequestDispatcher rd = request.getRequestDispatcher("products/index.jsp");
				rd.forward(request, response);
			}

		} catch (Exception e) {
			// Catch-all: networking issues, JSON mapping issues, unexpected runtime errors
			e.printStackTrace();

			request.setAttribute("err", "ServerError");

			// If you were trying to load a single product, go to details; else go to index.
			if (productIdStr != null && !productIdStr.trim().isEmpty()) {
				RequestDispatcher rd = request.getRequestDispatcher("products/details.jsp");
				rd.forward(request, response);
			} else {
				RequestDispatcher rd = request.getRequestDispatcher("products/index.jsp");
				rd.forward(request, response);
			}
		} finally {
			// Always close the JAX-RS client to avoid connection leaks
			try {
				client.close();
			} catch (Exception ignored) {
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// For convenience, POST is routed to doGet (supports forms that post but expect list behavior)
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
