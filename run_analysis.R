#  run_analysis.R

# as long as the Samsung data is in your working directory
# this script should work
# I use this command to set my work dir --> setwd("/opt/cleaningdata/UCI HAR Dataset/")

# Merge the training and the test sets to create one data set.

# read train files
trainF1 <- "train/subject_train.txt"
trainF2 <- "train/X_train.txt"
trainF3 <- "train/y_train.txt"

trainD1 <- read.csv(trainF1,header=FALSE)
trainD2 <- read.csv(trainF2,header=FALSE,sep="")
trainD3 <- read.csv(trainF3,header=FALSE)

# column bind the three components 
train <- cbind(trainD1, trainD2, trainD3)

# read test files
testF1 <- "test/subject_test.txt"
testF2 <- "test/X_test.txt"
testF3 <- "test/y_test.txt"

testF1 <- read.csv(testF1,header=FALSE)
testF2 <- read.csv(testF2,header=FALSE,sep="")
testF3 <- read.csv(testF3,header=FALSE)

# column bind the three components 
test <- cbind(testF1, testF2, testF3)

# row bind train and test
traintest <- rbind(train, test)


# Extracts only the measurements on the mean and standard deviation for each measurement. 
features  <- read.csv("features.txt", header=FALSE, sep="")
features$V2 <- as.character( features$V2 ) # feature names are strings
features$V2 <- gsub("\\(", "", features$V2) # remove '(' from names
features$V2 <- gsub("\\)", "", features$V2) # remove ')' from names
namesF <- features$V2[grep("mean|std", features$V2)] # I only want columns that have something to do with mean and std
extraction <- grepl("mean|std", features$V2) # calculate the indices of that mean or std columns
extraction <- c(TRUE, extraction, TRUE) # add first column (subject) and last columns (activity) to the extraction 
extractionF <- traintest[,extraction] # extract!
names(extractionF) <- c("subject",namesF,"activity") # rename first and last columns
extractionDF = as.data.frame(do.call(cbind, extractionF)) # first convert the extraction list to a data frame, in order to be able to export it using write.csv function
write.csv(extractionDF,file="extraction.txt",row.names=FALSE) # export it to extraction.txt (using csv structure)

# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive activity names. 

names(traintest) <-  c("subject",features$V2,"activity")  # rename traintest column names to something more semantic

activityLabelsF <- "activity_labels.txt" # the activity names are already written in this file
activityLabels <- read.csv(activityLabelsF,header=FALSE,sep="") # read activity labels
names(activityLabels) <- c("id","description") # rename columns
mergedData = merge(traintest,activityLabels,by.x="activity",by.y="id",all=TRUE) # merge by activity ID
# reorder activity column name , I want to have the activity name as the las column
col_idx <- grep("activity", names(mergedData))
mergedData <- mergedData[,c((1:ncol(mergedData))[-col_idx],col_idx)]

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
dataColumns <- features$V2  
groupColumns = c("subject","activity")
res = ddply(traintest, groupColumns, function(x) colMeans(x[dataColumns])) # I have decided that the exercise asks to summarize all the columns values to get their means
tidy = as.data.frame(do.call(cbind, res)) # as before, have to convert the list to a data frame so we can write it using write.csv
write.csv(tidy,file="tidy.txt",row.names=FALSE) # final tidy file
