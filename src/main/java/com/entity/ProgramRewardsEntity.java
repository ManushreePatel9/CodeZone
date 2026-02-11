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
@Table(name = "program_rewards")
public class ProgramRewardsEntity {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer rewardId;

    @OneToOne
    @JoinColumn(name = "program_id")
    private ProgramEntity program;

    @Column(length = 1000)
    private String prize1;

    @Column(length = 1000)
    private String prize2;

    @Column(length = 1000)
    private String prize3;

    @Column(length = 1000)
    private String rewardAndPrizeDesc;

    private Integer topRankerLimit;
}
