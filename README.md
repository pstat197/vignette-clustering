*Vignette on k-means and hierarchical clustering; created as a class project for PSTAT197A in Fall 2022.*

# vignette-clustering


### Contributors: Ashley Son, Hannah Li, Ryan Quon, Alexander Lim

## Abstract: 

Clustering is an unsupervised machine learning model that involves grouping observations using various algorithms. This vignette covers 2 clustering methods: Hierarchical and K-means clustering. Using the UCI, quality of white wine dataset, both Hierarchical and K-means clustering are performed RESULTS HERE [Wine Quality Dataset](https://archive.ics.uci.edu/ml/datasets/Wine+Quality)

## Repository content

-   `data` - contains 
    -   `winequality-white.csv` contains 12 physicochemical test measures for 4,898 wines
    -   `clean-winequality.RData` contains the scaled data from winequality-white.csv with missing values removed.
-   `scripts` -
    -   `primarydocument-clustering.Rmd` contains the code used in `vignette-clustering.qmd`
    -   `drafts` contains scratchwork files `scratchwork-ashley.R`, `scratchwork-hierarchial.R`, and `scratchwork-kmeans.Rmd`
    -   `Clustering_files` contains the dendrogram figures created in `vignette-clustering.qmd`
    

## References:

-   [Hierarchical Clustering](https://www.statology.org/hierarchical-clustering-in-r/)

-   [K-Means Clustering](https://towardsdatascience.com/understanding-k-means-clustering-in-machine-learning-6a6e67336aa1)

-   [Additional Clustering Methods and Details](https://www.freecodecamp.org/news/8-clustering-algorithms-in-machine-learning-that-all-data-scientists-should-know/)
