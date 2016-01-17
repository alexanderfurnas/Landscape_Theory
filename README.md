# Landscape_Theory

The code block below is at the top of *Landscape_Theory_Calculation_Script.R*. Adjust these file paths appropriately for your input and working directory.

	#set your working directory here
	setwd("/Users/alexanderfurnas/Projects/Work with Axelrod/Landscape_Theory/Public_version/")
	
	#load data -- make sure you are using the appropriate file names and they are in your working directory.
	pairwise <- read.table("pairwise_relationships_names.csv", header = TRUE, row.names=1, 
	                           sep = ",")
	actor_data <- read.csv("Actor_data.csv")
	
	
	#output filepath -- put file name here, wd is default directory
	filepath <- "Landscape_Results"
	
	#output filepath for favorite alignments - put file name here, wd is default directory
	filepath_fav <- "Landscape_Favored_Alignments"


Also included in this repository are *Actor_data.csv* and *pairwise_relationships_names.csv*. These are examples of the data input taken by the calculation script.