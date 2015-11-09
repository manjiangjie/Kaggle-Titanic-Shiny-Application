library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  titlePanel("Kaggle Titanic Project"),
  
  tabsetPanel(tabPanel("Profile",
                       sidebarLayout(
                         sidebarPanel(
                           h3("About the project"),
                           p("author: Jiangjie Man (Jack)"),
                           p("date: November 8, 2015"),
                           p("For more info: "),
                           a("Kaggle Titanic Competition", href = "https://www.kaggle.com/c/titanic"),
                           br(),
                           a("CSX460 Course Github Repo", href = "https://github.com/CSX460/CSX460")
                         ),
                         mainPanel(
                           h3("Project Description"),
                           p("This is the course project of ", strong("CSX460: Practical Machine Learning (with R)")),
                           p("Also, it is a Shiny Application developed using the Kaggle's Titanic dataset 
                             that predicts the survival of the passengers on the Titanic."),
                           br(),
                           h3("About the Titanic Disaster"),
                           img(src = "titanic.jpg", height = 300, width = 600),
                           br(),
                           br(),
                           p("The sinking of the RMS Titanic is one of the most infamous shipwrecks in history.  
                             On April 15, 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, 
                             killing 1502 out of 2224 passengers and crew. This sensational tragedy shocked the international community 
                             and led to better safety regulations for ships."),
                           p("One of the reasons that the shipwreck led to such loss of life was that 
                             there were not enough lifeboats for the passengers and crew. 
                             Although there was some element of luck involved in surviving the sinking, 
                             some groups of people were more likely to survive than others, 
                             such as women, children, and the upper-class."),
                           br(),
                           br()
                         )
                       )
                       ),
              
              tabPanel("Data", 
                       sidebarLayout(  
                         sidebarPanel(
                           selectInput("x", label = "x-axis", 
                                       choices = list("Age" = "Age", "Fare"="Fare", "Family Size"="FamilySize", "Number of Siblings on board"="SibSp"),
                                       selected = list("Age")
                                       ),
                           selectInput("y", label="y-axis", 
                                       choices=list("Age" = "Age", "Fare"="Fare", "Family Size"="FamilySize", "Number of Siblings on board"="SibSp"),
                                       selected=list("Fare")
                                       ),
                           selectInput("toPlot", label="Variable to distinguish on the plot", 
                                       choices=list("Sex" = "Sex", "Class" = "Pclass",  
                                                    "Embarkment Port"="Embarked", "Family Size"="FamilySize", "Family Name"="FamilyID2",
                                                    "Title"="Title", "Number of Siblings on board"="SibSp"),
                                       selected=list("Pclass")
                                       ),
                           checkboxGroupInput("facets", label="Facets", 
                                              choices = list("Survived"="Survived", "Sex" = "Sex", "Class" = "Pclass", "Embarkment Port"="Embarked",
                                                             "Family Size"="FamilySize", "Family Name"="FamilyID2",
                                                             "Title"="Title", "Number of Siblings on board"="SibSp"),
                                              selected = list("Sex", "Survived")
                                              )
                         ),
                         mainPanel(
                           h3("Data Analysis"),
                           plotOutput("dataPlot")
                         )
                       )
                       ),
              
              tabPanel("Age repartition",
                       sidebarLayout(  
                         sidebarPanel(sliderInput("ageBins", "Number of age ranges to consider", min=1, max=30, value=8)),
                         mainPanel(
                           h2("Survival by Age range"),
                           plotOutput("ageHist"),
                           plotOutput("dataBoxPlot")
                         )
                       )),
              "Modeling",
              
              tabPanel("Decision tree", 
                       sidebarLayout(  
                         sidebarPanel(
                           checkboxGroupInput("treeVariables", label = h4("Variables to take into account"), 
                                              choices = list("Sex" = "Sex", "Age" = "Age", "Class" = "Pclass", "Fare"="Fare", 
                                                             "Embarkment Port"="Embarked", "Family Size"="FamilySize", "Family Name"="FamilyID2",
                                                             "Title"="Title", "Number of Siblings on board"="SibSp"),
                                              selected = list("Sex", "Age")
                           )),
                         mainPanel(
                           h2("Decision tree obtained with rpart"),
                           plotOutput("decisionTree")
                         )
                       )),
              
              tabPanel("Did he survive ?", 
                       sidebarLayout(  
                         sidebarPanel(
                           "Select the characteristic of the passenger :",
                           radioButtons("Sex", "Sex", choices=list("Male"="male","Female"="female"), selected="male"),
                           sliderInput("Age", "Age", min=0, max=100, value = 25),
                           radioButtons("Pclass", "Class", choices=list("First"=1, "Second"=2, "Third"=3), selected=2),
                           sliderInput("Fare", "Fare", min=1, max=100, value=10),
                           selectInput("Embarked", "Embarked at", choices=list("Cherbourg"="C", "Queenstown"="Q", "Southhampton"="S"), selected="S"),
                           sliderInput("FamilySize", "Family size", min=1, max=15, value=3),
                           textInput("FamilyName", "Family name", value="Smith"),
                           selectInput("Title", "Title", choices=list("Mr"="Mr", "Mrs"="Mrs", "Miss"="Miss", "Master"="Master", "Dr"="Dr",
                                                                      "Rev"="Rev", "Sir"="Sir", "Lady"="Lady", "Col"="Col"), selected="Mr"),
                           sliderInput("Siblings", "Number of Siblings on board", min=0, max=10, val=2)
                         ),
                         mainPanel(
                           h2("Prediction according to the current decision tree"),
                           "According to the currently computed decision tree, this passenger must have",
                           textOutput("didHeSurvive", container=strong), " !",
                           br()
                         )
                       ))
  )
))