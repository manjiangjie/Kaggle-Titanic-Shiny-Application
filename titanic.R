
# Set working directory and import datafiles to the top of the file
setwd("~/Desktop/Coding/Projects/Kaggle-Titanic")
train <- read.csv("~/Desktop/Coding/Projects/Kaggle-Titanic/data/train.csv")
test <- read.csv("~/Desktop/Coding/Projects/Kaggle-Titanic/data/test.csv")


# The disaster was famous for saving “women and children first” 
# So first summary the gender of passagers to see if any patterns:
summary(train$Sex)
prop.table(table(train$Sex, train$Survived), 2)

test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1


# Then, create a column “Children” indicating whether passenger is below the age of 18:
summary(train$Age)
train$Children <- 0
train$Children[train$Age < 18] <- 1

submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit, file = "all_die.csv", row.names = FALSE)
