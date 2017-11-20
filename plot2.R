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

png("plot2.png")
plot(filteredPowerData$Date, as.numeric(filteredPowerData$Global_active_power), type = "l", xlab="", ylab = "Global Active Power (kilowatts)", main = "")
dev.off()