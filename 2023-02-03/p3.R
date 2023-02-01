p3_solo <- lengd_dvalar |>
    mutate(var = "Heildarfjöldi") |>
    ggplot(aes(ar, value, fill = lengd_dvalar)) +
    geom_area(position = "stack") +
    scale_x_continuous(
        expand = expansion(),
        breaks = seq(1998, 2022, 4)
    ) +
    scale_y_continuous(
        expand = expansion(),
        labels = label_number(accuracy = 1, big.mark = ".", decimal.mark = ",")
    ) +
    col_scale +
    coord_cartesian(clip = "off") +
    labs(
        x = NULL,
        y = NULL,
        fill = "Lengd dvalar",
        title = "Innfluttir íbúar eftir lengd dvalar á Íslandi",
        subtitle = "Erlendir íbúar fluttu mestmegnis til Reykjanesbæjar milli 2015 og 2020",
        caption = glue("Heimildir, gögn og kóði: {git_url}")
    ) +
    facet_wrap("var")

p3_solo

ggsave(
    plot = p3_solo,
    filename = "Figures/fig3.png",
    dpi = 320,
    width = 8, height = 0.5 * 8, scale = 1.3
)
