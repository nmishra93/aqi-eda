# Install and load the httr package if you haven't already
# install.packages("httr")
library(httr)
library(jsonlite)
library(tidyverse)


key <- Sys.getenv("DATA_GOV_API_KEY")
format <- "json"
limit <- "all"
base_url <- "https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69"

# create the url based on set parameters
url <-
  paste0(
    base_url, "?api-key=",
    key, "&format=",
    format, "&limit=", limit
  )

response <- GET(url)

# Check if the request was successful (status code 200)
if (http_status(response)$category == "Success") {
  # Parse the JSON response
  data <- content(response, as = "parsed", encoding = "UTF-8")

  # Print or process the data as needed
  print(data)
} else {
  # Print an error message if the request was not successful
  print(paste("Error:", http_status(response)$reason))
}

json_list <-
  toJSON(data, pretty = TRUE) |>
  # parse to a tibble
  jsonlite::fromJSON()

data <-
  json_list$records |>
  tibble::as_tibble() |>
  tidyr::unnest()

# generate a filename based on current datetime
filename <-
  paste0("data/data_gov_realtime_aqi_api_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv")

# write the data to a csv file
write_csv(data, filename)
