plot_dat <- hlutf_alls |>
    filter(!sveitarfelag %in% c("Reykjanesbær", "Alls"))

reykjanesb <- hlutf_alls |>
    filter(sveitarfelag == "Reykjanesbær")


landid_allt <- hlutf_alls |>
    filter(sveitarfelag == "Alls")

p2_solo <- plot_dat |>
    ggplot(aes(dags, hlutf)) +
    geom_line(
        data = plot_dat,
        aes(group = sveitarfelag),
        colour = other_col,
        linewidth = 0.15
        ) +
    geom_textline(
        data = landid_allt,
        colour = iceland_col,
        linewidth = 0.6,
        aes(x = dags, y = hlutf, label = "Ísland"),
        text_smoothing = 30,
        hjust = 0.9,
        inherit.aes = FALSE
    ) +
    geom_textline(
        data = reykjanesb,
        colour = reykjanes_col,
        linewidth = 0.6,
        aes(x = dags, y = hlutf, label = "Reykjanesbær"),
        text_smoothing = 30,
        hjust = 0.9,
        inherit.aes = FALSE
    ) +
    geom_textline(
        data = foreign_pop |> filter(geo == "United Kingdom", time >= min(plot_dat$dags)) |> drop_na(),
        colour = "#0c2c84",
        linewidth = 0.6,
        aes(x = time, y = perc_foreign, label = "Bretland"),
        text_smoothing = 30,
        hjust = 0.5,
        inherit.aes = FALSE,
        alpha = 0.6
    ) +
    geom_textline(
        data = foreign_pop |> filter(geo == "Norway", time >= min(plot_dat$dags)) |> drop_na(),
        colour = "#a50f15",
        linewidth = 0.6,
        aes(x = time, y = perc_foreign, label = "Noregur"),
        text_smoothing = 30,
        hjust = 0.3,
        inherit.aes = FALSE,
        alpha = 0.6
    ) +
    geom_textline(
        data = foreign_pop |> filter(geo == "Sweden", time >= min(plot_dat$dags)) |> drop_na(),
        colour = "#fd8d3c",
        linewidth = 0.6,
        aes(x = time, y = perc_foreign, label = "Svíþjóð"),
        text_smoothing = 30,
        hjust = 0.3,
        inherit.aes = FALSE,
        alpha = 0.6
    ) +
    geom_textline(
        data = foreign_pop |> filter(geo == "Denmark", time >= min(plot_dat$dags)) |> drop_na(),
        colour = "#cb181d",
        linewidth = 0.6,
        aes(x = time, y = perc_foreign, label = "Danmörk"),
        text_smoothing = 30,
        hjust = 0.6,
        inherit.aes = FALSE,
        alpha = 0.6
    ) +
    geom_textline(
        data = foreign_pop |> filter(geo == "Finland", time >= min(plot_dat$dags)) |> drop_na(),
        colour = "#4292c6",
        linewidth = 0.6,
        aes(x = time, y = perc_foreign, label = "Finnland"),
        text_smoothing = 30,
        hjust = 0.6,
        inherit.aes = FALSE,
        alpha = 0.6
    ) +
    scale_x_date(
        expand = expansion(),
        breaks = breaks_width("2 year", offset = "1 year"),
        labels = label_date_short()
    ) +
    scale_y_continuous(
        labels = label_hlutf(accuracy = 1),
        expand = expansion(),
        limits = c(0, 0.3001)
    ) +
    scale_colour_manual(
        values = c(other_col, reykjanes_col)
    ) +
    scale_linewidth_discrete(
        range = c(0.15, 0.6)
    ) +
    theme(
        legend.position = "none",
        plot.margin = margin(t = 5, r = 15, b = 5, l = 5)
    ) +
    labs(
        x =  NULL,
        y = NULL,
        title = "Hlutfall innfluttra af heildaríbúafjölda",
        subtitle = "Þróun frá 2009 í sveitarfélögum landsins borin saman við önnur lönd",
        caption = glue("Heimildir, gögn og kóði: {git_url}")
    )

p2_solo

ggsave(
    plot = p2_solo,
    filename = "Figures/fig2.png",
    dpi = 320,
    width = 8, height = 0.5 * 8, scale = 1.3
)
