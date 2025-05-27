Sys.setenv(RSTUDIO_PANDOC = "C:/PROGRA~3/CHOCOL~1/bin")
library(data.table)
# library(gdata) # For lsos() - Commented out due to issues
library(rmarkdown) # For rmarkdown::run

# VERSION HISTORY
z99.version <- "1.0.0"
# VERSION HISTORY
z99.version = "1.0.0"
z99.ModDate <- as.Date("2019-06-09")
################################################################################
## Step 99.00 create object table                                            ###
################################################################################
# Commenting out problematic lines:
# dtObj <- setDT(lsos(), keep.rownames = T)[]
# names(dtObj)[1] <- "Name" ### rename data.table column
# lsObj <- list(dtObj[Type == "data.table" & Length_Rows == 0][, 1])
# # dtObj[Type=='data.table' & Length_Rows == 0]
################################################################################
# df <- ls()[sapply(ls(), function(x) is.data.frame(get(x)) | is.xts(get(x)))] # Might fail if specific objects not created
# l <- ls()[sapply(ls(), function(x) is.data.frame(get(x)))] # Might fail
################################################################################
## Step 99.01 remove unwanted data.frames; e.g. 'metadata' in its name       ###
################################################################################
# rm(list = ls()[grepl("(SQL|metadata)", ls())]) # Might fail if specific objects not created
################################################################################
## Step 99.02: Processing                                                    ###
################################################################################
print(paste("RSTUDIO_PANDOC before rmarkdown::run:", Sys.getenv("RSTUDIO_PANDOC")))
print("Calling rmarkdown::find_pandoc():")
print(rmarkdown::find_pandoc())
print("Calling rmarkdown::pandoc_version():")
print(rmarkdown::pandoc_version())

# Attempt to check if the target Rmd file exists
rmd_file_path <- "./SPL-Dashboard/FlexDashboard.Rmd" # Corrected case
if (file.exists(rmd_file_path)) {
  print(paste("Attempting to run:", rmd_file_path))
  rmarkdown::run(rmd_file_path)
} else {
  print(paste("Error: R Markdown file not found at", rmd_file_path))
  print(paste("Current working directory:", getwd()))
  print("Files in SPL-Dashboard directory:")
  print(list.files("./SPL-Dashboard"))
}

# ------------------------------------------------------------------------------
# rmarkdown::render(input="./reports/dashboard.Rmd")
# rmarkdown::render(input="./dashboard/Flexdashboard.Rmd")
### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Step 99.02 Deploy to Shiny Server                                       ####
### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
# rsconnect::deployApp(appDir = "~/GitHub/splGoldenDeathX/SPL-Dashboard",
#                      appFileManifest = "C:/Users/gfalk/AppData/Local/Temp/4727-31b7-99eb-d3f2",
#                      appPrimaryDoc = "FlexDashboard.Rmd",
#                      appSourceDoc = "~/GitHub/splGoldenDeathX/SPL-Dashboard/FlexDashboard.Rmd",
#                      account = "utexas80",
#                      server = "shinyapps.io",
#                      appName = "FlexDashboard",
#                      appId = 2485642,
#                      launch.browser = function(url) {message("Deployment completed: ", url)},
#                      lint = FALSE,
#                      metadata = list(asMultiple = FALSE, asStatic = FALSE),
#                      logLevel = "verbose")

#  rsconnect::deployApp(appDir = "~/GitHub/splGoldenDeathX/SPL-Dashboard",
#                       appFileManifest = "C:/Users/gfalk/AppData/Local/Temp/2a6d-2e35-c5e7-3dab",
#                       appPrimaryDoc = "FlexDashboard.Rmd",
#                       appSourceDoc = "~/GitHub/splGoldenDeathX/SPL-Dashboard/FlexDashboard.Rmd",
#                       account = "utexas80",
#                       server = "shinyapps.io",
#                       appName = "FlexDashboard",
#                       appId = 2485642,
#                       launch.browser = function(url) {message("Deployment completed: ", url)},
#                       lint = FALSE,
#                       metadata = list(asMultiple = FALSE, asStatic = FALSE),
#                       logLevel = "verbose")
################################################################################
## Call rmarkdown::run() instead of render() because it is a shiny document  ### https://tinyurl.com/y2y2azny
## (http://rmarkdown.rstudio.com/authoring_shiny.html).                      ###
################################################################################
# rmarkdown::run("./reports/Flexdashboard.Rmd")
# rmarkdown::run("./reports/_Flexdashboard.Rmd")
# xaringan::infinite_moon_reader("./reports/dashboard.Rmd")
################################################################################
## Step 99.02: Diagnostics                                                   ###
################################################################################
s.info <- sessionInfo()
diagnostic <- data.frame("Version", "Date")
diagnostic[, 1] <- as.character(diagnostic[, 1])
diagnostic[, 2] <- as.character(diagnostic[, 2])
diagnostic.names <- NULL
# MAGIC NUMBER ## Strings have not member names - Depends on sessionInfo() -----
ver <- strsplit(s.info[["R.version"]][["version.string"]][1], " ")[[1]][3]
dat <- as.character(substr(strsplit(s.info[["R.version"]][["version.string"]][1], " ")[[1]][4], 2, 11))
diagnostic <- rbind(diagnostic, c(ver, dat))
ver <- s.info[["platform"]][1]
dat <- ""
diagnostic <- rbind(diagnostic, c(ver, dat))
diagnostic.names <- c(diagnostic.names, "R Version", "platform")

if (length(s.info[["otherPkgs"]]) > 0) {
  for (i in 1:length(s.info[["otherPkgs"]])) {
    ver <- s.info[["otherPkgs"]][[i]]$Version
    dat <- as.character(s.info[["otherPkgs"]][[i]]$Date)
    if (length(dat) == 0) {
      dat <- " "
    }
    diagnostic <- rbind(diagnostic, c(ver, dat))

    diagnostic.names <- c(diagnostic.names, s.info[["otherPkgs"]][[i]]$Package)
  }
}

if (length(s.info[["loadedOnly"]]) > 0) {
  for (i in 1:length(s.info[["loadedOnly"]])) {
    ver <- s.info[["loadedOnly"]][[i]]$Version
    dat <- as.character(s.info[["loadedOnly"]][[i]]$Date)
    if (length(dat) == 0) {
      dat <- " "
    }
    diagnostic <- rbind(diagnostic, c(ver, dat))

    diagnostic.names <- c(diagnostic.names, s.info[["loadedOnly"]][[i]]$Package)
  }
}

# Add code diagnostic information
# These variables (a00.version, a00.ModDate, etc.) might not be defined
# if their respective scripts (00-A.R, etc.) haven't been run.
# Adding tryCatch for safety.
tryCatch({
  diagnostic <- rbind(diagnostic, c(a00.version, as.character(a00.ModDate)))
  diagnostic.names <- c(diagnostic.names, "00-A")
}, error = function(e) { print("00-A version/date not found") })

tryCatch({
  diagnostic <- rbind(diagnostic, c(a01.version, as.character(a01.ModDate)))
  diagnostic.names <- c(diagnostic.names, "01-A") # Should be 01-Performance or similar based on file names
}, error = function(e) { print("01-A version/date not found") }) # Corrected name

diagnostic <- rbind(diagnostic, c(z99.version, as.character(z99.ModDate)))
diagnostic.names <- c(diagnostic.names, "99-Z")

diagnostic <- diagnostic[-1, ]
colnames(diagnostic) <- c("Version", "Date")
rownames(diagnostic) <- diagnostic.names
last.diagnostic <- 1
diagnostic.rows <- 19 # MAGIC NUMBER - TRIAL & ERROR

# Commenting out textplot as it requires X11 typically
# while (last.diagnostic <= nrow(diagnostic)) {
#   tmp.diagnostic <- diagnostic[last.diagnostic:min(nrow(diagnostic), last.diagnostic + diagnostic.rows), ]
#   # layout(c(1,1))
#   # textplot(cbind(tmp.diagnostic),valign="top")
# 
#   last.diagnostic <- last.diagnostic + diagnostic.rows + 1
# }

# The 'tables' function might not be available in basic data.table,
# it's more of a summary often used interactively or from other packages.
# dtTables <- data.table::tables() 
# lTables <- lsos() # lsos() was causing issues
# ------------------------------------------------------------------------------
# 'start.time' is not defined in this script. Commenting out.
# finish.time <- Sys.time()
# timeProcessing <- finish.time - start.time
# print(finish.time - start.time)
################################################################################
## Step 99.99: VERSION HISTORY                                               ###
## http://tinyurl.com/y54k8gsw                                               ###
## http://tinyurl.com/yx9w8vje                                               ###
################################################################################
# These are likely defined in 00-A.R, not here.
# a00.version <- "1.0.0"
# a00.ModDate <- as.Date("2019-06-19")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
#  1st release
