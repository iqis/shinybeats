#' Evaluate an Expression on a Fixed Time Interval
#'
#' Can be used as a keepalive utility for external connections such as SSH and WebSocket, or Shiny itself; Can also be used as a watchdog to periodically check on something.
#'     This functions is thin wrapper around shiny::reactiveTimer() and shiny::observe()
#'
#' @param seconds time interval in seconds
#' @param do expression
#' @param ... any other arguments passed to shiny::observe()
#'
#' @return Shiny observer
#' @export
#'
#' @seealso [shiny::observe()]
#'
#' @examples
#'
#' \dontrun{
#' every(60, {
#'   cat("Keeping Connection Alive...\n")
#'   ssh::ssh_exec_internal(session = my_session,
#'                          command = "whoami")
#' })
#'
#' shinyApp(
#' fluidPage(
#'    shinyjs::useShinyjs(),
#'    actionButton("stop", "Stop"),
#'    textInput("blinker", "Blinker Input"),
#'),
#'function(input, output, session) {
#'    heartbeat <- shinybeats::every(1.2, {
#'        shinyjs::toggle("blinker")
#'    })
#'
#'    observeEvent(input$stop,{
#'        heartbeat$destroy()
#'    })
#'}
#')
#'}
every <- function(seconds = 1, do = cat("Thump!"), ...){
    func <- function(){}
    environment(func) <- parent.frame()
    body(func) <- substitute(do)

    timer <- shiny::reactiveTimer(seconds * 1000)
    shiny::observe(
        x = {
            timer()
            func()
        },
        ...)
}
