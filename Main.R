rm(list = ls())

# read in auxiliary files
setwd("~/noLabelNoCryMethod")
source("Constants.R")
source("Load Up Data.R")

# manipulate the data
source("Further Data Manipulation.R")

# AMM
source("alternatingMeanMap.R")
source("laplacianMeanMap.R")
source("meanMap.R")
source("auc.R")
source("noLabelNoCryComputation.R")
stats[["AMM"]] <- ammComputation(df, dataMatrix, trainPrecincts)
