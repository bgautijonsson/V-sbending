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
library(here)
library(metR)
library(geomtextpath)
theme_set(theme_visbending())
Sys.setlocale("LC_ALL", "is_IS.UTF-8")

reykjanes_col <- "#023858"

other_col <- "#bdbdbd"

iceland_col <- "#08519c"

col_scale <- scale_fill_brewer(palette = "Blues", direction = 1)

folder <- "2023-02-03"

git_url <- glue("https://www.github.com/bgautijonsson/visbending")

here(folder) |>
    setwd()

source("data.R")
source("combined_plot.R")
source("p1.R")
source("p2.R")
source("p3.R")
source("p4.R")

