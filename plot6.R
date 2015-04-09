require("ggplot2")
require("sqldf")

emissiondata <- readRDS("summarySCC_PM25.rds")
desc <- readRDS("Source_Classification_Code.rds")

## Modify the names as sqldf doesnt recognize '.'
names(desc) <- c("SCC", "Data_Category","Short_Name","EI_Sector",  "Option_Group","Option_Set","SCC_Level_One","SCC_Level_Two","SCC_Level_Three", "SCC_Level_Four", "Map_To", "Last_Inventory_Year", "Created_Date", "Revised_Date","Usage_Notes")       

## use sqldf function to get Sshort.Names containing "coal"
motorsource <-sqldf("select SCC from desc where SCC_Level_Two like '%vehicle%'")


## subset main dataset to get SCC values corresponding to found above
motorPM <-  subset(emissiondata, SCC %in% motorsource$SCC)
motorPM <- motorPM[motorPM$fips=="24510" | motorPM$fips=="06037",]

##consolidate emissions by year for Baltimore
consolidated_bm <- data.frame(tapply(motorPM[motorPM == "24510",]$Emissions, motorPM[motorPM == "24510",]$year, sum))
names(consolidated_bm) <- "Emissions"
consolidated_bm$year <- as.vector(row.names(consolidated_bm))
consolidated_bm$county <- "Baltimore"

##consolidate emissions by year for LA
consolidated_LA <- data.frame(tapply(motorPM[motorPM == "06037",]$Emissions, motorPM[motorPM == "06037",]$year, sum))
names(consolidated_LA) <- "Emissions"
consolidated_LA$year <- as.vector(row.names(consolidated_LA))
consolidated_LA$county <- "LA"

## Merge Baltimore and LA county datasets
consolidated <- rbind(consolidated_LA,consolidated_bm)

png("plot6.png")

qplot(year, Emissions, data=consolidated, geom="bar", stat="identity", main= "Baltimore vs LA - Vehicle PM2.5 Emissions Trend", ylab= "PM2.5 Emission (tons)", fill=county) + facet_grid(~county)

dev.off()





