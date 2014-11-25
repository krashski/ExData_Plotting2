# Exploratory Data Analysis
# Assignment 2
# Plot 6

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

# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# subset cases and variables required
NEI <- subset(NEI, fips %in% c("24510", "06037") & type == "ON-ROAD") # on-road NEI data for Baltimore & LA
NEI <- NEI[, c(1,4,6)] # County, Emissions and Year

# clean up the fips variable for plotting
names(NEI)[names(NEI) == "fips"] <- "County"
NEI$County[NEI$County == "24510"] <- "Baltimore City"
NEI$County[NEI$County == "06037"] <- "Los Angeles County"

# use 'reshape' to compute totals for Baltimore and Los Angeles for 1999-2008
library(reshape2)
df <- melt(NEI, id = c("County", "year"))
df <- dcast(df, County + year ~ variable, sum)

# inspect the data file
df

# open the PNG device
png(file = "plot6.png", width = 480, height = 480)

# create the plot
library(ggplot2)
g <- ggplot(df, aes(x = year, y = Emissions, group = County, colour = County)) + geom_line(size = 1.25)
g <- g + scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) +
    scale_y_continuous(limits = c(0, 5000)) +
    labs(x = "Year", y = expression(paste("Amount of ",PM[2.5]," Emitted (in Tons)"))) +
    labs(title = expression(paste("Motor Vehicle ",PM[2.5]," Emissions by County, 1999-2008"))) +
    theme(legend.position = "top")
print(g)

# close the PNG device
dev.off()


