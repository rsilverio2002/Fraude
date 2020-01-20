#codigo para rodar os Modelos

#Preparação dos parametros

formula1<-as.formula('is_attributed ~ app + device')
formula2<-as.formula('is_attributed ~ app + device + os + channel')

ctrl1 <- trainControl(sampling = "smote")
ctrl2 <- trainControl(sampling = "down")

#Modelo a ser treinado------

#model1 SVM: primeira tentativa

model1<-train(formula1,data=train,method='svmLinear',trControl=c(ctrl1,ctrl2))
res1<-predict(model1,test)
plot(model1)
model1
confusionMatrix(res1,test$is_attributed)


#model2 glm: segunda tentativa

model2<-train(formula1,data=train,method='glm',trControl=c(ctrl1,ctrl2))
res2<-predict(model2,test)
plot(model2)
model2
confusionMatrix(res2,test$is_attributed)


#model3 naiveBayes: terceira tentativa

model3<-train(formula1,data=train,method='naive_bayes',trControl=c(ctrl1,ctrl2))
res3<-predict(model3,test)
plot(model3)
model3
confusionMatrix(res3,test$is_attributed)

#model4 naiveBayes: quarta tentativa - todas as variáveis

model4<-train(formula2,data=train,method='naive_bayes',trControl=c(ctrl1,ctrl2))
res4<-predict(model4,test)
plot(model4)
model4
confusionMatrix(res4,test$is_attributed)


#model5 Usando um classificador com custo: quinta tentativa - todas as variáveis

model5<-train(formula2,data=train,method='svmLinearWeights',
              metric='Kappa',trControl=c(ctrl1,ctrl2))
res5<-predict(model5,test)
plot(model5)
model5
confusionMatrix(res5,test$is_attributed)


#model6 Usando outro classificador com custo: sexta tentativa - todas as variáveis

model6<-train(formula2,data=train,method='C5.0Cost',
              metric='Kappa',trControl=c(ctrl1,ctrl2))
res6<-predict(model6,test)
plot(model6)
model6
confusionMatrix(res6,test$is_attributed)
