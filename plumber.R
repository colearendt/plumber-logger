library(magrittr)
library(plumber)

#* @apiTitle Plumber Logging API

#* Log the request exactly as received
#* @filter logRequest
function(req, res) {
  cli::rule(
    left = "Request",
    right = format(Sys.time(), format = "%Y-%m-%d %H:%M:%S")
    ) %>%
    cli::cat_rule()
  as.list(req) %>%
    clean_object() %>%
    jsonlite::toJSON(pretty = TRUE) %>%
    cli::cat_line()
  
  res$status <- 200
  return(NULL)
  #plumber::forward()
}

# a manual cleanup function...
# we should really be able to do better than this!
clean_object <- function(obj){
  obj[["httpuv.version"]] <- capture.output(str(obj[["httpuv.version"]]))
  obj[["args"]][["res"]] <- NULL
  obj[["args"]][["req"]] <- NULL
  obj[["rook.errors"]] <- capture.output(str(obj[["rook.errors"]]))
  obj[["rook.input"]] <- capture.output(str(obj[["rook.input"]]))
  return(obj)
}

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
#* @get /
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}
