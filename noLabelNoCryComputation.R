
ammComputation <- function(df, dataMatrix, trainPrecincts) {
  
  #Hyperparameters
  lambda <- 10
  gamma <- .01
  sigma <- 1
  
  # organize data
  data <- data.frame(dataMatrix[df$Precinct %in% trainPrecincts,])
  data$bag <- df$Precinct[df$Precinct %in% trainPrecincts]
  outcome <- df$outcome[df$Precinct %in% trainPrecincts]

  proportions <- aggregate(data$outcome, list(data$bag), FUN = mean)
  names(proportions) <- c("bag", "label")
  data <- merge(data, proportions, by = "bag")
  
  # get the necessary columns
  data <- data[,c("label", "bag", "X.Intercept.", 
                  names(data)[!(names(data) %in% c(metadataPredictors, "bag", "label", "outcome"))])]
  
  # mean map 
  w.mm <- mean.map(data, lambda)
  print(w.mm) 

  #Laplacian Mean Map with similarity v^G
  #Functions for building the Laplacian matrix are into laplacian.mean.map.R
  N <- length(unique(data$bag))
  L <- laplacian(similarity="G,s", data, N, sigma=1)
  w.lmm <- laplacian.mean.map(data, lambda, gamma, L = L)
  print(w.lmm)
  
  #Laplacian Mean Map with similarity v^{G,s}
  L <- laplacian(similarity="G,s", data, N, sigma=sigma)
  w.lmm <- laplacian.mean.map(data, lambda, gamma, L = L)
  print(w.lmm)
  
  #Laplacian Mean Map with similarity v^NC
  L <- laplacian(similarity="NC", data, N)
  w.lmm <- laplacian.mean.map(data, lambda, gamma, L = L)
  print(w.lmm)
  
  #Alternating Mean Map started with MM
  w.amm <- alternating.mean.map(data, lambda=lambda, init="MM")
  w.amm <- w.amm$theta #the algorithm returns a structure that contains also the number of step until termination
  print(w.amm)
  
  #Alternating Mean Map started with LMM with similarity v^{G,s}
  L <- laplacian(similarity="G,s", data, N, sigma=10)
  w.amm <- alternating.mean.map(data, lambda=lambda, init="LMM", L=L, gamma=gamma)
  w.amm <- w.amm$theta #the algorithm returns a structure that contains also the number of step until termination
  print(w.amm)
}
