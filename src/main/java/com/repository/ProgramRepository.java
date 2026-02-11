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
    
//    // 1. Details table ke andar 'mode' field search karega
//    List<ProgramEntity> findByDetails_Mode(String mode);
//    
//    // 2. Details table ke andar 'payment' field search karega
//    List<ProgramEntity> findByDetails_Payment(String payment);
//    
//    // 3. Dono fields Details table se dhoondega
//    List<ProgramEntity> findByDetails_ModeAndDetails_Payment(String mode, String payment);
//    
//    // 4. Native Query safe hai kyunki ye direct table names use karti hai
//    @Query(value = "SELECT * FROM programs WHERE program_id IN (SELECT program_id FROM program_judges WHERE judge_id = :judgeId)", nativeQuery = true)
//    List<ProgramEntity> findProgramsByJudgeId(@Param("judgeId") Integer judgeId);
//
//    // Bonus: Agar aapko Category ya College se bhi dhoondna ho (future ke liye)
//    List<ProgramEntity> findByDetails_Category(String category);
//    List<ProgramEntity> findByDetails_College(String college);
//    @Query("SELECT p FROM ProgramEntity p WHERE p.dueDate >= :now")
//    List<ProgramEntity> findAllActive(LocalDateTime now);
	
  @Query(value = "SELECT * FROM programs WHERE program_id IN (SELECT program_id FROM program_judges WHERE judge_id = :judgeId)", nativeQuery = true)
	// 1. Saare active hackathons (Due date is after or equal to now)

    // 2. Filter by Mode + Active
    List<ProgramEntity> findByDetails_ModeAndDueDateGreaterThanEqual(String mode, LocalDateTime now);

    // 3. Filter by Payment + Active
    List<ProgramEntity> findByDetails_PaymentAndDueDateGreaterThanEqual(String payment, LocalDateTime now);

    // 4. Filter by Both Mode & Payment + Active
    List<ProgramEntity> findByDetails_ModeAndDetails_PaymentAndDueDateGreaterThanEqual(String mode, String payment, LocalDateTime now);
    
    
    @Query(value = "SELECT * FROM programs WHERE program_id IN (SELECT program_id FROM program_judges WHERE judge_id = :judgeId)", nativeQuery = true)
    List<ProgramEntity> findProgramsByJudgeId(@Param("judgeId") Integer judgeId);

    // 1. Saare active hackathons
    List<ProgramEntity> findByDueDateGreaterThanEqual(LocalDateTime now);

    // 2. Filter by Mode (Ignore Case) + Active
    List<ProgramEntity> findByDetails_ModeIgnoreCaseAndDueDateGreaterThanEqual(String mode, LocalDateTime now);

    // 3. Filter by Payment (Ignore Case) + Active
    List<ProgramEntity> findByDetails_PaymentIgnoreCaseAndDueDateGreaterThanEqual(String payment, LocalDateTime now);

    // 4. Both Mode & Payment (Ignore Case) + Active
    List<ProgramEntity> findByDetails_ModeIgnoreCaseAndDetails_PaymentIgnoreCaseAndDueDateGreaterThanEqual(String mode, String payment, LocalDateTime now);

    
}