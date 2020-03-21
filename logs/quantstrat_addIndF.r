function (strategy, name, arguments, parameters = NULL, label = NULL, 
  ..., enabled = TRUE, indexnum = NULL, store = FALSE) 
{
  if (!is.strategy(strategy)) {
    strategy <- try(getStrategy(strategy))
    if (inherits(strategy, "try-error")) 
      stop("You must supply an object or the name of an object of type 'strategy'.")
    store = TRUE
  }
  tmp_indicator <- list()
  tmp_indicator$name <- name
  if (is.null(label)) {
    label <- paste(name, "ind", sep = ".")
    gl <- grep(label, names(strategy$indicators))
    if (!identical(integer(0), gl)) 
      label <- paste(label, length(gl) + 1, sep = ".")
  }
  tmp_indicator$label <- label
  tmp_indicator$enabled = enabled
  if (!is.list(arguments)) 
    stop("arguments must be passed as a named list")
  tmp_indicator$arguments <- arguments
  if (!is.null(parameters)) 
    tmp_indicator$parameters = parameters
  if (length(list(...))) 
    tmp_indicator <- c(tmp_indicator, list(...))
  indexnum <- if (!is.null(indexnum)) {
    indexnum
  }
  else label
  tmp_indicator$call <- match.call()
  class(tmp_indicator) <- "strat_indicator"
  strategy$indicators[[indexnum]] <- tmp_indicator
  strategy$trials <- strategy$trials + 1
  if (store) 
    assign(strategy$name, strategy, envir = as.environment(.strategy))
  else return(strategy)
  strategy$name
}