# Readme.md file
Repository for final project of Coursera Getting and Cleaning Data course.
Nov. 2017, Rag.R

#Description of the project, data cleaning, and output
Repository for final project of Coursera Getting and Cleaning Data course. (Nov 2017)

#What is the project about:

(content from: course site)

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The R file in this repo, `run_analysis.R`, does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

This repo contains the following:

- `README.md` - this file. Provides overview and basic instructions.
- `run_analysis.R` - the R script that was used to create the data set as described in [Creating the data set](#creating-data-set) below
- `tidy_data.txt`-  the output data set created by running the R script in this repo: `run_analysis.R`
- `CodeBook.md` - required CodeBook describing the data and transformation.



For info on the study and the source data, please review:

[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)


## Creating the output data set <a name="creating-data-set"></a>

The R script `run_analysis.R` is used to create the output data set. Data loading, transformation, and output steps are as follows:

- Clear all variables
- Download and unzip source data if it doesn't exist.
- Delete the `tidy_data.txt` file if it exists. New one is created for each run.
- Load the training, and test data.
- Join the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement.
- Relabel the activity data with descriptive names/phrases.
- Create a new tidy set with the average of each variable for each activity and each subject.
- Write the data set to the `tidy_data.txt` file.
- Clear all variables

(End of README)
