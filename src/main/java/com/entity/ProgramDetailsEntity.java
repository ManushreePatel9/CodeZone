package com.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data
@Table(name = "program_details")
public class ProgramDetailsEntity {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer detailId;

    @OneToOne
    @JoinColumn(name = "program_id")
    private ProgramEntity program;

    private String programType;
    private String category;
    private String college;
    private String mode;
    private String payment;
    private Integer fees;

    @Column(length = 1000)
    private String skills;

    @Column(length = 1000)
    private String eligibility;

    @Column(length = 1000)
    private String detail;

    @Column(length = 1000)
    private String rules;
}
