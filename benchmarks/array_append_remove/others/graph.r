bench <- data.frame(
    program = c("D (Joka, List)", "Rust (Vec)", "Zig (AList, rawc)", "Odin (default)"),
    real = c(1.61, 1.89, 1.87, 2.40)
)

bp <- barplot(
    bench$real, 
    names.arg = bench$program, 
    col = "steelblue", 
    ylab = "Time (seconds)", 
    main = "Append & Remove 1B Items",
    cex.names = 0.7,
    ylim = c(0, 2.5)
)

text(x = bp, y = bench$real, label = bench$real, pos = 3, cex = 0.8, col = "red")
