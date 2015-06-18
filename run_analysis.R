library(dplyr)
library(foreach)

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

meanOfActivities <- cleanData %>%
  tbl_df %>%
  group_by(subjectID,activityName) %>%
  summarise_each(funs(mean))

#melted<-melt(cleanData,id=c("subjectID","activityIndex","activityName"))

#meanOfActivities<-foreach(i=1:length(unique(melted$subjectID)), .combine = rbind) %do% {
#  c(subjectID=i,tapply(melted[melted$subjectID==i,"value"],melted[melted$subjectID==i,"activityName"],mean))
#}

