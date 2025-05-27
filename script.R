print("Attempting to get Pandoc version via rmarkdown::pandoc_version()")
tryCatch({
  version_info <- rmarkdown::pandoc_version()
  print("rmarkdown::pandoc_version() output:")
  print(version_info)
}, error = function(e) {
  print("Error when calling rmarkdown::pandoc_version():")
  print(e)
})

print("Attempting to get Pandoc version via system command")
tryCatch({
  system_pandoc_out <- system("pandoc --version", intern = TRUE)
  print("system(\"pandoc --version\") output:")
  print(system_pandoc_out)
}, error = function(e) {
  print("Error when calling system(\"pandoc --version\"):")
  print(e)
})

sessionInfo()
