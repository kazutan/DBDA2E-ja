data{
  int<lower=0> N;
  real X1[N];
  real X2[N];
}

parameters{
  real muA;
  real muB;
  real<lower=0> sig1;
  real<lower=0> sig2;
}

model{
  // likelihood
  for(i in 1:N){
    X1[i] ~ normal(muA,sig1);
    X2[i] ~ normal(muB,sig2);
  }
  // prior
  sig1 ~ student_t(4,0,5);
  sig2 ~ student_t(4,0,5);
  muA ~ normal(0,1000);
  muB ~ normal(0,1000);
}

