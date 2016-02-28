## Download the file from the url and unzip it
datSetFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(datSetFileUrl,"Dataset.zip")
unzip("Dataset.zip")
message("Dataset download and extraction - DONE.")

##Read the training and the test sets into a data table.
message("Reading training and test sets into the data tables . . .")
trainingSubjectDt <-  read.table("UCI HAR Dataset/train/subject_train.txt")
testingSubjectDt <-  read.table("UCI HAR Dataset/test/subject_test.txt")

trainingLabelsDt <-  read.table("UCI HAR Dataset/train/Y_train.txt")
testingLabelsDt <-  read.table("UCI HAR Dataset/test/Y_test.txt")

trainingVariablesDt <- read.table("UCI HAR Dataset/train/X_train.txt")
testingVariablesDt <- read.table("UCI HAR Dataset/test/X_test.txt")
message("Read the training and test data for the subject, labels and variables into data tables - DONE.")


##Read the variable names into a table from 'features.txt'
featuresDt <- read.table("UCI HAR Dataset/features.txt")
message("Read the feature variable names  into a data table - DONE.")

##Read the Activity names into a table from 'activity_labels.txt'
activityNamesDt <- read.table("UCI HAR Dataset/activity_labels.txt")
message("Read the actvity names  into a data table - DONE.")

## Item 1 From Instruction - Merge the training and the test sets to create one data set.
mergedSubjectDt <- rbind(trainingSubjectDt, testingSubjectDt)
mergedLabelsDt <- rbind(trainingLabelsDt, testingLabelsDt)
mergedVariablesDt <- rbind(trainingVariablesDt, testingVariablesDt)
message("Merge the training and the test sets to create one data set - DONE.")

##Change the variable /column name to be more self descriptive
colnames(featuresDt) <- c("featureId","featureName")
colnames(activityNamesDt) <- c("activityId","activityName")
colnames(mergedSubjectDt) <- c("subjectId")
colnames(mergedLabelsDt) <- c("activity")
colnames(mergedVariablesDt)<-featuresDt[ ,"featureName"] ## <-To assign the feature names as the variable names.
message("Change the variable /column name to be more self descriptive - DONE.")

## Item 2 From Instruction - Extracts only the measurements on the mean and standard deviation for each measurement.
mergedVariablesDt<-setData[grepl("mean\\(\\)|std\\(\\)", colnames(mergedVariablesDt))]
message("Extract only the measurements on the mean and standard deviation for each measurement - DONE.")

## Merge the subject, label and variable data set into one
mergedVariablesDt <- cbind(mergedSubjectDt, mergedLabelsDt, mergedVariablesDt)

## Item 3 From Instruction - Use descriptive activity names to name the activities in the data set
mergedVariablesDt$activity <- activityNamesDt[mergedVariablesDt$activity, "activityName"]
message("Use descriptive activity names to name the activities in the data set - DONE.")

## Item 4 From Instruction - Appropriately labels the data set with descriptive variable names.
colnames(mergedVariablesDt) <- gsub("Acc","Accelaration",colnames(mergedVariablesDt))
colnames(mergedVariablesDt) <- gsub("Gyro","Gyroscope",colnames(mergedVariablesDt))
colnames(mergedVariablesDt) <- gsub("Mag","Magnitude",colnames(mergedVariablesDt))
colnames(mergedVariablesDt) <- gsub("mean\\(\\)","Mean",colnames(mergedVariablesDt))
colnames(mergedVariablesDt) <- gsub("std\\(\\)","StandardDeviation",colnames(mergedVariablesDt))
colnames(mergedVariablesDt) <- gsub("^t","Time-",colnames(mergedVariablesDt))
colnames(mergedVariablesDt) <- gsub("^f","Frequency-",colnames(mergedVariablesDt))
colnames(mergedVariablesDt) <- gsub("BodyBody","Body",colnames(mergedVariablesDt))
message("Appropriately label the data set with descriptive variable names - DONE.")

## Write the data back to a files 
write.table(mergedVariablesDt, "activity_mean_sd_data.txt", sep="\t", row.names = FALSE)
message("Creating 'activity_mean_sd_data.txt' - DONE.")

## Item 5 From Instruction - create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyVariablesDt <- aggregate(mergedVariablesDt, by=list(mergedVariablesDt$subjectId, mergedVariablesDt$activity), FUN=mean)
message("Generating Tidy Data - DONE.")

##Removing NA and changing the group id columns
tidyVariablesDt$activity <- NULL
tidyVariablesDt$subjectId <- NULL
names(tidyVariablesDt)[names(tidyVariablesDt) == 'Group.1'] <- 'subjectId'
names(tidyVariablesDt)[names(tidyVariablesDt) == 'Group.2'] <- 'activityName'

## Write the data back to a files 
write.table(tidyVariablesDt, "tidy_data.txt", sep="\t", row.names = FALSE)
message("Creating 'tidy_data.txt' - DONE.")