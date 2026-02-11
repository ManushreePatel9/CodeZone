package com.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.entity.ProgramDetailsEntity;
import com.entity.ProgramEntity;
import com.entity.ProgramJudgesEntity;
import com.entity.ProgramRewardsEntity;
import com.entity.ProgramRoundsEntity;
import com.entity.RequestEntity;
import com.entity.SubmissionEntity;
import com.entity.TeamEntity;
import com.entity.UserEntity;
import com.repository.*;
import jakarta.servlet.http.HttpSession;

@Controller
public class ProgramController {

    private final RoundResultRepository roundResultRepository;
	
	@Autowired
	ProgramRepository programRepo;
	@Autowired
	UserRepository userRepo;
	@Autowired
	RequestRepository requestRepo;
	@Autowired
	TeamRepository teamRepo;
	@Autowired
	ProgramJudgesRepository programJudgesRepo;
	@Autowired
	SubmissionRepository submissionRepo;
	@Autowired
	ProgramDetailsRepository detailsRepo; 
	@Autowired
	ProgramRewardsRepository rewardsRepo;


    ProgramController(RoundResultRepository roundResultRepository) {
        this.roundResultRepository = roundResultRepository;
    }

	
	
	@GetMapping("/addHackathon")
	public String addHackathon(Model model) {
		List<UserEntity> judges = userRepo.findByRole("judge");
		model.addAttribute("judges",judges);
		return "AddHackathon";
	}
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
	    binder.setAutoGrowNestedPaths(true);
	}
	


	

	
	@PostMapping("/addHackathon")
    public String addProgram(
            @ModelAttribute("programEntity") ProgramEntity programEntity, 
            @RequestParam(value = "judgeIds", required = false) int[] ids, 
            Model model) {
        
       
        ProgramEntity savedProgram = programRepo.save(programEntity);

        if (programEntity.getDetails() != null) {
            ProgramDetailsEntity details = programEntity.getDetails();
            details.setProgram(savedProgram); 
            detailsRepo.save(details);      
        }
        
    
        if (programEntity.getRewards() != null) {
            ProgramRewardsEntity rewards = programEntity.getRewards();
            rewards.setProgram(savedProgram); 
            rewardsRepo.save(rewards);      
        }

        if (programEntity.getRounds() != null && !programEntity.getRounds().isEmpty()) {
            for (ProgramRoundsEntity round : programEntity.getRounds()) {
                round.setProgram(savedProgram); 
            }
            programRepo.save(savedProgram);
        }

        if (ids != null) {
            for (int id : ids) {
                ProgramJudgesEntity mapping = new ProgramJudgesEntity();
                UserEntity judgeUser = userRepo.findById(id).orElse(null);
                
                if (judgeUser != null) {
                    mapping.setJudge(judgeUser);    
                    mapping.setProgram(savedProgram);
                    programJudgesRepo.save(mapping);
                }
            }
        }

        model.addAttribute("m", "Hackathon Added Successfully!");
        return "aDashboard"; 
    }






	@GetMapping("viewAllHackathon")
	public String viewHackathons(
			@RequestParam(value = "mode", required = false) String mode,
			@RequestParam(value = "payment", required = false) String payment,
	        Model model) {

	    List<ProgramEntity> list;
	    LocalDateTime now = LocalDateTime.now();

	    boolean modePresent = (mode != null && !mode.isEmpty());
	    boolean paymentPresent = (payment != null && !payment.isEmpty());

	    if (!modePresent && !paymentPresent) {
	        list = programRepo.findByDueDateGreaterThanEqual(now);
	    }
	    else if (modePresent && paymentPresent) {
	        list = programRepo.findByDetails_ModeIgnoreCaseAndDetails_PaymentIgnoreCaseAndDueDateGreaterThanEqual(mode, payment, now);
	    }
	    else if (modePresent) {
	        list = programRepo.findByDetails_ModeIgnoreCaseAndDueDateGreaterThanEqual(mode, now);
	    }
	    else {
	        list = programRepo.findByDetails_PaymentIgnoreCaseAndDueDateGreaterThanEqual(payment, now);
	    }

	    model.addAttribute("hackathons", list);
	    model.addAttribute("selectedMode", mode);
	    model.addAttribute("selectedPayment", payment);
	    return "ViewAllHackathon";
	}
	 @GetMapping("/viewHackathon")
	 public String viewHackathon(@RequestParam Integer pid, Model model, HttpSession session) {
	     UserEntity user = (UserEntity) session.getAttribute("user");
	     if (user == null) return "redirect:/login";

	     Optional<TeamEntity> teamOp = teamRepo.findByProgramIdAndLeaderId(pid, user.getUserId());
	     
	     if (teamOp.isPresent()) {
	         TeamEntity team = teamOp.get();
	         if(team.getTeamId()!=null) {
		         Integer curTeamId = team.getTeamId();
		         
		         session.setAttribute("curTeamId", curTeamId);
		         model.addAttribute("curTeamId", curTeamId);
		         model.addAttribute("teamName", team.getTeamName()); 	        	 
	         }

	     } else {
	         session.removeAttribute("curTeamId");
	     }
	     
	     ProgramEntity h = programRepo.findById(pid).orElse(null);
	     List<UserEntity> participants = userRepo.findByRole("participant");
	     List<RequestEntity> reqReceivers = requestRepo.findByProgramId(pid);
	     List<TeamEntity> teams = teamRepo.findAll();
	     List<SubmissionEntity> submissions = submissionRepo.findAll();
	     List<ProgramDetailsEntity> details = detailsRepo.findAll();
	     List<ProgramRewardsEntity> rewards = rewardsRepo.findAll();
	     
	     model.addAttribute("reqReceivers", reqReceivers != null ? reqReceivers : new ArrayList<>());
	     model.addAttribute("h", h);
	     model.addAttribute("participants", participants);
	     model.addAttribute("teams" , teams);
	     model.addAttribute("curProgramId" , pid);
	     model.addAttribute("submissions" ,submissions);
	     model.addAttribute("details" , details);
	     model.addAttribute("rewards" , rewards);
	    
	     return "HackathonDetails";
	 }
	 
	
	 
	 @GetMapping("/dashboard")
	 public String getDashboard(HttpSession session, Model model) {
	     UserEntity user = (UserEntity) session.getAttribute("user");
	     if (user == null) return "redirect:/login";

	     List<TeamEntity> teams = teamRepo.findAllMyTeams(user.getUserId());
	     
	     System.out.println("Teams found for user: " + teams.size());

	     List<ProgramEntity> myHackathons = new ArrayList<>();
	     for (TeamEntity t : teams) {
	         programRepo.findById(t.getProgramId()).ifPresent(myHackathons::add);
	     }

	     model.addAttribute("myHackathons", myHackathons);
	     model.addAttribute("requests", requestRepo.findByReceiver(user));
	     return "pDashboard";
	 }
}
