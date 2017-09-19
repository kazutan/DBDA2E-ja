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
  muA ~ uniform(-100,100);
  muB ~ uniform(-100,100);
}

generated quantities{
  real diff;
  diff = muA - muB;
}
