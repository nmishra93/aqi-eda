library(httr)
library(jsonlite)

# Neede this as `curl` was running into certificate expiration issues
set_config(config(ssl_verifypeer = FALSE))
options(RCurlOptions = list(ssl_verifypeer = FALSE))
options(rsconnect.check.certificate = FALSE)

# TESTING AND IT WORKED
# Get the token
# url <- "https://app.cpcbccr.com/dataRepository/download_file?file_name=Raw_data/1Hr/2022/site_117_ITO_Delhi_CPCB_1Hr.csv" # nolint
#
# data <- GET(url)
#
# class(data)
#
# data$status_code
#
#
# content(data, "text", encoding = "UTF-8") |>
#   writeLines(
#     "data.csv"
#   )

# Getting station IDs
station_ids <-
  fromJSON("raw/station_ids.json")

delhi_stations <-
  station_ids$dropdown$stations$Delhi
faridabad_stations <-
  station_ids$dropdown$stations$Faridabad
gurugram_stations <-
  station_ids$dropdown$stations$Gurugram
ghaziabad_stations <-
  station_ids$dropdown$stations$Ghaziabad
noida_stations <-
  station_ids$dropdown$stations$Noida
alwar_stations <-
  station_ids$dropdown$stations$Alwar
meerut_stations <-
  station_ids$dropdown$stations$Meerut
bhiwadi_stations <-
  station_ids$dropdown$stations$Bhiwadi
greater_noida_stations <-
  station_ids$dropdown$stations$`Greater Noida`

# creating url list
base_url <- "https://app.cpcbccr.com/dataRepository/download_file?file_name=Raw_data/1Hr/" # nolint

years <- c(2017:2022)

# Merge the two columns using paste
gurugram_stations$merged_column <- paste(gurugram_stations$value,
  gsub(
    ",", "",
    gsub(
      " - | ", "_",
      gurugram_stations$label
    )
  ),
  "1Hr.csv",
  sep = "_"
)

# View the resulting data frame
filenames <- gurugram_stations$merged_column

url_list <-
  paste0(
    base_url,
    rep(years, length(filenames)),
    "/",
    rep(filenames, each = length(years))
  )

# Downloading the data by for loop
# write a for loop to run on the above  code
for (url in url_list) {
  delay <- sample(
    x = round(abs(rnorm(10, 5, 2)), 4),
    size = 1
  )

  cat("Waiting for", round(delay, 1), "seconds before next request...\n")
  cat("Starting next download.\n")

  Sys.sleep(delay)

  filename <- sub(".*/(\\d+)/(.*)", "\\1_\\2", url)

  print(url)

  data <- GET(url)

  print(data$status_code)

  if (data$status_code == 200) {
    cat("Downloading", filename, "\n")

    csv <- content(data, "text", encoding = "UTF-8")

    writeLines(
      csv,
      con = filename
    )

    cat("File Successfully Downloaded!\n\n")
  } else {
    cat("Error:", data$status_code, "\n")
  }
}
