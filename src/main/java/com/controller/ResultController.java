package com.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.entity.ProgramEntity;
import com.entity.ProgramJudgesEntity;
import com.entity.ProgramRewardsEntity;
import com.entity.ProgramRoundsEntity;
import com.entity.RoundResultEntity;
import com.entity.SubmissionEntity;
import com.entity.TeamEntity;
import com.entity.UserEntity;
import com.repository.ProgramJudgesRepository;
import com.repository.ProgramRepository;
import com.repository.ProgramRewardsRepository;
import com.repository.ProgramRoundsRepository;
import com.repository.RoundResultRepository;
import com.repository.SubmissionRepository;
import com.repository.TeamRepository;
import com.repository.UserRepository;

import jakarta.mail.Session;
import jakarta.servlet.http.HttpSession;

@Controller
public class ResultController {

    private final JudgeController judgeController;
	@Autowired
    RoundResultRepository resultRepo;

    @Autowired
    SubmissionRepository submissionRepo;

    @Autowired
    TeamRepository teamRepo;

    @Autowired
    ProgramRoundsRepository roundRepo;

    @Autowired
    ProgramJudgesRepository judgeRepo;
    
    @Autowired
    ProgramRepository programRepo;
    @Autowired
    ProgramRewardsRepository rewardRepo;
    @Autowired
    UserRepository userRepo;

    ResultController(JudgeController judgeController) {
        this.judgeController = judgeController;
    }
	
	@GetMapping("/evaluateTeams")
	public String evaluateTeams(@RequestParam Integer roundNo, 
	                            @RequestParam Integer programId, 
	                            Model model , HttpSession session) {
	UserEntity curJudge = (UserEntity)	session.getAttribute("user");
	    
	    System.out.println("Fetching for Round No: " + roundNo + " | Program ID: " + programId);
	    
	    List<SubmissionEntity> submissionData = submissionRepo.findByRoundRoundNoAndRoundProgramProgramId(roundNo, programId);
	    
	    System.out.println("Size: " + submissionData.size());
	    
	    model.addAttribute("submissionData", submissionData);
	   List<RoundResultEntity> results =  resultRepo.findByJudge_UserId(curJudge.getUserId());
	   model.addAttribute("results" , results);
	    return "EvaluateTeams";
	}
	

	@PostMapping("/saveLink")
	public String saveLink(@RequestParam String submissionLink, 
	                       @RequestParam Integer roundNo, 
	                       @RequestParam Integer programId,
	                       @RequestParam Integer teamId , @RequestParam String submissionDesc ,Model model , RedirectAttributes attributes) {
	    
	    ProgramRoundsEntity round = roundRepo.findBySpecificRound(roundNo, programId);
	    
	    TeamEntity team = teamRepo.findById(teamId).orElse(null);
	    
	    if (round != null && team != null) {
	        SubmissionEntity submission = new SubmissionEntity();
	        submission.setSubmissionLink(submissionLink);
	        submission.setRound(round); 
	        submission.setTeam(team); 
	        submission.setSubmittedAt(LocalDateTime.now());
	        submission.setSubmissionDesc(submissionDesc);
	        
	        submissionRepo.save(submission);
	        model.addAttribute("m","Successfully Submitted");
	        attributes.addFlashAttribute("m", "Link Submitted Successfully");
	        return "redirect:/viewHackathon?pid=" + programId; 
	    }
        model.addAttribute("e","Not Submited");
        attributes.addFlashAttribute("m", "Link Not Submitted Successfully");
	    return "redirect:/viewHackathon?pid=" + programId;
	}
	
//	@PostMapping("/saveMarks")
//	@ResponseBody
//	public String saveMarks(@RequestParam Integer submissionId,
//	                        @RequestParam Integer teamId,
//	                        @RequestParam Integer roundId,
//	                        @RequestParam Integer marks,
//	                        @RequestParam String feedback,
//	                        HttpSession session) {
//		System.out.println("team id : " + teamId);
//		System.out.println("Round Id : " + roundId);
//		System.out.println("Marks : " + marks);
//		
//		
//	    try {
//	        UserEntity currentUser = (UserEntity) session.getAttribute("user");
//	        if (currentUser == null) return "SESSION_EXPIRED";
//
//	        Integer programId = roundRepo.findById(roundId).get().getProgram().getProgramId();
//
//	        Optional<RoundResultEntity> existingRecord = resultRepo
//	                .findByTeams_TeamIdAndRounds_RoundIdAndRounds_Program_ProgramId(teamId, roundId, programId);
//	        
//	        RoundResultEntity result;
//	
//	            result = new RoundResultEntity();
//	            result.setSubmission(submissionRepo.findById(submissionId).get());
//	            result.setTeams(teamRepo.findById(teamId).get());
//	            result.setRounds(roundRepo.findById(roundId).get());
//	            result.setJudge(currentUser);
//	        
//
//	        result.setMarks(marks);
//	        result.setFeedback(feedback);
//	        result.setStatus("EVALUATED");
//
//	        resultRepo.save(result);
//	        
//	        return "SUCCESS";
//
//	    } catch (Exception e) {
//	        e.printStackTrace();
//	        return "ERROR: " + e.getMessage();
//	    }
//	}
//	

	@PostMapping("/saveMarks")
	@ResponseBody
	public String saveMarks(@RequestParam Integer submissionId,
	                        @RequestParam Integer teamId,
	                        @RequestParam Integer roundId,
	                        @RequestParam Integer marks,
	                        @RequestParam String feedback,
	                        HttpSession session) {
	    
	    try {
	        UserEntity currentUser = (UserEntity) session.getAttribute("user");
	        if (currentUser == null) return "SESSION_EXPIRED";

	        // Program ID nikaalna
	        ProgramRoundsEntity round = roundRepo.findById(roundId)
	                .orElseThrow(() -> new Exception("Round not found"));
	        Integer programId = round.getProgram().getProgramId();

	        // Check karna ki kya is Team, Round aur Program ke liye pehle se marks diye gaye hain?
	        Optional<RoundResultEntity> existingRecord = resultRepo
	                .findByTeams_TeamIdAndRounds_RoundIdAndRounds_Program_ProgramIdAndJudge_UserId(teamId, roundId, programId , currentUser.getUserId());
	        
	        RoundResultEntity result;
	        
	        if (existingRecord.isPresent()) {
	            result = existingRecord.get();
	        } else {
	            // NEW SAVE LOGIC: Agar nahi mila toh naya banao
	            result = new RoundResultEntity();
	            result.setSubmission(submissionRepo.findById(submissionId).get());
	            result.setTeams(teamRepo.findById(teamId).get());
	            result.setRounds(round);
	            result.setJudge(currentUser);
	        }

	        // Common Fields (Dono case mein update honge)
	        result.setMarks(marks);
	        result.setFeedback(feedback);
	        result.setStatus("EVALUATED");

	        resultRepo.save(result);
	        return "SUCCESS";

	    } catch (Exception e) {
	        e.printStackTrace();
	        return "ERROR: " + e.getMessage();
	    }
	}
	
	@GetMapping("viewScores")
	public String viewScores(@RequestParam Integer roundId, Model model) {
	    List<RoundResultEntity> results = resultRepo.findByRounds_RoundId(roundId);
	    
	    model.addAttribute("results", results);
	    System.out.println("Size of rows " + results.size());
	    
	    
	    return "ViewScores";
	}
//	
//	@GetMapping("winnerDisplay")
//	public String winnerDisplay(@RequestParam Integer programId, Model model) {
//	    
//	    ProgramEntity program = programRepo.findById(programId).orElse(null);
//	    Optional<ProgramRewardsEntity> op = rewardRepo.findById(programId);
//	    if (program == null) return "redirect:/dashboard";
//
//	    List<Object[]> allResults = resultRepo.findFinalWinners(programId);
//	    if(op.isPresent()) {
//	    	ProgramRewardsEntity r = op.get();
//	    	 Integer limit = r.getTopRankerLimit();
//	    	    List<Object[]> winners = allResults.stream()
//	    	                                       .limit(limit)
//	    	                                       .collect(Collectors.toList());
//
//	    	    model.addAttribute("winners", winners);
//	    	    model.addAttribute("pName", program.getProgramName());
//	    }
//	    
//	   
//	
//	   
//	    return "FinalWinners"; 
//	}
	
	
//	@GetMapping("winnerDisplay")
//	public String winnerDisplay(@RequestParam Integer programId, Model model) {
//	    
//	    // 1. Program details lo
//	    ProgramEntity program = programRepo.findById(programId).orElse(null);
//	    if (program == null) return "redirect:/dashboard";
//
//	    // 2. Database se saare winners (Object[]) ki list lo
//	    List<Object[]> allResults = resultRepo.findFinalWinners(programId);
//	    
//	    // 3. Limit find karo (Default 3 rakho agar reward table me entry na mile)
//	    int limit = 3; 
//	    // Yahan ensure karein ki rewardRepo me findByProgramProgramId wala method ho
//	    Optional<ProgramRewardsEntity> op = rewardRepo.findByProgram_ProgramId(programId); 
//	    if (op.isPresent()) {
//	        limit = op.get().getTopRankerLimit();
//	    }
//
//	    // 4. Easy Handling: Agar data limit se kam hai toh handle karo
//	    // Hum sirf utne hi log uthayenge jitne available hain aur limit ke andar hain
//	    List<Object[]> winners = new ArrayList<>();
//	    if (allResults != null) {
//	        int actualToDisplay = Math.min(allResults.size(), limit);
//	        for (int i = 0; i < actualToDisplay; i++) {
//	            winners.add(allResults.get(i));
//	        }
//	    }
//
//	    // 5. Data JSP ko bhejo
//	    model.addAttribute("winners", winners);
//	    model.addAttribute("pName", program.getProgramName());
//	    
//	    return "FinalWinners"; 
//	}
	
	
	@GetMapping("winnerDisplay")
	public String winnerDisplay(@RequestParam Integer programId, Model model) {
	    ProgramEntity program = programRepo.findById(programId).orElse(null);
	    if (program == null) return "redirect:/dashboard";

	    List<Object[]> allResults = resultRepo.findFinalWinners(programId);
	    
	    // Limit Logic
	    int limit = 3; 
	    Optional<ProgramRewardsEntity> op = rewardRepo.findByProgram_ProgramId(programId); 
	    if (op.isPresent()) {
	        limit = op.get().getTopRankerLimit();
	    }

	    // Winners Processing with Names
	    List<Map<String, Object>> winnersList = new ArrayList<>();
	    if (allResults != null) {
	        int actualToDisplay = Math.min(allResults.size(), limit);
	        for (int i = 0; i < actualToDisplay; i++) {
	            Object[] data = allResults.get(i);
	            Map<String, Object> winnerMap = new HashMap<>();
	            winnerMap.put("teamName", data[0]);
	            winnerMap.put("score", data[1]);

	            // Member Names Fetching Logic
	            List<String> memberNames = new ArrayList<>();
	            for (int m = 2; m <= 6; m++) {
	                if (data[m] != null) {
	                    try {
	                        // data[m] is the ID from your query
	                        Integer userId = Integer.parseInt(data[m].toString());
	                        userRepo.findById(userId).ifPresent(u -> 
	                            memberNames.add(u.getFirstName() + " " + u.getLastName())
	                        );
	                    } catch (Exception e) { /* Skip if not a valid ID */ }
	                }
	            }
	            winnerMap.put("members", memberNames);
	            winnersList.add(winnerMap);
	        }
	    }

	    model.addAttribute("winners", winnersList);
	    model.addAttribute("pName", program.getProgramName());
	    
	    return "FinalWinners"; 
	}
}

