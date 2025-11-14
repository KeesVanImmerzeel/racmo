# racmo

**racmo** is an R package that provides tools to **download and process meteorological data** from **RACMOv2.3** (KNMI Data Platform), used for **STOWA drought statistics**.

<img width="1142" height="756" alt="Image" src="https://github.com/user-attachments/assets/2dd09fd6-dfa4-48aa-8bcc-eb34da0add51" />

---

## Features

- **Retrieve file lists** from the KNMI API  
  → `get_filenames()`

- **Download and convert NetCDF files** into projected `SpatRaster` stacks  
  → `download_and_load_raster()`

---

## Data Source

The package uses data from the KNMI dataset:  
`url` → KNMI Data Platform

---

## Installation

```r
# Install from source
devtools::install_github("KeesVanImmerzeel/racmo")



