# Exploratory Data Analysis
# Assignment 2
# Plot 5

#########
# 0. Download the data
#########

# set working directory
setwd("~/Documents/Coursera/Assignments/ExData_Plotting2")

# download the data set
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "NEI_data.zip", method = "curl")

# unzip the data set
unzip("NEI_data.zip")

#########
# 1. Read the data
#########

# load the data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#########
# 2. Create the plot
#########

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City? 

# subset cases and variables required
NEI <- subset(NEI, fips == 24510 & type == "ON-ROAD") # on-road NEI data for Baltimore 
NEI <- NEI[, c(4,6)] # Emissions and Year

# use 'reshape' to compute totals for 1999-2008
library(reshape2)
df <- melt(NEI, id = "year")
df <- dcast(df, year ~ variable, sum)

# inspect the data file
df

# open the PNG device
png(file = "plot5.png", width = 480, height = 480)

# create the plot
library(ggplot2)
g <- ggplot(df, aes(x = year, y = Emissions)) + geom_line(size = 1.25)
g <- g + scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) +
    scale_y_continuous(limits = c(0, 400)) +
    labs(x = "Year", y = expression(paste("Amount of ",PM[2.5]," Emitted (in Tons)"))) +
    labs(title = expression(paste("Motor Vehicle ",PM[2.5]," Emissions in Baltimore City, 1999-2008"))) 
print(g)

# close the PNG device
dev.off()


