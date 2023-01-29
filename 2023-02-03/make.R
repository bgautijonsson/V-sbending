library(ggtext)
library(janitor)
library(plotly)
library(tidyverse)
library(lubridate)
library(scales)
library(metill)
library(patchwork)
library(arrow)
library(glue)
library(eurostat)
library(hagstofa)
library(crosstalk)
library(here)
theme_set(theme_visbending())
Sys.setlocale("LC_ALL", "is_IS.UTF-8")

reykjanes_col <- "#023858"

other_col <- "#bdbdbd"

col_scale <- scale_fill_brewer(palette = "Blues")


here("2023-02-03") |>
    setwd()

source("data.R")
source("plot.R")

