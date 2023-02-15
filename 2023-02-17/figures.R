

# ATVINNA -----------------------------------------------------------------

plot_dat <-  atvinna |>
    drop_na(hlutf_atvinna) |>
    filter(
        vinnuafl == "Erlent"
    )


p1 <- plot_dat |>
    filter(is.na(litur)) |>
    ggplot(aes(dags, hlutf_atvinna, group = land)) +
    geom_line(
        alpha = 0.3,
        linewidth = 0.2,
        colour = litur_annad
    ) +
    geom_line(
        data = plot_dat |> drop_na(litur),
        aes(colour = litur),
        linewidth = 1
    ) +
    geom_text(
        data = plot_dat |>
            drop_na(litur) |>
            filter(dags == max(dags)) |>
            mutate(
                hlutf_atvinna = case_when(
                    land == "Finnland" ~ hlutf_atvinna * 1.01,
                    TRUE ~ hlutf_atvinna
                )
            ),
        aes(x = dags, y = hlutf_atvinna, label = land, col = litur),
        hjust = 0,
        nudge_x = 35,
        size = 5
    ) +
    scale_x_date(
        breaks = breaks_width("2 year", offset = "0 month"),
        labels = label_date_short(format = c("%Y", "%B"))
    ) +
    scale_y_continuous(
        labels = label_hlutf(accuracy = 1),
        limits = c(0.45, 1),
        expand = expansion()
    ) +
    scale_colour_identity() +
    scale_hjust_manual(
        values = c(0.137, 0.2, 0.0655, 0.41, 0.4)
    ) +
    coord_cartesian(
        clip = "off",
        xlim = date_build(year = c(1998, 2022), month = c(1, 7))
    ) +
    theme(
        plot.margin = margin(t = 5, r = 40, b = 5, l = 5)
    ) +
    labs(
        title = "Hlutfall vinnandi meðal erlendra íbúa",
        subtitle = "Hlutfall einstaklinga á atvinnumarkaði sem eru ekki atvinnulausir",
        x = NULL,
        y = NULL
    )

p1

ggsave(
    plot = p1,
    filename = "Figures/p1.png",
    width = 8, height = 0.5 * 8, scale = 1.3
)


plot_date <- format(max(plot_dat$dags), '%d. %B, %Y') |> str_replace("^0", "")
plot_subtitle <- glue("Staðan {plot_date}")




plot_dat <- atvinna |>
    filter(
        vinnuafl != "Samtals",
        dags == max(dags)
    ) |>
    filter(
        !any(is.na(hlutf_atvinna)),
        .by = land
    ) |>
    mutate(
        land_hopur = 1 * (is.na(litur)),
        litur = coalesce(litur, litur_annad),
        land = glue("<b style='color:{litur}'>{land}</b>"),
        land = fct_reorder(land, hlutf_atvinna * (vinnuafl == "Erlent"))
    ) |>
    pivot_wider(names_from = vinnuafl, values_from = hlutf_atvinna)


p3 <- plot_dat |>
    ggplot(aes(y = land, colour = litur, size = land_hopur, linewidth = land_hopur)) +
    geom_segment(
        aes(x = Erlent, xend = Innlent, yend = land)
    ) +
    geom_point(aes(x = Erlent, shape = "Erlent")) +
    geom_point(aes(x = Innlent, shape = "Innlent")) +
    scale_x_continuous(
        labels = label_hlutf(accuracy = 1),
        limits = c(0.6, 1),
        expand = expansion()
    ) +
    scale_colour_identity() +
    scale_linewidth_continuous(
        range = c(0.7, 0.3)
    ) +
    scale_size_continuous(
        range = c(3, 2)
    ) +
    scale_shape_manual(
        values = c(16, 15)
    ) +
    guides(
        shape = guide_legend(override.aes = list(size = 3)),
        linewidth = "none",
        size = "none"
    ) +
    theme(
        axis.text.y = element_markdown(),
        legend.position = c(0.075, 0.94),
        plot.margin = margin(t = 5, r = 25, b = 5, l = 5)
        # legend.margin = margin(t = -20, l = 450)
    ) +
    labs(
        x = NULL,
        y = NULL,
        shape = NULL,
        title = "Hlutfall vinnandi eftir fæðingarlandi vinnuafls",
        subtitle = "Hlutfall einstaklinga á atvinnumarkaði sem eru ekki atvinnulausir (1. júlí 2022)"
    )

p3

ggsave(
    plot = p3,
    filename = "Figures/p3.png",
    width = 8, height = 0.5 * 8, scale = 1.3
)


# ÞÁTTTAKA ----------------------------------------------------------------



plot_dat <-  virkni |>
    # semi_join(
    #     atvinna,
    #     by = join_by(dags)
    # ) |>
    drop_na(hlutf_virk) |>
    filter(
        vinnuafl == "Erlent"
    )


p2 <- plot_dat |>
    filter(is.na(litur)) |>
    ggplot(aes(dags, hlutf_virk, group = land)) +
    geom_line(
        alpha = 0.3,
        linewidth = 0.2,
        colour = litur_annad
    ) +
    geom_line(
        data = plot_dat |> drop_na(litur),
        aes(colour = litur),
        linewidth = 1
    ) +
    geom_text(
        data = plot_dat |>
            drop_na(litur) |>
            filter(dags == max(dags)) |>
            mutate(
                hlutf_virk = case_when(
                    land == "Svíþjóð" ~ hlutf_virk * 1.02,
                    land == "Danmörk" ~ hlutf_virk * 0.99,
                    land == "Finnland" ~ hlutf_virk * 0.995,
                    land == "Noregur" ~ hlutf_virk * 0.997,
                    TRUE ~ hlutf_virk
                )
            ),
        aes(x = dags, y = hlutf_virk, label = land, col = litur),
        hjust = 0,
        nudge_x = 35,
        size = 5
    ) +
    scale_x_date(
        breaks = breaks_width("2 year", offset = "0 month"),
        labels = label_date_short(format = c("%Y", "%B"))
    ) +
    scale_y_continuous(
        labels = label_hlutf(accuracy = 1),
        limits = c(0.45, 1),
        expand = expansion()
    ) +
    scale_colour_identity() +
    scale_hjust_manual(
        values = c(0.137, 0.2, 0.0655, 0.41, 0.4)
    ) +
    coord_cartesian(
        clip = "off",
        xlim = date_build(year = c(1998, 2022), month = c(1, 7))
    ) +
    theme(
        plot.margin = margin(t = 5, r = 40, b = 5, l = 5)
    ) +
    labs(
        title = "Þátttaka erlendra íbúa á atvinnumarkaði",
        subtitle = "Hlutfall einstaklinga sem hafa vinnu eða eru að leita að vinnu",
        x = NULL,
        y = NULL
    )

p2

ggsave(
    plot = p2,
    filename = "Figures/p2.png",
    width = 8, height = 0.5 * 8, scale = 1.3
)


plot_date <- format(max(plot_dat$dags), '%d. %B, %Y') |> str_replace("^0", "")
plot_subtitle <- glue("Staðan {plot_date}")




plot_dat <- virkni |>
    filter(
        vinnuafl != "Samtals",
        dags == max(dags)
    ) |>
    filter(
        !any(is.na(hlutf_virk)),
        .by = land
    ) |>
    mutate(
        land_hopur = 1 * (is.na(litur)),
        litur = coalesce(litur, litur_annad),
        land = glue("<b style='color:{litur}'>{land}</b>"),
        land = fct_reorder(land, hlutf_virk * (vinnuafl == "Erlent"))
    ) |>
    pivot_wider(names_from = vinnuafl, values_from = hlutf_virk)


p4 <- plot_dat |>
    ggplot(aes(y = land, colour = litur, size = land_hopur, linewidth = land_hopur)) +
    geom_segment(
        aes(x = Erlent, xend = Innlent, yend = land)
    ) +
    geom_point(aes(x = Erlent, shape = "Erlent")) +
    geom_point(aes(x = Innlent, shape = "Innlent")) +
    scale_x_continuous(
        labels = label_hlutf(accuracy = 1),
        limits = c(0.6, 1),
        expand = expansion()
    ) +
    scale_colour_identity() +
    scale_linewidth_continuous(
        range = c(0.7, 0.3)
    ) +
    scale_size_continuous(
        range = c(3, 2)
    ) +
    scale_shape_manual(
        values = c(16, 15)
    ) +
    guides(
        shape = guide_legend(override.aes = list(size = 3)),
        linewidth = "none",
        size = "none"
    ) +
    theme(
        axis.text.y = element_markdown(),
        legend.position = c(0.075, 0.94),
        plot.margin = margin(t = 5, r = 25, b = 5, l = 5)
        # legend.margin = margin(t = -20, l = 450)
    ) +
    labs(
        x = NULL,
        y = NULL,
        shape = NULL,
        title = "Þátttaka á vinnumarkaði eftir fæðingarlandi vinnuafls",
        subtitle = "Hlutfall einstaklinga sem hafa vinnu eða eru að leita að vinnu (1. júlí 2022)"
    )

p4

ggsave(
    plot = p4,
    filename = "Figures/p4.png",
    width = 8, height = 0.5 * 8, scale = 1.3
)
