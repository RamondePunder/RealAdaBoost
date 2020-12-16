library(devtools);
setwd(dirname(getActiveDocumentContext()$path))

load_all(".") 

###### MAIN ######
sFileName= 'COVID_WB_Data.Rdata'
sDep= 'Cases'
iN <- 70             # Sample size (meta) parameter estimation  
iSeed <- 1           # Random seed
iFold <- 5           # Number of folds Cross Validation
iDepth <- 2
dCasesSplit <- 10

## Load data and hold out test set
# Remark: xgboost package requires numeric matrices as inputs
load(sFileName)
set.seed(iSeed) 
vIdxTrain <- sample(nrow(dfData), iN)
dfData[,'Cases'] <- -1 * (dfData[,'Cases'] <= dCasesSplit) +  1*  (dfData[,'Cases'] > dCasesSplit)  # binary classification

mData <- as.matrix(dfData[, -which(colnames(dfData) %in% c('Deaths','Other'))]) # to prevent for dummy trap, and drop deaths
mDataTrain <- mData[vIdxTrain, ]
mDataTest <- mData[-vIdxTrain, ]

library(devtools) # Make sure that the devtools library is loaded

RealAdaBoostClass(mDataTrain = mDataTrain, mDataTest = mDataTest, iM=1, iDepth=2, iSeed=1)
