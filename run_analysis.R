## 1. download file
if(!file.exists("./data")) dir.create("./data")
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,"./data/assignment.zip")
zip<-unzip("./data/assignment.zip",exdir = "./data")

## 2. read data set
train.x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
test.x<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.y<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
test.subject<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")

## 3. merge
train<-cbind(train.subject,train.y,train.x)
test<-cbind(test.subject,test.y,test.x)
data<-rbind(train,test)

## 4. extract mean and standard deviation of each measurements
feature <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
feature<-feature[,2]
featuregrep<-grep(("mean\\(\\)|std\\(\\)"),feature)
featuregrepname<-grep(("mean\\(\\)|std\\(\\)"),feature,value=TRUE)
finaldata<-data[,c(1,2,featuregrep+2)]
colnames(finaldata)<-c("subject", "activity", featuregrepname)

## 5. Uses descriptive activity names to name the activities in the data set
activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
finaldata$activity <- factor(finaldata$activity, levels = activityName[,1], labels = activityName[,2])

## 6. Appropriately labels the data set with descriptive variable names
names(finaldata)<-gsub("\\(\\)","",names(finaldata))
names(finaldata)<-gsub("-","",names(finaldata))
names(finaldata)<-gsub("^t","time",names(finaldata))
names(finaldata)<-gsub("^f","frequency",names(finaldata))
names(finaldata)<-gsub("mean","Mean",names(finaldata))
names(finaldata)<-gsub("std","Std",names(finaldata))

## 7. creates a second, independent tidy data set
library(dplyr)
finaldata2<-finaldata
finaldata2<-group_by(finaldata2,subject,activity)
finaldata2<-summarize_all(finaldata2,mean)
write.table(finaldata2, "./mean.txt", row.names = FALSE)
