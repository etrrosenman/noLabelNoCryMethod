# seed
set.seed(2018)

# libraries
library(foreach)

# basic constants
refYear <- 2016
useGeneral <- TRUE
voting <- TRUE
numHoldoutPrecincts <- 100
predictorSet <- "demographics and voting history" 

# list of predictors 
if(predictorSet == "binary demographics only") {
  
  predictors <- c("VAN.ID", "County.Voter.ID", "Party", "Sex", 
                  "apartmentResident", "Precinct")
  
} else if(predictorSet == "demographics only") {
  
  predictors <- c("VAN.ID", "age", "County.Voter.ID", "Party", "Sex", 
                  "apartmentResident", "Precinct")
  
} else if (predictorSet == "demographics and voting history") {

  predictors <- c("VAN.ID", "County.Voter.ID", "age", "Party", "Sex", 
                  "priorPresidential", "priorGubernatorial", "priorMidterm", "priorOffyear",
                  "priorPresidentialPrimary", "priorGubernatorialPrimary", "priorMidtermPrimary", 
                  "priorOffyearPrimary", "apartmentResident", "Precinct")
  if(useGeneral)
    predictors <- c(predictors, "primary")
  
} else {
  predictors <- c()
}

# predictor types
metadataPredictors <- list("Precinct", "Voters", "Registered.Voters", "X.Intercept.",
                           "VAN.ID", "County.Voter.ID")
binaryPredictors <- list("PartyN", "PartyR", "SexM", "SexU", "priorPresidentialIn.Person",
                         "priorPresidentialMail.In", "priorGubernatorialIn.Person", 
                         "priorGubernatorialMail.In", "priorMidtermIn.Person", "priorMidtermMail.In", 
                         "priorOffyearIn.Person", "priorOffyearMail.In", "priorPresidentialPrimaryDemocrat", 
                         "priorPresidentialPrimaryRepublican", "priorGubernatorialPrimaryDemocrat",
                         "priorGubernatorialPrimaryRepublican", "priorMidtermPrimaryDemocrat",
                         "priorMidtermPrimaryRepublican", "priorOffyearPrimaryDemocrat", 
                         "priorOffyearPrimaryRepublican", "apartmentResidentTRUE", 
                         "primaryDemocrat", "primaryRepublican")
normalPredictors <- list("age")

# get the title
title <- paste(refYear, ": ", ifelse(useGeneral, "General", "Primary"), sep = "")