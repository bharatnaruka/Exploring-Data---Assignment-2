require("ggplot2")
require("sqldf")

emissiondata <- readRDS("summarySCC_PM25.rds")
desc <- readRDS("Source_Classification_Code.rds")

## Modify the names as sqldf doesnt recognize '.'
names(desc) <- c("SCC", "Data_Category","Short_Name","EI_Sector",  "Option_Group","Option_Set","SCC_Level_One","SCC_Level_Two","SCC_Level_Three", "SCC_Level_Four", "Map_To", "Last_Inventory_Year", "Created_Date", "Revised_Date","Usage_Notes")       

## use sqldf function to get Sshort.Names containing "coal"
coalsource <-sqldf("select SCC from desc where Short_Name like '%coal%' or Short_Name like '%lignite%'  ")

## subset main dataset to get SCC values correspondin to found above
coalPM <-  subset(emissiondata, SCC %in% coalsource$SCC)

##consolidate emissions by year
consolidated <- data.frame(tapply(coalPM$Emissions, coalPM$year, sum))

names(consolidated) <- "Emissions"

consolidated$year <- as.vector(row.names(consolidated))

##png("plot4.png")

qplot(year, Emissions/100000, data=consolidated, geom="bar", stat="identity", main= "US - Trend of Emission from Coal Combustion Related Sources", ylab= "PM2.5 Emission (tons)",col=colorRampPalette(c("Red","Yellow"))
    
##dev.off()





