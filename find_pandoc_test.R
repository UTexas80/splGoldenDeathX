# Ensure rmarkdown is loaded
# No, do not load rmarkdown globally yet. Let find_pandoc load it or handle its absence.
# library(rmarkdown) 

print("Initial check with rmarkdown::find_pandoc()")
tryCatch({
  # Ensure rmarkdown is available for this call
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("rmarkdown package not found for initial check.")
  }
  found_pandoc <- rmarkdown::find_pandoc()
  print("rmarkdown::find_pandoc() output:")
  print(found_pandoc)
  if (!is.null(found_pandoc$dir)) {
    print("Attempting rmarkdown::pandoc_version() with automatically found pandoc:")
    print(rmarkdown::pandoc_version())
  } else {
    print("rmarkdown::find_pandoc() did not return a directory.")
    # Attempt to call pandoc_version anyway to see the error if find_pandoc returns NULL
    print("Attempting rmarkdown::pandoc_version() even if find_pandoc() returned NULL dir:")
    print(rmarkdown::pandoc_version())
  }
}, error = function(e) {
  print("Error during initial find_pandoc/pandoc_version attempt:")
  print(e)
})

print("--------------------------------------------------------------------")
print("Attempting to set RSTUDIO_PANDOC to path from error message and re-check")

# Path derived from the error message: C:/PROGRA~3/CHOCOL~1/bin/pandoc.exe
# We need the directory, so C:/PROGRA~3/CHOCOL~1/bin
chocolatey_pandoc_dir <- "C:/PROGRA~3/CHOCOL~1/bin"
Sys.setenv(RSTUDIO_PANDOC = chocolatey_pandoc_dir)

print(paste("RSTUDIO_PANDOC set to:", Sys.getenv("RSTUDIO_PANDOC")))

print("Re-checking with rmarkdown::find_pandoc() after setting RSTUDIO_PANDOC")
tryCatch({
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("rmarkdown package not found for RSTUDIO_PANDOC check.")
  }
  found_pandoc_env <- rmarkdown::find_pandoc()
  print("rmarkdown::find_pandoc() output after setting RSTUDIO_PANDOC:")
  print(found_pandoc_env)
  # Regardless of what find_pandoc returns, try pandoc_version
  # because the original issue is about pandoc_version() erroring
  print("Attempting rmarkdown::pandoc_version() after setting RSTUDIO_PANDOC:")
  version_info_env <- rmarkdown::pandoc_version()
  print(version_info_env)
}, error = function(e) {
  print("Error after setting RSTUDIO_PANDOC and trying pandoc_version():")
  print(e)
})

print("--------------------------------------------------------------------")
print("Attempting with suspected full path C:/Program Files (x86)/Pandoc")

program_files_pandoc_dir <- "C:/Program Files (x86)/Pandoc"
Sys.setenv(RSTUDIO_PANDOC = program_files_pandoc_dir)

print(paste("RSTUDIO_PANDOC set to:", Sys.getenv("RSTUDIO_PANDOC")))

print("Re-checking with rmarkdown::find_pandoc() with C:/Program Files (x86)/Pandoc")
tryCatch({
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("rmarkdown package not found for Program Files (x86) check.")
  }
  found_pandoc_pf <- rmarkdown::find_pandoc()
  print("rmarkdown::find_pandoc() output after setting RSTUDIO_PANDOC to Program Files (x86):")
  print(found_pandoc_pf)
  print("Attempting rmarkdown::pandoc_version() with Program Files (x86) path:")
  version_info_pf <- rmarkdown::pandoc_version()
  print(version_info_pf)
}, error = function(e) {
  print("Error after setting RSTUDIO_PANDOC to Program Files (x86) path and trying pandoc_version():")
  print(e)
})

print("--------------------------------------------------------------------")
print("Attempting with suspected full path C:/Program Files (x86)/Pandoc/bin")
program_files_pandoc_dir_bin <- "C:/Program Files (x86)/Pandoc/bin"
Sys.setenv(RSTUDIO_PANDOC = program_files_pandoc_dir_bin)
print(paste("RSTUDIO_PANDOC set to:", Sys.getenv("RSTUDIO_PANDOC")))
tryCatch({
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("rmarkdown package not found for Program Files (x86)/bin check.")
  }
  found_pandoc_pf_bin <- rmarkdown::find_pandoc()
  print("rmarkdown::find_pandoc() output after setting RSTUDIO_PANDOC to Program Files (x86)/Pandoc/bin:")
  print(found_pandoc_pf_bin)
  print("Attempting rmarkdown::pandoc_version() with Program Files (x86)/Pandoc/bin path:")
  print(rmarkdown::pandoc_version())
}, error = function(e) {
  print("Error after setting RSTUDIO_PANDOC to Program Files (x86)/Pandoc/bin path and trying pandoc_version():")
  print(e)
})


print("--------------------------------------------------------------------")
print("Unsetting RSTUDIO_PANDOC to revert to default behavior")
Sys.unsetenv("RSTUDIO_PANDOC")
print(paste("RSTUDIO_PANDOC is now (should be empty): '", Sys.getenv("RSTUDIO_PANDOC"), "'", sep=""))


print("--------------------------------------------------------------------")
print("Final check with rmarkdown::pandoc_available() after unsetting RSTUDIO_PANDOC")
tryCatch({
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("rmarkdown package not found for final check.")
  }
  print("rmarkdown::find_pandoc() after unsetting RSTUDIO_PANDOC:")
  print(rmarkdown::find_pandoc())
  print("rmarkdown::pandoc_available(error = TRUE) reports:")
  # This is the call that would generate the error in the user's case if pandoc is not found correctly
  print(rmarkdown::pandoc_available(version = NULL, error = TRUE)) 
  print("rmarkdown::pandoc_version() reports:")
  print(rmarkdown::pandoc_version())
}, error = function(e) {
  print("Error from rmarkdown::pandoc_available(error = TRUE) or pandoc_version() in final check:")
  print(e)
})
