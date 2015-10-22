#setwd("c:/Data Mining Class/Get")
library(plyr)
#Step 0: download and uzip the file

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("dataset.zip")){
  download.file(fileurl,"dataset.zip")
  unzip("dataset.zip")
  }

#Step 1: Merges the training and the test sets to create one data set.

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_merged <- rbind(subject_test,subject_train)
x_merged <- rbind(x_test,x_train)
y_merged <- rbind(y_test,y_train)

#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("./UCI HAR Dataset/features.txt")
features_meanstd <- grep("-(mean|std)\\(\\)",features[,2])

x_meanstd <- x_merged[, features_meanstd]


#Step 3: Uses descriptive activity names to name the activities in the data set

actvities <- read.table("./UCI HAR Dataset/activity_labels.txt")
y_merged[,1] <- actvities[y_merged[,1],2]
names(y_merged) <- "activity"


#step 4: Appropriately labels the data set with descriptive variable names 
names(x_meanstd) <- features[features_meanstd,2]
names(y_merged) <- "activity"
names(subject_merged) <- "subject"

#Step 5: From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject
result <- cbind(x_meanstd,y_merged,subject_merged)
tidyresult <- ddply(result,.(subject,activity),function(x) colMeans(x[,1:66]))
write.table(tidyresult,"tidyresult.txt")