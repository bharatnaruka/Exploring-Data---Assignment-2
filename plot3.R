require("ggplot2")
require("sqldf")

emissiondata <- readRDS("summarySCC_PM25.rds")

baltimoreData <- emissiondata[emissiondata$fips == "24510",]

consolidated <- sqldf("select sum(Emissions) as Emission, type, year from baltimoreData group by type, year")


consolidated$year <- as.character(consolidated$year)


png("plot3.png")

qplot(year, Emission, data=consolidated, geom="bar", stat="identity", fill=year, ylab="Emission(tons)", main= "Baltimore PM2.5 Emission Trend by Type") + facet_grid(~type) + theme(axis.text.x = element_text(angle = 60))

dev.off()


