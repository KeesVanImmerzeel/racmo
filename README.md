# racmo

**racmo** is an R package that provides tools to download and process meteorological data from [RACMOv2.3](https://dataplatform.knmi.nl/dataset/knmi23-droogtestatistiek-1-0) in the [KNMI Data Platform](https://dataplatform.knmi.nl/). This dataset is used for [STOWA drought statistics](https://www.stowa.nl/publicaties/droogtestatistiek-knmi23-klimaatscenarios).

Useful references:

- [KNMI Klimaatscenarios](https://klimaatscenarios-data.knmi.nl/downloads)

- [Modeluitvoer KNMI’23-klimaatscenario’s](https://www.knmi.nl/kennis-en-datacentrum/achtergrond/modeluitvoer-knmi-23-klimaatscenario-s)


<img width="1142" height="756" alt="Image" src="https://github.com/user-attachments/assets/2dd09fd6-dfa4-48aa-8bcc-eb34da0add51" />

---

## Functions

- **Retrieve filenames of the available datasets** from the KNMI API  
  → `get_filenames()`

- **Download and convert NetCDF files** into projected `SpatRaster` stacks  
  → `download_and_load_raster()`

---

## Data Source

The following url to the KNMI data platform is defined as a character string named `url` in the package:  
`https://dataplatform.knmi.nl/dataset/knmi23-droogtestatistiek-1-0` 

---

## Installation

```r

Install the package:

`install_github("KeesVanImmerzeel/racmo")`

Then load the package:

`library("racmo")` 

