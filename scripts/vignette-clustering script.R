#Step 1: Load the Necessary Packages
library(tidymodels)
library(cluster)
require(readr) 
require(factoextra)

#Step 2: Load and Prep the Data
#read in csv
setwd("~/Documents/GitHub/vignette-clustering/data")
wine <- read.csv('winequality-white.csv', sep=';')
wine<-na.omit(wine)
wine2 <- scale(wine)
head(wine2)
save(wine2, file = "clean-winequality.RData")

#We will cut down the wine data set due to run time and simplicity of the dendrogram to 50 rows
set.seed(100)
w_ind <- sample(nrow(wine2),50,replace = F)
winecut <- wine[w_ind,]

#using the agnes() function from cluster package
#Since we don’t know beforehand which method will produce the best clusters,
#we can write a short function to perform hierarchical clustering using several different methods.
#this function calculates the agglomerative coefficient of each method, which is metric that measures the strength of the clusters. 
#The closer this value is to 1, the stronger the clusters.

#Step 3: Find the Linkage Method to Use
#define linkage methods
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

#function to compute agglomerative coefficient
ac <- function(x) {
  agnes(winecut, method = x)$ac
}

#calculate agglomerative coefficient for each clustering linkage method
sapply(m, ac)

#We can see that Ward’s minimum variance method produces the highest agglomerative coefficient, 
#thus we’ll use that as the method for our final hierarchical clustering:

#perform hierarchical clustering using Ward's minimum variance
clust <- agnes(winecut, method = "ward")

#produce dendrogram
pltree(clust, cex = 0.6, hang = -1, main = "Dendrogram") 





#full data set
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")
ac2 <- function(x) {
  agnes(wine2, method = x)$ac
}
sapply(m, ac2)
clust2 <- agnes(wine2, method = "ward")
pltree(clust2, cex = 0.6, hang = -1, main = "Dendrogram") 







#Each leaf at the bottom of the dendrogram represents an observation in the original dataset. 
#As we move up the dendrogram from the bottom, observations that are similar to each other are fused together into a branch.

#Step 4: Determine the Optimal Number of Clusters
#We will be calculating the cluster on the actual wine data set 
#we can use a metric known as the gap statistic, which compares the total intra-cluster variation for different values 
#of k with their expected values for a distribution with no clustering, to determine how many
#clusters the observations should be grouped in 

#We can calculate the gap statistic for each number of clusters using the clusGap() function from the cluster package 
#along with a plot of clusters vs. gap statistic using the fviz_gap_stat() function

#calculate gap statistic for each number of clusters (up to 10 clusters)
gap_stat <- clusGap(wine2, FUN = hcut, nstart = 25, K.max = 10, B = 50)

#produce plot of clusters vs. gap statistic
fviz_gap_stat(gap_stat)

#our highest k is at 3

#Step 5: Apply Cluster Labels to Original Dataset
#To actually add cluster labels to each observation in our dataset, 
#we can use the cutree() method to cut the dendrogram into 4 clusters:

#compute distance matrix
d <- dist(wine2, method = "euclidean")

#perform hierarchical clustering using Ward's method
final_clust <- hclust(d, method = "ward.D2" )

#cut the dendrogram into 4 clusters
groups <- cutree(final_clust, k=3)

#find number of observations in each cluster
table(groups)

#append cluster labels to original data
final_data <- cbind(wine, cluster = groups)

#display first six rows of final data
head(final_data)


# K-Means Clustering

#K-means clustering is an unsupervised learning method in machine learning (there is no response variable to evaluate the model off of). This method is used to group data points into K clusters where K is a tuning parameter chosen by the user. After initially randomly assigning data points to a cluster, the model iterates until the clusters are settled into their respective groups. The clustering is determined by the distance from the center of each cluster. The function used for k-means clustering is `kmeans()` found in the stats package.


#REFERENCE: https://uc-r.github.io/kmeans_clustering

#Pick distance measure, here I use Euclidean from the factoextra R package
distance <- get_dist(wine_sc)
#fviz_dist allows us to visualize the distance
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"),show_labels = FALSE)


#kmeans function used below. Here, we are setting centers = 2 to form two different clusters. Addiionally, the nstart option will attempt to create initial configurations in order to find the best one. In this instance, there are 30 configurations
kmeans2 <- kmeans(wine_sc, centers = 2, nstart = 30)
str(kmeans2)


#Below you can see the two clusters, along with the cluster means
kmeans2


#remember to remove labels
fviz_cluster(kmeans2, data = wine_sc)



kmeans3 <- kmeans(wine_sc, centers = 3, nstart = 30)
kmeans4 <- kmeans(wine_sc, centers = 4, nstart = 30)
kmeans5 <- kmeans(wine_sc, centers = 5, nstart = 30)

# plots to compare
p1 <- fviz_cluster(kmeans2, geom = "point", data = wine_sc) + ggtitle("k = 2")
p2 <- fviz_cluster(kmeans3, geom = "point",  data = wine_sc) + ggtitle("k = 3")
p3 <- fviz_cluster(kmeans4, geom = "point",  data = wine_sc) + ggtitle("k = 4")
p4 <- fviz_cluster(kmeans5, geom = "point",  data = wine_sc) + ggtitle("k = 5")

library(gridExtra)
grid.arrange(p1, p2, p3, p4, nrow = 2)

#So, Which is best? There are three methods we can use 
#ELBOW
fviz_nbclust(wine_sc, kmeans, method = "wss")
#SILHOUETTE
fviz_nbclust(wine_sc, kmeans,method = "silhouette")
#GAP STATISTICS

gap_stat <- clusGap(wine_sc, FUN = kmeans, nstart = 30,
                    K.max = 10, B = 50)
print(gap_stat, method = "firstmax")
fviz_gap_stat(gap_stat)
#2 clusters seems to be the best!!! !

final <- kmeans(winecut, centers = 2, nstart = 30) #labeled kmeans 2 since we have 2 clusters. We will use more later

fviz_cluster(final, data = winecut, geom=c("point"))
