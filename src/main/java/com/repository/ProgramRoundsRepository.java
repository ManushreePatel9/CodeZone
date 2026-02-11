package com.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.entity.ProgramRoundsEntity;
import com.entity.RoundResultEntity;
import com.entity.ProgramRoundsEntity;

public interface ProgramRoundsRepository extends JpaRepository<ProgramRoundsEntity, Integer>{
	    ProgramRoundsEntity findByRoundNoAndProgramProgramId(Integer roundNo, Integer programId);
	    @Query("SELECT r FROM ProgramRoundsEntity r WHERE r.roundNo = :rNo AND r.program.programId = :pId")
	    ProgramRoundsEntity findBySpecificRound(@Param("rNo") Integer rNo, @Param("pId") Integer pId);
	    Optional<ProgramRoundsEntity> findByRoundId(Integer roundId);
	    
	    @Query("SELECT r FROM ProgramRoundsEntity r WHERE r.program.programId IN :pIds")
	    List<ProgramRoundsEntity> findAllByProgramIds(@Param("pIds") List<Integer> pIds);
	 
}
