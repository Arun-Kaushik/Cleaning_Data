
#set working directory "UCI HAR Dataset", where working dataset is available
workingfile= "C://Users/KAUSHIK/Desktop/Coursera R work/UCI HAR Dataset"
setwd(workingfile)

FunRdata <- function(fname_suffix, path_prefix) {
  fpath <- file.path(path_prefix, paste0("y_", fname_suffix, ".txt"))
  y_data <- read.table(fpath, header=F, col.names=c("ActivityID"))
  
  fpath <- file.path(path_prefix, paste0("subject_", fname_suffix, ".txt"))
  subject_data <- read.table(fpath, header=F, col.names=c("SubjectID"))
  
  # read the features
  features <- read.table("features.txt", header=F, as.is=T, col.names=c("MeasureID", "MeasureName"))
  
  # read the X data file
  fpath <- file.path(path_prefix, paste0("X_", fname_suffix, ".txt"))
  data <- read.table(fpath, header=F, col.names=features$MeasureName)
  
  # names of subset columns required
  indices_of_Good_features <- grep(".mean\\(\\)|.std\\(\\)", features$MeasureName)

  # subset the data (done early to save memory)
  data <- data[,indices_of_Good_features]
  
  # append the activity id and subject id columns
  data$ActivityID <- y_data$ActivityID
  data$SubjectID <- subject_data$SubjectID
  
  # return the data
  data
}

# read test data set, in a folder named "test", and data file names suffixed with "test"
FunReadTestData <- function() {
  FunRdata("test", "test")
}

# read test data set, in a folder named "train", and data file names suffixed with "train"
FunReadTrainData <- function() {
  FunRdata("train", "train")
}

# Merge both train and test data sets.
#Extracts only the measurements on the mean and standard deviation
mergeData <- function() {
  data <- rbind(FunReadTestData(), FunReadTrainData())
  colnames1 <- colnames(data)
  colnames1 <- gsub("\\.+mean\\.+", colnames1, replacement="Mean")
  colnames1 <- gsub("\\.+std\\.+",  colnames1, replacement="Std")
  colnames(data) <- colnames1
  return(data)
}

# Add appropriately labels the data set with descriptive activity names..

applyActivityLabel <- function(data) {
  activity_labels <- read.table("activity_labels.txt", header=F, as.is=T, col.names=c("ActivityID", "ActivityName"))
  activity_labels$ActivityName <- as.factor(activity_labels$ActivityName)
  labeled_data <- merge(data, activity_labels)
  return(labeled_data)
}

# Combine train and test data sets and add the activity label as another column
MergedLabeledData <- function() {
  applyActivityLabel(mergeData())
}

# Create a tidy data set that has the average of each variable for each activity and each subject.
TidyData <- function(merged_labeled_data) {
  library(reshape2)
  
  id_vars = c("ActivityID", "ActivityName", "SubjectID")
  measure_vars = setdiff(colnames(merged_labeled_data), id_vars)
  melted_data <- melt(merged_labeled_data, id=id_vars, measure.vars=measure_vars)
  
  dcast(melted_data, ActivityName + SubjectID ~ variable, mean)    
}

# Create the tidy data set and save it on to the named file
createTidyDataFile <- function(filename) {
  cat("Creating tidy dataset .........")
  message("Just wait for few seconds( approx 28 sec) .............")
  
  tidy_data <- TidyData(MergedLabeledData())
  write.table(tidy_data, filename)
  
  cat("Tidy dataset created...........")
  message(" ............DONE.............")
  
}

createTidyDataFile("tidy_data.txt")
