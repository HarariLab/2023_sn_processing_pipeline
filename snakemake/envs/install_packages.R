install.packages('pak', repos = 'http://cran.us.r-project.org')
print("Installing packages")
print("Installing SeuratObject...")
pak::pkg_install('satijalab/seurat-object@release/4.1.4')
print("Installing Seurat...")
pak::pkg_install('satijalab/seurat@seurat4')
print("Installing scuttle...")
pak::pkg_install('scuttle')
print("Installing glmGamPoi...")
pak::pkg_install('glmGamPoi')
print("Installing DoubletFinder...")
pak::pkg_install('iaradsouza1/DoubletFinder')
print("Installing scDblFinder...")
pak::pkg_install('scDblFinder')
print("Installing garnett...")
pak::pkg_install("cole-trapnell-lab/garnett")
print("Installing qs...")
pak::pkg_install('qs')
print("Installing sceasy...")
pak::pkg_install("cellgeni/sceasy")
print("Installing ggplot2...")
pak::pkg_install('ggplot2')
print("Installing celda...")
pak::pkg_install('celda')
print("Installing DropletUtils...")
pak::pkg_install('DropletUtils')
print("Installing readxl...")
pak::pkg_install('readxl')
print("Installing HGNChelper...")
pak::pkg_install('HGNChelper')
print("Installing openxlsx...")
pak::pkg_install('openxlsx')
