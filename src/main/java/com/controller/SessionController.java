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

//	    @PostMapping("/login")
//	    public String login(
//	            String email,
//	            String password,
//	            Model model,
//	            HttpSession session) {
//
//	        Optional<UserEntity> op = userRepo.findByEmail(email);
//
//	        if (op.isPresent()) {
//	            UserEntity user = op.get();
//	            if (user.getPassword().equals(password)) {
//	                session.setAttribute("user", user);
//
//	                if (user.getRole().equals("participant")) {
//	                	model.addAttribute("m","Login Successfull!");
//
//	                    return "pDashboard";
//	                } else if (user.getRole().equalsIgnoreCase("admin")) {
//	                	model.addAttribute("m","Login Successfull!");
//
//	                    return "aDashboard";
//	                }else if (user.getRole().equalsIgnoreCase("judge")) {
//	                    // Session se lene ki zarurat nahi, 'user' variable pehle se hi upar available hai
//	                    
//	                 // User entity se judge_id (userId) nikal kar pass karein
//	                    List<ProgramEntity> myPrograms = programRepo.findProgramsByJudgeId(user.getUserId());
//	                    model.addAttribute("programs", myPrograms);
//	                    
//	                    if (myPrograms.isEmpty()) {
//	                        model.addAttribute("info", "You are not assigned to any hackathons yet.");
//	                    }
//	                    
//	                    // JSP ko data bhejein
//	                    model.addAttribute("today", new java.util.Date());
//	                    model.addAttribute("programs", myPrograms);
//	                    model.addAttribute("m", "Login Successful! Welcome Judge " + user.getFirstName());
//	                    
//	                    return "JudgeDashboard";
//	                }
//	                
//	                else {
//	                	model.addAttribute("m","Login Successfull!");
//	                    return "hDashboard";
//	                }
//	            }
//	        }
//
//	        model.addAttribute("e", "Login Failed");
//	        return "Signup";
//	    }
	    
	    @PostMapping("/login")
	    public String login(String email, String password, Model model, HttpSession session) {

	        Optional<UserEntity> op = userRepo.findByEmail(email);

	        if (op.isPresent()) {
	            UserEntity user = op.get();
	            if (user.getPassword().equals(password)) {
	                session.setAttribute("user", user);
	                
	                // COMMON DATA: Ye sabhi roles ko milega
	                model.addAttribute("m", "Login Successful! Welcome " + user.getFirstName());
	                model.addAttribute("today", new java.util.Date()); // Aaj ki date sabke liye

	                // 1. PARTICIPANT LOGIC
	                if (user.getRole().equalsIgnoreCase("participant")) {
	                    // Participant ke programs fetch karke model mein dalo agar zarurat ho
	                    return "pDashboard";
	                    
	                } 
	                // 2. ADMIN LOGIC
	                else if (user.getRole().equalsIgnoreCase("admin")) {
	                    return "aDashboard";
	                    
	                } 
	                // 3. JUDGE LOGIC
//	                else if (user.getRole().equalsIgnoreCase("judge")) {
//	                	// send program details from programs
//	                	// send round details from program_rounds
//	                	// 
//	                    List<ProgramEntity> myPrograms = programRepo.findProgramsByJudgeId(user.getUserId());
//	                    
//	                    model.addAttribute("programs", myPrograms);
//	                    
//	                    if (myPrograms.isEmpty()) {
//	                        model.addAttribute("info", "You are not assigned to any hackathons yet.");
//	                    }
//	                    return "JudgeDashboard";
//	                } 
	                else if (user.getRole().equalsIgnoreCase("judge")) {
	                    // 1. Judge ke assigned Programs fetch karein (Native query used)
	                    List<ProgramEntity> myPrograms = programRepo.findProgramsByJudgeId(user.getUserId());
for(ProgramEntity pr : myPrograms) {
	System.out.println("My ProgramId s : " + pr.getProgramId());
}

	                    if (!myPrograms.isEmpty()) {
	                        // 2. Sirf IDs ki list nikaal rahe hain (Stream API use karke)
	                        List<Integer> programIds = myPrograms.stream()
	                                                             .map(ProgramEntity::getProgramId)
	                                                             .toList();

	                        // 3. Un specific Program IDs ke saare rounds fetch karein
	                        List<ProgramRoundsEntity> allRounds = roundsRepo.findAllByProgramIds(programIds);
for(ProgramRoundsEntity r : allRounds) {
	System.out.println("Round Id " + r.getRoundId() + " Program id " + r.getProgram().getProgramId());
}
	                        // 4. Model mein dono data bhej dein
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
//	    @GetMapping("forgetPassword")
//	    public String forgetPassword(HttpSession session, Model model) {
//	        // 1. Logged in user nikalo
//	        UserEntity user = (UserEntity) session.getAttribute("user");
//	        
//	        if (user == null) {
//	            model.addAttribute("e", "Please login first!");
//	            return "Login"; // Agar login nahi hai to login pe bhejo
//	        }
//
//	        // 2. OTP Generate karo (Alphanumeric as per UUID)
//	        String otp = java.util.UUID.randomUUID().toString().replace("-", "").substring(0, 8);
//	        
//	        // 3. OTP ko session mein save karo (Taaki dusre controller me check kar sakein)
//	        session.setAttribute("otp", otp);
//	        
//	        // 4. Mail bhej do
//	        mailerService.sendOtpMail(user.getEmail(), otp);
//	        
//	        model.addAttribute("m", "A verification code has been sent to your registered email.");
//	        return "ForgetPassword";
//	    }
//	    @PostMapping("checkOTP")
//	    public String checkOTP(@RequestParam String email , @RequestParam Integer otp , @RequestParam String newPassword  , HttpSession session , Model model) {
//	    	
//	    	Integer ogOtp = (Integer) session.getAttribute("otp");
//	    	if(ogOtp == otp) {
//	    	Optional<UserEntity> op = 	userRepo.findByEmail(email);
//	    	if(op.isPresent()) {
//	    		UserEntity curUser = op.get();
//	    		if(curUser.getEmail().equalsIgnoreCase(email)) {
//	    			curUser.setPassword(newPassword);
//		    		model.addAttribute("m" , "Password reset successfully");
//	    		}
//	    	}
//	    	
//
//	    	}else {
//	    		model.addAttribute("e" , "Incorrect OTP or Email");
//	    	}
//	    	
//	    	return "Login";
//	    }
	    @PostMapping("generateOTP")
	    public String generateOTP(@RequestParam String email , HttpSession session , Model model) {
	    	Optional<UserEntity> op = 	userRepo.findByEmail(email);
	    	if(op.isPresent()) {
	    		UserEntity curUser = op.get();
	    		if(curUser.getEmail().equalsIgnoreCase(email)) {
	    			
	    			String otp = java.util.UUID.randomUUID().toString().replace("-", "").substring(0, 8);
	    	        
	    	        // 3. OTP ko session mein save karo (Taaki dusre controller me check kar sakein)
	    	        session.setAttribute("otp", otp);
	    	        session.setAttribute("email", email);
	    	        
	    	        // 4. Mail bhej do
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
