
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
    mutate(dags = clock::date_build(ar, man)) |>
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
            "reykjaví|garðab|kópav|hafnarf|mosf|seltjar|akrane|akureyr|fjarðab|árbo|múlaþ|vestman|borgarbygg|ísafjarð|suðurnes|grindaví|norðurþ|hverag|ölfus|hornafj|reykjane"
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
        var2 = "% innflytjenda eftir ári",
        text1 = str_c(
            "<b>", sveitarfelag, "</b>", "\n",
            "Innfæddir íbúar: ", number(alls - erl_rikisborgarar, big.mark = ".", decimal.mark = ","), "\n",
            "Innfluttir íbúar: ", number(erl_rikisborgarar, big.mark = ".", decimal.mark = ","), "\n",
            "% innflutt: ", hlutf(hlutf_latest, accuracy = 0.1)
        ),
        text2 = str_c(
            "<b>", sveitarfelag, "</b>", "\n",
            "Dagsetning: ", dags, "\n",
            "Innfæddir íbúar: ", number(alls - erl_rikisborgarar, big.mark = ".", decimal.mark = ","), "\n",
            "Innfluttir íbúar: ", number(erl_rikisborgarar, big.mark = ".", decimal.mark = ","), "\n",
            "% innflutt: ", hlutf(hlutf, accuracy = 0.1)
        )
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
            "Innan við ár",
            "1-2 ár",
            "3-5 ár",
            "6-10 ár",
            "11 ár og lengur"
        )
    )
