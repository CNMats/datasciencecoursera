## This R script does the following:
## 0.Get the data
## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
## !The following steps are not coded in this script yet!
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names. 
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## create data folder for downloaded data
if(!file.exists("./data"))
{dir.create("./data")}

## download data and unzip the file
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/SamsungDataSet.zip")
unzip("./data/SamsungDataSet.zip")


## obtain test data and read into R
test.raw <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
## combine with subject from subject_test file & test lables from y_test file
tester.id <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
test.id <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test.data <- cbind(tester.id, test.id)
test.data <- cbind(test.data, test.raw)
## change column names
names(test.data)[1] <- "subject_id"
names(test.data)[2] <- "test_id"

## calc the mean and standard deviation par subject
test.melt <- melt(test.data, id=c("subject_id","test_id"))
test.mean <- dcast(test.melt, subject_id ~ variable, mean)
test.sd <- dcast(test.melt, subject_id ~ variable, sd)

## create summary dataset
test.summary = merge(test.mean,test.sd,all=TRUE)
test.summary <- cbind("test",test.summary)
names(test.summary)[1] <- "type"

## obtain training data and read into R
train.raw <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
## combine with subject from subject_train file & training lables from y_train file
trainee.id <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
train.id <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train.data <- cbind(trainee.id, train.id)
train.data <- cbind(train.data, train.raw)
## change column names
names(train.data)[1] <- "subject_id"
names(train.data)[2] <- "training_id"

## calc the mean and standard deviation par subject
train.melt <- melt(train.data, id=c("subject_id","training_id"))
train.mean <- dcast(train.melt, subject_id ~ variable, mean)
train.sd <- dcast(train.melt, subject_id ~ variable, sd)

## create summary dataset
train.summary = merge(train.mean,train.sd,all=TRUE)
train.summary <- cbind("train",train.summary)
names(train.summary)[1] <- "type"

## merge the test & training data by subject
mergedData = merge(test.summary, train.summary,all=TRUE)
## export as txt file for submission
write.table(mergedData,file="tidydata.txt", sep=",",col.names=TRUE, row.name=FALSE)

## end of script
