## Description of the variables and the logic to clean the Data
1. Download the zip file from the url
  1. datSetFileUrl - Is a variable that points to the url from where the zip file is downloaded
2. Extract the downloaded file 
3. This automatically extacts the contents into the folder - 'UCI HAR Dataset' which is used as source path to read the various files needed for transforming and cleaning the data.
4. Reads the test and training data from the respective directory for the subject, labels and the variable data into the following variables
  1. trainingSubjectDt - A data table that stores the subjects training data
  2. testingSubjectDt  - A data table that stores the subjects test data
  3. trainingLabelsDt  - A data table that stores the activity id for the training data
  4. testingLabelsDt  -  A data table that stores the activity id for the test data
  5. trainingVariablesDt - A data table that stores the values for the 561 feature varibles for the training data
  6. testingVariablesDt - A data table that stores the values for the 561 feature varibles for the test data
  7. featuresDt - A data table that contains the feature variable names that will later be assigned to the respective columns of the merged training and testing variable data.
  8. activityNamesDt - A data table that contains the activity id and activity name.
  9. mergedSubjectDt <- A data table that is a merged version of the training and testing subject data
  10. mergedLabelsDt <- A data table that is a merged version of the training and testing activity id data
  11. mergedVariablesDt <- A data table that is a merged version of the training and testing variables.
5. After the data are read from the files, descriptive columns names are assigned to each of the above data tables
6. As specified in item 2 of the instruction the following code , Extracts only the measurements on the mean and standard deviation for each measurement.
    ```
        mergedVariablesDt<-setData[grepl("mean\\(\\)|std\\(\\)", colnames(mergedVariablesDt))]
    ```
7. All the subject, activity and variable data are merged into one big data set using the code below
	```
		mergedVariablesDt <- cbind(mergedSubjectDt, mergedLabelsDt, mergedVariablesDt)
	```
8. As specified in  item 3 of the instruction the following code, assigns descriptive activity names to name the activities in the data set
	```
		mergedVariablesDt$activity <- activityNamesDt[mergedVariablesDt$activity, "activityName"]
	```
9. The gsub function is then used to substitute the column / variable names from the above data set to a more descriptive cleaner names to statisfy the item 4 in the instruction.
10. The data obtained from step 9 is then written out to a text file - 'activity_mean_sd_data.txt'
11. The aggreagate function is used to group the data above by the subject and activity name and the mean of the all the extacted variables are caluclated
	```
		tidyVariablesDt <- aggregate(mergedVariablesDt, by=list(mergedVariablesDt$subjectId, mergedVariablesDt$activity), FUN=mean)
	```
12. Finally the data obtained from the above process is written out to a text file -'tidy_data.txt', after removing the NA columns and then renaming the group id columns.

