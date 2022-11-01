* Example 3: Europa trial

cap erase temp0.dta
cap erase temp1.dta

import delimited using "help_file_examples\EUROPA\Data\EUROPA_data_arm0.txt", clear
ipdfc, surv(s) failure isotonic tstart(ts) trisk(trisk) nrisk(nrisk) generate(t_ipd event_ipd) saving(temp0)

import delimited using "help_file_examples\EUROPA\Data\EUROPA_data_arm1.txt", clear

ipdfc, surv(s) failure isotonic tstart(ts) trisk(trisk) nrisk(nrisk) generate(t_ipd event_ipd) saving(temp1)



 use temp0, clear
 generate byte arm = 0
 append using temp1
 replace arm = 1 if missing(arm)
 stset t_ipd, failure(event_ipd)
 stcox arm
 
  label data "Example3 EUROPA, reconstructed IPD"
 save "example3.dta", replace

sts graph, by(arm) failure title("") ylabel(0(0.04)0.14) risktable(0(1)5, order(1 "Placebo" 2 "Perindopril")) xtitle("Time(years)") ///
           ytitle("Probability of composite events") ///
		   plot1opts(lpattern(solid) lcolor(gs12)) ///
	       plot2opts(lpattern(solid) lcolor(black)) ///
		   scheme(s2color) graphregion(fcolor(white)) ///
		   text(0.07 4.5 "Perindopril") text(0.125 4.6 "Placebo") ///
	       saving("help_file_examples\EUROPA\Results\km_europa",replace) legend(off)		   

		   
graph export "help_file_examples\EUROPA\Results\km_europa.eps", replace
