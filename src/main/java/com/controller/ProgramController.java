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
	ProgramDetailsRepository detailsRepo; // Ye naya add karna padega
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
	


	
//	@PostMapping("/addHackathon")
//	public String addProgram(
//	        @ModelAttribute("programEntity") ProgramEntity programEntity, 
//	        @RequestParam(value = "judgeIds", required = false) int[] ids, 
//	        Model model) {
//	    
//	    if (programEntity.getRounds() != null) {
//	        for (ProgramRoundsEntity round : programEntity.getRounds()) {
//	            round.setProgram(programEntity);
//	        }
//	    }
//
//	    ProgramEntity savedProgram = programRepo.save(programEntity);
//
//	    if(ids != null) {
//	        for(int i=0; i < ids.length; i++) {
//	            ProgramJudgesEntity mapping = new ProgramJudgesEntity();
//	            
//	        
//	            UserEntity judgeUser = userRepo.findById(ids[i]).orElse(null);
//	            
//	            if(judgeUser != null) {
//	                mapping.setJudge(judgeUser);    
//	                mapping.setProgram(savedProgram);
//	                programJudgesRepo.save(mapping);
//	            }
//	        }
//	    }
//
//	    model.addAttribute("m", "Hackathon & Judges Added Successfully!");
//	    return "aDashboard"; 
//	}
//	
	
//	@PostMapping("/addHackathon")
//	public String addProgram(
//	        @ModelAttribute("programEntity") ProgramEntity programEntity, 
//	        @RequestParam(value = "judgeIds", required = false) int[] ids, 
//	        Model model) {
//	    
//	    // 1. Bi-directional mapping set karo (Parent ko child se link karo)
//	    
//	    // Rounds Link
//	    if (programEntity.getRounds() != null) {
//	        for (ProgramRoundsEntity round : programEntity.getRounds()) {
//	            round.setProgram(programEntity);
//	        }
//	    }
//	    
//	    // Details Link
//	    if (programEntity.getDetails() != null) {
//	        programEntity.getDetails().setProgram(programEntity);
//	    }
//	    
//	    // Rewards Link
//	    if (programEntity.getRewards() != null) {
//	        programEntity.getRewards().setProgram(programEntity);
//	    }
//
//	    // 2. Program Save Karo (CascadeType.ALL ki wajah se details aur rewards bhi saath me save honge)
//	    ProgramEntity savedProgram = programRepo.save(programEntity);
//
//	    // 3. Judges Mapping (Ye alag table hai isliye loop chalega)
//	    if(ids != null) {
//	        for(int id : ids) {
//	            ProgramJudgesEntity mapping = new ProgramJudgesEntity();
//	            UserEntity judgeUser = userRepo.findById(id).orElse(null);
//	            
//	            if(judgeUser != null) {
//	                mapping.setJudge(judgeUser);    
//	                mapping.setProgram(savedProgram);
//	                programJudgesRepo.save(mapping);
//	            }
//	        }
//	    }
//
//	    model.addAttribute("m", "Hackathon, Details & Rewards Added Successfully!");
//	    return "aDashboard"; 
//	}
//	
	
	@PostMapping("/addHackathon")
    public String addProgram(
            @ModelAttribute("programEntity") ProgramEntity programEntity, 
            @RequestParam(value = "judgeIds", required = false) int[] ids, 
            Model model) {
        
        // 1. Pehle Parent (Program) ko save karo
        // Isse humein 'programId' mil jayega jo details aur rewards ke liye foreign key banega
        ProgramEntity savedProgram = programRepo.save(programEntity);

        // 2. Program Details Manual Mapping & Save
        // JSP mein "details.xyz" hone ki wajah se ye null nahi aayega
        if (programEntity.getDetails() != null) {
            ProgramDetailsEntity details = programEntity.getDetails();
            details.setProgram(savedProgram); // Foreign Key link set kiya (program_id)
            detailsRepo.save(details);        // Manual Save in program_details table
        }
        
        // 3. Program Rewards Manual Mapping & Save
        // JSP mein "rewards.xyz" hone ki wajah se ye null nahi aayega
        if (programEntity.getRewards() != null) {
            ProgramRewardsEntity rewards = programEntity.getRewards();
            rewards.setProgram(savedProgram); // Foreign Key link set kiya (program_id)
            rewardsRepo.save(rewards);        // Manual Save in program_rewards table
        }

        // 4. Program Rounds Link (Bi-directional mapping for List)
        if (programEntity.getRounds() != null && !programEntity.getRounds().isEmpty()) {
            for (ProgramRoundsEntity round : programEntity.getRounds()) {
                round.setProgram(savedProgram); // Har round ko parent program se joda
            }
            // Rounds list ko finalize karne ke liye save
            programRepo.save(savedProgram);
        }

        // 5. Judges Mapping (Join Table Logic)
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

        model.addAttribute("m", "Hackathon, Details & Rewards Added Successfully!");
        return "aDashboard"; 
    }


//	 @GetMapping("viewAllHackathon")
//	    public String viewHackathons(
//	   String mode,
//	   String payment,
//	            Model model) {
//
//	        List<ProgramEntity> list;
//
//	        if (mode == null && payment == null) {
//	            list = programRepo.findAll();
//	        }
//	    
//	        else if (mode != null && payment != null) {
//	            list = programRepo.findByModeAndPayment(mode, payment);
//	        }
//	      
//	        else if (mode != null) {
//	            list = programRepo.findByDetails_Mode(mode);
//	        }
//	     
//	        else {
//	            list = programRepo.findByDetails_Payment(payment);
//	        }
//
//	        model.addAttribute("hackathons", list);
//	        model.addAttribute("selectedMode", mode);
//	        model.addAttribute("selectedPayment", payment);
//
//	        return "ViewAllHackathon";
//	    }
//	
	
//	@GetMapping("viewAllHackathon")
//	public String viewHackathons(
//	        @RequestParam(required = false) String mode,
//	        @RequestParam(required = false) String payment,
//	        Model model) {
//
//	    List<ProgramEntity> list;
//	    LocalDateTime now = LocalDateTime.now(); // Aaj ki date aur time
//
//	    // Check karein ki parameters empty toh nahi hain
//	    boolean modePresent = (mode != null && !mode.isEmpty());
//	    boolean paymentPresent = (payment != null && !payment.isEmpty());
//
//	    if (!modePresent && !paymentPresent) {
//	        // Case 1: Kuch select nahi kiya, saare dikhao
//	        list = programRepo.findAll();
//	    }
//	    else if (modePresent && paymentPresent) {
//	        // Case 2: Dono select kiye hain (Fixed method name)
//	        list = programRepo.findByDetails_ModeAndDetails_Payment(mode, payment);
//	    }
//	    else if (modePresent) {
//	        // Case 3: Sirf Mode select kiya hai
//	        list = programRepo.findByDetails_Mode(mode);
//	    }
//	    else {
//	        // Case 4: Sirf Payment select kiya hai
//	        list = programRepo.findByDetails_Payment(payment);
//	    }
//
//	    model.addAttribute("hackathons", list);
//	    model.addAttribute("selectedMode", mode);
//	    model.addAttribute("selectedPayment", payment);
//
//	    return "ViewAllHackathon";
//	}



	@GetMapping("viewAllHackathon")
	public String viewHackathons(
	        @RequestParam(required = false) String mode,
	        @RequestParam(required = false) String payment,
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
	     System.out.println("Bada vala View Hackathon");
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
	 
	
	
	
//	@GetMapping("/viewHackathon")
//	public String viewHackathon(@RequestParam Integer pid, Model model, HttpSession session) {
//	    UserEntity user = (UserEntity) session.getAttribute("user");
//	    if (user == null) return "redirect:/login";
//
//	    // 1. Sirf is Program ke Details aur Rewards nikalein
//	    // Note: In methods ko apne Repositories mein define karein: findByProgramId(pid)
//	    List<ProgramDetailsEntity> details = detailsRepo.findByProgram_ProgramId(pid); 
//	    List<ProgramRewardsEntity> rewards = rewardsRepo.findByProgram_ProgramId(pid); 
//	    
//	    // 2. Baki logic (Team and Program)
//	    ProgramEntity h = programRepo.findById(pid).orElse(null);
//	    Optional<TeamEntity> teamOp = teamRepo.findByProgramIdAndLeaderId(pid, user.getUserId());
//	    
//	    if (teamOp.isPresent()) {
//	        model.addAttribute("curTeamId", teamOp.get().getTeamId());
//	        model.addAttribute("teamName", teamOp.get().getTeamName()); 	        	 
//	    }
//
//	    List<UserEntity> participants = userRepo.findByRole("participant");
//	    List<RequestEntity> reqReceivers = requestRepo.findByProgramId(pid);
//	    
//	    // Model Attributes
//	    model.addAttribute("h", h);
//	    model.addAttribute("details", details);
//	    model.addAttribute("rewards", rewards);
//	    model.addAttribute("reqReceivers", reqReceivers);
//	    model.addAttribute("participants", participants);
//	    
//	    return "HackathonDetails";
//	}
	 
	 @GetMapping("/dashboard")
	 public String getDashboard(HttpSession session, Model model) {
	     UserEntity user = (UserEntity) session.getAttribute("user");
	     if (user == null) return "redirect:/login";

	     // 1. Sidha Native Query call karo
	     List<TeamEntity> teams = teamRepo.findAllMyTeams(user.getUserId());
	     
	     // 2. Debug ke liye print karo (Console mein check karna data aa raha hai ya nahi)
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
