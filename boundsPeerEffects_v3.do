program drop npbpe
program npbpe, rclass

	syntax varname(numeric max=3) [if] [in] [,ALPHA(numlist) REGressors(varlist) AT(numlist) BW(numlist)]
	tempvar  Y Df Dm 
	
	tokenize `varlist'
			
	gen `Y' = `1'
	gen `Df' = `2'
	gen `Dm' = `3'
	
	
	marksample touse 
	qui {
	if ("`regressors'" == ""){
		sum `Y' if `touse'
		local Ey=r(mean) 

		sum `Df' if `touse' 
		local pf1 = r(mean)
		local pf0 = 1-`pf1'
			
		sum `Dm' if `touse' 
		local pm1 = r(mean)
		local pm0 = 1-`pm1'
		
		gen __aux = (`Df' == 1 & `Dm' == 1)
		sum __aux if `touse'  
		local p11 = r(mean)
		drop __aux  
		
		gen __aux = (`Df' == 1 & `Dm' == 0)
		sum __aux if `touse'
		local p10 = r(mean)
		drop __aux
		
		gen __aux = (`Df' == 0 & `Dm' == 1)
		sum __aux if `touse'
		local p01 = r(mean)
		drop __aux
		
		gen __aux = (`Df' == 0 & `Dm' == 0)
		sum __aux if `touse'
		local p00 = r(mean)
		drop __aux
		
		
		local P11 = `p11'*100
		local P10 = `p10'*100
		local P01 = `p01'*100
		local P00 = `p00'*100
		local Q11 = 100-`P11'
		local Q10 = 100-`P10'
		local Q01 = 100-`P01'
		local Q00 = 100-`P00'
		
		/* This is different from the same file in folder "code" */
		sum `Y' if `touse'
		local a11 = r(min)
	
		sum `Y' if `touse'
		local b11 = r(max)
		
		sum `Y' if `touse'
		local a10 = r(min)
		
		sum `Y' if `touse'
		local b10 = r(max)
		
		sum `Y' if  `touse'
		local a01 = r(min)
		
		sum `Y' if  `touse'
		local b01 = r(max)
	
		sum `Y' if  `touse'
		local a00 = r(min)
		
		sum `Y' if  `touse'
		local b00 = r(max)
		
		
		sum `Y' if `Df' == 1 & `Dm' == 1 & `touse'
		local Ey11 = r(mean)
		
		sum `Y' if `Df' == 0 & `Dm' == 1 & `touse'
		local Ey01 = r(mean)
		
		sum `Y' if `Df' == 1 & `Dm' == 0 & `touse'
		local Ey10 = r(mean)

		sum `Y' if `Df' == 0 & `Dm' == 0 & `touse'
		local Ey00 = r(mean)
		
		sum `Y' if `Df' == 1 & `touse'
		local Eyf1 = r(mean)
	
		sum `Y' if `Df' == 0 & `touse'
		local Eyf0 = r(mean)
		
		sum `Y' if `Dm' == 1 & `touse'
		local Eym1 = r(mean)
	
		sum `Y' if `Dm' == 0 & `touse'
		local Eym0 = r(mean)
	}
		
	else {
		liRacine  `Y' `regressors' if `touse', at(`at')   
		local Ey=r(ytilde)
		 display "`Ey'"

		liRacine `Df' `regressors' if `touse', at(`at') 
		local pf1 = r(ytilde)
		local pf0 = 1-`pf1'
		
		liRacine `Dm' `regressors' if `touse', at(`at')
		local pm1 = r(ytilde)
		local pm0 = 1-`pm1'
		
		display "`pf1' and `pm0'"
		
		gen __aux = (`Df' == 1 & `Dm' == 1)
		liRacine __aux `regressors' if `touse', at(`at')
		local p11 = r(ytilde)
		drop __aux
			
		gen __aux = (`Df' == 1 & `Dm' == 0)
		liRacine __aux `regressors' if `touse', at(`at')
		local p10 = r(ytilde)
		drop __aux
		
		gen __aux = (`Df' == 0 & `Dm' == 1)
		liRacine __aux `regressors' if `touse', at(`at')
		local p01 = r(ytilde)
		drop __aux
		
		gen __aux = (`Df' == 0 & `Dm' == 0)
		liRacine __aux `regressors' if `touse', at(`at')
		local p00 = r(ytilde)
		drop __aux
		
		display "`p11' and `p10' and `p01'  and `p00'"
		
		local P11 = `p11'*100
		local P10 = `p10'*100
		local P01 = `p01'*100
		local P00 = `p00'*100
		local Q11 = 100-`P11'
		local Q10 = 100-`P10'
		local Q01 = 100-`P01'
		local Q00 = 100-`P00'
		
		/* This is different from the code in the folder "code"*/
		sum `Y' if `touse'
		local a11 = r(min)
	
		sum `Y' if `touse'
		local b11 = r(max)
		
		sum `Y' if `touse'
		local a10 = r(min)
		
		sum `Y' if `touse'
		local b10 = r(max)
		
		sum `Y' if  `touse'
		local a01 = r(min)
		
		sum `Y' if  `touse'
		local b01 = r(max)
	
		sum `Y' if  `touse'
		local a00 = r(min)
		
		sum `Y' if  `touse'
		local b00 = r(max)
		
		
		liRacine `Y' `regressors' if `Df' == 1 & `Dm' == 1 & `touse', at(`at')
		local Ey11 = r(ytilde)
		
		liRacine `Y' `regressors' if `Df' == 0 & `Dm' == 1 & `touse', at(`at')
		local Ey01 = r(ytilde)
		
		liRacine `Y' `regressors' if `Df' == 1 & `Dm' == 0 & `touse', at(`at')
		local Ey10 = r(ytilde)

		liRacine `Y' `regressors' if `Df' == 0 & `Dm' == 0 & `touse', at(`at')
		local Ey00 = r(ytilde)
		
		liRacine `Y' `regressors' if `Df' == 1 & `touse', at(`at')
		local Eyf1 = r(ytilde)
	
		liRacine `Y' `regressors' if `Df' == 0 & `touse', at(`at')
		local Eyf0 = r(ytilde)
		
		liRacine `Y' `regressors' if `Dm' == 1 & `touse', at( `at')
		local Eym1 = r(ytilde)
	
		liRacine `Y' `regressors' if `Dm' == 0 & `touse', at(`at')
		local Eym0 = r(ytilde)
	
	 }
		 
	}	 
	
	if("`alpha'"!="") {
		 
		local alpha_f = `alpha'
		local alpha_m = `alpha'
		 
		
	}
	else {
		local alpha_f = 1
		local alpha_m = 1
	}
	
	
		
			
			
	//local methods zr cmtr cmtrg  ots mts cmtrMts  cmtrOts cmtrgOts otsMts cMtrOtsMts
	local methods zr cmtr ots mts cmtrMts cmtrOts otsMts cMtrOtsMts
	foreach j of local methods {
		if("`j'" == "zr") {
			 display "ZR"
			
			local `j'Y00_l = `Ey00'*`p00'+`a10'*`p10' +`a01'*`p01'+`a11'*`p11'
			local `j'Y00_u = `Ey00'*`p00'+`b10'*`p10' +`b01'*`p01'+`b11'*`p11'
		
			local `j'Y11_l = `Ey11'*`p11'+ `a10'*`p10' +`a01'*`p01' +`a00'*`p00'
			local `j'Y11_u = `Ey11'*`p11'+ `b10'*`p10' +`b01'*`p01' +`b00'*`p00'
			
			local `j'Y10_l = `Ey10'*`p10'+ `a11'*`p11'+`a01'*`p01' + `a00'*`p00'
			local `j'Y10_u = `Ey10'*`p10'+ `b11'*`p11'+`b01'*`p01' + `b00'*`p00'
			
			local `j'Y01_l = `Ey01'*`p01'+ `a11'*`p11'+`a10'*`p10' + `a00'*`p00'
			local `j'Y01_u = `Ey01'*`p01'+ `b11'*`p11'+`b10'*`p10' + `b00'*`p00'
			
		 
			
		}
		else if("`j'" == "cmtr") {
			 
			display "CMTR"
			local `j'Y00_l = `Ey' 
			local `j'Y00_u = `Ey00'*`p00'+`b10'*`p10' +`b01'*`p01'+`b11'*`p11'
		
			local `j'Y11_l = `Ey11'*`p11'+ `a10'*`p10' +`a01'*`p01' +`a00'*`p00'
			local `j'Y11_u = `Ey'
			
			local `j'Y10_l = `Ey10'*`p10' +`Ey11'*`p11'+`a01'*`p01' + `a00'*`p00'
			local `j'Y10_u = `Ey10'*`p10' +`Ey00'*`p00' +`b01'*`p01' + `b11'*`p11'
			
			local `j'Y01_l = `Ey01'*`p01' +`Ey11'*`p11' +`a10'*`p10'+`a00'*`p00'
			local `j'Y01_u = `Ey01'*`p01' +`Ey00'*`p00'+`b10'*`p10' + `b11'*`p11'
			
			matrix m`j'atef_l = ``j'Y10_l' - ``j'Y00_u'
			matrix m`j'atef_u = ``j'Y10_u' - ``j'Y00_l'
			
			matrix m`j'atem_l = ``j'Y01_l' - ``j'Y00_u'
			matrix m`j'atem_u = ``j'Y01_u' - ``j'Y00_l'
			
			matrix m`j'atej_l = ``j'Y11_l' - ``j'Y00_u'
			matrix m`j'atej_u = ``j'Y11_u' - ``j'Y00_l'
			
			matrix m`j'ateif_l = ``j'Y11_l' - ``j'Y01_u'
			matrix m`j'ateif_u = ``j'Y11_u' - ``j'Y01_l'
			
			matrix m`j'ateim_l = ``j'Y11_l' - ``j'Y10_u'
			matrix m`j'ateim_u = ``j'Y11_u' - ``j'Y10_l'
			
		
			
			
			return matrix m`j'atef_l=m`j'atef_l
			return matrix m`j'atef_u=m`j'atef_u
			return matrix m`j'atem_l=m`j'atem_l
			return matrix m`j'atem_u=m`j'atem_u
			return matrix m`j'atej_l=m`j'atej_l
			return matrix m`j'atej_u=m`j'atej_u
			return matrix m`j'ateif_l=m`j'ateif_l
			return matrix m`j'ateif_u=m`j'ateif_u
			return matrix m`j'ateim_l=m`j'ateim_l
			return matrix m`j'ateim_u=m`j'ateim_u
			
		}
		else if ("`j'" == "cmtrg"){
			
			display "CMTR-G."
			local `j'Y00_l = `Ey' 
			local `j'Y00_u = `Ey00'*`p00'+`b10'*`p10' +`b01'*`p01'+`b11'*`p11'
		
			local `j'Y11_l = `Ey11'*`p11'+ `a10'*`p10' +`a01'*`p01' +`a00'*`p00'
			local `j'Y11_u = `Ey'
			
			local `j'Y10_l = `Ey11'*`p11'+`Ey10'*`p10'+`Ey01'*`p01' + `a00'*`p00'
			local `j'Y10_u = `Ey00'*`p00'+`Ey10'*`p10' +`b01'*`p01' + `b11'*`p11'
			
			local `j'Y01_l = `Ey01'*`p01' +`Ey11'*`p11' +`a10'*`p10'+`a00'*`p00'
			local `j'Y01_u = `Ey00'*`p00'+`Ey01'*`p01' +`Ey10'*`p10' + `b11'*`p11'
			
			 
			 
		}
		else if ("`j'" == "ots"){
			
			
			
			display "OTS."
			local `j'Y00_l = `Ey00'*`p00' + `a10'*`p10'+ `a01'*`p01'+ `a11'*`p11' 
			local `j'Y00_u = `Ey00'*`p00'+(1/`alpha_f')*`Ey10'*`p10' ///
							+(1/`alpha_m')*`Ey01'*`p01' ///
							+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
							
							
			local `j'Y11_l = `Ey11'*`p11' + `a10'*`p10'+ `a01'*`p01'+ `a00'*`p00' 
			
			local `j'Y11_u = `Ey11'*`p11'+`alpha_f'*`Ey01'*`p01' ///
							+`alpha_m'*`Ey10'*`p10' ///
							+`alpha_f'*`alpha_m'*`Ey00'*`p00'
			
			
			
			
			local `j'Y10_l = `Ey10'*`p10' + `a11'*`p11'+ `a01'*`p01'+ `a00'*`p00' 
			local `j'Y10_u = `Ey10'*`p10' + (`alpha_f'/`alpha_m')*`Ey01'*`p01' +`alpha_f'*`Ey00'*`p00' ///
							+(1/`alpha_m')*`Ey11'*`p11'
			
			
			local `j'Y01_l = `Ey01'*`p01' + `a11'*`p11'+ `a10'*`p10'+ `a00'*`p00' 
			local `j'Y01_u = `Ey01'*`p01' + (`alpha_m'/`alpha_f')*`Ey10'*`p10' +`alpha_m'*`Ey00'*`p00' ///
							+(1/`alpha_f')*`Ey11'*`p11'
			
			 
		}
		else if ("`j'" == "mts"){
			
			
			display "MTS."
			local `j'Y00_l = `Ey00'*`p00' + `a10'*`p10'+ `a01'*`p01'+ `a11'*`p11' 
			local `j'Y00_u = `Ey00'
							
			local `j'Y11_l = `Ey11' 
			local `j'Y11_u = `Ey11'*`p11' + `b10'*`p10'+ `b01'*`p01'+ `b00'*`p00'
			
			local `j'Y10_l = `Ey10'*(`p10'+`p00')+`a01'*`p01' + `a11'*`p11'
			local `j'Y10_u = `Ey10'*(`p10'+`p11')+`b01'*`p01' + `b00'*`p00'
			
			
			local `j'Y01_l = `Ey01'*(`p01'+`p00')+`a10'*`p10' + `a11'*`p11'
			local `j'Y01_u = `Ey01'*(`p01'+`p11')+`b10'*`p10' + `b00'*`p00'
			
			 
			 
		}
		else if ("`j'" == "cmtrMts"){
			display "CMTR +MTR "
			
			local `j'Y00_l = `Ey' 
			local `j'Y00_u = `Ey00'
			local `j'Y11_l = `Ey11'
			local `j'Y11_u = `Ey'
			local `j'Y10_l = `Ey10'*(`p10'+`p00') + `a01'*`p01' + `Ey11'*`p11'
			local `j'Y10_u = `Ey10'*(`p10'+`p11') + `b01'*`p01' + `Ey00'*`p00'
			local `j'Y01_l =  `Ey01'*(`p01'+`p00') + `a10'*`p10'+`Ey11'*`p11' 
			local `j'Y01_u = `Ey01'*(`p01'+`p11') + `b10'*`p10' + `Ey00'*`p00'
			
			  
			 
		}
		else if ("`j'" == "cmtrgMts"){
			display "CMTR-G + MTS"
			local `j'Y00_l = `Ey' 
			local `j'Y00_u = `Ey00'
			local `j'Y11_l = `Ey11'
			local `j'Y11_u = `Ey'
			local `j'Y10_l = `Ey10'*(`p10'+`p00') + `Ey01'*`p01'+`Ey11'*`p11'
			local `j'Y10_u = `Ey10'*(`p10'+`p11') + `b01'*`p01' + `Ey00'*`p00'
			local `j'Y01_l =  `Ey01'*(`p01'+`p00') + `a10'*`p10'+`Ey11'*`p11' 
			local `j'Y01_u = `Ey01'*(`p01'+`p11') +`Ey10'*`p10' + `Ey00'*`p00'
			
		 
		}
		else if ("`j'" == "cmtrOts"){
			display "CMTR + OTS"
			 				
			
			
			local `j'Y00_l = `Ey' 
			local `j'Y00_u = `Ey00'*`p00'+(1/`alpha_f')*`Ey10'*`p10' ///
							+(1/`alpha_m')*`Ey01'*`p01' ///
							+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
			
			local `j'Y11_l = `Ey11'*`p11' + `a10'*`p10'+ `a01'*`p01'+ `a00'*`p00' 
			local `j'Y11_u = `Ey11'*`p11'+`alpha_f'*`Ey01'*`p01' ///
							+`alpha_m'*`Ey10'*`p10' ///
							+`alpha_f'*`alpha_m'*`Ey00'*`p00'
			
			local `j'Y10_l = `Ey10'*`p10' + `Ey11'*`p11'+`a01'*`p01'+`a00'*`p00'
			local `j'Y10_u = `Ey10'*`p10' + (`alpha_f'/`alpha_m')*`Ey01'*`p01' +(`alpha_f')*`Ey00'*`p00' ///
							+(1/`alpha_m')*`Ey11'*`p11'
			
			
			local `j'Y01_l =  `Ey01'*`p01'+`Ey11'*`p11'+`a10'*`p10'+`a00'*`p00'
			local `j'Y01_u = `Ey01'*`p01' + (`alpha_f'/`alpha_m')*`Ey10'*`p10' +`alpha_m'*`Ey00'*`p00' ///
							+(1/`alpha_f')*`Ey11'*`p11'
			
			
			 
			 
		}
			else if ("`j'" == "cmtrgOts"){
			display "CMTR-G + OTS"
			 				
			
			
			local `j'Y00_l = `Ey' 
			local `j'Y00_u = `Ey00'*`p00'+ (1/`alpha_f')*`Ey10' *`p10' ///
							+ (1/`alpha_m')*`Ey01'*`p01' ///
							+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
			
			local `j'Y11_l = `Ey11'*`p11' + `a10'*`p10'+ `a01'*`p01'+ `a00'*`p00' 
			local `j'Y11_u = `Ey11'*`p11'+ `alpha_f'*`Ey01'*`p01' ///
							+`alpha_m'*`Ey10'*`p10' ///
							+`alpha_f'*`alpha_m'*`Ey00'*`p00'
			
			local `j'Y10_l = `Ey10'*`p10'+`Ey01'*`p01'+`a00'*`p00'+`Ey11'*`p11'
			local `j'Y10_u = `Ey10'*`p10' + (`alpha_f'/`alpha_m')*`Ey01'*`p01' +`alpha_f'*`Ey00'*`p00' ///
							+(1/`alpha_m')*`Ey11'*`p11'
			
			
			local `j'Y01_l =  `Ey01'*`p01'+`Ey11'*`p11'+`a10'*`p10'+`a00'*`p00'
			local `j'Y01_u = `Ey01'*`p01' + min((`alpha_m'/`alpha_f')*`Ey10',`Ey10')*`p10' /// 
							+`alpha_m'*`Ey00'*`p00' ///
							+(1/`alpha_f')*`Ey11'*`p11'
			
			
			 
			 
		}
		else if ("`j'" == "otsMts"){
			display "MTS + OTS"
			 				
			
			
			local `j'Y00_l = `Ey00'*`p00' + `a10'*`p10' +`a01'*`p01'+`a11'*`p11' 
			local `j'Y00_u = `Ey00'*`p00'+min((1/`alpha_f')*`Ey10', `Ey00')*`p10' ///
							+min((1/`alpha_m')*`Ey01', `Ey00')*`p01' ///
							+min((1/(`alpha_f'*`alpha_m'))*`Ey11', `Ey00')*`p11'
			
			
			matrix m`j'Y00_u =J(8,1,.)
			
			
		
			matrix m`j'Y00_u[1,1] = `Ey00'*`p00' +(1/`alpha_f')*`Ey10'*`p10'+(1/`alpha_m')*`Ey01'*`p01'+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
			matrix m`j'Y00_u[2,1] = `Ey00'*`p00' +(1/`alpha_f')*`Ey10'*`p10'+(1/`alpha_m')*`Ey01'*`p01'+`Ey00'*`p11'
			matrix m`j'Y00_u[3,1] = `Ey00'*`p00' +(1/`alpha_f')*`Ey10'*`p10'+`Ey00'*`p01'+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
			matrix m`j'Y00_u[4,1] = `Ey00'*`p00' +(1/`alpha_f')*`Ey10'*`p10'+`Ey00'*`p01'+`Ey00'*`p11'
			matrix m`j'Y00_u[5,1] = `Ey00'*`p00' +`Ey00'*`p10'+(1/`alpha_m')*`Ey01'*`p01'+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
			matrix m`j'Y00_u[6,1] = `Ey00'*`p00' +`Ey00'*`p10'+(1/`alpha_m')*`Ey01'*`p01'+`Ey00'*`p11'
			matrix m`j'Y00_u[7,1] = `Ey00'*`p00' +`Ey00'*`p10'+`Ey00'*`p01'+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
			matrix m`j'Y00_u[8,1] = `Ey00'*`p00' +`Ey00'*`p10'+`Ey00'*`p01'+`Ey00'*`p11'
			
			
			local `j'Y11_l = `Ey11' 
			local `j'Y11_u = `Ey11'*`p11'+`alpha_f'*`Ey01'*`p01' ///
							+`alpha_m'*`Ey10'*`p10' ///
							+`alpha_f'*`alpha_m'*`Ey00'*`p00'
			
			local `j'Y10_l = `Ey10'*(`p00'+`p10')+`a01'*`p01'+ `a11'*`p11'
			local `j'Y10_u = `Ey10'*`p10' + (`alpha_f'/`alpha_m')*`Ey01'*`p01' +`alpha_f'*`Ey00'*`p00' ///
							+min((1/`alpha_m')*`Ey11', `Ey10')*`p11'
			
			matrix m`j'Y10_u =J(2,1,.)
			matrix m`j'Y10_u[1,1] =`Ey10'*`p10' + (`alpha_f'/`alpha_m')*`Ey01'*`p01' +`alpha_f'*`Ey00'*`p00'+(1/`alpha_m')*`Ey11'*`p11'
			matrix m`j'Y10_u[2,1] =`Ey10'*`p10' + (`alpha_f'/`alpha_m')*`Ey01'*`p01' +`alpha_f'*`Ey00'*`p00'+`Ey10'*`p11'
			
			
			local `j'Y01_l =  `Ey01'*(`p00'+`p01')+`a10'*`p10'+`a11'*`p11'
			local `j'Y01_u = `Ey01'*`p01' + (`alpha_m'/`alpha_f')*`Ey10'*`p10' + `alpha_m'*`Ey00'*`p00' ///
							+min((1/`alpha_f')*`Ey11', `Ey01')*`p11'
			
			matrix m`j'Y01_u =J(2,1,.)
			matrix m`j'Y01_u[1,1] = `Ey01'*`p01' + (`alpha_m'/`alpha_f')*`Ey10'*`p10' + `alpha_m'*`Ey00'*`p00'+(1/`alpha_f')*`Ey11'*`p11'
			matrix m`j'Y01_u[2,1] = `Ey01'*`p01' + (`alpha_m'/`alpha_f')*`Ey10'*`p10' + `alpha_m'*`Ey00'*`p00'+`Ey01'*`p11'
			 
			
			matrix i2 = J(2,1,1)
			matrix i8 = J(8,1,1)
			
			//display ``j'Y10_l'
			matrix m`j'atef_l = ``j'Y10_l'*i8 - m`j'Y00_u
			matrix m`j'atef_u = m`j'Y10_u - ``j'Y00_l'*i2
			
			matrix m`j'atem_l = ``j'Y01_l'*i8 - m`j'Y00_u
			matrix m`j'atem_u = m`j'Y01_u - ``j'Y00_l'*i2
			
			matrix m`j'atej_l = ``j'Y11_l'*i8 - m`j'Y00_u
			matrix m`j'atej_u = ``j'Y11_u' - ``j'Y00_l'
			
			matrix m`j'ateif_l = ``j'Y11_l'*i2 - m`j'Y01_u
			matrix m`j'ateif_u = ``j'Y11_u' - ``j'Y01_l'
			
			matrix m`j'ateim_l = ``j'Y11_l'*i2 - m`j'Y10_u
			matrix m`j'ateim_u = ``j'Y11_u' - ``j'Y10_l'
			
			return matrix  m`j'Y01_u = m`j'Y01_u
			return matrix  m`j'Y10_u = m`j'Y10_u 
			return matrix  m`j'Y00_u = m`j'Y00_u
			
			
			
			return matrix m`j'atef_l=m`j'atef_l
			return matrix m`j'atef_u=m`j'atef_u
			return matrix m`j'atem_l=m`j'atem_l
			return matrix m`j'atem_u=m`j'atem_u
			return matrix m`j'atej_l=m`j'atej_l
			return matrix m`j'atej_u=m`j'atej_u
			return matrix m`j'ateif_l=m`j'ateif_l
			return matrix m`j'ateif_u=m`j'ateif_u
			return matrix m`j'ateim_l=m`j'ateim_l
			return matrix m`j'ateim_u=m`j'ateim_u
			
			

		}
		else if ("`j'" == "cMtrOtsMts"){
			display "CMTR+MTS+ OTS"
			 				
			
			
			local `j'Y00_l = `Ey00'*`p00' + `Ey10'*`p10' +`Ey01'*`p01'+`Ey11'*`p11' 
			local `j'Y00_u = `Ey00'*`p00'+min((1/`alpha_f')*`Ey10', `Ey00')*`p10' ///
							+min((1/`alpha_m')*`Ey01', `Ey00')*`p01' ///
							+min((1/(`alpha_f'*`alpha_m'))*`Ey11', `Ey00')*`p11'
			
			matrix m`j'Y00_u =J(8,1,.)
			matrix m`j'Y00_u[1,1] = `Ey00'*`p00' +(1/`alpha_f')*`Ey10'*`p10'+(1/`alpha_m')*`Ey01'*`p01'+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
			matrix m`j'Y00_u[2,1] = `Ey00'*`p00' +(1/`alpha_f')*`Ey10'*`p10'+(1/`alpha_m')*`Ey01'*`p01'+`Ey00'*`p11'
			matrix m`j'Y00_u[3,1] = `Ey00'*`p00' +(1/`alpha_f')*`Ey10'*`p10'+`Ey00'*`p01'+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
			matrix m`j'Y00_u[4,1] = `Ey00'*`p00' +(1/`alpha_f')*`Ey10'*`p10'+`Ey00'*`p01'+`Ey00'*`p11'
			matrix m`j'Y00_u[5,1] = `Ey00'*`p00' +`Ey00'*`p10'+(1/`alpha_m')*`Ey01'*`p01'+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
			matrix m`j'Y00_u[6,1] = `Ey00'*`p00' +`Ey00'*`p10'+(1/`alpha_m')*`Ey01'*`p01'+`Ey00'*`p11'
			matrix m`j'Y00_u[7,1] = `Ey00'*`p00' +`Ey00'*`p10'+`Ey00'*`p01'+(1/(`alpha_f'*`alpha_m'))*`Ey11'*`p11'
			matrix m`j'Y00_u[8,1] = `Ey00'*`p00' +`Ey00'*`p10'+`Ey00'*`p01'+`Ey00'*`p11'
			
			
			local `j'Y11_l = `Ey11' 
			local `j'Y11_u = `Ey11'*`p11'+`alpha_f'*`Ey01'*`p01' ///
							+`alpha_m'*`Ey10'*`p10' ///
							+`alpha_f'*`alpha_m'*`Ey00'*`p00'
			
			local `j'Y10_l = `Ey10'*(`p00'+`p10')+`a01'*`p01'+ `Ey11'*`p11'
			local `j'Y10_u = `Ey10'*`p10' + (`alpha_f'/`alpha_m')*`Ey01'*`p01' +`alpha_f'*`Ey00'*`p00' ///
							+min((1/`alpha_m')*`Ey11', `Ey10')*`p11'

			matrix m`j'Y10_u =J(2,1,.)
			matrix m`j'Y10_u[1,1] =`Ey10'*`p10' + (`alpha_f'/`alpha_m')*`Ey01'*`p01' +`alpha_f'*`Ey00'*`p00'+(1/`alpha_m')*`Ey11'*`p11'
			matrix m`j'Y10_u[2,1] =`Ey10'*`p10' + (`alpha_f'/`alpha_m')*`Ey01'*`p01' +`alpha_f'*`Ey00'*`p00'+`Ey10'*`p11'
							
			
			local `j'Y01_l =  `Ey01'*(`p00'+`p01')+`a10'*`p10'+`Ey11'*`p11'
			local `j'Y01_u = `Ey01'*`p01' + (`alpha_m'/`alpha_f')*`Ey10'*`p10' + `alpha_m'*`Ey00'*`p00' ///
							+min((1/`alpha_f')*`Ey11', `Ey01')*`p11'

			matrix m`j'Y01_u =J(2,1,.)
			matrix m`j'Y01_u[1,1] = `Ey01'*`p01' + (`alpha_m'/`alpha_f')*`Ey10'*`p10' + `alpha_m'*`Ey00'*`p00'+(1/`alpha_f')*`Ey11'*`p11'
			matrix m`j'Y01_u[2,1] = `Ey01'*`p01' + (`alpha_m'/`alpha_f')*`Ey10'*`p10' + `alpha_m'*`Ey00'*`p00'+`Ey01'*`p11'
			
			
			matrix i2 = J(2,1,1)
			matrix i8 = J(8,1,1)
			
			display ``j'Y10_l'
			matrix m`j'atef_l = ``j'Y10_l'*i8 - m`j'Y00_u
			matrix m`j'atef_u = m`j'Y10_u - ``j'Y00_l'*i2
			
			matrix m`j'atem_l = ``j'Y01_l'*i8 - m`j'Y00_u
			matrix m`j'atem_u = m`j'Y01_u - ``j'Y00_l'*i2
			
			matrix m`j'atej_l = ``j'Y11_l'*i8 - m`j'Y00_u
			matrix m`j'atej_u = ``j'Y11_u' - ``j'Y00_l'
			
			matrix m`j'ateif_l = ``j'Y11_l'*i2 - m`j'Y01_u
			matrix m`j'ateif_u = ``j'Y11_u' - ``j'Y01_l'
			
			matrix m`j'ateim_l = ``j'Y11_l'*i2 - m`j'Y10_u
			matrix m`j'ateim_u = ``j'Y11_u' - ``j'Y10_l'
			
			return matrix  m`j'Y01_u = m`j'Y01_u
			return matrix  m`j'Y10_u = m`j'Y10_u 
			return matrix  m`j'Y00_u = m`j'Y00_u
			
			
			
			return matrix m`j'atef_l=m`j'atef_l
			return matrix m`j'atef_u=m`j'atef_u
			return matrix m`j'atem_l=m`j'atem_l
			return matrix m`j'atem_u=m`j'atem_u
			return matrix m`j'atej_l=m`j'atej_l
			return matrix m`j'atej_u=m`j'atej_u
			return matrix m`j'ateif_l=m`j'ateif_l
			return matrix m`j'ateif_u=m`j'ateif_u
			return matrix m`j'ateim_l=m`j'ateim_l
			return matrix m`j'ateim_u=m`j'ateim_u
			
		
		}
		
		local `j'atef_l = ``j'Y10_l' - ``j'Y00_u'
		local `j'atef_u = ``j'Y10_u' - ``j'Y00_l'
			
		local `j'atem_l = ``j'Y01_l' - ``j'Y00_u'
		local `j'atem_u = ``j'Y01_u' - ``j'Y00_l'
			
		local `j'atej_l = ``j'Y11_l' - ``j'Y00_u'
		local `j'atej_u = ``j'Y11_u' - ``j'Y00_l'
			
		local `j'ateif_l = ``j'Y11_l' - ``j'Y01_u'
		local `j'ateif_u = ``j'Y11_u' - ``j'Y01_l'
			
		local `j'ateim_l = ``j'Y11_l' - ``j'Y10_u'
		local `j'ateim_u = ``j'Y11_u' - ``j'Y10_l'
			 
		display "---------------------------------------------"
		display ""
		display "Y_00:  " _column(16) "[" %9.4f ``j'Y00_l' "," %9.4f ``j'Y00_u' "]"
		display ""
		display "Y_10:  " _column(16) "[" %9.4f ``j'Y10_l' "," %9.4f ``j'Y10_u' "]"
		display ""
		display "Y_01:  " _column(16) "[" %9.4f ``j'Y01_l' "," %9.4f ``j'Y01_u' "]"
		display ""
		display "Y_11:  " _column(16) "[" %9.4f ``j'Y11_l' "," %9.4f ``j'Y11_u' "]"
		display ""
		display "ATE_f:  " _column(16) "[" %9.4f ``j'atef_l' "," %9.4f ``j'atef_u' "]"	
		display ""
		display "ATE_m:  " _column(16) "[" %9.4f ``j'atem_l' "," %9.4f ``j'atem_u' "]"	
		display ""
		display "ATE_j:  " _column(16) "[" %9.4f ``j'atej_l' "," %9.4f ``j'atej_u' "]"	
		display ""
		display "ATE_if:  " _column(16) "[" %9.4f ``j'ateif_l' "," %9.4f ``j'ateif_u' "]"	
		display ""
		display "ATE_im:  " _column(16) "[" %9.4f ``j'ateim_l' "," %9.4f ``j'ateim_u' "]"	
		display "---------------------------------------------"
		display ""
			
		

	}
	
	 


local moments Y00 Y01 Y10 Y11 atef atem atej ateif ateim
foreach j of local methods {

	foreach k of local moments {
	
		return scalar `j'`k'_l = ``j'`k'_l'
		return scalar `j'`k'_u = ``j'`k'_u'
	
	}


}
end

 
/*


