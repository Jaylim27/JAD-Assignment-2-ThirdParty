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

	 // Parse ISO UTC string (e.g. 2026-01-29T01:33:50.797Z)
    private Date parseIsoUtc(String iso) throws Exception {
        if (iso == null || iso.isBlank()) return null;

        String s = iso.trim();

        // Try with milliseconds first
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
	 private String formatSg(Date d) {
	     if (d == null) return "-";
	
	     SimpleDateFormat outFmt =
	         new SimpleDateFormat("dd MMM yyyy, hh:mm a");
	     outFmt.setTimeZone(TimeZone.getTimeZone("Asia/Singapore"));
	     return outFmt.format(d);
	 }
	
	 // Convenience: ISO string → SG display string
	 private String isoToSgDisplay(String iso) {
	     try {
	         return formatSg(parseIsoUtc(iso));
	     } catch (Exception e) {
	         return "-";
	     }
	 }
	 
    /* =========================
     * Event Image Map
     * ========================= */
    private Map<Integer, String> buildImageMap(HttpServletRequest request) {
        Map<Integer, String> m = new HashMap<>();
        String p = request.getContextPath() + "/images/events/";

        m.put(2, p + "silvercareOrientation.png");
        m.put(3, p + "chineseNewYear.png");

        return m;
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	    /* =========================
	     * 1. Read form parameters
	     * ========================= */
	    String eventIdStr = request.getParameter("eventId");

	    /* =========================
	     * 2. Validate Event ID
	     * ========================= */
	    if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
	      request.setAttribute("err", "InvalidId");
	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	      return;
	    }

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
	    Client client = ClientBuilder.newClient();

	    try {

	      /* =========================
	       * 4. Build API URL (GET event by id)
	       * ========================= */
	      String restUrl = "http://localhost:8081/services/events/" + eventId;

	      /* =========================
	       * 5. Call REST API (GET)
	       * ========================= */
	      WebTarget target = client.target(restUrl);
	      Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
	      Response resp = invocationBuilder.get();

	      int status = resp.getStatus();
	      System.out.println("GET EVENT BY ID status: " + status);

	      /* =========================
	       * 6. Handle API response
	       * ========================= */
	      if (status == Response.Status.OK.getStatusCode()) {
	        Event event = resp.readEntity(Event.class);

	        /* =========================
	         * 7. Pass data to JSP
	         * ========================= */
	        request.setAttribute("event", event);
	        request.setAttribute("eventId", eventId);
	        
	        request.setAttribute("startTimeDisplay", isoToSgDisplay(event.getStartTime()));
	        request.setAttribute("endTimeDisplay", isoToSgDisplay(event.getEndTime()));
	        
            Map<Integer, String> imgMap = buildImageMap(request);
            request.setAttribute(
                "imgSrc",
                imgMap.getOrDefault(
                    eventId,
                    request.getContextPath() + "/images/default.png"
                )
            );

	        request.getRequestDispatcher("events/booking.jsp").forward(request, response);

	      } else if (status == Response.Status.NOT_FOUND.getStatusCode()) {
	        request.setAttribute("err", "NotFound");
	        request.setAttribute("eventId", eventId);
	        request.getRequestDispatcher("events/booking.jsp").forward(request, response);

	      } else {
	        request.setAttribute("err", "ApiError");
	        request.setAttribute("eventId", eventId);
	        request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	      }

	      try { resp.close(); } catch (Exception ignored) {}

	    } catch (Exception e) {
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
	    String eventIdStr = request.getParameter("eventId");
	    String guestName = request.getParameter("guestName");
	    String guestEmail = request.getParameter("guestEmail");

	    /* =========================
	     * 2. Validate Event ID
	     * ========================= */
	    if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
	      request.setAttribute("err", "InvalidId");
	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	      return;
	    }

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
	    Client client = ClientBuilder.newClient();

	    try {

	      /* =========================
	       * 4. Build API URL (BOOK)
	       * ========================= */
	      String bookUrl = "http://localhost:8081/services/events/book/" + eventId;

	      /* =========================
	       * 5. Prepare request body
	       * ========================= */
	      Map<String, String> body = new HashMap<>();
	      body.put("guestName", guestName);
	      body.put("guestEmail", guestEmail);

	      /* =========================
	       * 6. Call REST API (POST)
	       * ========================= */
	      Response apiResp = client
	          .target(bookUrl)
	          .request(MediaType.APPLICATION_JSON)
	          .post(Entity.entity(body, MediaType.APPLICATION_JSON));

	      int status = apiResp.getStatus();
	      System.out.println("BOOK EVENT status: " + status);

	      /* =========================
	       * 7. Read API response
	       * ========================= */
	      Map<String, Object> apiResult = apiResp.readEntity(new GenericType<Map<String, Object>>() {});
	      try { apiResp.close(); } catch (Exception ignored) {}

	      /* =========================
	       * 8. Load event again (so JSP can show left card)
	       * ========================= */
	      String getEventUrl = "http://localhost:8081/services/events/" + eventId;
	      WebTarget target = client.target(getEventUrl);
	      Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
	      Response resp = invocationBuilder.get();

	      if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
	        Event event = resp.readEntity(Event.class);
	        request.setAttribute("event", event);
	        
	        request.setAttribute("startTimeDisplay", isoToSgDisplay(event.getStartTime()));
	        request.setAttribute("endTimeDisplay", isoToSgDisplay(event.getEndTime()));

	        Map<Integer, String> imgMap = buildImageMap(request);
	        request.setAttribute(
	            "imgSrc",
	            imgMap.getOrDefault(eventId, request.getContextPath() + "/images/default.png")
	        );
	        
	      } else if (resp.getStatus() == Response.Status.NOT_FOUND.getStatusCode()) {
	        request.setAttribute("err", "NotFound");
	      } else {
	        request.setAttribute("err", "ApiError");
	      }
	      try { resp.close(); } catch (Exception ignored) {}

	      /* =========================
	       * 9. Pass data to JSP
	       * ========================= */
	      request.setAttribute("apiStatus", status);
	      request.setAttribute("apiResult", apiResult);
	      request.setAttribute("eventId", eventId);

	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);

	    } catch (Exception e) {
	      e.printStackTrace();
	      request.setAttribute("err", "ServerError");
	      request.getRequestDispatcher("events/booking.jsp").forward(request, response);
	    } finally {
	      try { client.close(); } catch (Exception ignored) {}
	    }
	  }

}
