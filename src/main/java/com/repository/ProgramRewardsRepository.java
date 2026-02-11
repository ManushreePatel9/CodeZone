package com.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.entity.ProgramRewardsEntity;

public interface ProgramRewardsRepository extends JpaRepository<ProgramRewardsEntity, Integer>{
//	List<ProgramRewardsEntity> findByProgram_ProgramId(Integer programId);
	Optional<ProgramRewardsEntity> findByProgram_ProgramId(Integer programId);	
}
