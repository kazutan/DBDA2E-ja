# ２群の差の検定
## 仮想データ生成
set.seed(20170922)
N <- 10   # サンプルサイズ
muA <- 50 # 群Aの平均
muB <- 65 # 群Bの平均
sig <- 3 # 共通する標準偏差

X1 <- round(rnorm(N,muA,sig),1) # 正規乱数によるデータの生成
X2 <- round(rnorm(N,muB,sig),1) # 正規乱数によるデータの生成
dataSet <- list(N=N,X1=X1,X2=X2)

# 古典的検定
t.test(X1,X2,var.equal = F)

# JAGSによる推定
library(runjags) # ライブラリの読み込み


runJagsOut <- run.jags(method="parallel",
                       model="JPA2017/kosugitti/example1_jags.txt",
                       monitor=c("muA","muB","sigma"),
                       data=dataSet,
                       n.chains=4,
                       adapt=1000,
                       burnin=1000,
                       sample=10000,
                       summarise=TRUE)
runJagsOut


# Stanによる推定
library(rstan)
rstan_options(auto_write = TRUE)
model1 <- stan_model("JPA2017/kosugitti/example1.stan") 
stanModelFit <- sampling(model1,data=dataSet,chains=4,warmup=1000,iter=10000)
stanModelFit
