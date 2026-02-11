package com.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.entity.TeamEntity;
import com.entity.UserEntity;
import com.repository.RequestRepository;
import com.repository.TeamRepository;
import com.repository.UserRepository;
import com.service.MailerService;

import jakarta.servlet.http.HttpSession;

@Controller
public class TeamController {

    private final ResultController resultController;

    private final TeamRepository teamRepository;
	@Autowired
	UserRepository userRepo;
	@Autowired
	TeamRepository teamRepo;
	@Autowired
	MailerService mailerService;
	@Autowired
	RequestRepository requestRepo;

    TeamController(TeamRepository teamRepository, ResultController resultController) {
        this.teamRepository = teamRepository;
        this.resultController = resultController;
    }

	
	@GetMapping("/viewHackathon/{id}")
	public String viewHackathon(@PathVariable Integer id, Model model) {



	    List<UserEntity> participants = userRepo.findByRole("participant");
	    model.addAttribute("participants", participants);

	    return "ViewHackathon";
	}
	
	@GetMapping("/makeTeam")
	public String makeTeam(TeamEntity teamEntity ,Integer pid , HttpSession session , RedirectAttributes attributes) {
		// check if user already enrolled in same hackathon as member or leader
		UserEntity user = (UserEntity) session.getAttribute("user");
		boolean isAlreadyEnrolled = teamRepo.isUserAlreadyInTeam(pid,user.getUserId());

		if (isAlreadyEnrolled) {
			attributes.addFlashAttribute("e", "You are already a part of a team in this Hackathon!");
			return "redirect:/viewHackathon?pid=" + pid;
		}

		System.out.println("Hello INSIDE MAKE A TEAM");
		teamEntity.setMem1(user.getUserId());
		teamEntity.setProgramId(pid);
		TeamEntity curTeam =	teamRepo.save(teamEntity);
		Integer curTeamId = curTeam.getTeamId();
		session.setAttribute("curTeamId", curTeamId);
		System.out.println("team created");
		requestRepo.deletePendingRequestsByReceiverAndProgram(user.getUserId(), pid);
		return "redirect:/viewHackathon?pid=" + pid;
	}
	
	
//	@GetMapping("/makeTeam")
//	public String makeTeam(TeamEntity teamEntity, Integer pid, HttpSession session, RedirectAttributes attributes) {
//	    UserEntity user = (UserEntity) session.getAttribute("user");
//	    if (user == null) return "redirect:/login";
//
////	    boolean isAlreadyEnrolled = teamRepo.isUserAlreadyInTeam(pid, user.getUserId());
////
////	    if (isAlreadyEnrolled) {
////	        attributes.addFlashAttribute("e", "You are already a part of a team in this Hackathon!");
////	        return "redirect:/viewHackathon?pid=" + pid;
////	    }
//
//	    // Team Setup
//	    teamEntity.setMem1(user.getUserId());
//	    teamEntity.setProgramId(pid);
//	    teamEntity.setRegistered(false); // Initially registration pending
//	    
//	    TeamEntity curTeam = teamRepo.save(teamEntity);
//	    
//	    // Session mein teamId rakh rahe hain as requested
//	    session.setAttribute("curTeamId", curTeam.getTeamId());
//	    
//	    // Leader ki purani pending requests delete karna
//	    requestRepo.deletePendingRequestsByReceiverAndProgram(user.getUserId(), pid);
//	    
//	    attributes.addFlashAttribute("s", "Team created successfully! Now invite your friends.");
//	    return "redirect:/viewHackathon?pid=" + pid;
//	}
////	@GetMapping("/updateTeamName")
////	public String updateTeamName(@RequestParam Integer teamId, @RequestParam String tName , Model model) {
////	    try {
////	        Optional<TeamEntity> op = teamRepo.findById(teamId);
////	        if (op.isPresent()) {
////	            TeamEntity team = op.get();
////	            team.setTeamName(tName);
////	            teamRepo.save(team);
////	            RedirectAttributes redirectAttributes.addFlashAttribute("m", "Team Name Updated Successfully!");	            
////	            return "redirect:/viewHackathon?pid=" + team.getProgramId();
////	        } else {
////	            return "redirect:/viewHackathon?e=Team not found!";
////	        }
////	    } catch (Exception e) {
////	        e.printStackTrace();
////	        return "redirect:/dashboard?e=Error updating team name";
////	    }
////	}
//
//	
	@GetMapping("/updateTeamName")
	public String updateTeamName(
	    @RequestParam Integer teamId, 
	    @RequestParam String tName, 
	    RedirectAttributes ra) { // 1. Yahan parameter add karna zaroori hai

	    try {
	        Optional<TeamEntity> op = teamRepo.findById(teamId);
	        if (op.isPresent()) {
	            TeamEntity team = op.get();
	            team.setTeamName(tName);
	            teamRepo.save(team);
	            
	            // 2. FlashAttribute redirect ke baad bhi data rakhta hai
	            ra.addFlashAttribute("m", "Team Name Updated Successfully! 🎉");
	            
	            return "redirect:/viewHackathon?pid=" + team.getProgramId();
	        } else {
	            ra.addFlashAttribute("e", "Team not found!");
	            return "redirect:/dashboard"; 
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        ra.addFlashAttribute("e", "Error: " + e.getMessage());
	        return "redirect:/dashboard";
	    }
	}
	
	@GetMapping("/registerTeam")
	public String registerTeam(Integer teamId, Integer pid) {
	    Optional<TeamEntity> op = teamRepo.findById(teamId);
	    
	    if(op.isPresent()) {
	        TeamEntity team = op.get();
	        team.setRegistered(true);
	        teamRepo.save(team);

	        List<Integer> memberIds = new ArrayList<>();
	        if(team.getMem1() != null) memberIds.add(team.getMem1());
	        if(team.getMem2() != null) memberIds.add(team.getMem2());
	        if(team.getMem3() != null) memberIds.add(team.getMem3());
	        if(team.getMem4() != null) memberIds.add(team.getMem4());
	        if(team.getMem5() != null) memberIds.add(team.getMem5());

	        for(Integer userId : memberIds) {
	            userRepo.findById(userId).ifPresent(user -> {
	                mailerService.sendRegistrationSuccessMail(
	                    user.getEmail(), 
	                    team.getTeamName(), 
	                    team.getTeamName()
	                		);
	            });
	        }
	        
	        return "redirect:/viewHackathon?pid=" + pid + "&msg=regSuccess";
	    }
	    return "redirect:/viewHackathon?pid=" + pid + "&msg=error";
	}
	
}
