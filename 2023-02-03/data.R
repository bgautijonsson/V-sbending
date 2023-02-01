
# Hlutfall erlendra -------------------------------------------------------



url <- "https://px.hagstofa.is:443/pxis/api/v1/is/Ibuar/mannfjoldi/2_byggdir/sveitarfelog/MAN10001.px"

hlutf_alls <- hg_data(url) |>
    filter(
        `Kyn og ríkisfang` %in% c("Alls", "Erl. ríkisborgarar")
    ) |>
    collect() |>
    janitor::clean_names() |>
    mutate(sveitarfelag = str_squish(sveitarfelag)) |>
    rename(value = 4) |>
    separate(
        arsfjordungur, into = c("ar", "man"), sep = "Á", convert = TRUE
    ) |>
    mutate(dags = clock::date_build(ar, 1 + 3 * (man - 1))) |>
    select(dags, sveitarfelag, kyn_og_rikisfang, value) |>
    pivot_wider(names_from = kyn_og_rikisfang) |>
    janitor::clean_names() |>
    mutate(hlutf = erl_rikisborgarar / alls) |>
    mutate(
        reyk = factor(1 * (sveitarfelag == "Reykjanesbær"))
    )

start_dags <- min(hlutf_alls$dags)

hlutf_alls <- hlutf_alls |>
    filter(
        str_detect(
            str_to_lower(sveitarfelag),
            "alls|reykjaví|garðab|kópav|hafnarf|mosf|seltjar|akrane|akureyr|fjarðab|árbo|múlaþ|vestman|borgarbygg|ísafjarð|suðurnes|grindaví|norðurþ|hverag|ölfus|hornafj|reykjane"
        )
    ) |>
    mutate(
        order_var = hlutf[dags == max(dags)],
        .by = sveitarfelag
    ) |>
    mutate(
        sveitarfelag = fct_reorder(sveitarfelag, order_var)
    ) |>
    mutate(
        hlutf_latest = ifelse(dags == max(dags), hlutf, NA_real_),
        var1 = glue("% innflytjenda ({format(max(hlutf_alls$dags), '%d. %B %Y')})"),
        var2 = "% innflytjenda eftir ári"
    )


# Lengd dvalar ------------------------------------------------------------



url <- "https://px.hagstofa.is:443/pxis/api/v1/is/Ibuar/mannfjoldi/3_bakgrunnur/Uppruni/MAN43007.px"

lengd_dvalar <- hg_data(url) |>
    filter(
        Kyn == "Alls",
        `Lengd dvalar` != "Alls",
        Sveitarfélag == "Reykjanesbær"
    ) |>
    collect() |>
    janitor::clean_names() |>
    select(-kyn) |>
    rename(value = 4) |>
    mutate(
        ar = parse_number(ar),
        hlutf = value / sum(value),
        .by = c(ar, sveitarfelag)
    ) |>
    mutate(
        lengd_dvalar = ifelse(lengd_dvalar == "1-2 tvö ár", "1-2 ár", lengd_dvalar),
        lengd_dvalar = fct_relevel(
            lengd_dvalar,
            "11 ár og lengur",
            "6-10 ár",
            "3-5 ár",
            "1-2 ár",
            "Innan við ár"
        )
    )


lengd_dvalar |>
    filter(ar == max(ar)) |>
    mutate(value = ifelse(lengd_dvalar == "Innan við ár", value + 1e3, value),
           hlutf = value / sum(value))


# Eurostat ----------------------------------------------------------------

foreign_pop <- get_eurostat(
    "migr_pop3ctb",
    cache = TRUE,
    cache_dir = "data"
)  |>
    label_eurostat() |>
    filter(
        c_birth %in% c("Foreign country", "Total"),
        age == "Total",
        sex == "Total"
    ) |>
    select(geo, c_birth, time, values) |>
    pivot_wider(names_from = c_birth, values_from = values) |>
    janitor::clean_names() |>
    mutate(perc_foreign = foreign_country / total)


