# Ensure rmarkdown is loaded
library(rmarkdown)

# Attempt to get Pandoc version
print("Attempting rmarkdown::pandoc_version() after setting RSTUDIO_PANDOC in munge/99-Z.R")
tryCatch({
  version_info <- rmarkdown::pandoc_version()
  print("rmarkdown::pandoc_version() output:")
  print(version_info)
}, error = function(e) {
  print("Error when calling rmarkdown::pandoc_version():")
  print(e)
})

# Also check pandoc_available()
print("Attempting rmarkdown::pandoc_available() after setting RSTUDIO_PANDOC in munge/99-Z.R")
tryCatch({
  available <- rmarkdown::pandoc_available()
  print("rmarkdown::pandoc_available() output:")
  print(available)
  if (available) {
    print("Pandoc is available according to rmarkdown.")
  } else {
    print("Pandoc is NOT available according to rmarkdown.")
  }
}, error = function(e) {
  print("Error when calling rmarkdown::pandoc_available():")
  print(e)
})
