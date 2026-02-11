package com.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.entity.ProgramJudgesEntity;
import com.entity.UserEntity;

public interface ProgramJudgesRepository extends JpaRepository<ProgramJudgesEntity, Integer>{
}
