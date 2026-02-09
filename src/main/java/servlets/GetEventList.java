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
	     Event Image Map
		  ========================= */
		  private Map<Integer, String> buildImageMap(HttpServletRequest request) {
		      Map<Integer, String> m = new HashMap<>();
		      String p = request.getContextPath() + "/images/events/";
		
		      m.put(2, p + "silvercareOrientation.png");
		      m.put(3, p + "chineseNewYear.png");
		
		      return m;
		  }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Optional debug
        // PrintWriter out = response.getWriter();

        String search = request.getParameter("search");
        String eventIdStr = request.getParameter("eventId"); 

        Client client = ClientBuilder.newClient();

        try {
            // ===========================
            // Build image map ONCE + set common request attributes ONCE
            // ===========================
            Map<Integer, String> imgMap = buildImageMap(request); // CHANGED
            request.setAttribute("imageMap", imgMap); // CHANGED
            request.setAttribute(
                "defaultImg",
                request.getContextPath() + "/images/events/default.png"
            ); 
            
            // ===========================
            // 1) GET EVENT BY ID 
            // ===========================
            if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
                int eventId;

                try {
                    eventId = Integer.parseInt(eventIdStr.trim());
                } catch (NumberFormatException ex) {
                    request.setAttribute("err", "InvalidId");
                    RequestDispatcher rd = request.getRequestDispatcher("events/details.jsp");
                    rd.forward(request, response);
                    return;
                }
                

                String restUrl = "http://localhost:8081/services/events/" + eventId;
                WebTarget target = client.target(restUrl);

                Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
                Response resp = invocationBuilder.get();

                System.out.println("GET BY ID status: " + resp.getStatus());

                if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
                    Event event = resp.readEntity(Event.class);
                    
                    // Format timestamps ONCE for details.jsp
                    request.setAttribute("startTimeDisplay", isoToSgDisplay(event.getStartTime()));
                    request.setAttribute("endTimeDisplay", isoToSgDisplay(event.getEndTime()));
                    request.setAttribute("createdAtDisplay", isoToSgDisplay(event.getCreatedAt()));
                    request.setAttribute("updatedAtDisplay", isoToSgDisplay(event.getUpdatedAt()));

                    request.setAttribute("event", event);
                    request.setAttribute("eventId", eventId);
                    
                    request.setAttribute(
                            "imgSrc",
                            imgMap.getOrDefault(
                                event.getEventId(), // CHANGED (safer than eventId var)
                                request.getContextPath() + "/images/events/default.png" // CHANGED
                            )
                        ); 

                    RequestDispatcher rd = request.getRequestDispatcher("events/details.jsp");
                    rd.forward(request, response);
                    return;

                } else if (resp.getStatus() == Response.Status.NOT_FOUND.getStatusCode()) {
                    request.setAttribute("err", "NotFound");
                    request.setAttribute("eventId", eventId);

                    RequestDispatcher rd = request.getRequestDispatcher("events/details.jsp");
                    rd.forward(request, response);
                    return;

                } else {
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
            String restUrl = "http://localhost:8081/services/events";
            WebTarget target = client.target(restUrl);

            if (search != null && !search.trim().isEmpty()) {
                target = target.queryParam("search", search.trim());
            }

            Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
            Response resp = invocationBuilder.get();

            System.out.println("GET ALL status: " + resp.getStatus());

            if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
                ArrayList<Event> events = resp.readEntity(new GenericType<ArrayList<Event>>() {});
                
                // Build display maps for index.jsp (keyed by eventId)
                Map<Integer, String> startTimeDisplayMap = new HashMap<>();
                Map<Integer, String> endTimeDisplayMap = new HashMap<>();

                for (Event e : events) {
                    startTimeDisplayMap.put(e.getEventId(), isoToSgDisplay(e.getStartTime()));
                    endTimeDisplayMap.put(e.getEventId(), isoToSgDisplay(e.getEndTime()));
                }
                
                request.setAttribute("startTimeDisplayMap", startTimeDisplayMap);
                request.setAttribute("endTimeDisplayMap", endTimeDisplayMap);

                request.setAttribute("eventArray", events);
                request.setAttribute("search", search);

                RequestDispatcher rd = request.getRequestDispatcher("events/index.jsp");
                rd.forward(request, response);

            } else {
                request.setAttribute("err", "NotFound");
                request.setAttribute("search", search);

                RequestDispatcher rd = request.getRequestDispatcher("events/index.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("err", "ServerError");

            // If you were trying to load a single event, go details; else go index.
            if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
                RequestDispatcher rd = request.getRequestDispatcher("events/details.jsp");
                rd.forward(request, response);
            } else {
                RequestDispatcher rd = request.getRequestDispatcher("events/index.jsp");
                rd.forward(request, response);
            }
        } finally {
            try { client.close(); } catch (Exception ignored) {}
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
