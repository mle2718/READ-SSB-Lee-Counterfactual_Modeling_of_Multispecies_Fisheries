
*cd $inputdir
use "$inputdir/$multiplier_file", clear

cap drop sppname gearcat calyear

/*Anna will send a fixed version to me 
replace aceprice=0 if ifq==0 & spstock2=="SeaScallop"*/
cap drop ifq ladas access_area


replace spstock2=lower(spstock2)
replace spstock2=subinstr(spstock2,"ccgom","CCGOM",.)
replace spstock2=subinstr(spstock2,"snema","SNEMA",.)
replace spstock2=subinstr(spstock2,"gom","GOM",.)

replace spstock2=subinstr(spstock2,"gb","GB",.)


/*using l_ c_ and q_ as landings multiplier, catch multiplier, and quotaprice prefixes respectively */
rename landing_m l_
rename catch_m c_
rename aceprice q_


reshape wide l_ c_ q_, i(hullnum month gffishingyear spstock2_prim) j(spstock2) string
/*fill in missing l, c, and q variables that arise from the reshape */

qui foreach var of varlist l_* c_* q_* {
replace `var'=0 if `var'==.
label variable `var' ""
}

compress
rename spstock2_prim spstock2

order hullnum month gffishingyear spstock2
sort hullnum month gffishingyear spstock2
notes drop _all
gen post=0
replace post=1 if gffishingyear>=2010

replace spstock2=lower(spstock2)
replace spstock2=subinstr(spstock2,"ccgom","CCGOM",.)
replace spstock2=subinstr(spstock2,"snema","SNEMA",.)
replace spstock2=subinstr(spstock2,"gom","GOM",.)

replace spstock2=subinstr(spstock2,"gb","GB",.)

notes  drop _all 
save "$inputdir/$multiplier_out", replace
