library(readr)
library(tidyverse)
library(ggplot2)
library(caret)
library(skimr)
library(randomForest)
library(DMwR)



#Leitura dos dados-----------------

trainname<-'train_sample.csv'
testname<-'test.csv'

treino<-read_csv(trainname,col_names=TRUE,col_types=NULL)%>%
  mutate(app=factor(app))%>%
  mutate(device=factor(device))%>%
  mutate(is_attributed=factor(is_attributed))%>%
  mutate(os=factor(os))

# teste<-read_csv(testname,col_names=TRUE,col_types=NULL)%>%
#   mutate(app=factor(app))%>%
#   mutate(device=factor(device))%>%
#   mutate(os=factor(os))%>%
#   sample(100000)



#Estatísticas Descritivas dos Dados-------------

skim(treino)
glimpse(treino)
summary(treino)

table(treino$app,treino$is_attributed)
table(treino$device,treino$is_attributed)
table(treino$os,treino$is_attributed)
table(treino$channel,treino$is_attributed)

#visualização das ocorrências das variáveis em cada grupo

treino%>%group_by(device,is_attributed)%>%
  count()%>%View()

# os devices 0, 1 e 2 são os mais frequentes, dominando o grupo

treino%>%group_by(app,is_attributed)%>%
  count()%>%View()

#vale deixar de fora apenas os apps que possuem observações positivas e negativas, ou One hot encode todos


treino%>%group_by(os,is_attributed)%>%
  count()%>%View()

#agrupados todos com ocorrência menor que 100

osmaiorque100<-treino%>%group_by(os,is_attributed)%>%
  count()%>%
  filter(n>100)




ggplot(treino)+
  geom_bar(aes(x=app))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(treino)+
  geom_bar(aes(x=device))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(treino)+
  geom_bar(aes(x=os))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(treino)+
  geom_bar(aes(x=channel))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(treino)+
  geom_histogram(aes(x=click_time))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(treino)+
  geom_boxplot(aes(x=is_attributed,y=click_time))


#Foi possível observar que as variáveis categóricas possuem multiplos níveis.
#A variavel de resposta é altamente desbalanceada.


#Tratamento das variáveis selecionadas para treino e teste--------

treinoaj<-treino%>%
  mutate(device=case_when(device == 0~'0',
                          device == 1~'1',
                          device == 2~'2',
                          TRUE ~ 'outro'))%>%
  mutate(os=as.character(os))%>%
  mutate(os=case_when(os %in% as.character(osmaiorque100$os) ~ as.character(os),
                      TRUE ~ 'outro'))%>%
  mutate(os=as.factor(os))%>%
  mutate(device=as.factor(device))

dummy<- dummyVars( ~ app, data=treinoaj)

treinoaj<-cbind(treinoaj,predict(dummy,treinoaj))

x<-createDataPartition(treinoaj$is_attributed,1,p=0.5,list=FALSE)

train<-treinoaj[x,]
test<-treinoaj[-x,]



#Feature Selection com RandomForest------

modelo<-randomForest(is_attributed ~ . -app -ip - channel ,train[,-7],importance=TRUE)

varImpPlot(modelo)

modelo
summary(modelo)

#os resultados indicam que os apps 19 e 35 são importantes na decisão. Além das variáveis mais os, clicktime e device.



#Modelo a ser treinado------

#model1 SVM: primeira tentativa

ctrl <- trainControl(sampling = "smote")

model1<-train(is_attributed ~ app.35+app.19+os+click_time+device,data=train[,-7],method='svmLinear',trControl=ctrl)
res1<-predict(model1,test)
plot(model1)
model1
confusionMatrix(res1,test$is_attributed)


#model2 glm: segunda tentativa

model2<-train(is_attributed ~ app.35+app.19+os+click_time+device,data=train[,-7],method='glm',trControl=ctrl)
res2<-predict(model2,test)
plot(model2)
model2
confusionMatrix(res2,test$is_attributed)


#model3 glm: terceira tentativa - removendo variáveis para os apps 35 e 19

model3<-train(is_attributed ~ os+click_time+device,data=train[,-7],method='glm')
res3<-predict(model3,test)
plot(model3)
model3
confusionMatrix(res3,test$is_attributed)


#model4 glm: terceira tentativa - incluindo novos apps da lista 25, 45 e 5

model4<-train(is_attributed ~ app.25+app.45+app.5+app.35+app.19+
                os+click_time+device,data=train[,-7],method='glm',trControl=ctrl)
res4<-predict(model4,test)
plot(model4)
model4
confusionMatrix(res4,test$is_attributed)

#model5 glm: quinta tentativa - incluindo todos os apps

model5<-train(is_attributed ~ . -app-ip-channel,data=train[,-7],method='glm')
res5<-predict(model5,test)
plot(model5)
model5
confusionMatrix(res5,test$is_attributed)


#model6 naive bayes: quinta tentativa - incluindo os apps 35,34,45 e 19

model6<-train(is_attributed ~ app.35+app.34+app.45+app.19+os+click_time+device,data=train[,-7],method='naive_bayes',trControl=ctrl)
res6<-predict(model6,test)
plot(model6)
model6
confusionMatrix(res6,test$is_attributed)


