* Example 2. ICON 7 trial
 
cap erase temp0.dta
cap erase temp1.dta


local tot0 = 464

local tot1 = 470

import delimited using "help_file_examples\ICON7\Data\ICON7_data_arm0.txt", clear
 
ipdfc, surv(s) tstart(ts) trisk(trisk) nrisk(nrisk) probability ///
         isotonic tot(`tot0') generate(t_ipd event_ipd) saving(temp0)
  
import delimited using "help_file_examples\ICON7\Data\ICON7_data_arm1.txt", clear
 
 
 ipdfc, surv(s) tstart(ts) trisk(trisk) nrisk(nrisk) probability ///
        isotonic tot(`tot1') generate(t_ipd event_ipd) saving(temp1)

 
 use temp0, clear
 generate byte arm = 0
 append using temp1
 replace arm = 1 if missing(arm)
 stset t_ipd, failure(event_ipd)
 stcox arm
 label data "Example2 ICON7, reconstructed IPD"
 save "example2.dta", replace

  estat phtest, rank detail
  
* Kaplan-Meier Curve
sts graph, by(arm) title("") xlabel(0(3)30) ylabel(0(0.2)1) ///
risktable(0(6)30, order(1 "Bevacizumab" 2 "Standard chemo-" )) ///
    xtitle("Months since Randomization") l2title("Alive without progression") ///
	scheme(s2color) graphregion(fcolor(white)) ///
	plot1opts(lpattern(solid) lcolor(gs12)) ///
	plot2opts(lpattern(solid) lcolor(black)) ///
	legend(off) text(-0.38 -3.2 "therapy") ///
	text (0.75 14 "Bevacizumab", place(e))  text(0.5 10 "Standard chemotherapy") ///
	saving("help_file_examples\ICON7\Results\km_icon7",replace)
	
graph export "help_file_examples\ICON7\Results\km_icon7.pdf", replace
