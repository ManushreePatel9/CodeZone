package com.entity;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data
@Table(name="requests")
public class RequestEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Integer requestId;

	
	@ManyToOne
	@JoinColumn(name="senderId")
	UserEntity sender; 
	
	
	@ManyToOne
	@JoinColumn(name="receiverId")    
	UserEntity receiver; 
	
	 
	String status;	
	
	LocalDate createdAt; 
	
	Boolean isRead;  
	
	@ManyToOne
    @JoinColumn(name="programId")
    ProgramEntity program;
	
	@ManyToOne
	@JoinColumn(name="teamId")
	TeamEntity team;
	
	String receiverEmail;
	



}
