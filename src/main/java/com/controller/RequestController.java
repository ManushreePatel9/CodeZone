package com.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.entity.ProgramEntity;
import com.entity.RequestEntity;
import com.entity.TeamEntity;
import com.entity.UserEntity;
import com.repository.ProgramRepository;
import com.repository.RequestRepository;
import com.repository.TeamRepository;
import com.repository.UserRepository;
import com.service.MailerService;

import jakarta.servlet.http.HttpSession;

@Controller
public class RequestController {

	@Autowired
	RequestRepository requestRepo;
	@Autowired
	UserRepository userRepo;
	@Autowired
	ProgramRepository programRepo;
	@Autowired
	TeamRepository teamRepo;

	@GetMapping("/sendMakeTeamRequest")
	public String sendMakeTeamRequest(Integer senderId, Integer receiverId, Integer pid, Integer teamId,Model model) {
		RequestEntity requestEntity = new RequestEntity();
		UserEntity sender = userRepo.findById(senderId).orElse(null);
		UserEntity receiver = userRepo.findById(receiverId).orElse(null);
		ProgramEntity program = programRepo.findById(pid).orElse(null);
		TeamEntity team = teamRepo.findById(teamId).orElse(null);
		requestEntity.setSender(sender);
		requestEntity.setReceiver(receiver);
		requestEntity.setStatus("pending");
		requestEntity.setCreatedAt(LocalDate.now());
		requestEntity.setIsRead(false);
		requestEntity.setProgram(program);
		requestEntity.setTeam(team);
		requestRepo.save(requestEntity);
		System.out.println("Inside SendMakeTeamRequest");
		return "redirect:/viewHackathon?pid=" + pid;
	}
	@Autowired
	private MailerService emailService;
	


	@PostMapping("/sendMakeTeamRequestManual")
	public String sendMakeTeamRequestManual(@RequestParam String email, 
	        @RequestParam Integer pid, @RequestParam String firstName,
	        @RequestParam Integer teamId, 
	        HttpSession session) {
	    
	    UserEntity sender = (UserEntity) session.getAttribute("user");
	    ProgramEntity program = programRepo.findById(pid).orElse(null);
	    
	    if (teamId == null) {
	        teamId = (Integer) session.getAttribute("curTeamId");
	    }

	    TeamEntity team = teamRepo.findById(teamId).orElse(null);

	    RequestEntity requestEntity = new RequestEntity();
	    requestEntity.setSender(sender);
	    requestEntity.setReceiverEmail(email); 
	    requestEntity.setStatus("pending");
	    requestEntity.setCreatedAt(LocalDate.now());
	    requestEntity.setIsRead(false);
	    requestEntity.setProgram(program);
	    requestEntity.setTeam(team); 
	    
	    requestRepo.save(requestEntity);
	    
	    try {
	        String senderFullName = sender.getFirstName() + " " + sender.getLastName();
	        emailService.sendHackathonInvitation(email, senderFullName, program.getProgramName(), pid.toString());
	        System.out.println("✅ Manual Mail Sent");
	    } catch (Exception e) {
	        System.out.println("❌ Mail Error: " + e.getMessage());
	    }

	    return "redirect:/viewHackathon?pid=" + pid + "&showBox=true";
	}
	
	@GetMapping("/viewHackathon?pid=")
	public String m(Model model) {
		model.addAttribute("msg", "requested");
		return "HackathonDetails";
	}

	@GetMapping("/viewRequests")
	public String viewRequests(HttpSession session, Model model) {

		UserEntity user = (UserEntity) session.getAttribute("user");

		List<RequestEntity> requests = requestRepo.findByReceiver(user);

		model.addAttribute("requests", requests);
		System.out.println("hello");
		return "pDashboard";
	}


	
	@GetMapping("/acceptRequest")
	public String acceptRequest(@RequestParam Integer requestId, @RequestParam Integer programId,Model model ,HttpSession session , RedirectAttributes attributes) {
	    Optional<RequestEntity> op = requestRepo.findById(requestId);
        UserEntity user = (UserEntity) session.getAttribute("user");

	    if (op.isPresent()) {
	        RequestEntity request = op.get();
	        TeamEntity curTeam = request.getTeam();
	        ProgramEntity program = request.getProgram(); 
	        
	        
	        if (teamRepo.isUserAlreadyInTeam(programId, user.getUserId())) {
	            attributes.addFlashAttribute("e", "You are already enrolled for this Hackathon!");
	            System.out.println("Already Enrolled in this hackathon");
	            return "pDashboard";
	        }
	        //
	        
	        int maxSize = (program.getMaxTeamSize() != null) ? program.getMaxTeamSize() : 5;
	     
	        int currentCount = 1; 
	        if(curTeam.getMem2() != null) currentCount++;
	        if(curTeam.getMem3() != null) currentCount++;
	        if(curTeam.getMem4() != null) currentCount++;
	        if(curTeam.getMem5() != null) currentCount++;

	        if (currentCount >= maxSize) {
	        	model.addAttribute("e","Team is already full! No space available");
	            return "pDashboard";
	        }

	        boolean spotFilled = false;

	        if (curTeam.getMem2() == null) {
	            curTeam.setMem2(user.getUserId());
	            spotFilled = true;
	        } else if (curTeam.getMem3() == null) {
	            curTeam.setMem3(user.getUserId());
	            spotFilled = true;
	        } else if (curTeam.getMem4() == null) {
	            curTeam.setMem4(user.getUserId());
	            spotFilled = true;
	        } else if (curTeam.getMem5() == null) {
	            curTeam.setMem5(user.getUserId());
	            spotFilled = true;
	        }

	        if (spotFilled) {
	            request.setStatus("accepted");
	            requestRepo.save(request);
	            teamRepo.save(curTeam);
	            model.addAttribute("m" , "Congratulations! You have joined"+curTeam.getTeamName());
	            return "pDashboard";
	        }
	    }

	    return "redirect:/pDashboard?e=Something went wrong!";
	}
	


	@GetMapping("/addMemManuallyForm")
	public String addMemManuallyForm() {
		return "AddMemForm";
	}
	
	@GetMapping("removeTeamMember")
	public String removeTeamMember(@RequestParam Integer pid, @RequestParam Integer teamId, @RequestParam Integer userId , Model model) {
	    Optional<TeamEntity> op = teamRepo.findById(teamId);
	    ProgramEntity program = programRepo.findById(pid).orElse(null);
	    
	    if (op.isPresent() && program != null) {
	        TeamEntity row = op.get();
	        int maxSize = (program.getMaxTeamSize() != null) ? program.getMaxTeamSize() : 5;
Optional<UserEntity> userOp=  userRepo.findById(userId);
UserEntity userEmail = userOp.get();

	      
	        int currentCount = 1;
	        if(row.getMem2() != null) currentCount++;
	        if(row.getMem3() != null) currentCount++;
	        if(row.getMem4() != null) currentCount++;
	        if(row.getMem5() != null) currentCount++;
	        
	        boolean wasTeamFull = (currentCount == maxSize);

	   
	        if (row.getMem2() != null && row.getMem2().equals(userId)) row.setMem2(null);
	        else if (row.getMem3() != null && row.getMem3().equals(userId)) row.setMem3(null);
	        else if (row.getMem4() != null && row.getMem4().equals(userId)) row.setMem4(null);
	        else if (row.getMem5() != null && row.getMem5().equals(userId)) row.setMem5(null);
	        
	        teamRepo.save(row);

	        requestRepo.deleteByTeamIdAndReceiverId(teamId, userId);
	        emailService.sendRemovalMail(userEmail.getEmail(), row.getTeamName(), program.getProgramName());
	        if (wasTeamFull) {
	            List<RequestEntity> pendingList = requestRepo.findByTeamIdAndStatus(teamId, "pending");
	            
	            for (RequestEntity req : pendingList) {
	                String email = (req.getReceiver() != null) ? req.getReceiver().getEmail() : req.getReceiverEmail();
	                
	               
	                emailService.sendSpotAvailableMail(email, row.getTeamName(), program.getProgramName(), pid);
	            }
	        }
		    model.addAttribute("m","Member removed  Notifications sent to pending invites!");
	        return "redirect:/viewHackathon?pid=" + pid;
	    }
	    return "redirect:/viewHackathon?pid=" + pid + "&e=Error removing member";
	}

	
	@GetMapping("/cancelRequest")
	public String cancelRequest(@RequestParam Integer pid, 
	                            @RequestParam Integer teamId, 
	                            @RequestParam Integer userId,
	                            @RequestParam String email, 
	                            Model model) {
	    try {
	  
	        if ((userId == null || userId == 0) && (email == null || email.isEmpty())) {
	            return "redirect:/viewHackathon?pid=" + pid + "&e=Invalid request data";
	        }

	        Integer safeUserId = (userId != null) ? userId : 0;
	        String safeEmail = (email != null) ? email : "no-email-provided";

	        int deletedCount = requestRepo.deletePendingRequestUnified(teamId, safeUserId, safeEmail);
	        
	        if (deletedCount > 0) {
	            return "redirect:/viewHackathon?pid=" + pid + "&m=Request withdrawn successfully!";
	        } else {
	            return "redirect:/viewHackathon?pid=" + pid + "&e=Request could not be withdrawn (maybe already accepted)";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "redirect:/viewHackathon?pid=" + pid + "&e=Error: " + e.getMessage();
	    }
	}
}
