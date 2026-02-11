package com.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data
@Table(name = "program_judges")
public class ProgramJudgesEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Integer assignment_id;
	
	@ManyToOne
    @JoinColumn(name = "judge_id") 
    private UserEntity judge;
	
	@ManyToOne
	@JoinColumn(name="program_id")
	ProgramEntity program;
	

}
