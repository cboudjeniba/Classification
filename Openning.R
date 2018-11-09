if (FALSE) {
  library(reticulate)
  reticulate::import_from_path("strel")
  # # Module(strel)
  # py_run_file("Openning.py")
  source_python("Proportion.py")
  compute_proportion("100.jpg", 200) ## devrait marcher!
  blanc=py$p
  I=sum(blanc>0)
  ##
  path="/Users/cheimaboudjeniba/anaconda2/lib/python2.7/site-packages"
  reticulate::import_from_path("cv2",path="/Users/cheimaboudjeniba/PycharmProjects/TP1/venv/lib/python2.7/site-packages")
  ########################################################
  ########################################################
  setwd("/Users/cheimaboudjeniba/Desktop/M2/Classification")
}

train <- read.table("Prop.txt", col.names = "prop_white")
# train <- as.matrix(train)

test <- read.table("PropTest.txt", col.names = "prop_white")
# test=as.matrix(Test)
test.truth <- factor(rep(0:1, each = 100), levels = 0:1)


# x=rep(0,500)
# y=rep(1,500)
# Y=c(x,y)

plot(ecdf(train$prop_white[1:500]))
plot(ecdf(train$prop_white[501:1000]), add = TRUE, col = 2)
plot(ecdf(test$prop_white[1:100]))
plot(ecdf(test$prop_white[101:200]), add = TRUE, col = 2)


train <- cbind(train, eol = rep(1:0, each = 500))
                                    #1er colonne: propotion de blanc & 2eme colonne: presence eolienne in {0,1}

## version knn
nb.neighbors <- 5
trained.knn <- knn3(I(as.factor(eol)) ~ prop_white, data = train, k = 3)
test.probs.knn <- predict(trained.knn, newdata = test)[, 2]

preds.knn <- factor((test.probs.knn >= 0.4) + 0)
confusionMatrix(table(preds.knn, test.truth))

## version glm
trained.glm <- glm(I(as.integer(eol)) ~ poly(prop_white, 5, raw = TRUE), 
                   data = train,
                   family = binomial)
test.probs.glm <- predict(trained.glm, newdata = test, type = "response")

preds.glm <- factor((test.probs.glm >= 0.4) + 0)
confusionMatrix(table(preds.glm, test.truth))

## version glmnet
y.train <- train$eol
x.train <- poly(train$prop_white, 10, raw = TRUE)
x.test <- poly(test$prop_white, 10, raw = TRUE)
trained.glmnet <- cv.glmnet(x.train, y.train,
                            family = "binomial")
test.probs.glmnet <- predict(trained.glmnet, newx =  x.test, type = "response")

preds.glmnet <- factor((test.probs.glmnet >= 0.4) + 0)
confusionMatrix(table(preds.glmnet, test.truth))

## version qda
library(MASS)
trained.qda <- qda(I(as.integer(eol)) ~ poly(prop_white, 5, raw = TRUE), 
                   data = train,
                   family = binomial)
test.predict.qda <- predict(trained.qda, newdata = test, type = "response")
test.probs.qda <- test.predict.qda$posterior
preds.qda <- test.predict.qda$class
confusionMatrix(table(preds.qda, test.truth))

