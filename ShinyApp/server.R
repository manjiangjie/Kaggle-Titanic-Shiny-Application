library(shiny)
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library(ggplot2)
library(randomForest)
source("preprocess.R")

shinyServer(function(input, output) {
  output$ageDensity <- renderPlot({                         
    plot(density(train$Age, na.rm = TRUE), main = "Age distribution by class")
  })
  
  output$dataPlot <- renderPlot({                         
    ggplot(train, aes_string(x = input$x, y = input$y, shape = input$toPlot, color = input$toPlot), facets = paste(input$facets, collapse = "~")) + geom_point(size = I(3), xlab = "XX", ylab = "YY") + facet_grid(paste(input$facets, collapse = "~"), scales = "free", space = "free")
  })
  
  output$ageHist <- renderPlot({
    x <- train$Age
    bins <- seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE), length.out = input$ageBins + 1)
    hist(x, breaks = bins, col = "skyblue", border = "white") 
  })
  
  fit.rp <- reactive({
    variables <- paste(input$treeVariables, collapse = "+")
    if (nchar(variables) < 2){
      variables <- "Sex"
    }
    args <- list(paste("as.factor(Survived) ~ ", variables))
    args$data <- train
    args$method <- "class"
    do.call(rpart, args)
  })
  
  fit.rf <- reactive({
    variables <- paste(input$treeVariables, collapse = "+")
    if (nchar(variables) < 2){
      variables <- "Sex"
    }
    args <- list(as.formula(paste("as.factor(Survived) ~ ", variables)))
    args$data <- train
    args$importance <- TRUE
    args$ntree <- 1000
    args$keep.forest <- FALSE
    args$proximity <- TRUE
    do.call(randomForest, args)
  })
  
  output$decisionTree <- renderPlot({  
    fancyRpartPlot(fit.rp())     
  })
  
  output$randomForest1 <- renderPlot({  
    set.seed(123)
    plot(fit.rf(), log = "y")
  })
  
  output$randomForest2 <- renderPlot({  
    set.seed(123)
    MDSplot(fit.rf(), train$Survived)
  })
  
  output$randomForest3 <- renderPlot({  
    set.seed(123)
    varImpPlot(fit.rf())
  })
  
  output$Survival <- renderText({
    FamilyID2 <- paste(input$FamilyName,input$FamilySize)
    toTest <- data.frame(Sex = input$Sex, Age = input$Age, Pclass = input$Pclass, SibSp = input$Siblings, Fare = input$Fare, Embarked = input$Embarked, Title = input$Title, input$FamilySize, FamilyID2 = FamilyID2)
    predict <- predict(fit.rp(), toTest, type = "class")
    return(as.character(predict))
  })
  
  output$Status <- renderImage({
    FamilyID2 <- paste(input$FamilyName,input$FamilySize)
    toTest <- data.frame(Sex = input$Sex, Age = input$Age, Pclass = input$Pclass, SibSp = input$Siblings, Fare = input$Fare, Embarked = input$Embarked, Title = input$Title, input$FamilySize, FamilyID2 = FamilyID2)
    predict <- predict(fit.rp(), toTest, type = "class")
    if (as.character(predict) == "Survived") {
      return(list(src = "www/survive.jpg", height = 300, width = 400))
    }
    else {
      return(list(src = "www/die.jpg", height = 300, width = 400))
    }
  }, deleteFile = FALSE)
})
