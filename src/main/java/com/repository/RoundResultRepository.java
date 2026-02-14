package com.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query; // Ye import check karo
import org.springframework.data.repository.query.Param;
import com.entity.RoundResultEntity;
import java.util.List;
import java.util.Optional;

public interface RoundResultRepository extends JpaRepository<RoundResultEntity,Integer> {
    Optional<RoundResultEntity> findByTeams_TeamIdAndRounds_RoundIdAndRounds_Program_ProgramId(
            Integer teamId, Integer roundId, Integer programId);
    
    
    List<RoundResultEntity> findByJudge_UserId(Integer userId);
    
    @Query("SELECT r FROM RoundResultEntity r WHERE r.rounds.roundId = :rId")
    List<RoundResultEntity> findByRounds_RoundId(@Param("rId") Integer rId); 

    @Query("SELECT t.teamName, SUM(r.marks), t.mem1, t.mem2 , t.mem3 , t.mem4 , t.mem5 FROM RoundResultEntity r JOIN r.teams t WHERE r.rounds.program.programId = :pId GROUP BY t.teamId ORDER BY SUM(r.marks) DESC")
    List<Object[]> findFinalWinners(@Param("pId") Integer pId);
    
    @Query("SELECT r FROM RoundResultEntity r WHERE r.teams.teamId = :tId " +
           "AND r.rounds.roundId = :rId " +
           "AND r.rounds.program.programId = :pId " +
           "AND r.judge.userId = :jId")
    Optional<RoundResultEntity> findByTeams_TeamIdAndRounds_RoundIdAndRounds_Program_ProgramIdAndJudge_UserId(
            @Param("tId") Integer teamId, 
            @Param("rId") Integer roundId, 
            @Param("pId") Integer programId, 
            @Param("jId") Integer judgeId
    );
}
