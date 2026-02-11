package com.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class FilterController {
	@GetMapping("filterData")
	public String filterData(
	         String mode,
	        String payment,
	        Model model) {
System.out.println("In Filter");
System.out.println("Mode "+mode);
System.out.println("Payment : " + payment);

	    return "aDashboard";
	}

}
