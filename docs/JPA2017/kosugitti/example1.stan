data{
  int<lower=0> N;
  real X1[N];
  real X2[N];
}

parameters{
  real muA;
  real muB;
  real<lower=0> sig;
}

model{
  // likelihood
  for(i in 1:N){
    X1[i] ~ normal(muA,sig);
    X2[i] ~ normal(muB,sig);
  }
  // prior
  sig ~ student_t(4,0,5);
  muA ~ normal(0,1000);
  muB ~ normal(0,1000);
}

