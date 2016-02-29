library(reshape2)

#Program assumes that the data for the project is available in the same working
#directory.
# Load activity labels + features
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
activities[,2] <- as.character(activities[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data for mean and standard deviation
requiredfeatures <- grep(".*mean.*|.*std.*", features[,2])
requiredfeatures.names <- features[requiredfeatures,2]
requiredfeatures.names = gsub('-mean', 'Mean', requiredfeatures.names)
requiredfeatures.names = gsub('-std', 'Std', requiredfeatures.names)
requiredfeatures.names <- gsub('[-()]', '', requiredfeatures.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[requiredfeatures]
trainingActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainingActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[requiredfeatures]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", requiredfeatures.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "averages_tidy.txt", row.names = FALSE, quote = FALSE)
