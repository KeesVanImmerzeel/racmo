#' racmo: Download and Process RACMO NetCDF Data
#'
#' The **racmo** package provides tools to download and process meteorological data
#' from RACMOv2.3 (KNMI Data Platform) used for STOWA drought statistics.
#' It includes functions to:
#' \itemize{
#'   \item Retrieve file lists from the KNMI API: \link{get_filenames}
#'   \item Download and convert NetCDF files into projected SpatRaster stacks: \link{download_and_load_raster}
#' }
#'
#' Data source: \link{url} (see \url{https://dataplatform.knmi.nl/dataset/knmi23-droogtestatistiek-1-0})
#'
#' @section Functions:
#' \describe{
#'   \item{\link{get_filenames}}{Retrieve filenames from the KNMI API.}
#'   \item{\link{download_and_load_raster}}{Download and process NetCDF files into raster stacks.}
#' }
#'
#' @section Constants:
#' \describe{
#'   \item{\link{url}}{URL constant pointing to KNMI dataset.}
#' }
#'
#' @keywords internal
"_PACKAGE"
#'
#' @importFrom httr GET add_headers content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom ncdf4 nc_open nc_close ncvar_get
#' @importFrom terra rast ext crs project names
#' @importFrom CFtime CFtime as_timestamp
#' @importFrom utils download.file
NULL
