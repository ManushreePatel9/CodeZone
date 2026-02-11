

package com.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.entity.RequestEntity;
import com.entity.UserEntity;
import jakarta.transaction.Transactional;

public interface RequestRepository extends JpaRepository<RequestEntity, Integer> {
    
    List<RequestEntity> findBySender(UserEntity sender);
    List<RequestEntity> findByReceiver(UserEntity receiver);
  List<RequestEntity> findByReceiverEmail(String email);

    
    @Query("SELECT r FROM RequestEntity r WHERE r.program.programId = :pid")
    List<RequestEntity> findByProgramId(@Param("pid") Integer pid);

    @Query("SELECT r FROM RequestEntity r WHERE r.team.teamId = :teamId AND r.status = :status")
    List<RequestEntity> findByTeamIdAndStatus(@Param("teamId") Integer teamId, @Param("status") String status);

    @Transactional
    @Modifying
    @Query("DELETE FROM RequestEntity r WHERE r.team.teamId = :teamId AND r.receiver.userId = :userId")
    void deleteByTeamIdAndReceiverId(@Param("teamId") Integer teamId, @Param("userId") Integer userId);
    
    @Transactional
    @Modifying
    @Query("DELETE FROM RequestEntity r WHERE r.team.teamId = :teamId " +
           "AND r.status = 'pending' " +
           "AND ((:userId > 0 AND r.receiver.userId = :userId) OR (r.receiverEmail = :email))")
    int deletePendingRequestUnified(@Param("teamId") Integer teamId, 
                                    @Param("userId") Integer userId, 
                                    @Param("email") String email);
    // delete request for same program after making team 
    @Modifying
    @Transactional
    @Query("DELETE FROM RequestEntity r WHERE r.receiver.userId = :uid AND r.team.programId = :pid AND r.status = 'pending'")
    void deletePendingRequestsByReceiverAndProgram(@Param("uid") Integer userId, @Param("pid") Integer pid);
}




