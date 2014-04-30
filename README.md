## Getting and Cleaning Data Project
* Download and unzip the [data set]( https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip )
* Set working directory to this folder in R-Studio.
* Run run_analysis.R in R-Studio
 
Returns one data set by reading and merging all component files.
 Data set comprises of the X values, Y values and Subject IDs.
 The path_prefix indicates the path where the data files can be found.
The fname_suffix indicates the file name suffix to be used to create the complete file name.

## About
 
A simple R script to merge, clean, and summarize the [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) data set.

Written for the April 2014 [Getting and Cleaning Data](https://class.coursera.org/getdata-002) course offered by Johns Hopkins University through [Coursera](http://www.coursera.org).


## Usage

1. Get run_analysis.R on your local machine using whatever method suits you.
1. In R, set your working directory to the directory that contains run_analysis.R.
1. [Download the data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
1. Extract the "UCI HAR Dataset" directory into the same directory as run\_analysis.R.
  - Your working directory should contain both **run\_analysis.R** and the **UCI HAR Dataset** directory.
1. Execute the script from the R command line with `source("run_analysis.R")`

## Outputs and Variables
- `mergedData` - A data.table containing the merged and cleaned data set.
- `tidyData` - A data.table with the average (mean) value of the mean and standard deviation of each measurement, for each subject and activity.
- `tidy.txt` - A text file containing tidyData.

## Details

The script performs the steps below to produce a tidy data set with the mean of each std() and mean() feature for each activity and subject, and writes that to the file tidy.txt.

After running, the merged data can be referenced through the `mergedData` variable, and the summary data through the `tidyData` variable, both of which are of type data.table.

#### Merging the data into mergedData

1. Combines the training and test feature (X\_train.txt and X\_text.txt) data from the UCI HAR Dataset directory into one data.table, `mergedData`.
  - The Inertial Signals data is not used.
1. Applies the names in features.txt to the columns of `mergedData`.
1. Discards the columns that do not contain **mean()** and **std()** in their name.
  - **Note: meanFreq() columns are not kept.**
1. Adds two columns to `mergedData`
  1. activity - from y\_train.txt and y\_test.txt files. 
  1. subject.id - subject\_train.txt and subject\_test.txt files.
1. Replaces the activity column values with the corresponding labels defined in activity_labels.txt.

#### Creating a tidy summary data set

1. Melts `mergedData` using the activity and subject.id columns for id variables.
1. Casts the molten data, by activity and subject.id, using mean as the aggregate function. The result of this cast operation is stored in the data.table variable `tidyData`.
1. Writes the cast summary data to tidy.txt in the current working directory.


