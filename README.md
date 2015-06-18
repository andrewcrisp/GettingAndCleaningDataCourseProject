# GettingAndCleaningDataCourseProject #

## Files ##

run_analysis.R - The single R script to download and process the data.
README.md - A description of the project and goals.
CODEBOOK.md - A listing of the variable names in the output data.
UCI HAR Dataset/ - The original data, associated metadata, readme, and codebook.

## Goals ##

This script will:
  1. Merge training and test data into one data set.
  2. Extract only the mean and standard deviation for each measurement.
  3. Use descriptive variable names.
  4. Label the data set descriptively.
  5. Create a second, tidy data set with the average of each variable for each activity and subject.
  6. Output that tidy subset to a file, meanOfActivities.txt

These six goals are attained out of order.  

First, we will check for and acquire the original data.  Of the original data files, eight are needed.
1. Data:
  * y_train.txt
  * subject_train.txt
  * X_train.txt
  * y_test.txt
  * subject_test.txt
  * X_text.txt
2. Metadata:
  * activity_labels.txt
  * features.txt
  
Goals - 4, 2
With the data loaded, we then assign labels and select out only the relevant information.  The labels satisfy goal 4.  Addressing goal 2, only the original observations involving mean() and std() are kept.  The five vectors from the original data that average the signals in the signal windows have been intentionally ignored.  These are observations about the measurements rather than being themselves measurements.

Goal - 1
After naming the variables, the data is combined into one wide data frame with all variables existing in each row.  Time is taken to further clean up the names and correct typos from the original data set names (specifically, "BodyBody" in a few entries).

Goal - 5
With clean data available, dplyr is utilized to group and summarize the information into the desired shape.  

Goal - 6
The data is written to file for storage and transmission.

Goal - 3
This goal is not found in a specific spot in the script.  Rather, throughout operations, scripting variables are chosen for readability and clarity of purpose.