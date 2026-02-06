//package dbaccess;
//
//import java.sql.Timestamp;
//
//public class Event {
//    private int eventId;
//    private String title;
//    private String description;
//    private String location;
//    private Timestamp startTime;
//    private Timestamp endTime;
//    private int capacity;
//    private boolean active;
//    private int createdBy;
//    private Timestamp createdAt;
//    private Timestamp updatedAt;
//    private String imagePath;
//
//    public Event() {
//    	super();
//    }
//
//    public int getEventId() { 
//    	return eventId; 
//    }
//    
//    public void setEventId(int eventId) {
//    	this.eventId = eventId; 
//    }
//
//    public String getTitle() { 
//    	return title; 
//    }
//    public void setTitle(String title) { 
//    	this.title = title; 
//    }
//
//    public String getDescription() { 
//    	return description; 
//    }
//    
//    public void setDescription(String description) { 
//    	this.description = description; 
//    }
//
//    public String getLocation() { 
//    	return location; 
//    }
//    
//    public void setLocation(String location) { 
//    	this.location = location; 
//    }
//
//    public Timestamp getStartTime() { 
//    	return startTime; 
//    }
//    
//    public void setStartTime(Timestamp startTime) { 
//    	this.startTime = startTime; 
//    }
//
//    public Timestamp getEndTime() { 
//    	return endTime; 
//    }
//    
//    public void setEndTime(Timestamp endTime) { 
//    	this.endTime = endTime; 
//    }
//
//    public int getCapacity() { 
//    	return capacity; 
//    }
//    
//    public void setCapacity(int capacity) { 
//    	this.capacity = capacity; 
//    }
//
//    public boolean isActive() { 
//    	return active; 
//    }
//    
//    public void setActive(boolean active) { 
//    	this.active = active; 
//    }
//
//    public int getCreatedBy() { 
//    	return createdBy; 
//    }
//    
//    public void setCreatedBy(int createdBy) { 
//    	this.createdBy = createdBy; 
//    }
//
//    public Timestamp getCreatedAt() { 
//    	return createdAt; 
//    }
//    
//    public void setCreatedAt(Timestamp createdAt) { 
//    	this.createdAt = createdAt; 
//    }
//
//    public Timestamp getUpdatedAt() { 
//    	return updatedAt; 
//    }
//    
//    public void setUpdatedAt(Timestamp updatedAt) { 
//    	this.updatedAt = updatedAt; 
//    }
//
//    public String getImagePath() { 
//    	return imagePath; 
//    }
//    
//    public void setImagePath(String imagePath) { 
//    	this.imagePath = imagePath; 
//    }
//}
 



package dbaccess;

public class Event {

    private int eventId;
    private String title;
    private String description;
    private String location;

    // CHANGED from Timestamp → String
    private String startTime;
    private String endTime;

    private int capacity;
    private boolean active;
    private int createdBy;

    // CHANGED from Timestamp → String
    private String createdAt;
    private String updatedAt;

    private String imagePath;

    public Event() {
        super();
    }

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    // String timestamps
    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    // String timestamps
    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
}
