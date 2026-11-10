
library(lme4) 
library(sjPlot) 
library(car)


data <- within(behaviour_data, {
  sub <- as.factor(sub)
  confidence <- as.numeric(confidence)
  escape <- as.numeric(escape)
  anxiety <- as.numeric(anxiety)
  FID <- as.numeric(FID)
  DTR <- as.numeric(DTR)
})


summary(data)


## confidence and anxiety scores predict success
# model development
aGmodel1 <- glmer(escape ~ confidence + (1|sub), family=binomial, data=data)
summary(aGmodel1)
sjPlot::tab_model(aGmodel1)

aGmodel2 <- glmer(escape ~ anxiety + (1|sub), family=binomial, data=data)
summary(aGmodel2)
sjPlot::tab_model(aGmodel2)

aGmodel3 <- glmer(escape ~ confidence+anxiety + (1|sub), family=binomial, data=data)
summary(aGmodel3)
sjPlot::tab_model(aGmodel3)

aGmodel4 <- glmer(escape ~ confidence+anxiety+confidence*anxiety + (1|sub), family=binomial, data=data)
summary(aGmodel4)
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
Gmodel1 <- glmer(escape ~ FID + (1|sub), family=binomial, data=data)
summary(Gmodel1)
sjPlot::tab_model(Gmodel1)

Gmodel2 <- glmer(escape ~ DTR + (1|sub), family=binomial, data=data)
summary(Gmodel2)
sjPlot::tab_model(Gmodel2)

Gmodel3 <- glmer(escape ~ FID+DTR + (1|sub), family=binomial, data=data)
summary(Gmodel3)
sjPlot::tab_model(Gmodel3)

Gmodel4 <- glmer(escape ~ FID+DTR+FID*DTR + (1|sub), family=binomial, data=data)
summary(Gmodel4)
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
z_score <- (as.numeric(Gmodel4_coefs["DTR"]) - as.numeric(Gmodel4_coefs["FID:DTR"])) / (sqrt(Gmodel4_coefs_se["DTR"]^2 + Gmodel4_coefs_se["FID:DTR"]^2))
pvalue <- pnorm(-abs(z_score))
print(z_score)
print(pvalue)



















