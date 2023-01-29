# Hlutfall erlendra íbúa --------------------------------------------------

upper_theme <- theme(
    strip.text = element_text(margin = margin(3, 3, 3, 3)),
    legend.position = "none",
    plot.margin = margin(t = 5, r = 10, b = 5, l = 5),
    plot.title = element_text(size = 12),
    plot.subtitle = element_text(size = 8),
    axis.text = element_text(size = 8)
)

p1 <- hlutf_alls |>
    ggplot(aes(hlutf_latest, sveitarfelag, group = sveitarfelag, colour = reyk, linewidth = reyk, size = reyk)) +
    geom_point() +
    geom_segment(
        aes(yend = sveitarfelag, xend = 0),
        alpha = 1,
        size = 0.1
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
    upper_theme +
    labs(
        x = NULL,
        y = NULL,
        title = "Hlutfall innfluttra af öllum ríkisborgurum",
        subtitle = glue("Staðan {format(max(hlutf_alls$dags), '%d. %B %Y')}") |> str_replace("01", "1")
    )

p2 <- hlutf_alls |>
    ggplot(aes(dags, hlutf,  colour = reyk, linewidth = reyk)) +
    geom_line(aes(group = sveitarfelag)) +
    scale_x_date(
        expand = expansion()
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
    upper_theme +
    labs(
        x =  NULL,
        y = NULL,
        subtitle = "Þróun frá 2009"
    )


# Lengd dvalar ------------------------------------------------------------



lower_theme <- theme(
    legend.margin = margin(r = -80),
    legend.text = element_text(size = 8),
    legend.title = element_text(size = 10),
    plot.title = element_text(size = 12),
    plot.subtitle = element_text(size = 8),
    legend.position = "left",
    strip.background = element_rect(colour = NA, fill = "grey93")
)

p3 <- lengd_dvalar |>
    mutate(var = "Heildarfjöldi") |>
    ggplot(aes(ar, value, fill = lengd_dvalar)) +
    geom_area(position = "stack") +
    scale_x_continuous(
        expand = expansion()
    ) +
    scale_y_continuous(
        expand = expansion(),
        labels = label_number(accuracy = 1, big.mark = ".", decimal.mark = ",")
    ) +
    col_scale +
    coord_cartesian(clip = "off") +
    lower_theme +
    labs(
        x = NULL,
        y = NULL,
        fill = "Lengd dvalar",
        title = "Innfluttir ríkisborgarar eftir lengd dvalar á Íslandi",
        subtitle = "Erlendir ríkisborgarar fluttu mestmegnis til Reykjanesbæjar milli 2015 og 2020"
    ) +
    facet_wrap("var")

p4 <- lengd_dvalar |>
    mutate(var = "Hlutfall eftir lengd dvalar") |>
    ggplot(aes(ar, hlutf, fill = lengd_dvalar)) +
    geom_area(position = "stack") +
    scale_x_continuous(
        expand = expansion()
    ) +
    scale_y_continuous(
        expand = expansion(),
        labels = label_hlutf(accuracy = 1),
        position = "right"
    )  +
    col_scale +
    lower_theme +
    labs(
        x = NULL,
        y = NULL,
        fill = "Lengd dvalar",
        subtitle = "Langflestir erlendir ríkisborgarar í Reykjanesbæ hafa búið á Íslandi í 3 ár eða lengur"
    ) +
    facet_wrap("var")


# Combine Plots -----------------------------------------------------------



design <- "
AAAABBBBB
CCCCCCCCC
"

p <- p1 + p2 +
    (p3 + p4 +
         plot_layout(
             ncol = 2,
             guides = "collect"
         ) &
         theme(
             legend.position = "left"
         )

    ) +
    plot_layout(
        design = design, heights = c(0.5, 0.5)
    ) +
    plot_annotation(
        caption = "Heimildir, gögn og kóði: https://www.github.com/bgautijonsson/visbending/2023-02-03",
        theme = theme(
            plot.title = element_markdown(),
            plot.subtitle = element_markdown(size = 12, margin = margin())
        )
    )
ggsave(
    plot = p,
    filename = "Figures/reykjanesbær.png",
    width = 8, height = 0.621 * 8, scale = 1.3
)
