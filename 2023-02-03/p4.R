

p4_solo <- lengd_dvalar |>
    mutate(var = "Hlutfall eftir lengd dvalar") |>
    ggplot(aes(ar, hlutf, fill = lengd_dvalar)) +
    geom_area(position = "stack") +
    scale_x_continuous(
        expand = expansion(),
        breaks = seq(1998, 2022, 4)
    ) +
    scale_y_continuous(
        expand = expansion(),
        labels = label_hlutf(accuracy = 1)
    )  +
    col_scale +
    coord_cartesian(
        clip = "off"
    ) +
    labs(
        x = NULL,
        y = NULL,
        fill = "Lengd dvalar",
        title = "Innfluttir íbúar eftir lengd dvalar á Íslandi",
        subtitle = "Flestir (~75%) erlendir íbúar Reykjanesbæjar hafa búið á Íslandi í 3 ár eða lengur",
        caption = glue("Heimildir, gögn og kóði: {git_url}")
    ) +
    facet_wrap("var")

p4_solo

ggsave(
    plot = p4_solo,
    filename = "Figures/fig4.png",
    dpi = 320,
    width = 8, height = 0.5 * 8, scale = 1.3
)
