source("renv/activate.R")
# LanguageServer Setup Start (do not change this chunk)
# to remove this, run languageserversetup::remove_from_rprofile
if (requireNamespace('languageserversetup', quietly = TRUE)) {
  options(langserver_library = 'C:/Users/falkg/Documents/languageserver-library')
  languageserversetup::languageserver_startup()
  unloadNamespace('languageserversetup')
}
# LanguageServer Setup End
options(repos = c(
  mlrorg = "https://mlr-org.r-universe.dev",
  CRAN = "https://cran.rstudio.com/"
))

# Ensure reproducibility of Python environment setup
if (requireNamespace("reticulate", quietly = TRUE)) {
  
  # Define the preferred project-specific virtualenv
  venv_path <- file.path(getwd(), ".venv")
  
  if (dir.exists(venv_path)) {
    # Use the project's virtual environment if available
    message("Using project virtualenv: ", venv_path)
    reticulate::use_virtualenv(venv_path, required = TRUE)
    
  } else {
    # Fallback to system Python
    message("No .venv found, falling back to system Python")
    # You can replace "python3" with a specific path if needed
    reticulate::use_python(Sys.which("python3"), required = FALSE)
  }
  
} else {
  message("reticulate not installed, skipping Python setup")
}
# LanguageServer Setup Start (do not change this chunk)
# to remove this, run languageserversetup::remove_from_rprofile
if (requireNamespace('languageserversetup', quietly = TRUE)) {
  options(langserver_library = 'C:/Users/falkg/Documents/languageserver-library')
  languageserversetup::languageserver_startup()
  unloadNamespace('languageserversetup')
}
# LanguageServer Setup End
