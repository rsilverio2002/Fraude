# Fraude

## Introdução
GitHub preparado para guardar os dados e análises usando o conjunto de dados Talking Data na análise de cliques fraudulentos em propaganda. Esse é um dos Projetos da Formação Ciência de Dados da Data Science Academy.

Os dados originais (do Kaggle) possuem um tamanho de cerca de 7 GB para treino e mais 800 mb para teste e excederam consideravelmente a capacidade da minha máquina de trabalhar com eles. Como alternativa usei o train_sample.csv (que possui 100.000 obs e cerca de 3,6 mb). Mesmo com ele, as análises ficaram relativamente lentas.

## Analise exploratória dos dados
A análise exploratória usando a função skim e gráficos das variáveis mostrou que o dataset é desbalanceado e as variáveis categóricas possuem muitos valores únicos. 
Analisando as contagens dos valores nos casos positivos e afirmativos, ficou clara a necessidade de reduzir a quantidade de categorias.
Como forma de corrigir isso, foi usada a função fct_lump() do pacote forcats como forma de reduzir o número de categorias, agregando as demais em um grupo único.

Via de regra, os fatores ficaram razoavelmente desbalanceados (assim como a variável alvo). Isso pode ser um ponto de melhoria para o futuro.

As variáveis IP e Click_Time não aparentaram ter utilidade para resolução do problema com base na análise do problema de negócio e não foram utilizadas.

## Feature Selection

Para essa seção busquei usar os algoritmos já disponíveis no pacote CARET. Foram rodados três métricas diferentes:
- Recursive Feature Elimination (RFE) com funções do tipo Naive Bayes (nbFuncs)
- Recursive Feature Elimination (RFE) com funções do tipo Logistic Regression (lrFuncs)
- Selection By Filtering (SBF) com funções do tipo Naive Bayes (nbFuncs)

Os métodos sinalizaram que as variáveis app e device são as mais relevantes para a explicação do modelo, mas tiveram dificuldade em identificar variáveis significativas.

## Rodando os Modelos

Foram testados 6 modelos diferentes com 2 tipos de parâmetros para tentar resolver o problema de desbalanceamento das classes: downsampling e SMOTE foram aplicados em todos os treinos.

Modelos e algoritmos utilizados:
- svmLinear, naive_bayes e glm com as variáveis app e device.
- naive_bayes com todas as variáveis
- algoritmos com função custo (svmLinearWeights e C5.0Cost) como forma de tentar atenuar o problema de classificação. Nesses foram usadas todas as variáveis.

## Resultados

Com exceção dos modelos 3 e 4, que simplesmente tentaram colocar todas as respostas na categoria mais frequente, não houve grande variabilidade nos resultados.

Todos os modelos erraram bastante ao tentar prever o is_attributed = 1. Pelo critério AUC, o modelo 5, que usou o algo svmLinearWeights e todos os dados foi ligeiramente melhor que os outros.
