package beans;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Column;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;

import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "user_address")
public class Address implements Serializable {

	private static final long serialVersionUID = -7415410969017941320L;

	
	
	@OneToOne(cascade = CascadeType.ALL, targetEntity=User.class)
	@JoinColumn(name = "USER_ID")
	private User user;

	
	@Id
	@Column(name = "USER_ADDRESS_LINE_1")
	private String userAddress1;

	@Column(name = "USER_ADDRESS_LINE_2")
	private String userAddress2;

	/*
	 * public int getUserID() { return userID; }
	 * 
	 * public void setUserID(int userID) { this.userID = userID; }
	 */
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Column(name = "CITY")
	private String city;

	@Column(name = "STATE")
	private String state;

	@Column(name = "ZIP_CODE")
	private String zipCode;

	public String getUserAddress1() {
		return userAddress1;
	}

	public void setUserAddress1(String userAddress1) {
		this.userAddress1 = userAddress1;
	}

	public String getUserAddress2() {
		return userAddress2;
	}

	public void setUserAddress2(String userAddress2) {
		this.userAddress2 = userAddress2;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getZipCode() {
		return zipCode;
	}

	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}

}
