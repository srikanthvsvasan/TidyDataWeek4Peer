This file describes how the data from Samsung wearable device is processed in the accompanying run_analysis.R script. The associated codebook.txt in the same repo describes the variables in the resulting tidy dataset. This is a response to the peer-graded assignment in week 4 of Coursera's 'Getting and Cleaning data' course. Original data source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Input:
Please ensure that the zip file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip is UNZIPPED into your working directory.

Output:
On running the script, you should have a new file ss_tidy_data.txt written into your working directory.


General comments:
1) My program to 'get and clean' the data may look verbose primarily because of 2 reasons: volume of comments and lot of intermediate variables. For example, I have not used 'chaining' and I have renamed the columns of 'test' and 'train' datasets independently instead of doing it once  for the merged data. Given that the processing is relatively simple anyway, I gave preference to code readability rather than speed or performance.

2) In the following analysis if you find any tag starting or ending with an underscore (_), please understand that that comment applies for both 'test' and 'train' categoris. Eg: when I say '_values tables', I mean both test_values and train_values tables.

3) The advice from https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/  was useful in resolving my confusion about whether to use the values in the 'interial' subfolder.

Explanation of the analysis.
1) Read the 'test' and 'train' datasets (X_, y_ and subject_ text files) using read.table

2) Running dim() and table() commands on the data sets revealed that X_ data set had the measurement values for all the 561 features, y_ and subject_ datasets had the corresponding activities performed and subjects under test respectively.
Other clues :
  2a) The number of observations(rows) was the same for X_ , y_ and       subject_ datasets
  2b) The table() command on y_ dataset said the values ranged from       1 through 6 and so are the acitivities (from activity_labels       .txt)
  2c) The table() command on subject_test dataset said that there        are 9 unique values. So that must be the id of the 'test'          subjects as 30% of a total of 30 subjects is 9. The original       data's README says 30% of the total subjects were considered       for 'test'.

3) So we have 3 'test' tables of dimensions 2947*1 (subject), 2947*1 (activity) and 2947*561 (feature values). We have 3 similar tables for the 'train' subjects with the only difference being the number of observations which is 7352.

4) Rename the column name of the _subject tables to "subject"

5) Read in features.txt from the working directory into a table feat_vector. This now contains the names of all 561 features. Rename the column name of this vector for ease of use.

6) Rename the column names of _values tables using feat_vector from step 5.

7) Read in the activity_labels.txt from the working directory into a table activity_labels. This contains the activity names and their numeric codes 1 through 6 in ascending order.

8) Rename the column names of _activity tables to 'activity'. Then use activity_labels from step 7 to rename the activity values in the test_activity and train_activity tables.

9) cbind test_subject, test_activity and test_values to get the complete dataset for 'test' subjects. Do the same for 'train' tables to get the complete dataset for train_subjects. Name these test_data and train_data.

10) rbind test_data and train_data to get the comeplete data for all 30 subjects. Name it merged_data.

11) Using grep, extract the column numbers for columns containing 'mean' and 'std'. I made it case sensitive so that the features 555 through 561 containing some angle variables are not included. Those did not sound like mean measurements to be. So now we have a pruned data with 79 feature columns along with subject and activity columns.

12) Rename the feature column names to remove dashes and parantheses. Use gsub to do this.

13) Step 5 in the assignment asks for "average of each variable for each activity and each subject." . So group the data according to subject and then activity using group_by. Save it in tidy_data_group.

14) Use summarise_all to calculate the mean of all the columns in tidy_data_group and save it in the table tidy_data.

15) Use write.table with row.names=FALSE to write tidy_data into a text file ss_tidy_data.txt in the working directory.
