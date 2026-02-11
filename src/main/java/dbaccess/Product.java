package dbaccess;

// Represents a Product entity used in the application (POJO / JavaBean)
public class Product {

	  // Unique identifier for the product
	  private int productId;

	  // Category that the product belongs to (e.g. service, merchandise)
	  private String category;

	  // Display name of the product
	  private String name;

	  // Detailed description of the product
	  private String description;

	  // Price of the product
	  private float price;

	  // Indicates whether the product is active/available
	  private boolean isActive;

	  // Path or URL to the product image
	  private String imagePath;

	  // Timestamp indicating when the product was created (stored as String)
	  // Using String helps avoid JSON/Timestamp parsing issues
	  private String createdAt;

	  // Timestamp indicating the last update to the product (stored as String)
	  private String updatedAt;

	  // No-argument constructor required by frameworks (JSP, JSON binding, etc.)
	  public Product() {
	    super();
	  }

	  // Getter for productId
	  public int getProductId() {
	    return productId;
	  }

	  // Setter for productId
	  public void setProductId(int productId) {
	    this.productId = productId;
	  }

	  // Getter for category
	  public String getCategory() {
	    return category;
	  }

	  // Setter for category
	  public void setCategory(String category) {
	    this.category = category;
	  }

	  // Getter for name
	  public String getName() {
	    return name;
	  }

	  // Setter for name
	  public void setName(String name) {
	    this.name = name;
	  }

	  // Getter for description
	  public String getDescription() {
	    return description;
	  }

	  // Setter for description
	  public void setDescription(String description) {
	    this.description = description;
	  }

	  // Getter for price
	  public float getPrice() {
	    return price;
	  }

	  // Setter for price
	  public void setPrice(float price) {
	    this.price = price;
	  }

	  // Getter for active status
	  public boolean isActive() {
	    return isActive;
	  }

	  // Setter for active status
	  public void setActive(boolean isActive) {
	    this.isActive = isActive;
	  }

	  // Getter for imagePath
	  public String getImagePath() {
	    return imagePath;
	  }

	  // Setter for imagePath
	  public void setImagePath(String imagePath) {
	    this.imagePath = imagePath;
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
}
