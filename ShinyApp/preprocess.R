# import libraries
library(rpart)
library(caret)
library(randomForest)
library(party)
library(rpart.plot)
library(ggplot2)

# Set working directory and import datafiles to the top of the file
setwd("~/Desktop/Coding/Projects/Kaggle-Titanic/ShinyApp")
train <- read.csv("data/train.csv")
test <- read.csv("data/test.csv")

# Bind the two datasets together:
test$Survived <- NA
combi <- rbind(train, test)

# Feature engineering
combi$Name <- as.character(combi$Name)
combi$Title <- sapply(combi$Name, FUN = function(x) {strsplit(x, split = '[,.]')[[1]][2]})
combi$Title <- sub(' ', '', combi$Title)
combi$Title[combi$Title %in% c('Mme', 'Mlle', 'Ms')] <- 'Mlle'
combi$Title[combi$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
combi$Title[combi$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'
combi$Title <- factor(combi$Title)
combi$FamilySize <- combi$SibSp + combi$Parch + 1
combi$Surname <- sapply(combi$Name, FUN = function(x) {strsplit(x, split = '[,.]')[[1]][1]})
combi$FamilyID <- paste(as.character(combi$FamilySize), combi$Surname, sep = "")
combi$FamilyID[combi$FamilySize <= 2] <- 'Small'
famIDs <- data.frame(table(combi$FamilyID))
famIDs <- famIDs[famIDs$Freq <= 2,]
combi$FamilyID[combi$FamilyID %in% famIDs$Var1] <- 'Small'
combi$FamilyID <- factor(combi$FamilyID)

# Replace missing values:
Agefit <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title + FamilySize, data=combi[!is.na(combi$Age),], method="anova")
combi$Age[is.na(combi$Age)] <- predict(Agefit, combi[is.na(combi$Age),])
combi$Embarked <- ifelse(combi$Embarked == '', "S", combi$Embarked)
combi$Embarked <- factor(combi$Embarked)
combi$Fare <- ifelse(is.na(combi$Fare), mean(combi$Fare, na.rm = TRUE), combi$Fare)
combi$FamilyID2 <- combi$FamilyID
combi$FamilyID2 <- as.character(combi$FamilyID2)
combi$FamilyID2[combi$FamilySize <= 3] <- 'Small'
combi$FamilyID2 <- factor(combi$FamilyID2)

# partition data
train <- combi[1:891,]
test <- combi[892:1309,]
train$Survived <- factor(train$Survived, levels = c(0, 1), labels = c("Died", "Survived"))

# Fitting rpart model:
fit <- rpart(Survived ~ Pclass + Sex, data = train, method = "class")
test$Survived <- predict(fit, test)

# Save model and submit:
submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit, file = "submit.csv", row.names = FALSE)
