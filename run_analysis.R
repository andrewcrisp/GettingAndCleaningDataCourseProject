################################################################################
#
# Author:   			Andrew Crisp
# Filename: 			run_analysis.R
# Comments:			  
#						      This script will:
#  					      1. Merge training and test data into one data set.
#  					      2. Extract only the mean and standard deviation for each measurement.
#  					      3. Use descriptive variable names.
#  					      4. Label the data set descriptively.
#  					      5. Create a second, tidy data set with the average of each variable for each activity and subject.
#						      6. Output that tidy subset to a file, meanOfActivities.txt
#  					      
#    				      Prerequisites: dplyr
#    				      
################################################################################
################################################################################
### Imports
################################################################################

library(dplyr)

################################################################################
### Function declarations
################################################################################

read.projectFiles.numeric <- function(file, nrows) {
  read.table(
    file = file,
    header = FALSE,
    sep = "",
    colClasses = "numeric",
    nrows = nrows)
}

################################################################################
### Script Body
################################################################################
################################################################################
### Goal 0 - Get the data and metadata
################################################################################

if(!file.exists("UCI HAR Dataset")){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  destFile <- "UCIDataset.zip"
  download.file(url=fileUrl, destfile=destFile)
  unzip("UCIDataset.zip")
}

yTrain          <- read.projectFiles.numeric(file = "UCI HAR Dataset//train//y_train.txt", nrows = 7352)
subjectTrain    <- read.projectFiles.numeric(file = "UCI HAR Dataset//train//subject_train.txt", nrows = 7352)
XTrain          <- read.projectFiles.numeric(file = "UCI HAR Dataset//train//X_train.txt", nrows = 7352)
yTest           <- read.projectFiles.numeric(file= "UCI HAR Dataset//test//y_test.txt", nrows = 2947)
subjectTest     <- read.projectFiles.numeric(file = "UCI HAR Dataset//test//subject_test.txt", nrows = 2947)
XTest           <- read.projectFiles.numeric(file="UCI HAR Dataset//test//X_test.txt", nrows = 2947)

activityLabels  <- read.table(
  file = "UCI HAR Dataset//activity_labels.txt",
  header = FALSE,
  sep = "",
  nrows = 6)
features        <-read.table(
  file = "UCI HAR Dataset//features.txt",
  header = FALSE,
  sep = "",
  nrows = 561)

################################################################################
### Goal 4 - Label the data set descriptively
################################################################################

names(subjectTrain)   <- "subjectID"
names(subjectTest)    <- "subjectID"
names(yTrain)         <- "activityIndex"
names(yTest)          <- "activityIndex"
names(XTrain)         <- features[,2]
names(XTest)          <- features[,2]
names(activityLabels) <- c("activityIndex","activityName")

################################################################################
### Goal 2 - Select only mean and std data, see README.md for reasoning
################################################################################

columnFilter  <- grepl(pattern = "mean\\()|std\\()", x=features[,2])
XTrain        <- XTrain[,columnFilter]
XTest         <- XTest[,columnFilter]

################################################################################
### Goal 1 - Merge the data into a single data set
################################################################################

cleanTrain  <- cbind(subjectTrain,yTrain,XTrain)
cleanTest   <- cbind(subjectTest,yTest,XTest)
cleanData   <- bind_rows(cleanTrain,cleanTest)
cleanData   <- merge(x=activityLabels,y=cleanData,by="activityIndex")
cleanData   <- select(cleanData,-activityIndex)

names(cleanData) <- gsub(pattern = "\\()", replacement = "", names(cleanData))
names(cleanData) <- gsub(pattern = "BodyBody", replacement = "Body", names(cleanData))
names(cleanData) <- gsub(pattern = "-", replacement = ".", names(cleanData))

################################################################################
### Goal 5 - Select and mutate the data into a tidy summary of the average of
###           each subject and activity
################################################################################

meanOfActivities <- cleanData %>%
  tbl_df %>%
  group_by(subjectID,activityName) %>%
  summarise_each(funs(mean))

################################################################################
### Goal 6 - Write to file
################################################################################

write.table(meanOfActivities,file = 'meanOfActivities.txt',row.name=FALSE)
