# Enough to get started

# Set these variables:
dbName <- "/path/to/your/sqlite.db"
wxName <- "/path/to/any/weather.csv"
    # Weather data will end up in the database, eventually
    # I grab the monthly statistics from
    # http://www.wunderground.com/history/airport/$airport/$yy/$mm/$dd/MonthlyHistory.html?format=1
    # with some minor processing

# Use these to manage the data.
install.packages("data.table")
install.packages("RSQLite")
require(data.table)
require(RSQLite)

# Connect to the database.
drv <- dbDriver("SQLite")
dbFile <- dbConnect(drv, dbname = dbName)

# Get the data and use the data tables
activity <- dbGetQuery(dbFile, "select * from activity")
activity <- as.data.table(activity)
weather <- read.csv("weather.csv")
weather <- as.data.table(weather)

# What do we have?
summary(weather)
summary(activity)

# Set the dates as keys, probably needs more work
setkey(activity, start)
setkey(weather, Year.Month.Day)

# Some basic plotting regarding how long I'm using programs in general.
plot(sort(activity[[4]]))
plot(sort(log(activity[[4]])))

# Don't forget that the long items may be mostly idle.
plot(sort(log(activity[[4]] - activity[[5]])))
