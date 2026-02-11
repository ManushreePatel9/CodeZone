package com.repository;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query; 
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.entity.ProgramEntity;

@Repository
public interface ProgramRepository extends JpaRepository<ProgramEntity, Integer> {

	
  @Query(value = "SELECT * FROM programs WHERE program_id IN (SELECT program_id FROM program_judges WHERE judge_id = :judgeId)", nativeQuery = true)

    List<ProgramEntity> findByDetails_ModeAndDueDateGreaterThanEqual(String mode, LocalDateTime now);

    List<ProgramEntity> findByDetails_PaymentAndDueDateGreaterThanEqual(String payment, LocalDateTime now);

    List<ProgramEntity> findByDetails_ModeAndDetails_PaymentAndDueDateGreaterThanEqual(String mode, String payment, LocalDateTime now);
    
    
    @Query(value = "SELECT * FROM programs WHERE program_id IN (SELECT program_id FROM program_judges WHERE judge_id = :judgeId)", nativeQuery = true)
    List<ProgramEntity> findProgramsByJudgeId(@Param("judgeId") Integer judgeId);

    List<ProgramEntity> findByDueDateGreaterThanEqual(LocalDateTime now);

    List<ProgramEntity> findByDetails_ModeIgnoreCaseAndDueDateGreaterThanEqual(String mode, LocalDateTime now);

    List<ProgramEntity> findByDetails_PaymentIgnoreCaseAndDueDateGreaterThanEqual(String payment, LocalDateTime now);

    List<ProgramEntity> findByDetails_ModeIgnoreCaseAndDetails_PaymentIgnoreCaseAndDueDateGreaterThanEqual(String mode, String payment, LocalDateTime now);

    
}