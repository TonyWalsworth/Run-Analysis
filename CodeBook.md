This document describes the process, variables and functions used by the enclosed run_analysis R code.

The project brief doesn't make clear whether the data files used have to be downloaded by the run_analysis code so it 
has been assumed that all data will be present, unzipped, in the working directory before the code is invoked.

Stage 1 - Creating a tidy data set.
There are four basic processes involved:

1) reading the text files into data tables, using read.table:
    Files:activity_labels.txt, features.txt, X_test.txt, y_test.txt, subject_test.txt, X_train.txt,
          y_train.txt and subject_train.txt.
    Tables and vectors:      
    Vector: activityLabels  <- activity_labels.txt (the activity descriptions; Walking, lying etc.)
    Vector: features <- features.txt (column names for the variables in the data sets.)
    Table: xtest <- X_test.txt (The test data set)
    Table: ytest<- y_test.txt (The y axis activity indeces for the test set)
    Table: subjectsTest <- subject_test.txt (The subjects identifiers ints for the test data set)
    Table: xtrain <- X_train.txt (The train data set)
    Table: ytrain <- y_train.txt (The y axis activity indeces for the training set)
    Table: subjectsTrain <- subject_train.txt (The subjects identifiers ints for the train data set)
    
2)  Labelling each data set:
    There are 2 data sets here (test and train) which will need to be recomposed and then merged into 1.
    For each data set...(using code snippets as examples)
    
    colnames(xtest)<-features           (create a vector of column names from the features data)
    Activity <- ytest[,1]               (create a vector of activity indicators from the yaxis data)
    Activity_Type<-activityLabels[ytest[,1]] (create a vector of activity types from activityLabels
                                              using ytest as an index)        
    Subject <- subjectsTest[,1]         (create a vector of subject identifiers)
    xtest<-cbind(Activity,xtest)        (bind the activity index as a new column on the left)
    xtest<-cbind(Subject,xtest)         (bind the subject index as a new column on the left)
    
    Repeating the above with the train data set will result in two identically structured data
    sets although of differing lengths (the train data set is much longer).
    
3)  Merge the data sets together:
    fullDataSet<-rbind(xtest,xtrain) (produces one large dataset)
    
4)  Subsetting the complete data set:
    StdAndMeanColumns <- grep("Activity|Subject|*mean()|*std()", colnames(fullDataSet))  
      (identify those columns with Activity, Subject, Mean or Std content in the column name and create
      an index vector)
                        
    StdAndMeanSet<-fullDataSet[,StdAndMeanColumns]
      Subset the complete data set based on the index vector) 
    
The above results in a basic tidy data set (named StdAndMeanSet) which thus far still requires the activity 
labels to be added.
The labels will be added before the data set is written to file since further processing is required for
stage 2 and any character values will get in the way. 

Stage 2 - Averaging the column data.
This involves creating a new data set called StdAndMeanAverages containing the column means of the StdAndMeanSet
grouped by Activity and Subject columns:

    StdAndMeanAverages <- ddply(StdAndMeanSet, .(Activity,Subject), colMeans)
    
    The above snippet uses the ddply function of the plyr library to do the work.
    
 Stage 3 - Labelling the data sets.
 
 Both data sets (StdAndMeanSet and StdAndMeanAverages) now have to be given descriptive activity labels:

    ActivityType<-activityLabels[StdAndMeanAverages[,2]]       (create a vector of activity types)
    StdAndMeanAverages<-cbind(ActivityType,StdAndMeanAverages) (bind it to the front of the data set as a new column.)
    
    ActivityType<-activityLabels[StdAndMeanSet[,2]]            (create a vector of activity types
    StdAndMeanSet<-cbind(ActivityType,StdAndMeanSet)           ( bind it to the front of the data set as a new column.
    
  Stage 4 - Writing the output.
       
    write.table(StdAndMeanAverages,file="TW_TidyDataSet.txt",row.names=FALSE) (write the StdAndMeanAverages data set
                                                                               to a text file TW_TidyDataSet.txt)
                                                                               
    StdAndMeanAverages     (Also, return the table as a result of the function)
