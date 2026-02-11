// - Name: Lim Song Chern Jayden
// - Admin No: P2424093
// - Class: DIT/FT/2B/01
// - Last Edited: 9/2/2026

package dbaccess;

// Plain Old Java Object (POJO) representing an Event entity
public class Event {

    // Unique identifier for the event
    private int eventId;

    // Event title/name
    private String title;

    // Detailed description of the event
    private String description;

    // Location where the event takes place
    private String location;

    // Event start time stored as a String (ISO / API-friendly format)
    // String to avoid JSON parsing issues
    private String startTime;

    // Event end time stored as a String
    private String endTime;

    // Maximum number of participants allowed
    private int capacity;

    // Indicates whether the event is active or inactive
    private boolean active;

    // ID of the user/admin who created the event
    private int createdBy;

    // Timestamp of when the event was created (stored as String)
    // String for JSON compatibility
    private String createdAt;

    // Timestamp of the last update to the event (stored as String)
    private String updatedAt;

    // Path or URL to the event image
    private String imagePath;

    // No-argument constructor required for frameworks (JSON-B, JAX-RS, etc.)
    public Event() {
        super();
    }

    // Getter for eventId
    public int getEventId() {
        return eventId;
    }

    // Setter for eventId
    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    // Getter for title
    public String getTitle() {
        return title;
    }

    // Setter for title
    public void setTitle(String title) {
        this.title = title;
    }

    // Getter for description
    public String getDescription() {
        return description;
    }

    // Setter for description
    public void setDescription(String description) {
        this.description = description;
    }

    // Getter for location
    public String getLocation() {
        return location;
    }

    // Setter for location
    public void setLocation(String location) {
        this.location = location;
    }

    // Getter for startTime (String-based timestamp)
    public String getStartTime() {
        return startTime;
    }

    // Setter for startTime
    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    // Getter for endTime
    public String getEndTime() {
        return endTime;
    }

    // Setter for endTime
    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    // Getter for capacity
    public int getCapacity() {
        return capacity;
    }

    // Setter for capacity
    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    // Getter for active flag
    public boolean isActive() {
        return active;
    }

    // Setter for active flag
    public void setActive(boolean active) {
        this.active = active;
    }

    // Getter for createdBy (creator user ID)
    public int getCreatedBy() {
        return createdBy;
    }

    // Setter for createdBy
    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    // Getter for createdAt timestamp (String-based)
    public String getCreatedAt() {
        return createdAt;
    }

    // Setter for createdAt
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    // Getter for updatedAt timestamp
    public String getUpdatedAt() {
        return updatedAt;
    }

    // Setter for updatedAt
    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Getter for imagePath
    public String getImagePath() {
        return imagePath;
    }

    // Setter for imagePath
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
}
