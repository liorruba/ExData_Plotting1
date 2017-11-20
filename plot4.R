library(data.table)
library(lubridate)

dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
reqDateRange <- c(as.Date("2007-02-01"), as.Date("2007-02-02"))

# Download the data:
if (!file.exists("power_data.zip"))
  download.file(dataUrl, destfile = "power_data.zip")

# Unzip the file:
if (!dir.exists("household_power_consumption.txt"))
  unzip("power_data.zip")

# Read the data:
if (!exists("powerData")){
  print("Dataset doesn't exist in memory, reading from file...")
  powerData  <- fread(input = "household_power_consumption.txt", header = TRUE)
  
  # Filter the data according to the requested dates:
  powerData$Date <- as.Date(powerData$Date, "%d/%m/%Y")
  logicalRange <- powerData$Date >= reqDateRange[1] & powerData$Date <= reqDateRange[2]
  
  filteredPowerData <- powerData[logicalRange,]
  
  # Convert first column to datetime:
  filteredPowerData$Date <- paste(filteredPowerData$Date,filteredPowerData$Time)
  dateTime <- strptime(filteredPowerData$Date, "%Y-%m-%d %H:%M:%S")
  
  filteredPowerData[,1] <- data.table(dateTime)
}

png("plot4.png")
par(mfrow=c(2,2))
# First plot:
plot(filteredPowerData$Date, as.numeric(filteredPowerData$Global_active_power), type = "l",xlab="", ylab = "Global Active Power (kilowatts)", main = "")

# Second plot:
plot(filteredPowerData$Date, as.numeric(filteredPowerData$Voltage), type = "l", xlab = "datetime", ylab = "Voltage (kilowatts)", main = "")

#Third plot:
plot(filteredPowerData$Date, as.numeric(filteredPowerData$Sub_metering_1), type = "l", xlab="", ylab = "Global Active Power (kilowatts)", main = "", col="black")
lines(filteredPowerData$Date, as.numeric(filteredPowerData$Sub_metering_2), type = "l", ylab = "Global Active Power (kilowatts)", main = "", col="red")
lines(filteredPowerData$Date, as.numeric(filteredPowerData$Sub_metering_3), type = "l", ylab = "Global Active Power (kilowatts)", main = "", col="blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black","red", "blue"), lwd = 1)

# Fourth plot:
plot(filteredPowerData$Date, as.numeric(filteredPowerData$Global_reactive_power), type = "l", xlab="datetime", ylab = "global_reactive_power", main = "", col="black")
dev.off()