package com.entity;

import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data
@Table(name="users")
public class UserEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Integer userId;
	String email;
	String firstName;
	String lastName;
	String mobile;
	String category;
	String domain;
	String college;
	String password;
	String role="participant";
 List<String> technology;
}
