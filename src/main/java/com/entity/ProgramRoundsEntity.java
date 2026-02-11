package com.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

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
@Table(name = "program_rounds")
public class ProgramRoundsEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer roundId;
    
	
	@ManyToOne
    @JoinColumn(name = "program_id") 
    private ProgramEntity program;
	
	Integer roundNo;
	String roundName;
	String roundDesc;
	String submissionLink;
	String taskFile;
	
	
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	Date startDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	Date endDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	Date resultDate;
	String roundTask; 
	
}
