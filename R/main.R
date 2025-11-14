#' Retrieve filenames from an API endpoint
#'
#' Sends an HTTP GET request to the specified URL with query parameters and a Bearer token.
#' Parses the JSON response and returns a data frame of file information.
#'
#' @param url Character. The full API endpoint URL.
#' @param maxKeys Numeric. Maximum number of file entries to retrieve. Default is 100000.
#' @param sorting Character. Sorting order for the files, e.g., "asc" or "desc". Default is "asc".
#' @param token Character. Bearer token for authentication.
#'
#' @return A data frame containing file information (e.g., filenames and metadata).
#'
#' @examples
#' \dontrun{
#' download filenames and apply a filter to create a single filename.
#' df <- get_filenames(url, maxKeys = 100000, sorting = "asc", token)
#' df <- df[grepl("RACMO23\\.nc$", df$filename), ]
#' df <- df[grepl("^optimalslice_2050Md", df$filename), ]
#' df <- df[grepl("Wetterskip-Fryslan|Waterschap-Noorderzijlvest",
#' df$filename), ]
#' filename <- head(df$filename, 1)
#' }
#'
#' @export
get_filenames <- function(url, maxKeys = 100000, sorting = "asc", token) {
  params <- list(
    maxKeys =format(maxKeys, scientific = FALSE),
    sorting = sorting
  )

  response <- httr::GET(
    url,
    httr::add_headers(Authorization = paste("Bearer", token)),
    query = params
  )

  if (httr::status_code(response) == 200) {
    content_json <- httr::content(response, as = "text", encoding = "UTF-8")
    content_list <- jsonlite::fromJSON(content_json)

    df <- as.data.frame(content_list$files)
    return(df)
  } else {
    stop(paste(
      "Request failed with status:", httr::status_code(response),
      "\nResponse:", httr::content(response, as = "text", encoding = "UTF-8")
    ))
  }
}


#' Download and load a raster from a NetCDF file
#'
#' Downloads a NetCDF file from a remote API using a temporary URL, extracts a specified variable,
#' converts it into a projected SpatRaster stack, and assigns time-based layer names.
#'
#' @param filename Character. Name of the file to download.
#' @param varid Character. Variable name to extract from the NetCDF file. Default is "precip".
#' @inheritParams get_filenames
#'
#' @return A `terra::SpatRaster` object with layers named by variable and date.
#'
#' @details
#' This function:
#' \enumerate{
#'   \item Removes temporary files.
#'   \item Requests a temporary download URL from the API.
#'   \item Downloads the NetCDF file.
#'   \item Reads the specified variable and creates a raster stack.
#'   \item Projects the raster to EPSG:28992.
#'   \item Extracts CF-compliant time dimension and assigns layer names.
#' }
#'
#' @examples
#' \dontrun{
#' st <- download_and_load_raster(filename, varid="precip", token, url)
#' Write the rasters as separate "tif" files (maximum of 9 files).
#' out_dir <- "c:/tmp"
#' fnames <- file.path(out_dir, paste0(names(st), ".tif"))
#' n <- min(length(fnames), 9)
#' st <- st[[1:n]]
#' fnames <- fnames[1:n]
#' terra::writeRaster(st, fnames, overwrite=TRUE)
#' terra::plot(st)
#' }
#'
#' @export
download_and_load_raster <- function(filename, varid = "precip", token, url) {
  # Clean tempdir
  files <- list.files(tempdir(), full.names = TRUE)  # base
  unlink(files, recursive = TRUE)                          # base

  # Build file URL
  file_url <- paste0(url, "/", filename, "/url")           # base

  # Get download URL
  file_response <- httr::GET(                                    # httr
    file_url,
    httr::add_headers(Authorization = paste("Bearer", token))  # httr, base
  )
  if (httr::status_code(file_response) != 200)                  # httr
    stop("Failed to get file URL for ", filename)          # base

  file_info <- jsonlite::fromJSON(                               # jsonlite
    httr::content(file_response, as = "text", encoding = "UTF-8") # httr
  )
  download_url <- file_info$temporaryDownloadUrl

  # Download file locally
  local_path <- file.path(tempdir(), filename)       # base
  utils::download.file(                                          # utils
    download_url,
    destfile = local_path,
    mode = "wb",
    method = "curl"
  )

  # Read NetCDF and extract data
  nc <- ncdf4::nc_open(local_path)                              # ncdf4
  dat <- ncdf4::ncvar_get(nc, varid)                            # ncdf4
  rlon <- range(ncdf4::ncvar_get(nc, varid = "lon"))      # ncdf4, base
  rlat <- range(ncdf4::ncvar_get(nc, varid = "lat"))      # ncdf4, base
  ext <- terra::ext(c(rlon, rlat))                        # terra, base

  # Create raster stack and project
  rstack <- terra::rast(dat, extent = ext)                      # terra
  terra::crs(rstack) <- "EPSG:4326"                             # terra
  rstack <- terra::project(rstack, "EPSG:28992")                # terra

  # Extract time dimension info
  time_vals <- nc$dim$time$vals
  time_units <- nc$dim$time$units
  time_calendar <- nc$dim$time$calendar


  cf <- CFtime::CFtime(definition = time_units, calendar = time_calendar,
                       time_vals)
  dates <- as.Date(CFtime::as_timestamp(cf))              # CFtime, base
  date_strings <- format(dates, "%Y-%m-%d")              # base
  names(rstack) <- paste0(varid, "_", date_strings) # terra, base

  ncdf4::nc_close(nc)                                           # ncdf4

  # Clean up tempdir
  files <- list.files(tempdir(), full.names = TRUE) # base
  unlink(files, recursive = TRUE)                         # base

  return(rstack)                                                # base
}
