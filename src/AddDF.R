library(jsonlite)
library(mongolite)
library(readxl)

# Used to add large number of books from json

auth <- read_excel("C://Users//12034//Desktop//Fall2022//BookLog//src//auth.xlsx")
df <- fromJSON('Data/example.json')

bookInfo <- data.frame(df$Title, df$Author, df$Genre, df$Start_date, df$End_date, df$Num_pages, df$Rating)
colnames(bookInfo) <- c('Title', 'Author', "genre", 'Start_date', 'End_date', 'Num_pages', 'Rating')

# read in from mongodb
connection_string = sprintf('mongodb+srv://%s:%s@testmongo.lpnpetn.mongodb.net/?retryWrites=true&w=majority',auth$auth[1], auth$auth[2])
book_collection = mongo(collection="BookLog", db="BookLogMongo", url=connection_string)

# add the local json object to mongoDB
book_collection$insert(bookInfo)