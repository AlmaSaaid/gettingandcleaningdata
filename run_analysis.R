#**************************************************#
#MODULE 3: Getting and Cleaning Data Course Project#
#Author: Fatimah Almah Saaid                       #
#Date: 06 Oct 2016
#**************************************************#


#----------------------#
#A. Data pre-processing
#----------------------#
#call respective libraries
library(RCurl)
library(reshape2)
library(downloader)
library(plyr)
library(knitr)

#My own note for the project working directory!
#"C:/Users/tm35082/Desktop/New files/Cousera/Week4"

uci.filepath <- file.path("./data" , "UCI HAR Dataset")
uci.datafile <- list.files(uci.filepath, recursive=TRUE)

#checking...
uci.datafile

#Activity files
Y.train <- read.table(file.path(uci.filepath , "train", "Y_train.txt"),header = FALSE)
Y.test  <- read.table(file.path(uci.filepath , "test" , "Y_test.txt" ),header = FALSE)

#Subject files
subject.train <- read.table(file.path(uci.filepath , "train", "subject_train.txt"),header = FALSE)
subject.test  <- read.table(file.path(uci.filepath , "test" , "subject_test.txt"),header = FALSE)

#Feature files
X.train <- read.table(file.path(uci.filepath , "train", "X_train.txt"),header = FALSE)
X.test  <- read.table(file.path(uci.filepath , "test" , "X_test.txt" ),header = FALSE)

#******************************************#
#Q1. Merge the TEST and TRAINING datasets  #
#   and create one dataset                 #
#******************************************#

#get the data from the .txt files given and combine
#based on their respective subject area 
subject.data <- rbind(subject.train, subject.test)
activity.y <- rbind(Y.train , Y.test)
features.x <- rbind(X.train, X.test)

#give names to respective df
names(subject.data)<-c("subject")
names(activity.y)<- c("activity")

#get names from text file provided from the installed UCI folder in local computer
features.name <- read.table("data/UCI HAR Dataset/features.txt",head=FALSE)
#grab the 2nd variable (consists of names) and apply to features data
names(features.x)<- features.name$V2

#checking...
#> dim(features.x)
#[1] 10299   561

#again, checking..
#> features.x[1,1:5]
#tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X
#1         0.2885845       -0.02029417        -0.1329051       -0.9952786
#...meaning features data is having 10,299 rows and 561 variables
#with names assigned for each variable

#combining df into one dataset
subject.activity.combined <- cbind(subject.data, activity.y)
combined.all <- cbind(features.x, subject.activity.combined)

#checking...
str(combined.all)
dim(combined.all)
#> dim(combined.all)
#[1] 10299   563
# subject and activity variables are merged

#again, checking...
#> combined.all[1,561:563]
#  angle(Z,gravityMean) subject activity
#1          -0.05862692       1        5
# I checked the last three columns and here they are...

#****************************done for q1***********************************#

#******************************************#
#Q2. Extracts only the measurements on the #
#    mean and SD for each measurement.     #
#******************************************#

#just grab the mean and SD variables
features.mean.sd <-features.name$V2[grep("mean\\(\\)|std\\(\\)", features.name$V2)]
combined.subset <-c(as.character(features.mean.sd), "subject", "activity" )
combined.all.new <- subset(combined.all, select = combined.subset)

#checking whether it is correct that the names grabbed are mean and SD only
combined.subset 
#checked and correct

#again, check the new df dimension
dim(combined.all.new)
#> dim(combined.all.new)
#[1] 10299    68
#meaning mean and SD data consist of 66 columns only plus another 2 columns 
# i.e.subject & activity columns

#and check a sample data from column 65 to 68 
combined.all.new[1,65:68]
#> combined.all.new[1,65:68]
#fBodyBodyGyroJerkMag-mean() fBodyBodyGyroJerkMag-std() subject activity
#1                  -0.9919904                 -0.9906975       1        5
# it shows the first row only...

#****************************done for q2***********************************#

#*******************************************#
#Q3. Use descriptive activity names to name #
#    the activities in the data set.        #
#*******************************************#

#grab the activity names from text file intalled in UCI folder in local computer
activity.name <- read.table("data/UCI HAR Dataset/activity_labels.txt",header = FALSE)

#checking...
activity.name
#this is how it looks like...
#> activity.name
#  V1                 V2
#1  1            WALKING
#2  2   WALKING_UPSTAIRS
#3  3 WALKING_DOWNSTAIRS
#4  4            SITTING
#5  5           STANDING
#6  6             LAYING
#...so we have six levels here

#factorize the variables
combined.all.new$activity <- factor(combined.all.new$activity,
                    labels=c("WALKING", "WALKING_UPSTAIRS",
                    "WALKING_DOWNSTAIRS","SITTING",
                    "STANDING","LAYING"))

#checking the df properties
str(combined.all.new)
#> str(combined.all.new)
# 'data.frame':  10299 obs. of  68 variables:
# then if you scroll down the console, here is what you see:
#$ subject                    : int  1 1 1 1 1 1 1 1 1 1 ...
#$ activity                   : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 5 5 5 5 5 5 5 5 5 5 ...
#...so activity column had been factorized correctly  
  
  
#checking the data...
combined.all.new[1:5,66:68]
#> combined.all.new[1:5,66:68]
# fBodyBodyGyroJerkMag-std() subject activity
#1                 -0.9906975       1 STANDING
#2                 -0.9963995       1 STANDING
#3                 -0.9951274       1 STANDING
#4                 -0.9952369       1 STANDING
#5                 -0.9954648       1 STANDING

#****************************done for q3***********************************#

#*******************************************#
#Q4. Appropriately labels the data set with #
#    descriptive variable names.            #
#*******************************************#

#check first the column names
names(combined.all.new)
# from the output in console, we found serveral acronyms used like "tGravityAcc-std()-X"
# "fBodyAcc-std()-Y", "fBodyBodyGyroJerkMag-mean()" & etc.
# ...so"we can change some of them like "t", "f", "Acc", "Gyro" & etc. with meaningful ones.
# Note1: I refer to features_info.txt for all these names; I can't find what "Jerk" stands for.
# Note2: I believe "fBodyBodyGyroJerkMag-mean()" could be wrongly labelled with double "Body" 
#       so it's renamed with single "Body".

#rename all of the identified labels with appropriate ones 
names(combined.all.new)<-gsub("Gyro", "Gyroscope", names(combined.all.new))
names(combined.all.new)<-gsub("Acc", "Accelerometer", names(combined.all.new))
names(combined.all.new)<-gsub("Mag", "Magnitude", names(combined.all.new))
names(combined.all.new)<-gsub("^t", "time", names(combined.all.new))
names(combined.all.new)<-gsub("^f", "frequency", names(combined.all.new))
names(combined.all.new)<-gsub("BodyBody", "Body", names(combined.all.new))

#checking...
names(combined.all.new)
# all seems good with appropriate and meaningful labels


#****************************done for q4***********************************#

#*******************************************#
#Q5. Creates a second, independent tidy     #
#    data set and ouput it.                 #
#*******************************************#


# create a tidy data set
melted.combined <- melt(combined.all.new, id=c("subject","activity"))
tidy.combined <- dcast(melted.combined, subject + activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy.combined, "tidydata_combined.csv", row.names=FALSE)

#****************************done for q5***********************************#

#---------------------------------------------------------#
#R markdown to create codebook as required
knit2html("CodeBook.Rmd")

#---------------------------------------------------------#
