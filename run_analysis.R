## Rag R - Coursera - Getting and Cleaning Data, Nov. 2017
## v 0.1

library(dplyr)

#clear all objects from environment/memory
rm(list=ls())

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"
dataFolder <- "UCI HAR Dataset"
tidyFile <- "tidy_data.txt"

workingDir <- "~/work/coursera/c3p1/Getting-and-Cleaning-Data-Project"

#change to working dir
setwd(workingDir)

print("0. If needed, download and unzip data file.")
## If needed, download and unzip the dataset
if (!file.exists(zipFile)){
  download.file(fileURL, zipFile, method="curl")
}
#if zipFile hasn't been unzipped, then unzip. Uses the file name as folder name
if (!file.exists(zipFile)) {
  unzip(zipFile)
}

#If output Tidy file exists, delete it as we will create it.
if (file.exists(tidyFile)) {
  file.remove(tidyFile)
  print("0.1 Removing existing tidy file to create a new run for each run.")
}

print("1. Input data is ready!")

################################
# Load data from source files
################################

# Load activity labels into a table
###################################
print("2. Loading Activities:")
activities <- read.table(file.path(dataFolder, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")
print("2. Activities Loaded!")

# Load features into a table
###################################
print("3. Loading Features:")
features <- read.table(file.path(dataFolder, "features.txt"), as.is = TRUE)
print("3. Features Loaded!")
# feature names are not unique

# Load training data
###################################
print("4. Loading Training:")
trainSubs <- read.table(file.path(dataFolder, "train", "subject_train.txt"))
trainVals <- read.table(file.path(dataFolder, "train", "X_train.txt"))
trainActs <- read.table(file.path(dataFolder, "train", "y_train.txt"))
print("4. Training data Loaded!")

# Load test data
###################################
print("5. Loading Test data:")
testSubs <- read.table(file.path(dataFolder, "test", "subject_test.txt"))
testVals <- read.table(file.path(dataFolder, "test", "X_test.txt"))
testActs <- read.table(file.path(dataFolder, "test", "y_test.txt"))
print("5. Test data Loaded!")

# merge and combine data to have one set
########################################

# using row and column bind, join individual data tables to make single data table
#########################################################################################
print("6. Joining data:")
joinedData <- rbind(cbind(trainSubs, trainVals, trainActs), cbind(testSubs, testVals, testActs))

# assign column names
colnames(joinedData) <- c("subject", features[, 2], "activity")
print("6. Joined data Ready!")

## Pick and label select columns
########################################
#Pick mean and standard dev to keep

# Figure which columnsto keep based on column name...
colsToKeep <- grepl("subject|activity|mean|std", colnames(joinedData))

# only keep the selected column data
joinedData <- joinedData[, colsToKeep]


#set descriptive activity labels
joinedData$activity <- factor(joinedData$activity,
                                 levels = activities[, 1], labels = activities[, 2])

## set labels
########################################
print("7. Cleaning up labels!")
# get column names
joinedDataCols <- colnames(joinedData)

# Replace special chars
joinedDataCols <- gsub("[\\(\\)-]", "", joinedDataCols)

# Rename and clean up labels to be more meaningful
joinedDataCols <- gsub("^f", "FrequencyDomain", joinedDataCols)
joinedDataCols <- gsub("^t", "TimeDomain", joinedDataCols)
joinedDataCols <- gsub("Acc", "Accelerometer", joinedDataCols)
joinedDataCols <- gsub("Gyro", "Gyroscope", joinedDataCols)
joinedDataCols <- gsub("Mag", "Magnitude", joinedDataCols)
joinedDataCols <- gsub("Freq", "Frequency", joinedDataCols)
joinedDataCols <- gsub("mean", "Mean", joinedDataCols)
joinedDataCols <- gsub("std", "StandardDeviation", joinedDataCols)
joinedDataCols <- gsub("BodyBody", "Body", joinedDataCols)

# use new labels as column names
colnames(joinedData) <- joinedDataCols
print("7. Cleaning up labels done.")

# group data to save, summarize by mean
########################################
# group by subject and activity and summarise using mean
# use dplyr %>% to pass results from LHS to RHS
joinedDataMeans <- joinedData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
# output to file "tidy_data.txt"
########################################
print("8. Writing to tidy data file:")
write.table(joinedDataMeans,tidyFile , row.names = FALSE, quote = FALSE)
print("8. Tidy data file created!")

#release objects
rm(joinedDataMeans,joinedDataCols,joinedData,colsToKeep,
   trainSubs, trainVals, trainActs, 
   testActs,testSubs, testVals,
   activities, features)
# END
########################################