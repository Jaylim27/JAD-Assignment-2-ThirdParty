package dbaccess;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class Timeslot {
	private int availabilityId;
	private int caregiverId;
	private String availabilityDate;
	private String startTime;
	private String endTime;
	private String createdAt;
	private String updatedAt;

	public int getAvailabilityId() {
		return availabilityId;
	}

	public int getCaregiverId() {
		return caregiverId;
	}
	
	public String getAvailabilityDate() {
		return availabilityDate;
	}

	public String getAvailabilityDateFormatted() {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate date = LocalDate.parse(availabilityDate.toString(), formatter);
		return date.toString();
	}

	public String getStartTime() {
		return startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public String getUpdatedAt() {
		return updatedAt;
	}

	public void setAvailabilityId(int availabilityId) {
		this.availabilityId = availabilityId;
	}

	public void setCaregiverId(int caregiverId) {
		this.caregiverId = caregiverId;
	}

	public void setAvailabilityDate(String availabilityDate) {
		this.availabilityDate = availabilityDate;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}

	public void setUpdatedAt(String updatedAt) {
		this.updatedAt = updatedAt;
	}

}
