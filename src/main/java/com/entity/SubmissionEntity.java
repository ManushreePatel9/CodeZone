package com.entity;

import lombok.Data;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "submissions")
public class SubmissionEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer submissionId;

    @ManyToOne
    @JoinColumn(name = "team_id") 
    private TeamEntity team;

    @ManyToOne
    @JoinColumn(name = "round_id")
    private ProgramRoundsEntity round;

    @Column(name = "submission_link", length = 500)
    private String submissionLink;

    @Column(name = "submission_desc", columnDefinition = "TEXT")
    private String submissionDesc;

    @Column(name = "submitted_at")
    private LocalDateTime submittedAt = LocalDateTime.now();
}