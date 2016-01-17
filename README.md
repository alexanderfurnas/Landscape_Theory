# Landscape_Theory

The code block below is at the top of *Landscape_Theory_Calculation_Script.R*. Adjust these file paths appropriately for your input and working directory.

	#set your working directory here
	setwd("..")
	
	#load data -- make sure you are using the appropriate file names and they are in your working directory.
	pairwise <- read.table("pairwise_relationships_names.csv", header = TRUE, row.names=1, 
	                           sep = ",")
	actor_data <- read.csv("Actor_data_weaksyria.csv")
	
	
	#output filepath -- put anything here, wd is default
	filepath <- getwd()
	
	#output filepath for favorite alignments - put anything here, wd is default
	filepath_fav <- getwd()


Also included in this repository are *Actor_data.csv* and *pairwise_relationships_names.csv*. These are examples of the data input taken by the calculation script.