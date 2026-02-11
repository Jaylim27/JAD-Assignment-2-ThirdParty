// - Name: Lim Song Chern Jayden
// - Admin No: P2424093
// - Class: DIT/FT/2B/01
// - Last Edited: 9/2/2026

package servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import dbaccess.Event;

/**
 * Servlet implementation class GetEventBookingDetails
 */
@WebServlet("/GetEventBookingDetails")
public class GetEventBookingDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /* =========================
    Helpers: ISO → SG display
    ========================= */

	// Parses an ISO-8601 UTC timestamp string into a java.util.Date
	// Example expected input: 2026-01-29T01:33:50.797Z
    private Date parseIsoUtc(String iso) throws Exception {
    	// Return null if the input is missing or empty
        if (iso == null || iso.isBlank()) return null;

        //Remove leading/trailing whitespace
        String s = iso.trim();

        // Try with milliseconds first (".SSS")
        try {
            SimpleDateFormat isoFmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
            isoFmt.setTimeZone(TimeZone.getTimeZone("UTC"));
            return isoFmt.parse(s);
        } catch (Exception ignored) {
            // Fallback: no milliseconds
            SimpleDateFormat isoFmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
            isoFmt.setTimeZone(TimeZone.getTimeZone("UTC"));
            return isoFmt.parse(s);
        }
    }
	
	 // Format Date to Singapore display string
     // Example output: "03 Feb 2026, 01:07 AM"
	 private String formatSg(Date d) {
		// Return "-" if date is null to avoid null output in JSP
	     if (d == null) return "-";
	
	     // Define display format (day month year, 12-hour time with AM/PM)
	     SimpleDateFormat outFmt =
	         new SimpleDateFormat("dd MMM yyyy, hh:mm a");
	     outFmt.setTimeZone(TimeZone.getTimeZone("Asia/Singapore")); // show in SG timezone
	     return outFmt.format(d);
	 }
	
	 // Convenience: ISO string → SG display string
	 private String isoToSgDisplay(String iso) {
	     try {
	         return formatSg(parseIsoUtc(iso));
	     } catch (Exception e) {
	    	// If parsing fails (unexpected timestamp format), return "-"
	         return "-";
	     }
	 }
	 
    /* =========================
     * Event Image Map
     * ========================= */
	// Builds a small mapping of eventId -> image URL for displaying event images on booking page
    private Map<Integer, String> buildImageMap(HttpServletRequest request) {
        Map<Integer, String> m = new HashMap<>();
        // Base path to event images under your webapp
        String p = request.getContextPath() + "/images/events/";

        //Mapping for specific event IDs
        m.put(2, p + "silvercareOrientation.png");
        m.put(3, p + "chineseNewYear.png");

        return m;
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	    /* =========================
	     * 1. Read form parameters
	     * ========================= */
		// eventId is passed as a query parameter (e.g., /GetEventBookingDetails?eventId=2)
	    String eventIdStr = request.getParameter("eventId");

	    /* =========================
	     * 2. Validate Event ID
	     * ========================= */
	    // Reject missing/blank eventId
	    if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
	      request.setAttribute("err", "InvalidId");
	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	      return;
	    }

	    // Convert eventId from String to int, reject if not numeric
	    int eventId;
	    try {
	      eventId = Integer.parseInt(eventIdStr.trim());
	    } catch (NumberFormatException e) {
	      request.setAttribute("err", "InvalidId");
	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	      return;
	    }

	    /* =========================
	     * 3. Create REST client
	     * ========================= */
	    // JAX-RS client used to call your backend REST service
	    Client client = ClientBuilder.newClient();

	    try {

	      /* =========================
	       * 4. Build API URL (GET event by id)
	       * ========================= */
	      // Endpoint: GET /services/events/{eventId}
	      String restUrl = "http://localhost:8081/services/events/" + eventId;

	      /* =========================
	       * 5. Call REST API (GET)
	       * ========================= */
	      WebTarget target = client.target(restUrl);
	      Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
	      Response resp = invocationBuilder.get();

	      // HTTP status code from REST API call
	      int status = resp.getStatus();
	      System.out.println("GET EVENT BY ID status: " + status);

	      /* =========================
	       * 6. Handle API response
	       * ========================= */
	      if (status == Response.Status.OK.getStatusCode()) {
	    	// Convert JSON response into Event object
	        Event event = resp.readEntity(Event.class);

	        /* =========================
	         * 7. Pass data to JSP
	         * ========================= */
	        // Store event data for JSP display
	        request.setAttribute("event", event);
	        request.setAttribute("eventId", eventId);
	        
	        // Convert ISO timestamps into Singapore-friendly strings for display in JSP
	        request.setAttribute("startTimeDisplay", isoToSgDisplay(event.getStartTime()));
	        request.setAttribute("endTimeDisplay", isoToSgDisplay(event.getEndTime()));
	        
	        // Determine which event image to display (fallback to default.png)
            Map<Integer, String> imgMap = buildImageMap(request);
            request.setAttribute(
                "imgSrc",
                imgMap.getOrDefault(
                    eventId,
                    request.getContextPath() + "/images/default.png"
                )
            );

            // Forward to booking page JSP (server-side render)
	        request.getRequestDispatcher("events/booking.jsp").forward(request, response);

	      } else if (status == Response.Status.NOT_FOUND.getStatusCode()) {
	    	// Event ID not found in backend
	        request.setAttribute("err", "NotFound");
	        request.setAttribute("eventId", eventId);
	        request.getRequestDispatcher("events/booking.jsp").forward(request, response);

	      } else {
	    	// Any other non-OK response treated as API error
	        request.setAttribute("err", "ApiError");
	        request.setAttribute("eventId", eventId);
	        request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	      }

	      // Close response
	      try { resp.close(); } catch (Exception ignored) {}

	    } catch (Exception e) {
	      // Catch-all: network issues, JSON parse issues, unexpected errors
	      e.printStackTrace();
	      request.setAttribute("err", "ServerError");
	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	    } finally {
	      try { client.close(); } catch (Exception ignored) {}
	    }
	  }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    
		/* =========================
	     * 1. Read form parameters
	     * ========================= */
		// Parameters submitted from booking form
	    String eventIdStr = request.getParameter("eventId");
	    String guestName = request.getParameter("guestName");
	    String guestEmail = request.getParameter("guestEmail");

	    /* =========================
	     * 2. Validate Event ID
	     * ========================= */
	    // Reject missing/blank eventId
	    if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
	      request.setAttribute("err", "InvalidId");
	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	      return;
	    }

	    // Convert eventId to int, reject if invalid
	    int eventId;
	    try {
	      eventId = Integer.parseInt(eventIdStr.trim());
	    } catch (NumberFormatException e) {
	      request.setAttribute("err", "InvalidId");
	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	      return;
	    }

	    /* =========================
	     * 3. Create REST client
	     * ========================= */
	    // JAX-RS client used for POST booking and GET event details
	    Client client = ClientBuilder.newClient();

	    try {

	      /* =========================
	       * 4. Build API URL (BOOK)
	       * ========================= */
	      // Endpoint: POST /services/events/book/{eventId}
	      String bookUrl = "http://localhost:8081/services/events/book/" + eventId;

	      /* =========================
	       * 5. Prepare request body
	       * ========================= */
	      // JSON request body expected by the booking endpoint
	      Map<String, String> body = new HashMap<>();
	      body.put("guestName", guestName);
	      body.put("guestEmail", guestEmail);

	      /* =========================
	       * 6. Call REST API (POST)
	       * ========================= */
	      // Send booking request as JSON
	      Response apiResp = client
	          .target(bookUrl)
	          .request(MediaType.APPLICATION_JSON)
	          .post(Entity.entity(body, MediaType.APPLICATION_JSON));

	      // Booking endpoint status code
	      int status = apiResp.getStatus();
	      System.out.println("BOOK EVENT status: " + status);

	      /* =========================
	       * 7. Read API response
	       * ========================= */
	      // Read JSON response from booking endpoint into a generic map
	      Map<String, Object> apiResult = apiResp.readEntity(new GenericType<Map<String, Object>>() {});
	      try { apiResp.close(); } catch (Exception ignored) {}

	      /* =========================
	       * 8. Load event again 
	       * ========================= */
	   // After booking, fetch event details again so page can still display event info
	      String getEventUrl = "http://localhost:8081/services/events/" + eventId;
	      WebTarget target = client.target(getEventUrl);
	      Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
	      Response resp = invocationBuilder.get();

	      if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
	    	// Convert JSON response into Event object
	        Event event = resp.readEntity(Event.class);
	        // Store event object for JSP rendering
	        request.setAttribute("event", event);
	        
	        // Pre-format start/end time for JSP display
	        request.setAttribute("startTimeDisplay", isoToSgDisplay(event.getStartTime()));
	        request.setAttribute("endTimeDisplay", isoToSgDisplay(event.getEndTime()));

	        // Resolve event image source path (with default fallback)
	        Map<Integer, String> imgMap = buildImageMap(request);
	        request.setAttribute(
	            "imgSrc",
	            imgMap.getOrDefault(eventId, request.getContextPath() + "/images/default.png")
	        );
	        
	      } else if (resp.getStatus() == Response.Status.NOT_FOUND.getStatusCode()) {
	    	// Event no longer exists / invalid eventId
	        request.setAttribute("err", "NotFound");
	      } else {
	    	// Other backend issues
	        request.setAttribute("err", "ApiError");
	      }
	      try { resp.close(); } catch (Exception ignored) {}

	      /* =========================
	       * 9. Pass data to JSP
	       * ========================= */
	      // Provide booking result info to JSP (success/failure messages, bookingId, etc.)
	      request.setAttribute("apiStatus", status);
	      request.setAttribute("apiResult", apiResult);
	      request.setAttribute("eventId", eventId);

	      // Forward back to the same booking JSP to display results
	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);

	    } catch (Exception e) {
	      // Catch-all: network issues, JSON parsing issues, unexpected errors
	      e.printStackTrace();
	      request.setAttribute("err", "ServerError");
	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	    } finally {
	      // Always close client to prevent resource leak
	      try { client.close(); } catch (Exception ignored) {}
	    }
	  }

}
