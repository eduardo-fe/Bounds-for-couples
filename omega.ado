/*
This code, together with boundsPeerEffects_v3 is the one I used
to produce the results in the Ecnomic Letters paper (Revisions -PUblished)
*/

set matsize 10000

program drop m_sqrt

mata:
    mata drop eigenvalue_adjust()
    
    real matrix eigenvalue_adjust(string scalar __v) {
        real matrix v
        v = st_matrix(__v)
        
        // Set small values in eigenvalues to zero
        v = mm_cond(v :< 1e-4, 0, v)
        
        st_matrix("__vsqrt", sqrt(v))
		 
        return(sqrt(v))
    }
end


program drop m_sqrt
program m_sqrt, rclass

    // Parse the input arguments
    syntax varname(numeric max=3) [if] [in]  [,BOUND(string) ALPHA(numlist) Replications(real 9) ]
	tempvar  Y Df Dm 
	
	tokenize `varlist'
			
	gen `Y' = `1'
	gen `Df' = `2'
	gen `Dm' = `3'
	
	qui sum `Y' 
	local N = r(N)
	
    // Number of bootstrap samples
    local B = `replications'
	 
	if "`alpha'" == "" {
		qui npbpe `Y' `Df' `Dm'
	}
	else{
		qui npbpe `Y' `Df' `Dm', alpha(`alpha')
	}
    display "the bound is `bound'"
	matrix __mRES_u =  r(`bound'_u) 
	matrix __mRES_l =  r(`bound'_l)
	
    forvalues b = 1/`B' {
        preserve
        bsample
        if "`alpha'" == "" {
			qui npbpe `Y' `Df' `Dm'
		}
		else{
			qui npbpe `Y' `Df' `Dm', alpha(`alpha')
		}
        matrix temp =  r(`bound'_u)  
        matrix __mRES_u = __mRES_u , temp
		matrix temp =  r(`bound'_l)  
        matrix __mRES_l = __mRES_l , temp
        restore
    }

    matrix __mRES_u =sqrt(`N')*__mRES_u[.,2...]  // <------------ Multiply root-N
	matrix __mRES_l =sqrt(`N')*__mRES_l[.,2...]  // <------------ Multiply root-N
	

    // Calculate the mean of the results
    matrix __mu_u = (__mRES_u * J(`B', 1, 1) / `B')
	
    // Calculate the outer product of mRES
    matrix __Outter_u = __mRES_u * __mRES_u'

    // Calculate the product of mu and its transpose, scaled by `B'
    matrix __outMu_u = `B' * __mu_u * __mu_u'

    // Calculate the covariance matrix
    matrix __sigma_u = (1 / (`B' - 1)) * (__Outter_u - __outMu_u)
	 
     
    // Eigenvalue decomposition to find square root of matrix
    matrix symeigen __X_u __v_u = __sigma_u
    mata: eigenvalue_adjust("__v_u")
	

    // Calculate the square root of the covariance matrix
    matrix __sigmaHalf_u = __X_u * diag(__vsqrt) * __X_u'
    
    // Return the matrices
    return matrix sigma_u = __sigma_u
    return matrix sigmaHalf_u = __sigmaHalf_u
	
	//********
	// Calculate the mean of the results
    matrix __mu_l = (__mRES_l * J(`B', 1, 1) / `B')
	
    // Calculate the outer product of mRES
    matrix __Outter_l = __mRES_l * __mRES_l'

    // Calculate the product of mu and its transpose, scaled by `B'
    matrix __outMu_l = `B' * __mu_l * __mu_l'

    // Calculate the covariance matrix
    matrix __sigma_l = (1 / (`B' - 1)) * (__Outter_l - __outMu_l)
    
    // Eigenvalue decomposition to find square root of matrix
    matrix symeigen __X_l __v_l = __sigma_l
    mata: eigenvalue_adjust("__v_l")
	

    // Calculate the square root of the covariance matrix
    matrix __sigmaHalf_l = __X_l * diag(__vsqrt) * __X_l'
	
	
    // Return the matrices
    return matrix sigma_l = __sigma_l
    return matrix sigmaHalf_l = __sigmaHalf_l

end



mata:
mata drop rho_adjust()
void rho_adjust(real scalar N, string scalar bound, string scalar sigma, string scalar sigmaHalf, real scalar lb, real scalar c)
{
	matrix omega, omegaHalf, vShat, Z, gnu, Znu, cap,phi, test, keep, theta
	scalar k, i, normGnu, cn, kappa, R, sol, bnd
	R=10000
		
	omega = st_matrix(sigma)
	k = rows(omega)
	
	omega
	if(k==1 & abs(J(1,k,1)*omega*J(k,1,1))<=1e-4){
		st_numscalar("__bnd", st_matrix(bound))
		st_numscalar("__ci", 0)
	} 
	else{
	
	omegaHalf 	= st_matrix(sigmaHalf)
	omegaHalf
	theta = st_matrix(bound)
	
	vShat = (sqrt(diagonal(omega)/N))
	
	
	
	Z = rnormal(k, R,0,1)
	
	cap = J(1,R,.)
	
	for(i= 1; i<= k; i++) {
	
		gnu = omegaHalf[i,]; 

		normGnu = sqrt(gnu*gnu'); 

		Znu = (gnu*Z)/normGnu;
		cap = cap \ Znu
		
	}
	
	cap = cap[2..k+1,]
	
	phi = colmax(cap)

	
	cn = 1-(0.1/log(N));
	
	kappa = mm_quantile(phi',1, (cn))
	
	keep = J(k,1,.)
	
	for(i= 1; i<= k; i++) {
		if(lb !=1) {
			 
			test = theta  + kappa*vShat + 2*kappa *(vShat[i,]*J(k,1,1))
			test = colmin(test)
			test = mm_cond(theta[i,] :<= test, 1, 0)
			
			keep[i,] = test
		}
		else{
			test = theta  - kappa*vShat - 2*kappa *(vShat[i,]*J(k,1,1))
			test = colmax(test)
			test = mm_cond(theta[i,] :>= test, 1, 0)
			
			keep[i,] = test
		}
	}
	
	 
	cap = select(cap, keep)
	
	phi= colmax(cap)
	
	kappa = mm_quantile(phi',1, c)
	
	
	if(lb !=1) {
		sol = colmin(theta+ kappa*vShat)
		bnd =colmin(theta)
		 
	}
	else{
		sol = colmax(theta- kappa*vShat)
		bnd =colmax(theta)
		 
	}
	st_numscalar("__bnd", bnd)
	st_numscalar("__ci", sol)
	}
	
}
end


program drop engine
program engine, rclass

    // Parse the input arguments
    syntax varname(numeric max=3) [if] [in]  [,BOUND(string) ALPHA(numlist) Replications(real 9) ]
	tempvar  Y Df Dm 
	
	tokenize `varlist'
			
	gen `Y' = `1'
	gen `Df' = `2'
	gen `Dm' = `3'
	
	local what "`bound'"
	 
	qui m_sqrt `Y' `Df' `Dm' , bound(`what') replications(`replications') alpha(`alpha')

	matrix sigma_u = r(sigma_u)
	matrix sigma_l = r(sigma_l)
	matrix sigmaHalf_u = r(sigmaHalf_u)
	matrix sigmaHalf_l = r(sigmaHalf_l)

	qui npbpe `Y'  `Df' `Dm', alpha(`alpha')
	matrix bound_u= r(`what'_u) 
	matrix bound_l= r(`what'_l) 
	 
	mata: rho_adjust(9000, "bound_l", "sigma_l", "sigmaHalf_l",1, 0.5)
	scalar __lb = __bnd
	scalar __lb_pc = __ci
	mata: rho_adjust(9000, "bound_u", "sigma_u", "sigmaHalf_u",0, 0.5)
	scalar __ub = __bnd
	scalar __ub_pc = __ci
	
	
	mata: rho_adjust(9000, "bound_l", "sigma_l", "sigmaHalf_l",1, 0.25)
	scalar __lb25 = __bnd
	scalar __lb25_pc = __ci
	
	mata: rho_adjust(9000, "bound_u", "sigma_u", "sigmaHalf_u",0, 0.25)
	scalar __ub25 = __bnd
	scalar __ub25_pc = __ci
	
	mata: rho_adjust(9000, "bound_l", "sigma_l", "sigmaHalf_l",1, 0.75)
	scalar __lb75 = __bnd
	scalar __lb75_pc = __ci
	
	mata: rho_adjust(9000, "bound_u", "sigma_u", "sigmaHalf_u",0, 0.75)
	scalar __ub75 = __bnd
	scalar __ub75_pc = __ci
	
	local lbpc = __lb_pc
	local ubpc = __ub_pc
	local lbpc75 = __lb75_pc
	local ubpc75 = __ub75_pc
	local lbpc25 = __lb25_pc
	local ubpc25 = __ub25_pc
	
	
	mata:phat(9000, `ubpc',  `lbpc', `ubpc75',  `lbpc75',`ubpc25',  `lbpc25' )
	local pHat = phat
	
	mata: rho_adjust(9000, "bound_l", "sigma_l", "sigmaHalf_l",1, `pHat')
	scalar __lbci = __bnd
	scalar __lbci_pc = __ci
	
	mata: rho_adjust(9000, "bound_u", "sigma_u", "sigmaHalf_u",0, `pHat')
	scalar __ubci = __bnd
	scalar __ubci_pc = __ci
	
	display __ub ", " __ub_pc ", " __ub75_pc
	display __lb_pc ", " __lb75_pc
	display __ubci_pc 
	display __lbci_pc
end

mata:
mata drop phat()
void phat(real scalar n, real scalar __ub_pc,  real scalar __lb_pc, real scalar __ub75_pc,  real scalar __lb75_pc, real scalar __ub25_pc,  real scalar __lb25_pc)
{
	scalar gammaHat, gammaHatPlus, rho, tau, p
	
	gammaHat = __ub_pc - __lb_pc
	
	gammaHatPlus = rowmax((0, gammaHat))
	
	rho = rowmax(((__ub75_pc - __ub25_pc) , (__lb75_pc - __lb25_pc)))
	
	tau = 1/(rho*log(n))
	p = 1 - normal(tau*gammaHatPlus)*0.05
	st_numscalar("phat", p)
	
	
}
end 

* Data Analysis

sum p600_df_pc
local mu = r(mean)
gen __temp_y = 100* p600_df_pc / `mu'

local B = 999
local alph = 0.9

local subindex f m j if im
local assumptions1 zrate cmtrate  otsate mtsate 
local assumptions2 cmtrMtsate cmtrOtsate motsMtsate mcMtrOtsMtsate  

matrix mRES = J(20,8,.)


local col = 1

foreach i of local assumptions1{
local row = 1
	foreach j of local subindex{
		display "`i'`j'"
		
		 
		
		engine __temp_y retired_f retired_m , bound("`i'`j'") replications(`B') alpha(`alph')

		matrix mRES[`row', `col'] = __lb_pc
		matrix mRES[`row', `col'+1] = __ub_pc
		matrix mRES[`row'+1, `col'] = __lbci_pc
		matrix mRES[`row'+1, `col'+1] = __ubci_pc
		local row = `row'+ 2
	}
	local col = `col' + 2

}
matrix list mRES

local subindex f m j if im
local assumptions2  cmtrMtsate cmtrOtsate motsMtsate mcMtrOtsMtsate  //

local col = 1

foreach i of local assumptions2{
local row = 11
	foreach j of local subindex{
		display "`i'`j'"
		
		engine __temp_y retired_f retired_m , bound("`i'`j'") replications(`B') alpha(`alph')

		matrix mRES[`row', `col'] = __lb_pc
		matrix mRES[`row', `col'+1] = __ub_pc
		matrix mRES[`row'+1, `col'] = __lbci_pc
		matrix mRES[`row'+1, `col'+1] = __ubci_pc
		local row = `row'+ 2
	}
	local col = `col' + 2

}
matrix list mRES


 







