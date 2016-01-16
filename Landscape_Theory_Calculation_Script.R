require(dplyr)


#load data
pairwise <- read.table("/Users/alexanderfurnas/Projects/Work with Axelrod/Landscape_Theory/pairwise_relationships_names.csv", header = TRUE, row.names=1, 
                           sep = ",")
actor_data <- read.csv("/Users/alexanderfurnas/Projects/Work with Axelrod/Landscape_Theory/Actor_data_weaksyria.csv")

#output filepath
filepath <- "/Users/alexanderfurnas/Projects/Work with Axelrod/Landscape_Theory/ISIS_Landscape_Results"

#output filepath for favorite alignments
filepath_fav <- "/Users/alexanderfurnas/Projects/Work with Axelrod/Landscape_Theory/ISIS_Landscape_Favored_Alignments_SyriaSensitivity"

#function for to get all of the possible alliances
get_groupings<- function(n){
    List <- list()  
    for(nt in 1:as.integer(n+1/2)){
        C = combn(n,nt)
        l = ncol(C)
        Z = matrix(2, nrow=n,ncol=l)
        for(j in 1:l){Z[C[,j],j] = 1
        List[[nt]] <- Z
    }
        }
        
    Matrix = do.call(cbind, List)
    return(Matrix)
    
    }

#function to get the distance matrix for a given alliance
get_distance_mat <-function(g){
g<- replace(g, g==0, 2)
g_mat <- outer(g,g)
g_mat <- replace(g_mat, g_mat==4,0)
g_mat <- replace(g_mat, g_mat==1,0)
g_mat <- replace(g_mat, g_mat==2,1)


return(g_mat)
    }

#function to calculate the scores for all of the possible alliances
get_scores <- function(grps, strength_mat, pairwise){
List <- list() 
    for (gr in 1:ncol(grps)){
    dist <- get_distance_mat(grps[,gr])
    frust_mat <- dist * strength_mat * pairwise
    frustrations <- t(apply(frust_mat, 1, sum))
    energy <- sum(frust_mat)
    grouping_result <- c(grps[,gr],energy, frustrations)
    List[[gr]] <- grouping_result
    }
    output <- as.data.frame(t(do.call(cbind, List)))
    cnames <- c(colnames(pairwise), "Energy", lapply(colnames(pairwise), paste0, "_Frustration"))
    names(output) <- cnames
    return(output)
}

#function to find the hamming distance between two vectors
hamm <- function(vec1, vec2){
    hd <- sum(vec1 != vec2)
    return(hd)
        }

check_local_minall <- function(n, mat){
    for(i in 1:nrow(mat)){
        tocheck <- mat[i,]  
        energy <- tocheck[n+1]
        n_energies <- c()
        for(v in 1:nrow(mat)){
            row <- mat[v,]
         if(hamm(tocheck[1:n],row[1:11]) == 1)
             n_energies <- c(n_energies, row[n+1])
        }
            min_ne <- min(unlist(n_energies))

            if (min_ne > energy)
                result <- c(tocheck, "True")
            else
                result <- c(tocheck, "False")
                print(result)
        
    }
}

#fucntion to get neighboring allignments for a given alignment
get_neighbors <- function(vec){
    cdim <- length(vec)
    neighbors <- matrix(0,ncol=cdim, nrow=cdim)
for (i in 1:cdim){
    ntv <- vec
    if (ntv[i]== 1)
        ntv[i]<-2
    else
        ntv[i] <- 1
    neighbors[i,] <- ntv

}
        return(neighbors)
        }

    
#function to check whether a given alignment is a local minimum
check_local_min <- function(i, n, strength_mat, pairwise){
    n_energies <- c()
    neighbors <- get_neighbors(i[1:11])
    energy <- sum(get_distance_mat(i[1:11])* strength_mat * pairwise)
    for(v in 1:nrow(neighbors)){
        row <- neighbors[v,]
        dist<-get_distance_mat(row)
        n_energy <- sum(dist * strength_mat * pairwise)
        n_energies <- c(n_energies, n_energy)
        min_ne <- min(unlist(n_energies))
}
        if (min_ne >= energy)
            return(TRUE)
        else
            return(FALSE)
    
}


#rescale pairwise relationships
pairwise <- pairwise -3
pairwise[ row(pairwise) == col(pairwise) ] <- 0

strength_mat <- outer(as.numeric(actor_data$strength), as.numeric(actor_data$strength))
grps <-get_groupings(ncol(pairwise))

#get all the scores
res <- get_scores(grps, strength_mat, pairwise)

#prepare data to output
res <- as.data.frame(res)
res1 <- filter(res, US == 1)
dim(res1)


filepath <- paste(filepath, Sys.Date(), sep="_")
filepath <- paste(filepath, "csv", sep =".")
write.csv(res1, filepath)

#get everyone's favorite alignment

Optimal  <- subset(res1, Energy==min(Energy))
US_best <- subset(res1, US_Frustration==min(US_Frustration))
Russia_best <- subset(res1, Russia_Frustration==min(Russia_Frustration))
Syria_best <- subset(res1, Syria_Frustration==min(Syria_Frustration))
Turkey_best <- subset(res1, US_Frustration==min(US_Frustration))
Saudi_Arabia_best <- subset(res1, Saudi_Arabia_Frustration==min(Saudi_Arabia_Frustration))
Iran_best <- subset(res1, Iran_Frustration==min(Iran_Frustration))
ISIS_best <- subset(res1, ISIS_Frustration==min(ISIS_Frustration))
Hezbollah_best <- subset(res1, Hezbollah_Frustration==min(Hezbollah_Frustration))
Iraqi_Kurds_best <- subset(res1, Iraqi_Kurds_Frustration==min(Iraqi_Kurds_Frustration))
Nursa_best <- subset(res1, Nursa_Frustration==min(Nursa_Frustration))
Baghdad_best <- subset(res1, Baghdad_Frustration==min(Baghdad_Frustration))

favorites <- rbind(Optimal, US_best, Russia_best, Syria_best, Turkey_best, Saudi_Arabia_best, Iran_best, ISIS_best, Hezbollah_best, Iraqi_Kurds_best, Nursa_best, Baghdad_best)


filepath_fav <- paste(filepath_fav, Sys.Date(), sep="_")
filepath_fav <- paste(filepath_fav, "csv", sep =".")
write.csv(favorites, filepath_fav)