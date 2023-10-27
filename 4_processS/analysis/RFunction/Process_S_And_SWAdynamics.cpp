#include <Rcpp.h>
using namespace Rcpp;

// Function to simulate process-S and the dynamic of SWA in Reindeer
// Asymptote of SWA is delimited by Process-S

// [[Rcpp::export]]
List SWA_Simulation(NumericVector NREM, NumericVector Wake, NumericVector Rumination, NumericVector Time,
                             double U, double L, double tau_wake, double tau_nrem, double tau_rumination, 
                             double tau_swa_synchro, double tau_swa_desynchro, double L_swa,
                             double init_ProcessS, double init_SWA,bool RuminationDecreasePS=true){
  
  double TimeStep = Time[1] - Time[0];
  
  // If U is free, make sure that init_PRocessS is smaller than U
  //U = U + init_ProcessS; 
  
  // Number of step to simulate
  int Nstep = Time.length();
  
  // Vector of process S
  NumericVector ProcS(Nstep+1);
  // Fill with initial value
  ProcS[0] = init_ProcessS;
  
  // Vector of SWA
  NumericVector SWA(Nstep+1);
  // Fill with initial value
  SWA[0] = init_SWA;
  
  // variable for updated process-S(t)
  double PSt;
  
  // variable for updated SWA(t)
  double SWAt;
  
  
  // variable for time spent in Wake
  double TinW;
  
  // variable for time spent in NREM
  double TinN;
  
  // variable for time spent in Rumination
  double TinR;
  
  // Update process-S and SWA for each time step
  for (int i = 0; i < Nstep; i ++ ){
    
    // Time spent in wake during this time step
    TinW = Wake[i];
    // Same for NREM
    TinN = NREM[i];
    //Same for Rumination
    TinR = Rumination[i];
    
    // First compute S for time spent in wake, NREM and Rumination
    PSt = U - (U - ProcS[i]) * exp(-TinW / tau_wake); // Wake 
    PSt = L + (PSt - L) * exp(-TinN / tau_nrem); // NREM
    
    if (RuminationDecreasePS == true){
      PSt = L + (PSt - L) * exp(-TinR / tau_rumination); // Rumination
    }else{
      PSt = U - (U - PSt) * exp(-TinR / tau_rumination); // Rumination
    }
    
    
    
    // Then compute dynamic of SWA
    // SWAt = PSt - (PSt - SWA[i]) * exp(-TinN/tau_swa_synchro); // NREM
    // if (SWAt > PSt){
    //   SWAt = PSt;
    // }
    SWAt = -exp(-TinN/tau_swa_synchro)*(ProcS[i] - SWA[i]) + PSt;// NREM
    
    SWAt = L_swa + (SWAt - L_swa) * exp(-(TimeStep-TinN)/tau_swa_desynchro); 
    
    ProcS[i+1] = PSt;
    SWA[i+1] = SWAt;
    
  }
  
  return List::create(
    _["time"] = Time,
    _["ProcessS"] = ProcS,
    _["SWAdynamics"] = SWA
  );
  
}