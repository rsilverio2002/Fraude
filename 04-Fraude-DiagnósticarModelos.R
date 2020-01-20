library(ROCR)

### Criar Gráficos AUC das previsões

predm5<-prediction(as.numeric(res5),as.numeric(test$is_attributed))
perf5<-performance(predm5,'tpr','fpr')
plot(perf5)
abline(0,1)
auc5 <- performance(predm5, measure = "auc")
auc5@y.values

predm6<-prediction(as.numeric(res6),as.numeric(test$is_attributed))
perf6<-performance(predm6,'tpr','fpr')
plot(perf6)
abline(0,1)
auc6 <- performance(predm6, measure = "auc")
auc6@y.values


predm1<-prediction(as.numeric(res1),as.numeric(test$is_attributed))
perf1<-performance(predm1,'tpr','fpr')
plot(perf1)
abline(0,1)
auc1 <- performance(predm1, measure = "auc")
auc1@y.values

predm2<-prediction(as.numeric(res2),as.numeric(test$is_attributed))
perf2<-performance(predm2,'tpr','fpr')
plot(perf2)
abline(0,1)
auc2 <- performance(predm2, measure = "auc")
auc2@y.values

predm3<-prediction(as.numeric(res3),as.numeric(test$is_attributed))
perf3<-performance(predm3,'tpr','fpr')
plot(perf3)
abline(0,1)
auc3 <- performance(predm3, measure = "auc")
auc3@y.values

predm4<-prediction(as.numeric(res4),as.numeric(test$is_attributed))
perf4<-performance(predm4,'tpr','fpr')
plot(perf4)
abline(0,1)
auc4 <- performance(predm4, measure = "auc")
auc4@y.values

resultsAUC<-c(auc1@y.values,
  auc2@y.values,
  auc3@y.values,
  auc4@y.values,
  auc5@y.values,
  auc6@y.values)


resultsAUC

#### Conclusões: Os modelos 1, 2 e 5 apresentaram performance superior. Contudo, todos ainda erram 
#### bastante na hora de identificar a atribuição verdadeira corretamente. As classes desbalanceadas
#### realmente atrapalham.
