#################################################
##          further data manipulation          ##
#################################################

# create a data matrix
dataMatrix <- cbind(dataMatrix, VAN.ID = df$VAN.ID, County.Voter.ID = df$County.Voter.ID)
dataMatrix <- cbind(dataMatrix, outcome = df$outcome)

# get a list of precinct data frames
designMatrices <- lapply(trainPrecincts, FUN = function(p) {
  dataMatrix[df$Precinct == p,]
})
names(designMatrices) <- trainPrecincts
names(designMatrices)[names(designMatrices) == "Wharton Boro 05"] <- "Wharton Borough D05"

# clean things up 
trainMatrix <- do.call(rbind, designMatrices)
outcome <- trainMatrix[,ncol(trainMatrix)]
trainMatrix <- trainMatrix[,-ncol(trainMatrix)] # drop the outcome 
IDs <- trainMatrix[,c("VAN.ID", "County.Voter.ID")]
trainMatrix <- trainMatrix[,-((ncol(trainMatrix)-1):ncol(trainMatrix))] # drop the IDs
trainMatrix <- data.frame(trainMatrix)

designMatrices <- lapply(designMatrices, FUN = function(x) {
  x[,!colnames(x) %in% c("VAN.ID", "County.Voter.ID")]
})

# make a holdout matrix
holdoutMatrix <- dataMatrix[df$Precinct %in% holdoutPrecincts,]
holdoutMatrix <- holdoutMatrix[,!colnames(holdoutMatrix) %in% 
                                 c("VAN.ID", "County.Voter.ID")]
