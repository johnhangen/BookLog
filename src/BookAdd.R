library(mongolite)
library(jsonlite)
library(tidyverse)

# adding new books to mongodb with command line

auth <- read_excel("../src/auth.xlsx")

connection_string = sprintf('mongodb+srv://%s:%s@testmongo.lpnpetn.mongodb.net/?retryWrites=true&w=majority',auth$auth[1], auth$auth[2])
book_collection = mongo(collection="BookLog", db="BookLogMongo", url=connection_string)

addBook <- function() {
  name <- readline(prompt = "What is the name of the book?")
  genre <- readline(prompt = "What is the genre of the book?")
  StartDate <- readline(prompt = "When did you start reading the book?")
  endDate <- readline(prompt = "When did you stop reading the book?")
  author <- readline(prompt = "Who is the author of the book?")
  numberOfPages <- readline(prompt = "How many pages did the book have?")
  rating <- readline(prompt = "What would you rate the book?")

  bookInfo <- data.frame(c(name), c(genre), c(StartDate), c(endDate), c(author), c(numberOfPages), c(rating))
  colnames(bookInfo) <- c('Title', 'Author', "genre", 'Start_date', 'End_date', 'Num_pages', 'Rating')

  book_collection$insert(bookInfo)
}

main <- function () {
  res <- readline(prompt = "Would you like to add a book? (y/n) ")
  if(res == 'y') {
    addBook()

    main()

  } else {
    print("Will not add book to database")
  }
}

main()



