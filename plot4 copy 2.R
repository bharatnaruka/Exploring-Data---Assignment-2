## read the file from wrking dir
power_con_data <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?")

## get data into a dataframe only for two dates
TwoDay <- power_con_data[(power_con_data$Date == "2/1/2007")|(power_con_data$Date == "2/2/2007"),]



## Convert Date column into Date class
TwoDay$Date <- as.Date(TwoDay$Date, "%m/%d/%Y")

## concatenate date and time
TwoDay$DateTime <- paste(TwoDay$Date, TwoDay$Time, sep=" ")

## convert date and time with striptime
TwoDay$DateTime <- strptime(TwoDay$DateTime,"%Y-%m-%d %H:%M:%S", tz="EST5EDT")


## open PNG device
png(file="plot4.png",width=480, height=480, unit="px")


par(mfrow=c(2,2), mar=c(4,4,4,4), oma=c(0,0,0,0))

##Date v/s active power
with(TwoDay, plot(DateTime,Global_active_power, type="l",xlab="", ylab="Global Active Power (kilowatts)"))

## Date v/s Voltage
with(TwoDay, plot(DateTime,Voltage, type="l",xlab="datetime", ylab="Voltage"))

## Date v/s sub metering
with(TwoDay, plot(DateTime, Sub_metering_1, type="n",ylim=c(0,30),xlab="", ylab="Energy sub metering"))
with(TwoDay, points(DateTime, Sub_metering_1, type="l"))
with(TwoDay, points(DateTime, Sub_metering_2, type="l", col="red"))
with(TwoDay, points(DateTime, Sub_metering_3, type="l", col="blue"))
legend("topright", col=c("black","red","blue"), pch="-", border="white", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

## Date v/s Voltage
with(TwoDay, plot(DateTime,Global_reactive_power, type="l",xlab="datetime"))




## close device
dev.off()