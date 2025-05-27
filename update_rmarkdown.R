print("Attempting to update rmarkdown package...")
install.packages("rmarkdown", repos = "http://cran.us.r-project.org")

print("Verifying rmarkdown version after update attempt:")
tryCatch({
  library(rmarkdown)
  print(packageVersion("rmarkdown"))
}, error = function(e) {
  print("Error loading rmarkdown after update attempt:")
  print(e)
})

print("Attempting to get Pandoc version via rmarkdown::pandoc_version() after rmarkdown update")
tryCatch({
  version_info <- rmarkdown::pandoc_version()
  print("rmarkdown::pandoc_version() output:")
  print(version_info)
}, error = function(e) {
  print("Error when calling rmarkdown::pandoc_version():")
  print(e)
})
