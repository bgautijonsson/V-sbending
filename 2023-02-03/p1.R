plot_dat <- hlutf_alls |>
    filter(dags == max(dags))

landid_allt <- plot_dat |>
    filter(sveitarfelag == "Alls") |>
    pull(hlutf)

p1_solo <- plot_dat |>
    filter(sveitarfelag != "Alls") |>
    ggplot(aes(hlutf, sveitarfelag, group = sveitarfelag, colour = reyk, linewidth = reyk, size = reyk)) +
    geom_vline(
        xintercept = landid_allt,
        lty = 2,
        alpha = 1,
        linewidth = 0.5,
        colour = iceland_col
    ) +
    geom_point() +
    geom_segment(
        aes(yend = sveitarfelag, xend = 0),
        alpha = 1,
        size = 0.1
    ) +
    annotate(
        x = landid_allt * 1.02,
        y = 5,
        label = "Landið alls",
        hjust = 0,
        geom = "text",
        colour = iceland_col
    ) +
    scale_x_continuous(
        labels = label_hlutf(accuracy = 1),
        limits = c(0, 0.3001),
        expand = expansion()
    ) +
    scale_colour_manual(
        values = c(other_col, reykjanes_col)
    ) +
    scale_linewidth_discrete(
        range = c(0.15, 0.6)
    ) +
    scale_size_manual(
        values = c(0.9, 2)
    ) +
    theme(
        legend.position = "none",
        plot.margin = margin(t = 5, r = 15, b = 5, l = 5)
    ) +
    labs(
        x = NULL,
        y = NULL,
        title = "Hlutfall innfluttra af heildaríbúafjölda eftir sveitarfélögum",
        subtitle = glue("Staðan {format(max(hlutf_alls$dags), '%d. %B %Y')}") |> str_replace("01", "1"),
        caption = glue("Heimildir, gögn og kóði: {git_url}")
    )

p1_solo

ggsave(
    plot = p1_solo +
        labs(caption = glue("Heimildir, gögn og kóði: {git_url}")),
    filename = "Figures/fig1.png",
    dpi = 320,
    width = 8, height = 0.5 * 8, scale = 1.3
)
