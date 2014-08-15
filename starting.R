# Enough to get started

# Set these variables:
dbName <- "/path/to/your/sqlite.db"
    # Weather data will end up in the database, eventually
    # uManage grabs the past month's statistics from
    # http://www.wunderground.com/history/airport/$airport/$yy/$mm/$dd/MonthlyHistory.html?format=1
    # with some minor pre-processing on (or near) the first of
    # every month

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
weather <- dbGetQuery(dbFile, "select * from weather")
weather <- as.data.table(weather)
pauses <- dbGetQuery(dbFile, "select * from pauses")
pauses <- as.data.table(pauses)
keepalives <- dbGetQuery(dbFile, "select * from keepalives")
keepalives <- as.data.table(keepalives)

# And the table added to from TypeTime
reaction <- dbGetQuery(dbFile, "select * from reaction")
reaction <- as.data.table(reaction)

# What do we have?
summary(weather)
summary(activity)
summary(pauses)
summary(keepalives)
summary(reaction)

# Some basic plotting regarding how long I'm using programs in general.
plot(sort(activity[[4]]))
plot(sort(log(activity[[4]])))

# Don't forget that the long items may be mostly idle.
plot(sort(log(activity[[4]] - activity[[5]])))

# A histogram might give us a rough idea of attention span.
# (Looks like around 2-10 minutes.)
hist(log(activity[[4]]))
hist(log(abs(activity[[4]] - activity[[5]])))

# Add the date, to make the data comparable to daily data
activity$date <- substring(activity[[1]], 1, 10)
pauses$date <- substring(pauses[[1]], 1, 10)
keepalives$date <- substring(keepalives[[1]], 1, 10)

# Set the dates as keys, probably needs more work
setkey(activity, date)
setkey(pauses, date)
setkey(keepalives, date)
setkey(weather, date)
setkey(reaction, date)

# Make sure we have our bearings
ls()

# What do the tables look like together?
act_wx <- activity[weather]
wx_act <- weather[activity]
summary(act_wx)
summary(wx_act)

# Right now, the only pauses I have logged are of one sort
plot(strptime(pauses[[2]],format="%Y-%m-%dT%T") - strptime(pauses[[1]],format="%Y-%m-%dT%T"))
# But we can also filter the table based on the reason
exercise <- pauses[reason == "Exercise"]
plot(strptime(exercise[[2]],format="%Y-%m-%dT%T") - strptime(exercise[[1]],format="%Y-%m-%dT%T"))

