package com.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import jakarta.persistence.*;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Data
@Table(name = "programs")
public class ProgramEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer programId;

    private String programName;
    private String organizerName;
    private String location;
    private String city;
    private String status;
    private String pic;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private Date startDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private Date dueDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private Date registrationStartDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private Date registrationDeadline;

    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private Date winnerPublishDate;
    
    @Column(updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    private Integer minTeamSize;
    private Integer maxTeamSize;
    private Integer userId;

    @OneToOne(mappedBy = "program", cascade = CascadeType.ALL)
    private ProgramDetailsEntity details;

    @OneToOne(mappedBy = "program", cascade = CascadeType.ALL)
    private ProgramRewardsEntity rewards;

    @OneToMany(mappedBy = "program", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ProgramRoundsEntity> rounds = new ArrayList<>();

    @OneToMany(mappedBy = "program")
    private List<ProgramJudgesEntity> assignedJudges;
}