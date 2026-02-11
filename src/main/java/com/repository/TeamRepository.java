package com.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.entity.ProgramEntity;
import com.entity.TeamEntity;

public interface TeamRepository extends JpaRepository<TeamEntity, Integer>{
    @Query(value = "SELECT * FROM teams WHERE team_id = :teamId AND " +
                   "(:userId IN (mem1, mem2, mem3, mem4, mem5))", nativeQuery = true)
   Optional<TeamEntity> findByTeamIdAndUserId(@Param("teamId") Integer teamId, @Param("userId") Integer userId);
    
    
    @Query(value = "SELECT * FROM teams WHERE program_id = :pid AND mem1 = :userId LIMIT 1", nativeQuery = true)
    Optional<TeamEntity> findByProgramIdAndLeaderId(@Param("pid") Integer pid, @Param("userId") Integer userId);
    
    @Query(value = "SELECT * FROM teams WHERE mem1 = :uid OR mem2 = :uid OR mem3 = :uid OR mem4 = :uid OR mem5 = :uid", nativeQuery = true)
    List<TeamEntity> findAllMyTeams(@Param("uid") Integer uid);
    
    @Query("SELECT COUNT(t) > 0 FROM TeamEntity t WHERE t.programId = :pid AND " +
            "(t.mem1 = :uid OR t.mem2 = :uid OR t.mem3 = :uid OR t.mem4 = :uid OR t.mem5 = :uid)")
     boolean isUserAlreadyInTeam(@Param("pid") Integer pid, @Param("uid") Integer uid);
}
