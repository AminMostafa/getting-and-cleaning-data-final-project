library(data.table)

##Reading the data
xtest <- read.table("C:\\Users\\Mostafa\\Documents\\data\\test\\X_test.txt", sep = "", header = FALSE)
ytest <- read.table("C:\\Users\\Mostafa\\Documents\\data\\test\\Y_test.txt", sep = "", header = FALSE)
subjecttest <- read.table("C:\\Users\\Mostafa\\Documents\\data\\test\\subject_test.txt", sep = "", header = FALSE)

xtrain <- read.table("C:\\Users\\Mostafa\\Documents\\data\\train\\X_train.txt", sep = "", header = FALSE)
ytrain <- read.table("C:\\Users\\Mostafa\\Documents\\data\\train\\Y_train.txt", sep = "", header = FALSE)
subjecttrain <- read.table("C:\\Users\\Mostafa\\Documents\\data\\train\\subject_train.txt", sep = "", header = FALSE)

features <- read.table("C:\\Users\\Mostafa\\Documents\\data\\features.txt", sep = "", header = FALSE)

activity_labels <- read.table("C:\\Users\\Mostafa\\Documents\\data\\activity_labels.txt", sep = "", header = FALSE)

##Mergind train and test data
test <- cbind(subjecttest,ytest, xtest)
train <- cbind(subjecttrain, ytrain, xtrain)
merged <- rbind(test, train) 

##Change variable names
featuresnames <- as.character(features[, 2])
colnames(merged) <- c("subject", "activity", featuresnames)

##Extract mean and std only 
merged_mean_std <- merged[,grepl(("mean|std|subject|activity"), colnames(merged))]

##Acitviy labelling
merged_mean_std$activity <- as.character(merged_mean_std$activity)
for (i in 1:6){
  merged_mean_std$activity[merged_mean_std$activity==i]<- as.character(activity_labels[i,2])
  }

##Newtidy data by each subject and activity
merged_mean_std$subject <- as.factor(merged_mean_std$subject)
merged_mean_std <- data.table(merged_mean_std)

newset <- aggregate(. ~subject + activity, merged_mean_std, mean)
newset <- newset[order(newset$subject,newset$activity),]
write.table(newset, file = "newset.txt", row.names = FALSE)


