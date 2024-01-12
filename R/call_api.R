# This script makes an API call to retrieve real-time air quality index (AQI) data from the data.gov.in website.
# It uses the httr package to send HTTP requests and retrieve the response.
# The retrieved data is then processed and saved to a CSV file.

# Load the required packages
library(httr)
library(jsonlite)
library(tidyverse)

# Get the API key from the system environment variable
key <- Sys.getenv("DATA_GOV_API_KEY")

# Set the format and limit for the API request
format <- "json"
limit <- "all"

# Set the base URL for the API
base_url <- "https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69"

# Create the URL with the set parameters
url <- paste0(base_url, "?api-key=", key, "&format=", format, "&limit=", limit)

# Make the API request and handle any errors
tryCatch(
  {
    response <- GET(url)

    # Check if the request was successful (status code 200)
    if (http_status(response)$category == "Success") {
      # Parse the JSON response
      data <- content(response, as = "parsed", encoding = "UTF-8")

      # Print or process the data as needed
      cat("API call successful.\nReceived", length(data$records), "records.\n")
    } else {
      # Print an error message if the request was not successful
      print(paste("Error:", http_status(response)$reason))
    }
  },
  error = function(e) {
    # Handle any errors, including DNS resolution issues
    print(paste("Error:", e$message))
  }
)

# Process and save the data if it exists
if (exists("data")) {
  # Convert the JSON response to a tibble
  json_list <- toJSON(data, pretty = TRUE) |>
    jsonlite::fromJSON()

  # Convert the tibble to a data frame and unnest the nested columns
  data <- json_list$records |>
    tibble::as_tibble() |>
    tidyr::unnest(
      cols = c(
        country, state, city, station, last_update, latitude, longitude,
        pollutant_id, pollutant_min, pollutant_max, pollutant_avg
      )
    )

  # Generate a filename based on the current datetime
  filename <- paste0(
    "data/api/data_gov_realtime_aqi_api_",
    format(
      Sys.time(),
      "%Y%m%d_%H%M%S"
    ),
    ".csv"
  )

  # Write the data to a CSV file
  write_csv(data, filename)
}
