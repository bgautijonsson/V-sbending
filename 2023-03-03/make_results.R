library(tidyverse)
library(eurostat)
library(here)
library(metill)
library(geomtextpath)
library(arrow)
library(glue)
library(ggtext)
Sys.setlocale("LC_ALL", "is_IS.UTF-8")
theme_set(theme_visbending())
here("2023-03-03") |>
    setwd()




litur_island <- "#08306b"

litur_danmork <- "#e41a1c"

litur_finnland <- "#3690c0"

litur_noregur <- "#7f0000"

litur_svithjod <- "#fd8d3c"

litur_annad <- "#737373"

litir <- tribble(
    ~land, ~litur,
    "Ísland", litur_island,
    "Danmörk", litur_danmork,
    "Finnland", litur_finnland,
    "Noregur", litur_noregur,
    "Svíþjóð", litur_svithjod
)


source("import_data.R")
source("figures.R")
