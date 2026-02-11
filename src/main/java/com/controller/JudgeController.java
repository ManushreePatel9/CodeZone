package com.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.entity.ProgramEntity;
import com.entity.UserEntity;
import com.repository.ProgramRepository;
import com.repository.UserRepository;
import com.service.MailerService;

import jakarta.servlet.http.HttpSession;
import java.util.UUID;

@Controller
public class JudgeController {
	@Autowired
	UserRepository userRepo;
	@Autowired
	ProgramRepository programRepo;
	@Autowired
	private MailerService mailerService;
	
	@GetMapping("addJudgeForm")
	public String addJudgeForm() {
		return "AddJudgeForm";
	}
//	@PostMapping ("addJudge")
//	public String addJudge(UserEntity userEntity , Model model) {
//		userEntity.setRole("judge");
//		userRepo.save(userEntity);
//		System.out.println("Judge Added");
//		model.addAttribute("m" , "Judge Added Successfully");
//		return "aDashboard";
//	}
	



	@PostMapping("addJudge")
	public String addJudge(UserEntity userEntity, Model model) {
	    
	    String randomPassword = java.util.UUID.randomUUID().toString().replace("-", "").substring(0, 8);
	    
	    userEntity.setRole("judge");
	    userEntity.setPassword(randomPassword);
	    userRepo.save(userEntity);
	    
	    mailerService.sendJudgeCredentialsMail(
	        userEntity.getEmail(), 
	        userEntity.getFirstName(), 
	        randomPassword
	    );
System.out.println("Password generated : " + randomPassword);
	    model.addAttribute("m", "Judge Added & Credentials Mailed Successfully");
	    return "aDashboard";
	}
	
	@GetMapping("/judgeDashboard")
	public String aDashboardd(Model model , HttpSession session) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		 List<ProgramEntity> myPrograms = programRepo.findProgramsByJudgeId(user.getUserId());
         model.addAttribute("programs", myPrograms);
         
         if (myPrograms.isEmpty()) {
             model.addAttribute("e", "You are not assigned to any hackathons yet.");
         }
		return "JudgeDashboard";
	}
}
