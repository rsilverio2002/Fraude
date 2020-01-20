library(readr)
library(tidyverse)
library(ggplot2)
library(caret)
library(skimr)
library(randomForest)
library(DMwR)
library(forcats)



#Leitura dos dados-----------------

trainname<-'train_sample.csv'
# testname<-'test.csv'


dados<-read_csv(trainname,col_names=TRUE,col_types=NULL)%>%
  mutate(app=factor(app))%>%
  mutate(device=factor(device))%>%
  mutate(app=factor(app))%>%
  mutate(is_attributed=factor(is_attributed))%>%
  mutate(os=factor(os))%>%
  mutate(channel=factor(channel))%>%
  select(-attributed_time)%>%
  mutate(ip=factor(ip))

# teste<-read_csv(testname,col_names=TRUE,col_types=NULL)%>%
#   mutate(app=factor(app))%>%
#   mutate(device=factor(device))%>%
#   mutate(os=factor(os))%>%
#   sample(100000)



#Estatísticas Descritivas dos Dados e Visualizações-------------

skim(dados)
glimpse(dados)
summary(dados)

table(dados$app,dados$is_attributed)
table(dados$device,dados$is_attributed)
table(dados$os,dados$is_attributed)
table(dados$channel,dados$is_attributed)

ggplot(dados)+
  geom_bar(aes(x=app))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(dados)+
  geom_bar(aes(x=device))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(dados)+
  geom_bar(aes(x=ip))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(dados)+
  geom_bar(aes(x=os))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(dados)+
  geom_bar(aes(x=channel))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(dados)+
  geom_histogram(aes(x=click_time))+
  facet_wrap(is_attributed~.)+
  coord_flip()

ggplot(dados)+
  geom_boxplot(aes(x=is_attributed,y=click_time))



#Foi possível observar que as variáveis categóricas possuem multiplos níveis.
#A variavel de resposta é altamente desbalanceada.
#as variáveis explicativas possuem muitos níveis únicos, o que requer algum tratamento para simplificação.


#Tratamento das variáveis selecionadas para dados e teste--------
#Estratégia adotada: manter explícitos os fatores mais frequentes nos resultados positivos. Agregar os demais
#usando o pacote Forcats.

positivo<-dados%>%
  filter(is_attributed==1)

a<-skim(positivo)
a$factor.top_counts[1]
a$skim_variable


dadosaj<-dados%>%
  mutate(app=fct_lump(app,n=20,other_level='other'))%>%
  mutate(device=fct_lump(device,n=5,other_level='other'))%>%
  mutate(os=fct_lump(os,n=3,other_level='other'))%>%
  mutate(channel=fct_lump(channel,n=20,other_level='other'))%>%
  select(-ip)

#diagnóstico dos dados após ajuste. Importante mostrar que as features ajustadas possuem poder para explicar os dados.

skim(dadosaj)

table(dadosaj$app,dados$is_attributed)
table(dadosaj$device,dados$is_attributed)
table(dadosaj$os,dados$is_attributed)
table(dadosaj$channel,dados$is_attributed)

#criação dos dados de treino e teste

x<-createDataPartition(dadosaj$is_attributed,1,p=0.7,list=FALSE)

train<-dadosaj[x,]
test<-dadosaj[-x,]






