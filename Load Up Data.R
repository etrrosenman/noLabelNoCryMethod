#########################################
##          voter data set up          ##
#########################################

# read in the voter data
source("~/Dropbox/Political Stuff/NJ-11 Analysis/2018/Poisson Binomial GLMs/helperFunctions.R")
if(!exists("allData") || is.null(allData)) {
  
  # read in the data
  allData <- read.csv("~/Dropbox/Political Stuff/NJ-11 Analysis/2018/Voter Propensity/voter_list_new.csv")
  
  # function to generate derived attributes
  allData <- generateCovariates(allData)
}

# median fill the age
allData[is.na(allData$Age),]$Age <- median(allData[!is.na(allData$Age),]$Age)
data <- allData

# generate the overall data matrix
df <- generateDataFrame(refYear, predictors, simplifyParties = TRUE, useGeneral = useGeneral)
if("primary" %in% predictorSet) {
  df$primary <- as.character(df$primary)
  df$primary[df$primary == ""] <- "Nonvoter"
  df$primary <- factor(df$primary)
}

# choose the precincts
holdoutPrecincts <- sample(unique(df$Precinct))[1:numHoldoutPrecincts]
trainPrecincts <- setdiff(unique(df$Precinct), holdoutPrecincts)

# drop pequannock d-12 (something is off...)
holdoutPrecincts <- holdoutPrecincts[holdoutPrecincts != "Pequannock Township D12"]
trainPrecincts <- trainPrecincts[trainPrecincts != "Pequannock Township D12"]

# make the data matrix
dataMatrix_unscaled <- model.matrix(glm(outcome ~ . - Precinct - VAN.ID - 
                                          County.Voter.ID, data = df, family = "binomial"))

dataMatrix <- scale(dataMatrix_unscaled)
dataMatrix[,1] <- rep(1, nrow(dataMatrix))  
