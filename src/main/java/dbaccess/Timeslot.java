package dbaccess;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

// Represents a caregiver availability timeslot (POJO / JavaBean)
public class Timeslot {

	// Unique identifier for this availability record
	private int availabilityId;

	// ID of the caregiver associated with this timeslot
	private int caregiverId;

	// Date of availability (stored as String to avoid date parsing issues)
	private String availabilityDate;

	// Start time of the availability (stored as String)
	private String startTime;

	// End time of the availability (stored as String)
	private String endTime;

	// Timestamp when this timeslot was created (stored as String)
	private String createdAt;

	// Timestamp when this timeslot was last updated (stored as String)
	private String updatedAt;

	// Getter for availabilityId
	public int getAvailabilityId() {
		return availabilityId;
	}

	// Getter for caregiverId
	public int getCaregiverId() {
		return caregiverId;
	}
	
	// Getter for availabilityDate (raw String)
	public String getAvailabilityDate() {
		return availabilityDate;
	}

	// Returns a formatted version of availabilityDate
	// Parses the stored String into a LocalDate using yyyy-MM-dd format
	public String getAvailabilityDateFormatted() {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate date = LocalDate.parse(availabilityDate.toString(), formatter);
		return date.toString();
	}

	// Getter for startTime
	public String getStartTime() {
		return startTime;
	}

	// Getter for endTime
	public String getEndTime() {
		return endTime;
	}

	// Getter for createdAt timestamp
	public String getCreatedAt() {
		return createdAt;
	}

	// Getter for updatedAt timestamp
	public String getUpdatedAt() {
		return updatedAt;
	}

	// Setter for availabilityId
	public void setAvailabilityId(int availabilityId) {
		this.availabilityId = availabilityId;
	}

	// Setter for caregiverId
	public void setCaregiverId(int caregiverId) {
		this.caregiverId = caregiverId;
	}

	// Setter for availabilityDate
	public void setAvailabilityDate(String availabilityDate) {
		this.availabilityDate = availabilityDate;
	}

	// Setter for startTime
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	// Setter for endTime
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	// Setter for createdAt timestamp
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}

	// Setter for updatedAt timestamp
	public void setUpdatedAt(String updatedAt) {
		this.updatedAt = updatedAt;
	}

}
