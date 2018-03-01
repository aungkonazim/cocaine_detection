rm(list=ls())
setwd('C://Users//aungkon//Desktop//jhu//code//code_final_1//data_NIDA')
data <- read.csv('feature.csv',header = F)

library(e1071)
library(caret)
library(tidyverse)
trainPositive<-subset(data[,1:25],data[,26]==1)
testpredictors<-data[,1:25]
testLabels<-data[,26]

svm.model<-svm(trainPositive,y=NULL,
               type='one-classification',
               nu=0.5,
               scale=TRUE,
               kernel="radial")
svm.pred<-predict(svm.model,testpredictors)
confusionMatrixTable<-table(Predicted=svm.pred,Reference=testLabels)
confusionMatrix(confusionMatrixTable,positive='TRUE')

svm_model <- svm(testLabels ~ ., data=data[,1:25])
summary(svm_model)
pred <- predict(svm_model,testpredictors)
table(pred,testLabels)



x <- data[,1:25]
y <- data[,26]
svm_model1 <- svm(x,y)
summary(svm_model1)
pred <- predict(svm_model1,x)
table(Predicted=pred,Reference=y)
svm_tune <- tune(svm, train.x=x, train.y=y, 
                 kernel="radial", ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)))


?mpg

#to produce a scatter plot of displacement vs mpg

ggplot(data=mpg)+geom_point(mapping=aes(x=displ,y=hwy))

#geom point tells ggplot what type of graph to produce
#mapping is always paired with aes()
# a template for creating the graph in ggplot is ggplot(data = <DATASET>)+<GEOM FUNCTION>(mapping=aes(<MAPPING>))

## add athird classification variable to a plot using aesthetics

## Color aesthetic
ggplot(data=data)+geom_point(mapping=aes(x=data[,25],y=data[,24],color=data[,26]))
