package com.entity;

import org.hibernate.annotations.JoinColumnOrFormula;

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
@Table(name="round_results")
public class RoundResultEntity {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	Integer resultId;
	
	@ManyToOne
	@JoinColumn(name="submission_id")
	SubmissionEntity submission;
	
	@ManyToOne
	@JoinColumn(name="round_id")
	ProgramRoundsEntity rounds;
	
	@ManyToOne
	@JoinColumn(name="team_id")
	TeamEntity teams;
	
	@ManyToOne
	@JoinColumn(name="judge_id")
	UserEntity judge;
	
	Integer marks;
	String feedback;
	String status;
}
