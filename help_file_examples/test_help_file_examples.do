* Example 1: Head and neck cancer trial

cap erase temp0.dta
cap erase temp1.dta
import delimited using "help_file_examples\Guyot2012\Data\Head_and_neck_arm0.txt", clear
ipdfc, surv(s) tstart(ts) trisk(trisk) nrisk(nrisk) isotonic generate(t_ipd event_ipd) saving(temp0)

import delimited using "help_file_examples\Guyot2012\Data\Head_and_neck_arm1.txt", clear
ipdfc, surv(s) tstart(ts) trisk(trisk) nrisk(nrisk) isotonic generate(t_ipd event_ipd) saving(temp1)

use temp0, clear
gen byte arm = 0
append using temp1
replace arm = 1 if missing(arm)
label define ARM 0 "Radiotherapy" 1 "Radiotherapy plus Cetuximab"
label values arm ARM
stset t_ipd, failure(event_ipd)

stcox arm
sts graph, by(arm) title("") xlabel(0(10)70) ylabel(0(0.2)1) ///
    xtitle("Months") l2title("Locoregional Control") legend(off) ///
    text(0.52 53 "Radiotherapy plus Cetuximab") text(0.20 60 "Radiotherapy") ///
    risktable(0(10)50, order(2 "Radiotherapy" 1 "Radiotherapy plus" bottom(msize(5)))) ///
    text(-0.38 -9 "Cetuximab")

	
* Example 2: ICON7

cap erase temp0.dta
cap erase temp1.dta

  local tot0=464
  local tot1=470
  import delimited using "help_file_examples\ICON7\Data\ICON7_data_arm0.txt", clear
  ipdfc, surv(s) tstart(ts) trisk(trisk) nrisk(nrisk) probability iso tot(`tot0') ///
    generate(t_ipd event_ipd) saving(temp0)
  import delimited using "help_file_examples\ICON7\Data\ICON7_data_arm1.txt", clear
  ipdfc, surv(s) tstart(ts) trisk(trisk) nrisk(nrisk) probability iso tot(`tot1') ///
    generate(t_ipd event_ipd) saving(temp1)

	
	use temp0, clear
    generate byte arm = 0
    append using temp1
    replace arm = 1 if missing(arm)
    stset t_ipd, failure(event_ipd)
    stcox arm
    sts graph, by(arm) xlabel(0(3)30) ylabel(0(0.2)1) ///
    risktable(0(6)30, order(1 "Bevacizumab" 2 "Standard chemo-" )) legend(off) ///
    xtitle("Months since Randomization") l2title("Alive without progression") ///
    plot1opts(lpattern(solid) lcolor(gs12)) plot2opts(lpattern(solid) lcolor(black)) ///
    text(-0.38 -3.2 "therapy") text(0.75 14 "Bevacizumab", place(e)) text(0.5 10 "Standard chemotherapy")

* Example 3: Europa
cap erase temp0.dta
cap erase temp1.dta

 import delimited using "help_file_examples\EUROPA\Data\europa_data_arm0.txt", clear
 ipdfc, surv(s) tstart(ts) trisk(trisk) nrisk(nrisk) failure iso ///
    generate(t_ipd event_ipd) saving(temp0)
 import delimited using "help_file_examples\EUROPA\Data\europa_data_arm1.txt", clear
 ipdfc, surv(s) tstart(ts) trisk(trisk) nrisk(nrisk) failure iso ///
    generate(t_ipd event_ipd) saving(temp1)
	
    use temp0, clear
    generate byte arm = 0
    append using temp1
    replace arm = 1 if missing(arm)
    stset t_ipd, failure(event_ipd)
    stcox arm
     sts graph, by(arm) failure title("") ylabel(0(0.04)0.14) ///
    risktable(0(1)5, order(1 "Placebo" 2 "Perindopril")) ///
	plot1opts(lpattern(solid) lcolor(gs12)) plot2opts(lpattern(dashed) lcolor(black)) ///
    xtitle("Time(years)") ytitle("Probability of composite events") ///
    text(0.07 4.5 "Perindopril") text(0.125 4.6 "Placebo") legend(off)


