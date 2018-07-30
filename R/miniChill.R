#' miniChill: A package for calculating chill portions with C++
#'
#' The miniChill package has one functionality: calculate chill portions of the
#' Dynamic Model from a vector of temperatures. As this calculation is sequential,
#' it requires a loop. It is implemented in C++ to make it faster.
#' 
#' @section Foo functions:
#' \code{chill_func} calculates chill portions from a vector of temperatures.
#'
#' @docType package
#' @name miniChill
NULL