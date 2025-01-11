program liRacine, rclass

	syntax varlist [if] [in] [, AT(numlist) BW(numlist) STORE ]	
	
	capture confirm variable ___selected
		if (_rc==0) {
			drop ___selected
		}
		
	if("`store'" != "") {
	
		capture confirm variable yHat
		if (_rc==0) {
			drop yHat	
		}
		
		capture confirm variable pHat
		if (_rc==0) {
			drop pHat	
		}	
		
		qui gen yHat =.
		qui gen pHat =.
		
		scalar storeMe = 1
	}
	else {
		scalar storeMe = 0
	}
	
	gettoken y xvars : varlist
	
 	marksample touse
	
	gen ___selected = `touse'
	
 	if("`bw'"!="") {
		matrix bw = J(1,1,.)
		tokenize `bw'
		while "`1'" != "" {
			matrix bw = bw \ `1'
			mac shift
		}
		matrix bw = bw[2...,1]
		
	}
	else {
		matrix bw = 0
	}
 	
	if("`at'"==""){
		mata: liR("`y'", "`xvars'", "", "bw") 	
		return matrix mhat = mhat
	return matrix phat = phat
	} 
	else {
		matrix mAT = J(1,1,.)
		tokenize `at'
		while "`1'" != "" {
			matrix mAT = mAT , `1'
			mac shift
		}
		matrix mAT= mAT[1,2...]
		mata: liR("`y'", "`xvars'", "mAT", "bw") 
		
		/*di ""
		di as input "Bandwidth: "
		matrix list bw, noh nob non
		di as input "Estimate at (`at')"
		di as input "y-hat =  " _column(16) %9.4f  mhat[1,1]
		di as input "p-hat =  " _column(16) %9.4f  phat[1,1]
	*/
		 
		scalar ytilde = mhat[1,1]
		return scalar ytilde = ytilde
		
		scalar ptilde = phat[1,1]
		return scalar ptilde = ptilde
		
		return matrix mhat = mhat
		return matrix phat = phat
		
		
		
	}
	
	
	
	
	drop ___selected
	
	
end



clear mata
mata:
mata set matastrict on
void liR(string scalar vY, string scalar mX, string scalar mAT, string scalar BW ){
	
	real vector Y, bw, w  ,  grid_g, weight, yhat,   mhat,phat, mYhat, mPhat
	real matrix X, AT , grid   ,  aux, aux2, aux3
	real scalar K , dim0, k, dimw  , G, g, lambda, kernelReg, store, q
	
	Y= st_data(., vY, "___selected")
	X =st_data(., mX, "___selected")
	store = st_numscalar("storeMe")
	
 	bw = st_matrix(BW)
	K= cols(X)
	
	
	if(bw ==0) {
		bw=J(K,1,.)
		for(q=1; q<=K; q++){
		 
			bw[q,1] = sqrt(variance(X[,q]))*1.06/(rows(Y)^0.19)
			
		}
	}
	
	if(mAT=="") {
	
		AT = X
		grid = uniqrows(AT[,1])
		dim0 = rows(grid)
		
		for(k=2; k<=K;k++){
		
			w= uniqrows(AT[,k])
			dimw = rows(w)
			grid = (grid#J(dimw,1,1), J(dim0,1,1)#w)
			dim0 = rows(grid)
		 
		}
		
	}
	else {
		AT = st_matrix(mAT)
		grid = AT
	}
	
	// Estimate
	// ---------------------------------------------------------
	
	G= rows(grid)
	mhat = J(G,1,.)
	phat = J(G,1,.)
	
	mYhat = J(rows(Y),1,.)
	mPhat = J(rows(Y),1,.)

	
	for(g=1; g<=G; g++){
	
		grid_g = grid[g,]
		aux2 = mm_cond(X:==grid_g, 1, 0) 
		aux = aux2 +(1:-aux2):*bw'
		weight=  mm_rowprod(aux)
		
		kernelReg =(Y'weight)/(rows(Y)*mean(weight)) 
		
		mhat[g,1]= kernelReg
		phat[g,1]= mean(weight)
		
		// add the predictions alongside Y
		aux3 = mm_rowprod(aux2) // This equals 1 only if X_i = x
 		
		mYhat = mm_cond(aux3:==1 , kernelReg, mYhat) 	
		mPhat = mm_cond(aux3:==1, mean(weight), mPhat) 	
	}
	
	
	if(store ==1) {
		st_store(.,"yHat", "___selected", mYhat)
		st_store(.,"pHat", "___selected", mPhat)
	}
	st_matrix("mhat", (mhat, grid))
	st_matrix("phat", (phat, grid))	
	st_matrix("bw", bw)
	
	if(mAT!="") {
		st_matrix("mhat", mhat)
		st_matrix("phat", phat)	

	}
  
}	
end

 
 
