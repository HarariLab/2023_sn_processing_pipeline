output_log <- file(snakemake@log[[2]], open="wt")
error_log <- file(snakemake@log[[1]], open="wt")
sink(output_log, type = "output")
sink(error_log, type = "message")

suppressPackageStartupMessages(library(Seurat))
suppressPackageStartupMessages(library(dplyr))
set.seed(123)

doublets_stats <- matrix(0, nrow = length(snakemake@input), ncol = 13)
colnames(doublets_stats) <- c("Total", "pass_QC_nuclei", "removed_prc",
                              "DF_doublets", "DF_doublets_prc",
                              "scDF_doublets", "scDF_doublets_prc",
                              "garnett_Unknown", "garnett_Unknown_prc",
                              "Init_Median_UMI", "Init_Median_nGenes",
                              "Phase1_Median_UMI", "Phase1_Median_nGenes")

idx <- 1
SAMPLES <- c()
print(snakemake@input)
for (SAMPLE_RDS in snakemake@input) {
    seu <- readRDS(SAMPLE_RDS)
    SAMPLE <- seu@project.name
    SAMPLES <- c(SAMPLES, SAMPLE)

    stat_1 <- table(seu@meta.data$doublet_prc)
    stat_2 <- table(seu@meta.data$scDblFinder.class)
    stat_3 <- table(seu@meta.data$garnett_prediction)
    stat_4 <- table(seu@meta.data$pass_doublets_QC)
    stat_5 <- seu@meta.data %>% filter(pass_doublets_QC == "PASS") %>%
        mutate(med_nUMI = median(nCount_RNA),
                med_nGenes = median(nFeature_RNA)) %>%
        select(med_nUMI, med_nGenes) %>%
        unique()
    stat_6 <- seu@meta.data %>%
        mutate(med_nUMI = median(nCount_RNA),
                med_nGenes = median(nFeature_RNA)) %>%
        select(med_nUMI, med_nGenes) %>%
        unique()
    total <- ncol(seu)
    doublets_stats[idx, ] <- c(total, stat_4["PASS"],
                            round((stat_4["FAIL"] / total) * 100, 2),
                            stat_1["Doublet"],
                            round((stat_1["Doublet"] / total) * 100, 2),
                            stat_2["doublet"],
                            round((stat_2["doublet"] / total) * 100, 2),
                            stat_3["Unknown"],
                            round((stat_3["Unknown"] / total) * 100, 2),
                            stat_6[1, 1],
                            stat_6[1, 2],
                            stat_5[1, 1],
                            stat_5[1, 2])
    
    idx <- idx + 1
}
rownames(doublets_stats) <- SAMPLES

write.table(doublets_stats,
            file = snakemake@output[[1]],
            sep = "\t", quote = FALSE,
            row.names = TRUE, col.names = NA)

sink()
