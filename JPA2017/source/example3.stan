data{
  int N;//人数(整数)
  real y[N];//被予測変数(N個の配列(実数))
  real x[N];//予測変数(N個の配列(実数))
}

parameters{
  real beta0;//切片(実数)
  real beta1;//回帰係数(実数)
  real <lower=0> sigma;//正規分布の標準偏差(下限0)(実数)
}

model{
  //モデルの記述
  real mu[N];
  for(n in 1:N){
    mu[n] = beta0+beta1*x[n];
    y[n] ~ normal(mu[n], sigma);
  }
  //事前分布の設定
  beta0 ~ normal(0, 100);
  beta1 ~ normal(0, 100);
  sigma ~ cauchy(0, 5);
}
