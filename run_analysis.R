

X_test <- read.table("C:/Users/Daniela/Documents/Cursos/R/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/Daniela/Documents/Cursos/R/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/Daniela/Documents/Cursos/R/UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("C:/Users/Daniela/Documents/Cursos/R/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/Daniela/Documents/Cursos/R/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/Daniela/Documents/Cursos/R/UCI HAR Dataset/train/subject_train.txt")
varnames<- read.table("C:/Users/Daniela/Documents/Cursos/R/UCI HAR Dataset/features.txt")
#Renames columns from the subject and Y data frames
subject_test<-rename(subject_test, S=V1)
subject_train<-rename(subject_train, S=V1)
y_test<-rename(y_test, Y=V1)
y_train<-rename(y_train, Y=V1)
#Merges all the data frames 
mergedtestdata<-cbind(subject_test, y_test, X_test)
mergedtraindata<-cbind(subject_train, y_train, X_train)
mergedtotaldata <- rbind(mergedtestdata, mergedtraindata)
#Extracts measurements on the mean and standard deviation for each measurement
extracteddata<- select(mergedtotaldata,S:V6, V41:V46, V81:V86, V121:V126, V161:V166, V201:V202,  V214:V215, V227:V228, V240:V241, V253:V254, V266:V271, V345:V350, V424:V429, V503:V504, V516:V517, V529:V530, V542:V543)
#Gives descriptive names to the activities using a Look up vector
LookupVector<- c("Walking", "Walking.downstairs", "Walking.upstairs", "Sitting", "Standing", "Laying")
extracteddata$Y<-LookupVector[extracteddata$Y]
#Labels the data set with appropriate names
varnames[, 2] <-gsub("^t","time", as.matrix(varnames[, 2]))
varnames[, 2] <-gsub("^f","freq", as.matrix(varnames[, 2]))
varnames[, 2] <-gsub("-",".", as.matrix(varnames[, 2]))
varnames[, 2] <-gsub("[()]","", as.matrix(varnames[, 2]))
usevarnames<-varnames[grep("mean\\.|mean$|std", varnames[, 2]), 2]
fullvarnames <-c("Subject", "Activity", usevarnames)
colnames(extracteddata)<- fullvarnames
#Creates a tidy data set by grouping them by subject and the activity and
#obtaining the mean of each group
tidydata<- group_by(extracteddata, Subject, Activity)
finaltidydata<-summarize_each(tidydata, mean)
finaltidydata