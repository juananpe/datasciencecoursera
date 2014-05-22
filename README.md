Getting and Cleaning Data Course Project
========================================================

This scripts assumes that the  Samsung data is in your working directory

First, it merges the training and the test sets to create one data set.
For doing that, it follows these steps:

  * read train files (there are 3 components, subject+data+activityclass)
  * column bind the three components 
  * read test files
  * column bind the three components 
  * row bind train and test to generate a single traintest dataframe 

Next, itextracts only the measurements on the mean and standard deviation for each measurement. 
  
  The algorithm is as follows:
  * read features.txt (feature names are strings)
  * remove '(' and ')' from feature names
  * picks only columns that have something to do with mean and std
  * export it to extraction.txt (using csv structure)

Uses descriptive activity names to name the activities in the data set
and appropriately labels the data set with descriptive activity names. 


   * it uses activity_labels.txt for getting the activity names
   * using merge() function, it joins traintest and activityLabels by activity ID

Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

   * it uses the plyr library and its ddply function
   * to summarize all the columns values and get their means
   * as before, the result is written to a tidy.txt file (with csv structure)
   
   
