## Rag R - Coursera - Getting and Cleaning Data, Oct. 2017
## v 0.1

library(data.table)
library(quantmod)
library(reshape2)
library(dplyr)

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"
dataFolder <- "UCI HAR Dataset"
tidyFile <- "tidy_data.txt"

workingDir <- "~/work/coursera"

setwd(workingDir)
## Download and unzip the dataset:
if (!file.exists(zipFile)){
  download.file(fileURL, zipFile, method="curl")
}
#if zipFile hasn't been unzipped, then unzip. Uses the files name as folder name
if (!file.exists(zipFolder)) {
  unzip(zipFile)
}
print("Data Folder Ready")

#############################################################################
# Step 0 - Read data from files
##############################################################################

# read activity labels
activities <- read.table(file.path(dataFolder, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")
print("Activities Loaded")

# read features, don't convert text labels to factors
features <- read.table(file.path(dataFolder, "features.txt"), as.is = TRUE)
print("Features Loaded")
## note: feature names (in features[, 2]) are not unique
##       e.g. fBodyAcc-bandsEnergy()-1,8

# read training data
trainingSubjects <- read.table(file.path(dataFolder, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataFolder, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(dataFolder, "train", "y_train.txt"))
print("Training Data Loaded")

# read test data
testSubjects <- read.table(file.path(dataFolder, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataFolder, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataFolder, "test", "y_test.txt"))
print("Test Data Loaded")


# merge and combine data to have one set

# concatenate individual data tables to make single data table
combinedData <- rbind(
  cbind(trainingSubjects, trainingValues, trainingActivity),
  cbind(testSubjects, testValues, testActivity)
)

# remove individual data tables to save memory
rm(trainingSubjects, trainingValues, trainingActivity,
   testSubjects, testValues, testActivity)

# assign column names
colnames(combinedData) <- c("subject", features[, 2], "activity")
print("Combined Data Ready")

#get mean and standard dev

# determine columns of data set to keep based on column name...
columnsToKeep <- grepl("subject|activity|mean|std", colnames(combinedData))

# ... and keep data in these columns only
combinedData <- combinedData[, columnsToKeep]


#set descriptive activity labels
combinedData$activity <- factor(combinedData$activity,
                                 levels = activities[, 1], labels = activities[, 2])

# set labels

# get column names
combinedDataCols <- colnames(combinedData)

# remove special characters
combinedDataCols <- gsub("[\\(\\)-]", "", combinedDataCols)

# expand abbreviations and clean up names
combinedDataCols <- gsub("^f", "frequencyDomain", combinedDataCols)
combinedDataCols <- gsub("^t", "timeDomain", combinedDataCols)
combinedDataCols <- gsub("Acc", "Accelerometer", combinedDataCols)
combinedDataCols <- gsub("Gyro", "Gyroscope", combinedDataCols)
combinedDataCols <- gsub("Mag", "Magnitude", combinedDataCols)
combinedDataCols <- gsub("Freq", "Frequency", combinedDataCols)
combinedDataCols <- gsub("mean", "Mean", combinedDataCols)
combinedDataCols <- gsub("std", "StandardDeviation", combinedDataCols)

# correct typo
combinedDataCols <- gsub("BodyBody", "Body", combinedDataCols)

# use new labels as column names
colnames(combinedData) <- combinedDataCols

# group and save file

# group by subject and activity and summarise using mean
combinedDataMeans <- combinedData %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# output to file "tidy_data.txt"
write.table(combinedDataMeans,tidyFile , row.names = FALSE,
            quote = FALSE)

message("Tidy data file created:")
print(tidyFile)
