package com.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.entity.SubmissionEntity;

public interface SubmissionRepository extends JpaRepository<SubmissionEntity, Integer>{
	List<SubmissionEntity> findByRoundRoundNoAndRoundProgramProgramId(Integer roundNo, Integer programId);
}