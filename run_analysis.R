library(dplyr)

read.projectFiles.numeric <- function(file, nrows) {
  read.table(
    file = file,
    header = FALSE,
    sep = "",
    colClasses = "numeric",
    nrows = nrows)
}

activityLabels <- read.table(
  file = "UCI HAR Dataset//activity_labels.txt",
  header = FALSE,
  sep = "",
  nrows = 6)
names(activityLabels) <- c("activityIndex","activityName")

features<-read.table(
  file = "UCI HAR Dataset//features.txt",
  header = FALSE,
  sep = "",
  nrows = 561)
columnFilter<-grepl(pattern = "mean\\()|std\\()", x=features[,2])

yTrain<-read.table(
  file = "UCI HAR Dataset//train//y_train.txt",
  header = FALSE, 
  sep = "", 
  colClasses = "numeric",
  nrows = 7352)
subjectTrain<-read.table(
  file = "UCI HAR Dataset//train//subject_train.txt", 
  header = FALSE,
  sep = "", 
  colClasses = "numeric", 
  nrows = 7352)
XTrain<-read.table(
  file = "UCI HAR Dataset//train//X_train.txt",
  header = FALSE,
  sep = "",
  colClasses="numeric",
  nrows = 7352)
names(subjectTrain)<-"subjectID"
names(yTrain)<-"activityIndex"
names(XTrain)<-features[,2]
XTrain<-XTrain[,columnFilter]
cleanTrain<-cbind(subjectTrain,yTrain,XTrain)

yTest<-read.table(
  file= "UCI HAR Dataset//test//y_test.txt",
  header = FALSE,
  sep="",
  colClasses="numeric",
  nrows = 2947)
subjectTest<-read.table(
  file = "UCI HAR Dataset//test//subject_test.txt",
  header = FALSE,
  sep = "",
  colClasses="numeric",
  nrows = 2947)
XTest<-read.table(
  file="UCI HAR Dataset//test//X_test.txt",
  header = FALSE,
  sep= "",
  colClasses="numeric",
  nrows = 2947)
names(subjectTest)<-"subjectID"
names(yTest)<-"activityIndex"
names(XTest)<-features[,2]
XTest<-XTest[,columnFilter]
cleanTest<-cbind(subjectTest,yTest,XTest)

cleanData<-rbind(cleanTrain,cleanTest)
cleanData<-merge(x=activityLabels,y=cleanData,by="activityIndex")
cleanData<-select(cleanData,-activityIndex)

meanOfActivities <- cleanData %>%
  tbl_df %>%
  group_by(subjectID,activityName) %>%
  summarise_each(funs(mean))

write.table(meanOfActivities,file = 'meanOfActivities.txt',row.name=FALSE)
