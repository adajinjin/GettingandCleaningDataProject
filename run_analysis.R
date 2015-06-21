## This is a script to solve the course project for Getting and Cleaniing data.
## Before getting into the 5 steps in the statement, downloading the files and loading data to the workspace.

setwd("/Users/yangjin84/coursera/Getting_and_Cleaning_data/GettingandCleaningDataProject")
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "Dataset.zip", method = "curl")
unzip("Dataset.zip")
xtest <- read.table(file = "./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table(file = "./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table (file = "./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(ytest,subject_test,xtest)
xtrain <- read.table(file = "./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table(file = "./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table (file = "./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(ytrain,subject_train,xtrain)
## Step 1: Merges the training and the test sets to create one data set.
total <- rbind(train,test)

## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
## Change the column names of x to the meaningful column names.(This is part of step3)
head <- read.table(file = "./UCI HAR Dataset/features.txt")
names(total) <- c("Activity", "Subject", as.character(head[,2]))


## Pick variable names containing "mean", and "std".
## Please note that dataset y doesn't cotain any column with mean or std, so dataset y is not processed here.
mean <- grep("mean",x = names(total))
std <- grep("std", x = names(total))
mean_std <- sort(c(mean,std))
total_meanstdsub <- total[,c(1,2,mean_std)]

## Step 3: Uses descriptive activity names to name the activities in the data set
total_meanstdsub$Activity <- as.factor(total_meanstdsub$Activity)
library(plyr)
total_meanstdsub$Activity <- revalue(total_meanstdsub$Activity, c("1"="Walking", 
"2"="Walking_upstairs", "3" = "Walking_downstairs","4" = "Sitting", "5" = "Standing", 
"6" = "Laying"))


## step 4 in the program statement has been done using the names(x) <- head[,2] command

## step 5: caluclate average of each activity and subject
tidy_data <- aggregate(x = total_meanstdsub[,c(-1,-2)], 
    by = list(total_meanstdsub$Activity,total_meanstdsub$Subject),FUN = "mean")
names(tidy_data)[1:2] <- c("Activity","Subject")
write.table(x = tidy_data,file = "tidydata.txt",row.names = FALSE)
