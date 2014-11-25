# Exploratory Data Analysis
# Assignment 2
# Plot 3

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

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999–2008 
# for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the 
# ggplot2 plotting system to make a plot answer this question.

# Subset cases and variables required
NEI <- subset(NEI, fips == 24510) # Baltimore data
NEI <- NEI[, 4:6] # Emissions, Type and Year

# clean up the type variable for plotting
library(Hmisc)
names(NEI)[names(NEI) == "type"] <- "Type"
NEI$Type <- capitalize(tolower(NEI$Type))
NEI$Type <- factor(NEI$Type)

# use 'reshape' to compute totals for each source for Baltimore for 1999-2008
library(reshape2)
df <- melt(NEI, id = c("Type", "year"))
df <- dcast(df, Type + year ~ variable, sum)

# inspect the data file
df

# open the PNG device
png(file = "plot3.png", width = 480, height = 480)

# create the plot
library(ggplot2)
g <- ggplot(df, aes(x = year, y = Emissions, group = Type, colour = Type)) + geom_line(size = 1.25)
g <- g + scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) +
    scale_y_continuous(limits = c(0, 2500)) +
    labs(x = "Year", y = expression(paste("Amount of ",PM[2.5]," Emitted (in Tons)"))) +
    labs(title = expression(paste("Total ",PM[2.5]," Emissions in Baltimore City by Type, 1999-2008"))) +
    theme(legend.position = "top")
print(g)

# close the PNG device
dev.off()


