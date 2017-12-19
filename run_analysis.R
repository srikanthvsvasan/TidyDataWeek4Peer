# Read in the text files inside "test" and "train" subfolders

# data from "test" subfolder
test_activity <-read.table("./test/y_test.txt", stringsAsFactors = FALSE)
test_subject  <-read.table("./test/subject_test.txt", stringsAsFactors = FALSE)
test_values   <-read.table("./test/X_test.txt", stringsAsFactors = FALSE)

# data from "train" subfolder
train_activity <-read.table("./train/y_train.txt", stringsAsFactors = FALSE)
train_subject  <-read.table("./train/subject_train.txt", stringsAsFactors = FALSE)
train_values   <-read.table("./train/X_train.txt", stringsAsFactors = FALSE)
# test_values :
# dim(test_values)
# [1] 2947  561
# The above gives us a clue that test_value has 2947 observations and that the
# columns indicate each of the variables in the feature vector as features.txt
# has 561 features.
#
# test_activity:
# dim(test_activity)
# [1] 2947    1
# The above dimension indicates that the observations have 1-1 mapping with those
# of test_values (same number of rows)
# table(test_activity)
# test_activity
#   1   2   3   4   5   6
# 496 471 420 491 532 537
# As the measurements are taken for 6 activities, this dataset must reflect the
# activities that map to the values in test_values.
#
# test_subject:
# dim(test_subject)
# [1] 2947    1
# table(test_subject)
# test_subject
#   2   4   9  10  12  13  18  20  24
# 302 317 288 294 320 327 364 354 381
#
# Again, the above dimensions and the table output clearly indicates that this
# dataset corresponds to the 'subjects' whose observations are recoded in
# test_values. 30% of 30 subjects were recorded for 'test' dataset. That amounts
# to 9 subjects. The number of unique subjects as indicated by the table command
# on test_subject variable is also 9.
#
# So now we have 3 different tables (feature values, subjects, activities) for
# both train and test categories of subjects.

# Rename the column name of the subject datasets to 'subject'
names(test_subject)  <- "subject"
names(train_subject) <- "subject"

# Read in the table of the feature names contained in features.txt
feat_vector <- read.table("./features.txt", stringsAsFactors = FALSE)

# Rename the column names of feat_vector for ease of use
names(feat_vector) <- c("feature_index", "feature")

# Rename the column names of test_values and train_values in line with the names
# of features (from feat_vector)
names(test_values)  <- feat_vector$feature
names(train_values) <- feat_vector$feature

#read in the table of the activity names contained in activity_labels.txt
activity_labels<-read.table("./activity_labels.txt", stringsAsFactors = FALSE)

# The output of 'activity_labels' clearly indicates that it maps activity
# numeric to readable activity labels
# Rename the column names appropriately
names(activity_labels) <- c("activity_index", "activity")

# Rename column name of train_activity for ease of use
names(train_activity) <- "activity"

# Replace the values in train_activity with the more readable strings (from the
# activity table that maps numbers to activity labels)
train_activity$activity <-activity_labels[train_activity$activity,]$activity

# Repeat the same for the test category dataset.
names(test_activity)   <- "activity"
test_activity$activity <- activity[test_activity$activity,]$activity

# Merge the 3 tables of test and train category datasets such that the first 2
# columns are subject and activity respectively. The subsequent 561 columns are
# features.
train_data <- cbind(train_subject, train_activity, train_values)
test_data  <- cbind(test_subject, test_activity, test_values)

# Now merge both test and train category datasets to get a single large dataset
merged_data<-rbind(test_data, train_data)

# At this point, we have a merged data set with descriptive activity names and
# appropriate labels for the variable names. This achieves steps 1, 3 and 4 from
# assignment description.
#
# Let us now extract just the mean and std columns from the merged data (step 2)

# Get the mean and std column indices using grep
mean_cols <- grep("*mean*",names(merged_data))
std_cols  <- grep("*std*",names(merged_data))

# Combine the mean and std columns
select_cols <- c(mean_cols, std_cols)

# Select only the mean and std columns from the merged dataset.
merged_data_prune<-merged_data[,c(1,2, select_cols)]

# Remove the dashes and () in column names
names(merged_data_prune) <- gsub("-","", names(merged_data_prune))
names(merged_data_prune) <- gsub("\\()","", names(merged_data_prune))

# Move on to step 5 to create the tidy data.
#
# First group the tidy data by subject and activity.
tidy_data_group<-group_by(merged_data_prune, subject, activity)

# Find the average for each variable. As we have already grouped them by subject
# and activity the mean will be calculated for every subject-activity pair on
# all variables.
tidy_data<-summarise_all(tidy_data_group,mean)

# Write the tidy data into a text file in the working directory.
write.table(tidy_data, "./ss_verify_tidy_data.txt", row.names = FALSE)


