Creating a Tidy Data Set
========================

There is a single file "run_analysis.R" that reads the training and test data sets and creates the tidy data set. It follows instructions 1 to 5 as given in the Assignment web site. The code is commented well and should easy to follow. A summary is provided below.

Instruction 1: Merge the training and test sets to create one data set.
We load the two data sets and combine them using *rbind*. For both the training and test sets, the subject list (subject_test.txt) and the activity codes (y_test.txt) have to be loaded separately and combined with the actual data (X_test.txt). *cbind* is used for this purpose. We also load the features and use these as column names, i.e., headers.

Instruction 2: Extract only the measurements on the mean and standard deviation for each measurement.
This is not difficult. A couple of calls to *grep* takes care of it.

Instruction 3: Use descriptive activity names to name the activities in the data set.
This is also not difficult. We use logical array (x1 to x6) to separate out the activites and then index the data frames with the logical arrays and then change the corresponding activity labels.

Instruction 4: Appropriately label the data set with descriptive variable names.
We do the basic checks and make sure that there are no variable names with dots, white spaces, or underscores (using *grep*) and we also make sure that there are no repeated variable names (using *unique* ). Now, the lecture notes say that variable names should use only lower case letters. I respectfully disagree. Here, having a mix of upper and lower case names is quite useful. e.g., having names like "ActivityLabel" makes reading it a loteasier

Instruction 5: Create an independent tidy data set with the average of each variable for each activity and each subject.
There are 30 subjects and 6 activites. This means that there should be 180 rows in the resulting data frame. Also when filtered for means and standard deviations, there are 79 variables. This becomes 81 once we add the subject and Activity Label variables. Hence we should expect a data frame with 180 rows and 81 columns. A for loop is used to populate the data frame and *write.table* is used to write a tab delimited text file. Before we write the file, we do a couple of clean up jobs: first we remove the "()" from variable names and then we remove "-" from variable names. Then we change "mean" to "Mean" and "std" to "Std" respectively. This gives variable names like "tBodyAccMeanX" which is read as total body accelearion means in the X direction for that particular subject and activity level. Please refer to CodeBook.md for details. 

Please Note:
(1) The variables names (headers) in the tidy set are all means, i.e., a variable name like "tBodyAccMeanX" is really mean of all measurements of that quantity for that subject and activity. So, our data set has means of means and means of standard deviations. The file "codebook.md" has more detials.
(2) Please open the tidy data set in a spreadsheet program like Excel. If you open it in a text editor like emacs or the editor in RStudio, it looks pretty untidy due to word wrapping. You can also load into to R using the command:
df <- read.table("tidy_data_set.txt",header=TRUE)




