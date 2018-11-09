setwd("/Users/cheimaboudjeniba/Desktop/M2/Classification/Defi")


train_std <- read.table("train_hsv_std.txt",col.names = c("a","b","c"))
#train_std <- cbind(train_std, eol = rep(0:1, each = 500))

train_mean <- read.table("train_hsv_mean.txt", col.names = c("d","e","f"))
#train_mean <- cbind(train_mean, eol = rep(0:1, each = 500))

train_min <- read.table("train_hsv_min.txt", col.names = c("g","h","i"))
#train_min <- cbind(train_min, eol = rep(0:1, each = 500))

train_max <- read.table("train_hsv_max.txt", col.names = c("j","k","l"))
#train_max <- cbind(train_max, eol = rep(0:1, each = 500))

train <- cbind(train_std , train_mean , train_min ,train_max , 
               eol = rep(0:1, each = 30000))

test_std <- read.table("test_hsv_std.txt", col.names = c("a","b","c"))
test_mean <- read.table("test_hsv_mean.txt", col.names = c("d","e","f"))
test_min <- read.table("test_hsv_min.txt", col.names = c("g","h","i"))
test_max <- read.table("test_hsv_max.txt", col.names = c("j","k","l"))

test <- cbind(test_std, test_mean, test_min, test_max)

x=rep(0,5000)
y=rep(1,2966)
Y=c(x,y)
test.truth <- factor(Y, levels = 0:1)


## version knn
nb.neighbors <- 10
trained.knn <- knn3(I(as.factor(eol)) ~ . , data = train, k = nb.neighbors)
test.probs.knn <- predict(trained.knn, newdata = test)

preds.knn <- ((test.probs.knn >= 0.5)+0)
confusionMatrix(table(preds.knn, test.truth))

## version glm
trained.glm <- glm(I(as.integer(eol)) ~ ., 
                   data = train,
                   family = binomial)
test.probs.glm <- predict(trained.glm, newdata = test, type = "response")

preds.glm <- factor((test.probs.glm >= 0.4) + 0)
confusionMatrix(table(preds.glm, test.truth))

## version glmnet
y.train <- train$eol
x.train <- as.matrix(train[,-c(13)])
x.test <- as.matrix(test)

trained.glmnet <- cv.glmnet(x = x.train , y = y.train , family = "binomial")
test.probs.glmnet <- predict(trained.glmnet, newx =  x.test, type = "response")

preds.glmnet <- factor((test.probs.glmnet >= 0.5) + 0)
confusionMatrix(table(preds.glmnet, test.truth))

## version qda
library(MASS)
trained.qda <- qda(train$eol ~ .,data = train )
test.predict.qda <- predict(trained.qda, newdata = test, type = "response")
test.probs.qda <- test.predict.qda$posterior
preds.qda <- test.predict.qda$class
confusionMatrix(table(preds.qda, test.truth))

## version random forest
set.seed(123)
library(randomForest)

trained.rf <- randomForest(as.factor(eol) ~ . , data = train )
test.probs.rf <- predict(trained.rf, newdata = test)

preds.rf <- (as.matrix(test.probs.rf)>=0.5) + 0

table(preds.rf, test.truth)

