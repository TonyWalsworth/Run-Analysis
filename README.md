Run-Analysis
Contains R code and codebook for the run_analysis project in the coursera data science course.
run_analysis() takes the content of several input files:
activity_labels.txt, features.txt, X_test.txt, y_test.txt, subject_test.txt, X_train.txt
y_train.txt and subject_train.txt. 
All of the above are available as a single zipped package from: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Uses: plyr package for averaging functions by grouping.

Assumptions:
That all of the above files are available, unzipped, in the current working directory.

Purpose:
To read in the above file set and to form their content into a meaningful and tidy data
set.
To label columns appropriately.
To add further columns as required, offering meaningful activity names or types.
To further subset the data taking only those columns with the terms std() or mean() in
the column name.
 
Further:
To take the mean value of each column and then to write those values to an output file
while keeping the relevant column name associated with each calculated mean, grouping
by subject and activity.
The averaging subset will be written to an output file.
The output file will be in .txt format and will be named TW_TidyDataSet.txt
The subset will also be returned by the function.

To run:
Ensure that all required files are in the current working directory.
Source this script "run_analysis.R"
evoke the run_analysis() function.
Example: myData<-run_analysis()

The entire process is goverened by one function - a detailed description is given in codebook.md
