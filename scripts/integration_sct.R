output_log <- file(snakemake@log[[2]], open="wt")
error_log <- file(snakemake@log[[1]], open="wt")
sink(output_log, type = "output")
sink(error_log, type = "message")

suppressPackageStartupMessages(library(Seurat))
options(future.globals.maxSize = 1 * 1024^5)
set.seed(123)

seu_clean <- readRDS(snakemake@input[[1]])
## NORMALIZATION

seu_clean <- SCTransform(
  seu_clean,
  ncells = min(100000, ncol(seu_clean)),
  vars.to.regress = c("subsets_Mito_percent", "subsets_Ribo_percent"),
  verbose = TRUE,
  conserve.memory = TRUE
)

# Let's make a note that on Phase 3 and Phase 4 we got an error when
# running Cell Cycle Score on SCT array.
# This is a possible workaround to avoid the error suggested by Iara
# as using RNA assay instead of SCT:
#
# seu_clean <- NormalizeData(seu_clean, assay = "RNA")
# seu_clean <- CellCycleScoring(seu_clean, s.features = s.genes,
#                              g2m.features = g2m.genes, set.ident = FALSE,
#                              assay = "RNA")

## CELL CYCLE SCORING

if ("run_cell_cycle_scores" %in% names(snakemake@config)) {
  if (snakemake@config[["run_cell_cycle_scores"]]) {
    s.genes <- stringr::str_to_title(cc.genes$s.genes)
    g2m.genes <- stringr::str_to_title(cc.genes$g2m.genes)


    seu_clean <- CellCycleScoring(seu_clean, s.features = s.genes,
                              g2m.features = g2m.genes, set.ident = FALSE,
                              assay = "SCT")
  }
}
saveRDS(seu_clean, file = snakemake@output[[1]])

sink()
