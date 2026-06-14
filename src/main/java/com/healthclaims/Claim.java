package com.healthclaims;
public class Claim {
//data each claim holds
private String id; // claim id
private String patientName; 
private String status; // APPROVED, PENDING, or REJECTED
private String amount; 
public Claim(String id, String patientName, String status, String amount) {
this.id = id;
this.patientName = patientName;
this.status = status;
this.amount = amount;
}
public String getId() { return id; }
public String getPatientName() { return patientName; }
public String getStatus() { return status; }
public String getAmount() { return amount; }
}