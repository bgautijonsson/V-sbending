

# ATVINNA -----------------------------------------------------------------

atvinna <- get_eurostat(
    "lfsq_ergan",
    cache = TRUE,
    update_cache = TRUE,
    cache_dir = "Data"
) |>
    label_eurostat() |>
    filter(
        age == "From 20 to 64 years",
        sex == "Total",
        citizen %in% c("Total", "Foreign country", "Reporting country")
    ) |>
    select(geo, citizen, time = TIME_PERIOD, values) |>
    rename(country = geo) |>
    mutate(
        country = ifelse(str_detect(country, "Germany"), "Germany", country)
    ) |>
    inner_join(
        metill::country_names()
    ) |>
    mutate(
        citizen = fct_recode(
            citizen,
            "Samtals" = "Total",
            "Erlent" = "Foreign country",
            "Innlent" = "Reporting country"
        )
    ) |>
    select(land, vinnuafl = citizen, dags = time, hlutf_atvinna = values) |>
    mutate(
        hlutf_atvinna = hlutf_atvinna / 100
    )


atvinna |>
    left_join(
        litir,
        by = join_by(land)
    ) |>
    write_parquet("Data/atvinna.parquet")





virkni <- get_eurostat(
    "lfsq_argan",
    cache = TRUE,
    cache_dir = "Data"
) |>
    label_eurostat() |>
    filter(
        age == "From 20 to 64 years",
        sex == "Total",
        citizen %in% c("Total", "Foreign country", "Reporting country")
    ) |>
    select(geo, citizen, time = TIME_PERIOD, values) |>
    rename(country = geo) |>
    mutate(
        country = ifelse(str_detect(country, "Germany"), "Germany", country)
    ) |>
    inner_join(
        metill::country_names()
    ) |>
    mutate(
        citizen = fct_recode(
            citizen,
            "Samtals" = "Total",
            "Erlent" = "Foreign country",
            "Innlent" = "Reporting country"
        )
    ) |>
    select(land, vinnuafl = citizen, dags = time, hlutf_virk = values) |>
    mutate(
        hlutf_virk = hlutf_virk / 100
    )


virkni |>
    left_join(
        litir,
        by = join_by(land)
    ) |>
    write_parquet("Data/virkni.parquet")




