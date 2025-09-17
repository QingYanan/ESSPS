
library(lme4) 
library(sjPlot) 
library(car)


my_data <- within(behaviour_data, {
  sub <- as.factor(sub)
  age <- as.numeric(age)
  gender <- as.factor(gender)
  trials <- as.integer(trials)
  type <- as.factor(type)
  predator <- as.factor(predator)
  confidence <- as.numeric(confidence)
  escape <- as.numeric(escape)
  anxiety <- as.numeric(anxiety)
  enddistance <- as.numeric(enddistance)
  startPPX <- as.numeric(startPPX)
  startPSX <- as.numeric(startPSX)
  startpd <- as.numeric(startpd)
  startpy <- as.numeric(startpy)
  zBAS <- as.numeric(zBAS)
  zBIS <- as.numeric(zBIS)
  zSAI <- as.numeric(zSAI)
  zTAI <- as.numeric(zTAI)
  zBDI <- as.numeric(zBDI)
  zSPSRQsp <- as.numeric(zSPSRQsp)
  zSPSRQsr <- as.numeric(zSPSRQsr)
  zGRiPS <- as.numeric(zGRiPS)
  zTAS <- as.numeric(zTAS)
})

data=na.omit(my_data) 
summary(data)


## confidence and anxiety scores predict success
# model development
aGmodel1 <- glmer(escape ~ confidence + (1|sub), family=binomial, data=data)
summary(Gmodel1)
Anova(Gmodel1)
sjPlot::tab_model(Gmodel1)

aGmodel2 <- glmer(escape ~ anxiety + (1|sub), family=binomial, data=data)
summary(Gmodel2)
Anova(Gmodel2)
sjPlot::tab_model(Gmodel2)

aGmodel3 <- glmer(escape ~ confidence+anxiety + (1|sub), family=binomial, data=data)
summary(aGmodel3)
Anova(aGmodel3)
sjPlot::tab_model(aGmodel3)

aGmodel4 <- glmer(escape ~ confidence+anxiety+confidence*anxiety + (1|sub), family=binomial, data=data)
summary(aGmodel4)
Anova(aGmodel4)
sjPlot::tab_model(aGmodel4)


# model comparison
tab_model(aGmodel1,aGmodel2,aGmodel3,aGmodel4,show.aic=T)
anova(aGmodel1,aGmodel2,aGmodel3,aGmodel4)

# coefficient
coefficients <- summary(aGmodel4)$coefficients
print(coefficients)

# likelihood ratio test 
lrt_result <- anova(aGmodel1,aGmodel2,aGmodel3,aGmodel4,test = "Chisq")  
print(lrt_result) 

# beta coefficient test
aGmodel4_coefs <- fixef(aGmodel4)
aGmodel4_coefs_se <- sqrt(diag(vcov(aGmodel4)))
z_score <- (as.numeric(aGmodel4_coefs["confidence"]) - as.numeric(aGmodel4_coefs["confidence:anxiety"])) / (sqrt(aGmodel4_coefs_se["confidence"]^2 + aGmodel4_coefs_se["confidence:anxiety"]^2))
pvalue <- 2 * pnorm(-abs(z_score))
print(z_score)
print(pvalue)

 

## FID and DTR predict success
# model development
Gmodel1 <- glmer(escape ~ startPPX + (1|sub), family=binomial, data=data)
summary(Gmodel1)
Anova(Gmodel1)
sjPlot::tab_model(Gmodel1)

Gmodel2 <- glmer(escape ~ startPSX + (1|sub), family=binomial, data=data)
summary(Gmodel2)
Anova(Gmodel2)
sjPlot::tab_model(Gmodel2)

Gmodel3 <- glmer(escape ~ startPPX+startPSX + (1|sub), family=binomial, data=data)
summary(Gmodel3)
Anova(Gmodel3)
sjPlot::tab_model(Gmodel3)

Gmodel4 <- glmer(escape ~ startPPX+startPSX+startPPX*startPSX + (1|sub), family=binomial, data=data)
summary(Gmodel4)
Anova(Gmodel4)
sjPlot::tab_model(Gmodel4)


#model comparison
tab_model(Gmodel1,Gmodel2,Gmodel3,Gmodel4,show.aic=T)
anova(Gmodel1,Gmodel2,Gmodel3,Gmodel4)


#coefficient
coefficients <- summary(Gmodel4)$coefficients
print(coefficients)


# likelihood ratio test 
lrt_result <- anova(Gmodel1,Gmodel2,Gmodel3,Gmodel4,test = "Chisq") 
print(lrt_result)  


## beta coefficient test
Gmodel4_coefs <- fixef(Gmodel4)
Gmodel4_coefs_se <- sqrt(diag(vcov(Gmodel4)))
z_score <- (as.numeric(Gmodel4_coefs["startPSX"]) - as.numeric(Gmodel4_coefs["startPPX:startPSX"])) / (sqrt(Gmodel4_coefs_se["startPSX"]^2 + Gmodel4_coefs_se["startPPX:startPSX"]^2))
pvalue <- pnorm(-abs(z_score))
print(z_score)
print(pvalue)



















