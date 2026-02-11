package com.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.entity.UserEntity;
import com.repository.UserRepository;

@Controller

public class ProfileController {
	
	@Autowired
	UserRepository userRepo;
	
	@GetMapping("/viewMyProfile")
	public String viewMyProfile(Integer userId , Model model) {
	Optional<UserEntity> op=	userRepo.findById(userId);
	if(op.isPresent()) {
		System.out.println("Inside View My Profile");
		UserEntity user = op.get();
		model.addAttribute("curUser" , user);
	}
		return "MyProfile";
	}
}
