package beans;

import java.util.Date;

import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;



@Entity
public class Bank {

	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Long BANK_ID;
	private String NAME;
	
	@Temporal(TemporalType.DATE)
	private Date CREATED_DATE;
	
	
	private String CREATED_BY;
	
	private String LAST_UPDATED_BY;
	
	
	/*Temporal use for Time format*/
	
	@Temporal(TemporalType.TIME)
	private Date LAST_UPDATED_DATE;
	private boolean IS_INTERNATIONAL;
	
	
	@Embedded
	private Address address =new Address();
	
	
	
	public Long getBANK_ID() {
		return BANK_ID;
	}
	public void setBANK_ID(Long bANK_ID) {
		BANK_ID = bANK_ID;
	}
	public String getNAME() {
		return NAME;
	}
	public void setNAME(String nAME) {
		NAME = nAME;
	}
	public Date getCREATED_DATE() {
		return CREATED_DATE;
	}
	public void setCREATED_DATE(Date cREATED_DATE) {
		CREATED_DATE = cREATED_DATE;
	}
	public String getCREATED_BY() {
		return CREATED_BY;
	}
	public void setCREATED_BY(String cREATED_BY) {
		CREATED_BY = cREATED_BY;
	}
	public String getLAST_UPDATED_BY() {
		return LAST_UPDATED_BY;
	}
	public void setLAST_UPDATED_BY(String lAST_UPDATED_BY) {
		LAST_UPDATED_BY = lAST_UPDATED_BY;
	}
	public Date getLAST_UPDATED_DATE() {
		return LAST_UPDATED_DATE;
	}
	public void setLAST_UPDATED_DATE(Date lAST_UPDATED_DATE) {
		LAST_UPDATED_DATE = lAST_UPDATED_DATE;
	}
	public boolean isIS_INTERNATIONAL() {
		return IS_INTERNATIONAL;
	}
	public void setIS_INTERNATIONAL(boolean iS_INTERNATIONAL) {
		IS_INTERNATIONAL = iS_INTERNATIONAL;
	}
	public Address getAddress() {
		return address;
	}
	public void setAddress(Address address) {
		this.address = address;
	}
	@Override
	public String toString() {
		return "Bank [BANK_ID=" + BANK_ID + ", NAME=" + NAME + ", CREATED_DATE=" + CREATED_DATE + ", CREATED_BY="
				+ CREATED_BY + ", LAST_UPDATED_BY=" + LAST_UPDATED_BY + ", LAST_UPDATED_DATE=" + LAST_UPDATED_DATE
				+ ", IS_INTERNATIONAL=" + IS_INTERNATIONAL + ", address=" + address + "]";
	}
	
	

}
