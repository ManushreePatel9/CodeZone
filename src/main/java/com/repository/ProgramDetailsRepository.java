package com.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.entity.ProgramDetailsEntity;

public interface ProgramDetailsRepository extends JpaRepository<ProgramDetailsEntity, Integer>{
	List<ProgramDetailsEntity> findByProgram_ProgramId(Integer programId);}
