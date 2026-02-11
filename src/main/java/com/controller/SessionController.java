package com.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.entity.ProgramEntity;
import com.entity.ProgramRoundsEntity;
import com.entity.RequestEntity;
import com.entity.UserEntity;
import com.repository.ProgramRepository;
import com.repository.ProgramRoundsRepository;
import com.repository.RequestRepository;
import com.repository.UserRepository;
import com.service.MailerService;

import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

@Controller
public class SessionController {

	 @Autowired
	    UserRepository userRepo;
	 @Autowired
	 RequestRepository requestRepo;
@Autowired
ProgramRepository programRepo;
@Autowired
MailerService mailerService;
@Autowired
ProgramRoundsRepository roundsRepo;
	
@GetMapping("/test")
public String test() {
	return "Test";
}

	 

	    @GetMapping("/")
	    public String welcome() {

	        return "Signup";
	    }
	    
	    @GetMapping("/pDashboard")
	    public String p() {
	    	return "pDashboard";
	    }


	    
	    

	    
	    @PostMapping("/signup")
	    @Transactional 
	    public String signup(UserEntity userEntity, Model model) {

	        String cleanEmail = userEntity.getEmail().trim().toLowerCase();
	        userEntity.setEmail(cleanEmail);
	        
	        
	        Optional<UserEntity> existingUserOp = userRepo.findByEmail(cleanEmail);
	        UserEntity savedUser;

	        if (existingUserOp.isPresent()) {
	            UserEntity existingUser = existingUserOp.get();
	            
	            userEntity.setUserId(existingUser.getUserId()); 
	            savedUser = userRepo.save(userEntity);
	            System.out.println("✅ Placeholder updated for User ID: " + savedUser.getUserId());
	        } else {
	            savedUser = userRepo.save(userEntity);
	        }

	        model.addAttribute("m", "Signup Successful!");
	      
	        List<RequestEntity> pendingRequests = requestRepo.findByReceiverEmail(cleanEmail);
	        System.out.println("Found requests: " + pendingRequests.size());

	        if (pendingRequests != null && !pendingRequests.isEmpty()) {
	            for (RequestEntity req : pendingRequests) {
	                if (req.getReceiver() == null) {
	                    req.setReceiver(savedUser);
	                    requestRepo.save(req);
	                    System.out.println("✅ Linked Request ID " + req.getRequestId() + " to User ID " + savedUser.getUserId());
	                }
	            }
	        }
	        
	        return "Login"; 
	    }

	    @GetMapping("/login")
	    public String login() {
	        return "Login";
	    }


	    @PostMapping("/login")
	    public String login(String email, String password, Model model, HttpSession session) {

	        Optional<UserEntity> op = userRepo.findByEmail(email);

	        if (op.isPresent()) {
	            UserEntity user = op.get();
	            if (user.getPassword().equals(password)) {
	                session.setAttribute("user", user);
	                
	                model.addAttribute("m", "Login Successful! Welcome " + user.getFirstName());
	                model.addAttribute("today", new java.util.Date()); 

	                if (user.getRole().equalsIgnoreCase("participant")) {
	                    return "pDashboard";
	                   
	                } 
	                else if (user.getRole().equalsIgnoreCase("admin")) {
	                    return "aDashboard";
	                    
	                } 
	             
	                else if (user.getRole().equalsIgnoreCase("judge")) {
	                    List<ProgramEntity> myPrograms = programRepo.findProgramsByJudgeId(user.getUserId());
for(ProgramEntity pr : myPrograms) {
	System.out.println("My ProgramId s : " + pr.getProgramId());
}

	                    if (!myPrograms.isEmpty()) {
	                        List<Integer> programIds = myPrograms.stream()
	                                                             .map(ProgramEntity::getProgramId)
	                                                             .toList();

	                        List<ProgramRoundsEntity> allRounds = roundsRepo.findAllByProgramIds(programIds);
for(ProgramRoundsEntity r : allRounds) {
	System.out.println("Round Id " + r.getRoundId() + " Program id " + r.getProgram().getProgramId());
}
	                        model.addAttribute("programs", myPrograms);
	                        model.addAttribute("allRounds", allRounds);
	                    } else {
	                        model.addAttribute("info", "You are not assigned to any hackathons yet.");
	                    }
	                    
	                    return "JudgeDashboard";
	                }
	                else {
	                    return "hDashboard";
	                }
	            }
	        }

	        model.addAttribute("e", "Invalid Email or Password");
	        return "Signup";
	    }
	    @GetMapping("logout")
	    public String logout(HttpSession session , Model model) {
	    	model.addAttribute("e" , "Logged Out");
	    	session.removeAttribute("user");
	    	return "Login";
	    }
	    @GetMapping("forgetPassword")
	    public String forgetPassword() {
	    	return "ForgetPassword";
	    }

	    @PostMapping("generateOTP")
	    public String generateOTP(@RequestParam String email , HttpSession session , Model model) {
	    	Optional<UserEntity> op = 	userRepo.findByEmail(email);
	    	if(op.isPresent()) {
	    		UserEntity curUser = op.get();
	    		if(curUser.getEmail().equalsIgnoreCase(email)) {
	    			
	    			String otp = java.util.UUID.randomUUID().toString().replace("-", "").substring(0, 8);
	    	        
	    	        session.setAttribute("otp", otp);
	    	        session.setAttribute("email", email);
	    	        
	    	        mailerService.sendOtpMail(email, otp);
	    	        
	    	        model.addAttribute("m", "A verification code has been sent to your registered email.");
	    	    	return "ResetPassword";
	    			
	    		}
	    	}else {
	    		model.addAttribute("e" , "Email not present");
	    	}
    		return "Login";
	    
	    }

	    @PostMapping("saveNewPassword")
	    public String resetPassword(@RequestParam String newPassword ,@RequestParam String otp , HttpSession session ,Model model) {
	    	String email = (String) session.getAttribute("email");
	    	String ogOtp = (String) session.getAttribute("otp");
	    	if(ogOtp.equals(otp)) {
	    	Optional<UserEntity> op = 	userRepo.findByEmail(email);
	    	if(op.isPresent()) {
	    		UserEntity curUser = op.get();
	    		if(curUser.getEmail().equalsIgnoreCase(email)) {
	    			curUser.setPassword(newPassword);
	    			userRepo.save(curUser);
		    		model.addAttribute("m" , "Password reset successfully");
	    		}
	    	}
	    	

	    	}else {
	    		model.addAttribute("e" , "Incorrect OTP or Email");
	    	}
	    	
	    	return "Login";
}
}
