require("ggplot2")
require("sqldf")

emissiondata <- readRDS("summarySCC_PM25.rds")
desc <- readRDS("Source_Classification_Code.rds")

## Modify the names as sqldf doesnt recognize '.'
names(desc) <- c("SCC", "Data_Category","Short_Name","EI_Sector",  "Option_Group","Option_Set","SCC_Level_One","SCC_Level_Two","SCC_Level_Three", "SCC_Level_Four", "Map_To", "Last_Inventory_Year", "Created_Date", "Revised_Date","Usage_Notes")       

## use sqldf function to get Sshort.Names containing "coal"
motorsource <-sqldf("select SCC from desc where SCC_Level_Two like '%vehicle%'")


## subset main dataset to get SCC values correspondin to found above
motorPM <-  subset(emissiondata, SCC %in% motorsource$SCC)

motorPM <- motorPM[motorPM$fips=="24510",]

##consolidate emissions by year
consolidated <- data.frame(tapply(motorPM$Emissions, motorPM$year, sum))

names(consolidated) <- "Emissions"

consolidated$year <- as.vector(row.names(consolidated))

png("plot5.png")

qplot(year, Emissions, data=consolidated, geom="bar", stat="identity", main= "Baltimore - Motor Vehicle PM2.5 Emission Trend", ylab= "PM2.5 Emission(tons)")

dev.off()





