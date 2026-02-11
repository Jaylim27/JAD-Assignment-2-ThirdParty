// - Name: Lim Song Chern Jayden
// - Admin No: P2424093
// - Class: DIT/FT/2B/01
// - Last Edited: 9/2/2026

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

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import dbaccess.Event;

@WebServlet("/GetEventList")
public class GetEventList extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /* =========================
    Helpers: ISO → SG display
    ========================= */

	 // Parse ISO UTC string (e.g. 2026-01-29T01:33:50.797Z)
    private Date parseIsoUtc(String iso) throws Exception {
    	// Return null for missing/blank timestamp strings
        if (iso == null || iso.isBlank()) return null;

        // Trim whitespace to avoid parse failures
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
	
	     // Display format: dd MMM yyyy, hh:mm AM/PM
	     SimpleDateFormat outFmt =
	         new SimpleDateFormat("dd MMM yyyy, hh:mm a");
	     outFmt.setTimeZone(TimeZone.getTimeZone("Asia/Singapore")); // display in SG time
	     return outFmt.format(d);
	 }
	
	 // Convenience: ISO string → SG display string
	 private String isoToSgDisplay(String iso) {
	     try {
	         return formatSg(parseIsoUtc(iso));
	     } catch (Exception e) {
	    	// If parsing fails due to unexpected format, return "-"
	         return "-";
	     }
	 }
	 
	    /* =========================
	     Event Image Map
		  ========================= */
	 	  // Builds a mapping of eventId -> image URL to display on index/details pages.
		  private Map<Integer, String> buildImageMap(HttpServletRequest request) {
		      Map<Integer, String> m = new HashMap<>();
		      // Base path where event images are stored in the webapp
		      String p = request.getContextPath() + "/images/events/";
		
		      // Mapping for specific event IDs
		      m.put(2, p + "silvercareOrientation.png");
		      m.put(3, p + "chineseNewYear.png");
		
		      return m;
		  }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Optional debug
        // PrintWriter out = response.getWriter();

    	// Search keyword used when listing events
        String search = request.getParameter("search");
        //Event ID used to load details view
        String eventIdStr = request.getParameter("eventId"); 

        // Create a JAX-RS client for calling the backend REST service
        Client client = ClientBuilder.newClient();

        try {
            // ===========================
            // Build image map ONCE + set common request attributes ONCE
            // ===========================
        	// Build image mapping once per request so JSP can reuse it
            Map<Integer, String> imgMap = buildImageMap(request); 
            request.setAttribute("imageMap", imgMap); 
            // Default image path used if an eventId has no mapping
            request.setAttribute(
                "defaultImg",
                request.getContextPath() + "/images/events/default.png"
            ); 
            
            // ===========================
            // 1) GET EVENT BY ID 
            // ===========================
            // If eventId is provided, show the details page for that specific event
            if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
                int eventId;

                // Validate that eventId is numeric
                try {
                    eventId = Integer.parseInt(eventIdStr.trim());
                } catch (NumberFormatException ex) {
                    request.setAttribute("err", "InvalidId");
                    RequestDispatcher rd = request.getRequestDispatcher("events/details.jsp");
                    rd.forward(request, response);
                    return;
                }
                
                // REST endpoint for single event lookup
                String restUrl = "http://localhost:8081/services/events/" + eventId;
                WebTarget target = client.target(restUrl);

                // Request JSON response
                Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
                Response resp = invocationBuilder.get();

                System.out.println("GET BY ID status: " + resp.getStatus());

                if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
                	// Map JSON response into Event object
                    Event event = resp.readEntity(Event.class);
                    
                    // Format timestamps ONCE for details.jsp
                    request.setAttribute("startTimeDisplay", isoToSgDisplay(event.getStartTime()));
                    request.setAttribute("endTimeDisplay", isoToSgDisplay(event.getEndTime()));
                    request.setAttribute("createdAtDisplay", isoToSgDisplay(event.getCreatedAt()));
                    request.setAttribute("updatedAtDisplay", isoToSgDisplay(event.getUpdatedAt()));

                    // Store event object and id for JSP usage
                    request.setAttribute("event", event);
                    request.setAttribute("eventId", eventId);
                    
                    // Resolve image source for this event (fallback to default)
                    request.setAttribute(
                            "imgSrc",
                            imgMap.getOrDefault(
                                event.getEventId(), 
                                request.getContextPath() + "/images/events/default.png" // CHANGED
                            )
                        ); 

                    // Forward to event details view
                    RequestDispatcher rd = request.getRequestDispatcher("events/details.jsp");
                    rd.forward(request, response);
                    return;

                } else if (resp.getStatus() == Response.Status.NOT_FOUND.getStatusCode()) {
                	// Backend returned 404 for this event ID
                    request.setAttribute("err", "NotFound");
                    request.setAttribute("eventId", eventId);

                    RequestDispatcher rd = request.getRequestDispatcher("events/details.jsp");
                    rd.forward(request, response);
                    return;

                } else {
                	// Any non-OK, non-404 treated as API error
                    request.setAttribute("err", "ApiError");
                    request.setAttribute("eventId", eventId);

                    RequestDispatcher rd = request.getRequestDispatcher("events/details.jsp");
                    rd.forward(request, response);
                    return;
                }
            }

            // ===========================
            // 2) GET ALL EVENTS 
            // ===========================
            // If eventId not provided, show the events list page
            String restUrl = "http://localhost:8081/services/events";
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
            	// Read JSON array into ArrayList<Event>
                ArrayList<Event> events = resp.readEntity(new GenericType<ArrayList<Event>>() {});
                
                // Build display maps for index.jsp (keyed by eventId)
                Map<Integer, String> startTimeDisplayMap = new HashMap<>();
                Map<Integer, String> endTimeDisplayMap = new HashMap<>();

                // Convert ISO timestamps returned by backend to SG display strings
                for (Event e : events) {
                    startTimeDisplayMap.put(e.getEventId(), isoToSgDisplay(e.getStartTime()));
                    endTimeDisplayMap.put(e.getEventId(), isoToSgDisplay(e.getEndTime()));
                }
                
                // Store maps for JSP to lookup formatted time by eventId
                request.setAttribute("startTimeDisplayMap", startTimeDisplayMap);
                request.setAttribute("endTimeDisplayMap", endTimeDisplayMap);

                // Store the raw events list and the search string for rendering
                request.setAttribute("eventArray", events);
                request.setAttribute("search", search);

                // Forward to events list page
                RequestDispatcher rd = request.getRequestDispatcher("events/index.jsp");
                rd.forward(request, response);

            } else {
            	// Non-OK response; show an error on index.jsp
                request.setAttribute("err", "NotFound");
                request.setAttribute("search", search);

                RequestDispatcher rd = request.getRequestDispatcher("events/index.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
        	// Catch-all: networking issues, JSON mapping issues, unexpected runtime errors
            e.printStackTrace();

            request.setAttribute("err", "ServerError");

            // Route user to details.jsp if they attempted to view a single event, otherwise index.jsp
            if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
                RequestDispatcher rd = request.getRequestDispatcher("events/details.jsp");
                rd.forward(request, response);
            } else {
                RequestDispatcher rd = request.getRequestDispatcher("events/index.jsp");
                rd.forward(request, response);
            }
        } finally {
        	// Always close the JAX-RS client to prevent connection leaks
            try { client.close(); } catch (Exception ignored) {}
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
