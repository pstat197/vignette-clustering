#loading in packages
library(readr)
library(cluster)

#loading in data
wine <- read.csv('winequality-white.csv', sep=';')

#clean data 
wine<-na.omit(wine)
wine2 <- scale(wine)
head(wine2)
save(wine2, file = "clean-winequality.RData")

#cutting down data for faster and clearer dendrogram
set.seed(100)
w_ind <- sample(nrow(wine2),50,replace = F)
winecut <- wine[w_ind,]

#finding linkage method 
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

#function to compute agglomerative coefficient
ac <- function(x) {
  agnes(winecut, method = x)$ac
}

#calculate agglomerative coefficient for each clustering linkage method
sapply(m, ac)

#perform hierarchical clustering using Ward's minimum variance since it produces the highest agglomerative coefficient
clust <- agnes(winecut, method = "ward")

#produce dendrogram
pltree(clust, cex = 0.6, hang = -1, main = "Dendrogram") 



#computing agglomerative coefficient for full data set
m <- c( "average", "single", "complete", "ward")

#using ward's method
names(m) <- c( "average", "single", "complete", "ward")
ac2 <- function(x) {
  agnes(wine2, method = x)$ac
}
sapply(m, ac2)
clust2 <- agnes(wine2, method = "ward")

#dendogram for full data set, a bit messy..
pltree(clust2, cex = 0.6, hang = -1, main = "Dendrogram") 


#calculaing gap statistic
gap_stat <- clusGap(wine2, FUN = hcut, nstart = 25, K.max = 10, B = 50)

#produce plot of clusters vs. gap statistic
#highest gap statistic came out to be 3.
fviz_gap_stat(gap_stat)

#calculate distance matrix
d <- dist(wine2, method = "euclidean")

#hierarchical clustering using Ward's method
final_clust <- hclust(d, method = "ward.D2" )

#group into clusters of 3
groups <- cutree(final_clust, k=3)

#find number of observations in each cluster
table(groups)

#append cluster labels to original data
final_data <- cbind(wine, cluster = groups)

#display first six rows of final data
head(final_data)

#references: https://www.statology.org/hierarchical-clustering-in-r/
