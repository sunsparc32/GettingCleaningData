rm(list=ls())


# 1. Merge the training and test sets to create one data set
# ----------------------------------------------------------
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE) #Same for both the training and test sets

# Load the test set and attach subject codes and activity labels
subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
colnames(subjects) <- c("subject")
activity_labels <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
colnames(activity_labels) <- c("activity__label")
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
# Give descriptive column names for the test set
colnames(test_set) <- features$V2
# cbind the subject codes and activity labels
test_set <- cbind(subjects,activity_labels,test_set)

# Load the training set and attach subject codes and activity labels
subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
colnames(subjects) <- c("subject")
activity_labels <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
colnames(activity_labels) <- c("activity__label")
train_set <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
# Give descriptive column names for the training set set
colnames(train_set) <- features$V2
# cbind the subject codes and activity labels
train_set <- cbind(subjects,activity_labels,train_set)

# rbind the training and test sets.
# Useful check: all(colnames(train_set)==colnames(test_set)) # this should return TRUE
data_set <- rbind(test_set,train_set)

# 2. Extract only the measurements on the mean and standard deviation for each measurement
# ----------------------------------------------------------------------------------------
a <- grep("mean",colnames(data_set))
b <- grep("std",colnames(data_set))
d <- sort(c(a,b))
d <- c(1,2,d) # we still need the subject code and activity label code
data_set2 <- data_set[,d] #take all rows, but only the columns in d

# 3. Use descriptive activity names to name the activities in the data set
# ------------------------------------------------------------------------
activity_strings <-  read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)
colnames(activity_strings) <- c("code","action")
activity_strings$action <- as.character(activity_strings$action)
# There is probably a better way to do this
x1 <- data_set2$activity__label==1
x2 <- data_set2$activity__label==2
x3 <- data_set2$activity__label==3
x4 <- data_set2$activity__label==4
x5 <- data_set2$activity__label==5
x6 <- data_set2$activity__label==6

data_set2$activity__label[x1] <- activity_strings$action[1]
data_set2$activity__label[x2] <- activity_strings$action[2]
data_set2$activity__label[x3] <- activity_strings$action[3]
data_set2$activity__label[x4] <- activity_strings$action[4]
data_set2$activity__label[x5] <- activity_strings$action[5]
data_set2$activity__label[x6] <- activity_strings$action[6]

# 4. Appropriately label the data set with descriptive variable names
# -------------------------------------------------------------------
# Here we follow the following guidelines from the notes:
# All lower case, descriptive, not duplicated, not have underscores or dots or white spaces
colnames(data_set2)[2] <- "ActivityLabel"

# Verify that there are no underscores, dots, or white spaces:
c(grep("_",colnames(data_set2)), grep("\\.",colnames(data_set2)), grep(" ",colnames(data_set2)) )

# Verify that there are no duplicates in column names:
length(unique(colnames(data_set2)))==length(colnames(data_set2)) #should be TRUE

#With respect, I will disagree with the strict use of lowe case only variables only
#as espoused by the instructors. Here, having a mix of upper and lower case names
#is quite useful. E.g., having names like "ActivityLabel" makes reading it a lot
#easier


# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject
# ------------------------------------------------------------------------------------------------------------------

# sort by subject, then by activity
q  <- data_set2[order(data_set2$subject,data_set2$ActivityLabel),]
q1 <- q[1,]

sindex <- 1:30 # 30 subjects
aindex <- 1:6  # 6 activities

for (i in 1:length(sindex)){
    for (j in 1:length(aindex)){
        q2 <- subset(q, subject==i & ActivityLabel==activity_strings[j,2])
        dw <- colMeans(q2[,3:81])
        dw$subject <- i
        dw$ActivityLabel <- activity_strings[j,2]
        q1 <- rbind(q1,dw)
    }
     }

q3 <- q1[2:181,] #Remove the first row, which really was a place holder
write.table(q3, "tidy_data_set.txt", sep="\t", row.names=FALSE, quote=FALSE)
