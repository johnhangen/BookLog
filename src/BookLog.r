library(mongolite)
library(jsonlite)
library(tidyverse)
library(readxl)
library(lubridate)

# Working with data
auth <- read_excel("C:/Users/12034/Desktop/winter/BookLog/src/auth.xlsx")

# read in from mongodb
connection_string = sprintf('mongodb+srv://%s:%s@testmongo.lpnpetn.mongodb.net/?retryWrites=true&w=majority',auth$auth[1], auth$auth[2])
book_collection = mongo(collection="BookLog", db="BookLogMongo", url=connection_string)

df <- data.frame(book_collection$find('{}'))

df$Start_date <- as.Date(df$Start_date, "%m/%d/%Y")
df$End_date <- as.Date(df$End_date, "%m/%d/%Y")

# making main graph
p <- ggplot(data = df, aes(y = Num_pages, color = genre)) +
  geom_segment(aes(x = Start_date, xend = End_date, y = Num_pages, yend=Num_pages), size = 5) +
  labs(title="Time Taken to Read vs Number of Pages", x = "Date", y = "Number of Pages", color = "Genre") +
  theme_minimal()

ggsave('Graphs/Main.png',bg="white")

# making pie chart
pie <- ggplot(df, aes(x="", y=genre, fill = genre)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  labs(title = "Amount Read per Genre",fill = "Genre") +
  theme_void()

ggsave('Graphs/pie.png',bg="white")

# making line chart
line <- ggplot(df) +
  geom_line(aes(x = Start_date, xend = End_date, y = Num_pages, yend=Num_pages)) +
  geom_point(aes(x = Start_date, xend = End_date, y = Num_pages, yend=Num_pages)) +
  labs(title="Amount of Pages Read", x = "Date", y = "Number of Pages") +
  theme_minimal()

ggsave('Graphs/line.png',bg="white")

# books per month
bar <- ggplot(df, aes(x=month(End_date), fill=genre)) +
  geom_bar(stat="bin") +
  labs(title="Amount of Books Read per Month", x = "Months (when the book was finished)", fill="Genre") +
  scale_y_discrete(name = "Number of Books", limits=c("0", "2", "3", "4", "5", "6") )+
  #scale_x_discrete(breaks = c("8","9","10","11","12"),labels=c("August","September","October","November","December")) +
  theme_minimal()

ggsave('Graphs/bar.png',bg="white")

