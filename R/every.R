#' Evaluate an Expression on a Fixed Time Interval
#'
#' @param seconds time interval in seconds
#' @param do expression
#' @param ... any other arguments passed to shiny::observe()
#'
#' @return Shiny observer
#' @export
#'
#' @seealso [shiny::observe]
#'
#' @examples
every <- function(seconds, do, ...){
    func <- function(){}
    environment(func) <- parent.frame()
    body(func) <- substitute(do)

    timer <- shiny::reactiveTimer(seconds * 1000)
    shiny::observe(x = {
        timer()
        func()
    }, ...)
}
