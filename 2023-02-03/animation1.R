foreign_pop |>
    drop_na() |>
    mutate(ar = year(time)) |>
    filter(
        any(geo == "Iceland"),
        .by = ar
    ) |>
    ggplot(aes(total, perc_foreign, group = geo)) +
    geom_point(aes(
        colour = geo == "Iceland",
        size = geo == "Iceland"
    )) +
    scale_x_log10(
        labels = label_number_si()
    ) +
    scale_y_log10(
        labels = label_hlutf()
    ) +
    scale_colour_manual(
        values = c(other_col, iceland_col)
    ) +
    scale_size_manual(
        values = c(1, 3)
    ) +
    theme(
        legend.position = "none",
        plot.subtitle = element_markdown()
    ) +
    labs(
        title = "Hlutfall innfluttra íbúa og heildarmannfjöldi",
        subtitle = str_c(
            glue(str_c(
                "Sýnt fyrir ",
                "<b style=color:{iceland_col}>Ísland</b>",
                " og ",
                "<b style=color{other_col}>önnur evrópsk lönd</b>"
            )),
            "<br>",
            "Ár: {frame_time}"
        ),
        x = "Heildarmannfjöldi",
        y = "% innflytjendur"
    ) +
    transition_time(as.integer(ar)) +
    ease_aes("cubic-in-out") +
    shadow_wake(
        wake_length = 0.1
    )

anim_save(filename = "Figures/animation1.gif")
