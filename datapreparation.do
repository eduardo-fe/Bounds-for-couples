* Living Costs and Food Survey.
/*
4697 5003 5210 5375 5986 6118 6385 6655 6945 7272 7472 7702 7992 8210 8351 8459
2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017

	Inflation
2002 	1.3
2003	1.4
2004 	1.3
2005	2.1
2006	2.3
2007	2.3
2008	3.6
2009	2.2
2010	3.3
2011	4.5
2012	2.8
2013	2.6
2014	1.5
2015	0.0
2016	0.7
2017	2.7


*/


local wave 2002
local caseStep 1000000
local study 4697 5003 5210 5375 5986 6118 6385 6655 6945 7272 7472 7702 7992 8210 8351 8459  
//local study  6945 7272 7472 7702 7992 8210 8351 8459

foreach s of local study {

	display `s' 
	display "something`wave'"
	//local datadir "D:\datasets\livingCostsAndFoodSurvey\UKDA-`s'-stata\stata"
	local datadir "/Users/user/Documents/datasets/livingCostsAndFoodSurvey/UKDA-`s'-stata/stata"

	
	//use "`datadir'\\`wave'_dvper_ukanon.dta" , clear
	use "`datadir'//`wave'_dvper_ukanon.dta" , clear
	
	rename *, lower
	
	if(`wave' == 2003){
		gen a0031 = (a002 ==1)
	}
	
	
	
	
//	merge m:1 case using "`datadir'\\`wave'_dvhh_ukanon.dta"
	merge m:1 case using "`datadir'//`wave'_dvhh_ukanon.dta"

	if(`wave' == 2017) {
		drop A055 A099 Year
	}
	rename *, lower
	
	
	
	
	gen xp_cars = p545 // includes insurance, tax, and other expenditures
	gen xp_cigs	= p540t
	gen xp_coth = p541t
	gen xp_furn = b270 + b271 + c51111c +c51211c +c51212t + c51113t + c51114t + c51311t +c52111t+c52112t
	gen xp_jewl = cc3111t
	gen xp_recr = p547t + p548t // goods and services
	gen xp_food = p538t
	gen xp_alch = p539t
	gen xp_fout = cb1111t+ cb1112t+ cb1113t+cb1114t+ cb1115t+ cb1116t+ ///
		cb1117c+ cb1118c+ cb1119c+cb111ac+ cb111bc+ cb111ct+cb111dt+ cb111et+ cb111ft+ ///
		cb111gt+ cb111ht+ cb111it+cb111jt+ cb1121t+ cb1122t+cb1123t+ cb1124t+ cb1125t+ ///
		cb1126t+ cb1127t+cb1128t+ cb112bt+ cb1213t+cb2111c+ cb2112c+ cb2114t
	gen xp_educ = p610t
	gen xp_hotl = b260t + b482 + b483 + b484
	gen xp_airp = c73312t+ c73311t
	gen xp_fuel = c72211t +c72212t
	gen xp_heal	= p606t
	egen xp_elecGas = rowtotal(b170 b175 )
	
	
	
	keep case person a002 a003 a0031 a004 a010 a012p a013p ///
	a015 a200 ///
	p051* p053 ///
	a005p a006* ///
	a054 a049 a056 a069p a091 a099 p600t-p630tp p344* p60* p61* p033 b028p a227 a229 ///
	p118t p119t p120t p121t  ///
	p135t p136t ///
	p539t p540t p541t p545t p547t p548t xp_* gorx
	
	// Pension income p033
	
	gen wave = `wave'
	gen caseNew = `caseStep' + case

	if(`wave' == 2006){
		rename ( p051p p053p)(p051 p053)
 		*drop p051_df
	}
	if (`wave' <= 2006) {
		rename (p344 p051 p053)(p344p p051p p053p)
	}

	local monetary p051p p053p p600 p601 p602 p603 p604 p605 p606 p607 ///
		p608 p609 p610 p611 p612 p620tp p630tp p344p p033 b028p xp_cars ///
		xp_cigs xp_coth xp_furn xp_jewl xp_recr xp_food xp_alch xp_fout ///
		xp_educ xp_hotl xp_airp xp_fuel xp_heal xp_elecGas
	
	
		
		
	
	foreach v of local monetary {
        local l`v' : variable label `v'
	}
	
	foreach j of local monetary {

		replace `j' = . if `j' <0

		gen `j'_df = `j'
		label variable `j'_df "`l`j'' deflated"
		
		replace `j'_df = `j' * 1.07 if wave == 2016
		replace `j'_df = `j' * 1.07* 1.000 if wave == 2015
		replace `j'_df = `j' * 1.07* 1.000*1.015 if wave ==  2014
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026 if wave ==  2013
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028 if wave ==  2012
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028*1.045 if wave ==  2011
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028*1.045*1.033 if wave ==  2010
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028*1.045*1.033*1.022 if wave ==  2009
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028*1.045*1.033*1.022*1.036 if wave ==  2008
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028*1.045*1.033*1.022*1.036*1.023 if wave ==  2007
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028*1.045*1.033*1.022*1.036*1.023*1.023 if wave ==  2006
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028*1.045*1.033*1.022*1.036*1.023*1.023*1.023 if wave ==  2005
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028*1.045*1.033*1.022*1.036*1.023*1.023*1.023*1.013 if wave ==  2004
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028*1.045*1.033*1.022*1.036*1.023*1.023*1.023*1.013*1.014 if wave ==  2003
		replace `j'_df = `j' * 1.07* 1.000*1.015*1.026*1.028*1.045*1.033*1.022*1.036*1.023*1.023*1.023*1.013*1.014*1.013 if wave ==  2002
	}

	 gen birthy = wave - a005p


	gen elig = 0
	replace elig = 1 if a005p >= 65 & a004 == 1 & birthy <1955
	replace elig = 1 if a005p >= 66 & a004 == 1 & birthy >=1955
 	replace elig = 1 if a005p >= 60 & a004 == 2 & birthy <=1950
	replace elig = 1 if a005p >= 61 & a004 == 2 & birthy == 1951
	replace elig = 1 if a005p >= 62 & a004 == 2 & birthy == 1952
	replace elig = 1 if a005p >= 63 & a004 == 2 & birthy == 1953
	replace elig = 1 if a005p >= 65 & a004 == 2 & birthy == 1954
	replace elig = 1 if a005p >= 66 & a004 == 2 & birthy >= 1955

	
	gen bsla = (a010>14 & birthy<1933) | (a010>15 & birthy>=1933 & birthy <1957)  | (a010>16 & birthy >=1957)

	 
	 
	//save "D:\datasets\livingCostsAndFoodSurvey\processed\wave`wave'.dta", replace
	save "/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave`wave'.dta", replace
	
	
	
	
	local wave = `wave' + 1
	local caseStep = `caseStep' + 100000
	
	
}


* deflate expenditure variables.


//use "D:\datasets\livingCostsAndFoodSurvey\processed\wave2017.dta", clear
use "/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2017.dta", clear


/*append using "D:\datasets\livingCostsAndFoodSurvey\processed\wave2002.dta" ///
"D:\datasets\livingCostsAndFoodSurvey\processed\wave2003.dta" ///
"D:\datasets\livingCostsAndFoodSurvey\processed\wave2004.dta" ///
"D:\datasets\livingCostsAndFoodSurvey\processed\wave2005.dta" ///
"D:\datasets\livingCostsAndFoodSurvey\processed\wave2006.dta" ///
"D:\datasets\livingCostsAndFoodSurvey\processed\wave2007.dta" ///
	"D:\datasets\livingCostsAndFoodSurvey\processed\wave2008.dta" ///
	"D:\datasets\livingCostsAndFoodSurvey\processed\wave2009.dta" ///
	"D:\datasets\livingCostsAndFoodSurvey\processed\wave2010.dta" ///
	"D:\datasets\livingCostsAndFoodSurvey\processed\wave2011.dta" ///
	"D:\datasets\livingCostsAndFoodSurvey\processed\wave2012.dta" ///
	"D:\datasets\livingCostsAndFoodSurvey\processed\wave2013.dta" ///
	"D:\datasets\livingCostsAndFoodSurvey\processed\wave2014.dta" ///
	"D:\datasets\livingCostsAndFoodSurvey\processed\wave2015.dta" ///
	"D:\datasets\livingCostsAndFoodSurvey\processed\wave2016.dta"
*/

append using "/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2002.dta" ///
"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2003.dta" ///
"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2004.dta" ///
"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2005.dta" ///
"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2006.dta" ///
"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2007.dta" ///
	"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2008.dta" ///
	"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2009.dta" ///
	"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2010.dta" ///
	"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2011.dta" ///
	"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2012.dta" ///
	"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2013.dta" ///
	"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2014.dta" ///
	"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2015.dta" ///
	"/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/wave2016.dta"

* Keep only data responses given by reference person or partner.

recode a0031 0=2
keep if a003 == 1 | a0031 == 1
drop if a0031 == 1 & a003==1

* Selection of variables to keep. 

drop c11121w-oac1d

* The following loop stores the variables labels.

local otherVars a091 a056 a054  a049 a006p a005p ///
	a200 a004 a010 a015 

foreach v of local otherVars {
	local l`v' : variable label `v'
}

	
* Given that only the reference person and parter are kept, we
* now select heterosexual couples. We do this by checking that the
* gender of the partner and ref. person do not coincide using these
* commands.

bysort caseNew: egen check2 = max(a004)
bysort caseNew: egen check1 = min(a004)
keep if check1 == 1 & check2 ==2	


* Next, we can reshape by gender. Let's create a gender indicator

gen sex = ""
replace sex = "m" if a004 == 1
replace sex = "f" if a004 == 2

reshape wide  p051p_df p053p_df  a004-a091 p033_df elig a003 b028p_df birthy bsla  , i(caseNew) j(sex, string)

/*foreach j of local monetary {
	forvalues i = 1/2 {
		
		
		label variable `j'_df`i' "`l`j'' 2017 prices"

	}
}
*/

foreach j of local otherVars {
	forvalues i = 1/2 {
		
		display "`j' and `i'"
		if(`i' ==1){
			label variable `j'm "`l`j''"
		}
		else if(`i' == 2){
			label variable `j'f "`l`j''"
		}
		
		

	}
}


* AGe thresholds.
keep if (a005pm!=. & a005pf!=.) & ///
	(a005pm >=55 & a005pm <=75)& ///
	(a005pf >=55 & a005pf <=75)

 
label var p051p_dff "Income" 
label var p051p_dfm "Income" 
label var p033_dff "Pension income"
label var p033_dfm "Pension income"

 
gen retired_m = a200m == 6
gen retired_f = a200f == 6

* Drop households with more than 2 active individuals 

drop if  a056f >=3 & a056f !=.


* Expenditure per capita in the household.

gen p600_df_pc   = p600_df   / a049f
gen p620tp_df_pc = p620tp_df / a049f
gen p630tp_df_pc = p630tp_df / a049f

//centile p630tp_df_pc, centile(99)
//local cutoff = r(c_1)
//drop if p630tp_df_pc> `cutoff'
//egen totHHinc_pc = rowtotal(p053p_dff p053p_dfm), missing

egen totHHinc_pc = rowtotal(p051p_dff p051p_dfm), missing
replace totHHinc_pc = totHHinc_pc / a049f
drop  if totHHinc_pc > 2000

/*local outcomes p600_df_pc p620tp_df_pc p630tp_df_pc 
foreach y of local outcomes {
	sum `y'
	gen sd_`y' = (`y' - r(mean))/r(sd)
	sum sd_`y',det
	replace sd_`y' =.  if sd_`y'>=r(p99)
	
}*/




 

local expcats p601_df p602_df p603_df p604_df p605_df p606_df p607_df ///
	p608_df p609_df p610_df p611_df p612_df
foreach y of local expcats {
	gen `y'_pc = `y' / a049f
	sum `y'_pc
	 
}


egen ctaxcat = cut(b028p_dff), group(2) label


egen edcatf = cut(a010f), group(2) label
egen edcatm = cut(a010m), group(2) label



gen pFUN_df_pc = p611_df_pc + p609_df


local expcats p601_df p607_df p606_df pFUN_df p600_df p620tp_df p630tp_df

foreach y of local expcats{

	centile `y'_pc, centile(98)
	local cutoff = r(c_1)

drop if `y'_pc> `cutoff'

}

cluster kmeans a005pf a005pm , k(3) measure(L2) start(krandom)



save "/Users/user/Documents/datasets/livingCostsAndFoodSurvey/processed/final.dta", replace
//save "D:\datasets\livingCostsAndFoodSurvey\processed\final.dta", replace

