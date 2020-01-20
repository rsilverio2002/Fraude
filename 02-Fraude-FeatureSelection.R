#Código para Feature Selection

#Feature Selection com RandomForest------

# modelo<-randomForest(is_attributed ~ . -app -ip - channel ,train,importance=TRUE)
# 
# varImpPlot(modelo)
# 
# modelo
# summary(modelo)

#os resultados indicam que os apps 19 e 35 são importantes na decisão. Além das variáveis mais os, clicktime e device.


#Feature Selection com Recursive Feature Elimination------

rfectrl1 <- rfeControl(functions = nbFuncs,method="cv", verbose=TRUE,allowParallel=TRUE)

feature1<-rfe(is_attributed ~ . ,data=train,
             sizes=1:5,metric='Accuracy',
             rfeControl=rfectrl1)


feature1


rfectrl2 <- rfeControl(functions = lrFuncs,method="cv", verbose=TRUE,allowParallel=TRUE)

feature2<-rfe(is_attributed ~ . ,data=train,
             sizes=1:5,metric='Accuracy',
             rfeControl=rfectrl2)


feature2

sbfctrl1 <- sbfControl(functions = nbSBF,method="cv", verbose=TRUE,allowParallel=TRUE)

feature3<-sbf(is_attributed ~ . ,data=train,
              sbfControl=sbfctrl1)


feature3


#diferentes métodos apontaram app e device como possíveis variáveis
