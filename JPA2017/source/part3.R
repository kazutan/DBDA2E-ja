library(rstan)
library(ggplot2)


#データ生成----------
N<-30
set.seed(123)
X<-round(runif(N, 20, 40),1)
set.seed(123)
Y<-round(rnorm(N,30+5.5*X, 20),1)

Y<-30+5.5*X


#データの可視化
dat<-data.frame(X=X, Y=Y)
ggplot(data=dat, aes(x=X, y=Y))+
  geom_point()



#単回帰----------------
#実行コード-------------
model<-stan_model("JPA2017/source/example3.stan")

data<-list(N=nrow(dat), y=dat$Y, x=dat$X)

fit<-sampling(model,
              data=data,
              chains = 4,
              iter = 2000,
              warmup = 1000,
              seed=123)
fit


#収束診断---------------
##トレースプロット
stan_trace(fit, 
           pars=c("beta0", "beta1", "sigma", "lp__"),
           inc_warmup = T)

##確率密度プロット
stan_dens(fit, 
          pars=c("beta0", "beta1", "sigma", "lp__"),
          inc_warmup = F,
          separate_chains = T)

##自己相関
stan_ac(fit,
        pars=c("beta0", "beta1", "sigma", "lp__"),
        inc_warmup = F)


##iter=10000で実行
fit2<-sampling(model,
              data=data,
              chains = 4,
              iter = 10000,
              warmup = 1000,
              seed=123)
fit2


#推定値の確認------
stan_plot(fit2,
          point_est = "mean",
          ci_level = 0.95,
          outer_level = 1.00,
          show_density = T)

print(fit2, 
      pars=c("beta0", "beta1", "sigma"),
      probs = c(0.025, 0.975),
      digit=2)


##回帰係数だけプロット
stan_plot(fit2,
          pars = "beta1",
          point_est = "mean",
          ci_level = 0.95,
          outer_level = 1.00,
          show_density = T)



#MCMCサンプルを取り出してみる-----
MCMC_sample <- rstan::extract(fit2)
MCMC_sample$beta1

beta1<-MCMC_sample$beta1

##95％区間を求める
print(
  quantile(beta1, probs=c(0.025, 0.975)),
  digit=3)

##事後分布をプロット
plot(density(beta1))


##回帰係数がある値を超える確率が知りたい
a <- 5
sum(ifelse(beta1 > a, 1, 0))/length(beta1)


##xがある値のときのyの95％範囲が知りたい
beta0<-MCMC_sample$beta0
beta1<-MCMC_sample$beta1
sigma<-MCMC_sample$sigma

x<-30
y<-rnorm(n = 36000,
         mean = beta0 + beta1*x,
         sd = sigma)
round(quantile(y, probs=c(0.025, 0.975)))


#予測区間の描画------
#新しく生成させるデータのxの範囲を指定
X_new <- 20:40
#新しく生成させるデータを入れる箱作り[データポイント[x]*mcmc分]
N_X <- length(X_new)
N_mcmc <- length(beta0) 
##生成したyを入れる箱
y <- as.data.frame(matrix(nrow=N_mcmc, ncol=N_X))

#データの生成
for(i in 1:N_X){
  y[,i] <- rnorm(n = N_mcmc,
                 mean = beta0 + beta1*X_new[i],
                 sd = sigma)
}

#発生させたデータの中央値と2.5%タイル点,95%タイル点を計算
qua<-apply(y, 2, quantile, probs=c(2.5,50,97.5)/100)
##転置してデータセット作成
d_pred <- data.frame(x=X_new, t(qua))

#描画
##発生させたデータで中央値の線、95％区間のリボンを描画し、その上にデータをプロット
p<-ggplot(data=d_pred, aes(x=x, y=X50.))
p+geom_ribbon(aes(ymin=X2.5., ymax=X97.5.), fill='black', alpha=1/6)+
  geom_line()+
  geom_point(data=dat, aes(x=X, y=Y))+
  labs(x="X", y="Y")
