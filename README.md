This readme is meant for explaining how  the run_analysis.R works

#**************************************************#
#MODULE 3: Getting and Cleaning Data Course Project	           
#Author: Fatimah Almah Saaid                       		           
#Date: 13 Oct 2016					           
#**************************************************#

Create one R script called run_analysis.R that does the following.
q1.	Merges the training and the test sets to create one data set.
q2.	Extracts only the measurements on the mean and standard deviation for each measurement.
q3.	Uses descriptive activity names to name the activities in the data set
q4.	Appropriately labels the data set with descriptive variable names.
q5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In a whole, the Project submission should be:
1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis, and 
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md


# Set the project’s working directory – where you save the UCI dataset
#check the files the folder

#Read table from Activity files
Y.train <- read.table(file.path(uci.filepath , "train", "Y_train.txt"),header = FALSE)
Y.test  <- read.table(file.path(uci.filepath , "test" , "Y_test.txt" ),header = FALSE)

# Read table from  Subject files
subject.train <- read.table(file.path(uci.filepath , "train", "subject_train.txt"),header = FALSE)
subject.test  <- read.table(file.path(uci.filepath , "test" , "subject_test.txt"),header = FALSE)

# Read table from Feature files
X.train <- read.table(file.path(uci.filepath , "train", "X_train.txt"),header = FALSE)
X.test  <- read.table(file.path(uci.filepath , "test" , "X_test.txt" ),header = FALSE)

#******************************************#
#Q1. Merge the TEST and TRAINING datasets              #
#   and create one dataset                 		        #
#******************************************#

#get the data from the .txt files given and combine based on their respective subject area 

#give names to respective df

#get names from text file provided from the installed UCI folder in local computer

#grab the 2nd variable (consists of names) and apply to features data

#checking the df’s dimension or some part of the rows/columns 
#scientist needs to understand the data structure & etc.

#combining df into one dataset

#checking the data properties to ensure that the df are all merged at one dataset

#****************************done for q1***********************************#


#******************************************#
#Q2. Extracts only the measurements on the 	        
#    mean and SD for each measurement.     	        
#******************************************#

#just grab the mean and SD variables using grep 

#then check whether it is correct that the names grabbed are mean and SD only

#again, check the new df dimension of the dataset

#****************************done for q2***********************************#

#*******************************************#
#Q3. Use descriptive activity names to name 	          
#    the activities in the data set.        		          
#*******************************************#

#grab the activity names from text file installed in UCI folder in local computer

#check the names

#factorize the variables

#then check the df properties
  
 # check the data, to see how it looks like

#****************************done for q3***********************************#

#*******************************************#
#Q4. Appropriately labels the data set with 	          
#    descriptive variable names.            		          
#*******************************************#

#check first the column names to see the acronyms used.
names(combined.all.new)
# from the output in console, I found serveral acronyms used like "tGravityAcc-std()-X"
# "fBodyAcc-std()-Y", "fBodyBodyGyroJerkMag-mean()" & etc.
# ...so I can change some of them like "t", "f", "Acc", "Gyro" & etc. with meaningful ones.
# Note1: I refer to features_info.txt for all these names; I can't find what "Jerk" stands for.
# Note2: I believe "fBodyBodyGyroJerkMag-mean()" could be wrongly labelled with double "Body" 
#       so it's renamed with single "Body".

#rename all of the identified labels with appropriate ones using gsub

#check the names again

#****************************done for q4***********************************#


#*******************************************#
#Q5. Creates a second, independent tidy     	         
#    data set and ouput it.                 		          
#*******************************************#

# create a tidy data set using melt

# write the tidy data set to a file
write.csv(tidy.combined, "tidydata_combined.csv", row.names=FALSE)

#---------------------------------------------------------#
#codebook as per required…
#knit2html("codebook.Rmd")
#---------------------------------------------------------#

#****************************done for q5***********************************#
