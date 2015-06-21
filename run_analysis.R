##------------------------------------------------------------------------------------------
## run_analysis() takes the content of several input files:
## activity_labels.txt, features.txt, X_test.txt, y_test.txt, subject_test.txt, X_train.txt
## y_train.txt and subject_train.txt. 
## All of the above are available as a single zipped package from: 
##  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
## Uses: plyr package for averaging functions by grouping.
##
## Assumptions:
## That all of the above files are available, unzipped, in the current working directory.
##
## Purpose:
## To read in the above file set and to form their content into a meaningful and tidy data
## set.
## To label columns appropriately.
## To add further columns as required, offering meaningful activity names or types.
## To further subset the data taking only those columns with the terms std() or mean() in
## the column name.
## 
## Further:
## To take the mean value of each column and then to write those values to an output file
## while keeping the relevant column name associated with each calculated mean, grouping
## by subject and activity.
## The averaging subset will be written to an output file.
## The output file will be in .txt format and will be named TW_TidyDataSet.txt
## The subset will also be returned by the function.
##
## To run:
## Ensure that all required files are in the current working directory.
## Source this script "run_analysis.R"
## evoke the run_analysis() function.
## Example: myData<-run_analysis()
##------------------------------------------------------------------------------------------
library(plyr)               ## required library
run_analysis<-function(){
    ## read all the files in first...
      print("reading data...")
    activityLabels<-read.table("activity_labels.txt",stringsAsFactors=FALSE)[,2] ## read the activity labels
    features<-read.table("features.txt",stringsAsFactors=FALSE)[,2]              ## read the column labels (features)
      print("     test data...")
    xtest<-read.table("X_test.txt")     ## read the test data vars
    ytest<-read.table("y_test.txt")     ## read the y axis activity indeces for the test set
    subjectsTest<-read.table("subject_test.txt")    ## read the subject identifiers for the test set
      print("     training data...")
    xtrain<-read.table("X_train.txt") ## read the train data vars
    ytrain<-read.table("y_train.txt") ## read the y axis activity indeces for the training set
    subjectsTrain<-read.table("subject_train.txt")  ## read the subject identifiers for the training set
    ##
      print("Labelling data sets...")
    ## label the xtest set...
    colnames(xtest)<-features           ## add the feature column names first
    Activity <- ytest[,1]               ## get the activity identifiers for the test data set
    Activity_Type<-activityLabels[ytest[,1]]  ## make a vector of activity types using ytest as an index        
    Subject <- subjectsTest[,1]         ## get the subject identifiers to the test data set
   ## xtest<-cbind(Activity_Type,xtest)   ## add the activity type as a new column on the left
    xtest<-cbind(Activity,xtest)        ## add the activity index as a new column on the left
    xtest<-cbind(Subject,xtest)         ## add the subject index as a new column on the left
    ## label the xtrain set...
    colnames(xtrain)<-features          ## add the feature column names first
    Activity <- ytrain[,1]              ## get the activity identifiers for the train data set 
    Activity_Type<-activityLabels[ytrain[,1]] ## make a vector of activity types using ytrain as an index
    Subject <- subjectsTrain[,1]        ## get the subject identifiers to the train data set
    ##xtrain<-cbind(Activity_Type,xtrain) ## add the activity type as a new column on the left
    xtrain<-cbind(Activity,xtrain)      ## add the activity index as a new column on the left
    xtrain<-cbind(Subject,xtrain)       ## add the subject index as a new column on the left
    
    ## The test and train data sets should now have identical structures
    ## though of different lengths. So okay to merge...
    
      print("merging data sets...")
    fullDataSet<-rbind(xtest,xtrain) ## merge the test and training data sets together                                     
    ##
      print("Subsetting for Stds and Means...") ## part 1 finished - now to subset the means and stds...
    ##
    ## using a regular expression: (https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html)
    ## to identify the Std and Mean column headers...
    ##
    StdAndMeanColumns <- grep("Activity|Subject|*mean()|*std()", colnames(fullDataSet))  
    ##
    StdAndMeanSet<-fullDataSet[,StdAndMeanColumns] ## subset the full data by the required cols
    ##
      print("Applying averages...")
    StdAndMeanAverages <- ddply(StdAndMeanSet, .(Activity,Subject), colMeans)
      print("Adding activity labels...")
    ## label the averaged data set first
    ActivityType<-activityLabels[StdAndMeanAverages[,2]]      ## create a column of activity types
    StdAndMeanAverages<-cbind(ActivityType,StdAndMeanAverages)## add it to the front of the
    ##                                                        ## data set as a new column.
    ## Now label the initial tidy data set 
    ActivityType<-activityLabels[StdAndMeanSet[,2]]           ## create a column of activity types
    StdAndMeanSet<-cbind(ActivityType,StdAndMeanSet)          ## add it to the front of the
    ##                                                        ## data set as a new column.
    ##
      print("Writing the averaged Stds and Means data set to TW_TidyDataSet.txt")
    write.table(StdAndMeanAverages,file="TW_TidyDataSet.txt",row.names=FALSE)
      print("Done... Output files will be in your working directory.")
    StdAndMeanAverages     ## this table will be returned by the function.
}## end of run_analysis