# Exploratory Data Analysis
# Assignment 2
# Plot 2

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

# Have total emissions from PM2.5 decreased in Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# Subset cases and variables required
NEI <- subset(NEI, fips == 24510) # Baltimore data
NEI <- NEI[, c(4,6)] # Emissions and Year 

# use 'reshape' to compute total for Baltimore for 1999-2008
library(reshape2)
df <- melt(NEI, id = "year")
df <- dcast(df, year ~ variable, sum)

# inspect the data file
df

# open the PNG device
png(file = "plot2.png", width = 480, height = 480)

# create the plot
with(df, plot(year, Emissions, type = "l", lwd = 4, col = "black", xlab = "", ylab = "", 
              xaxt = "n", ylim = c(0, 3500)))
axis(1, at = c(1999, 2002, 2005, 2008))
title(xlab = "Year", ylab = expression(paste("Amount of ",PM[2.5]," Emitted (in Tons)")),
      main = expression(paste("Total ",PM[2.5]," Emissions in Baltimore City, 1999-2008")))

# close the PNG device
dev.off()


