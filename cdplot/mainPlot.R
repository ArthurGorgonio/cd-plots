source('cd.R') # Esse arquivo tem toda a criação do plot

# Instalação e carregamento de pacotes necessário para utilizar os diagramas
packages <- c('PMCMRplus', 'argparse', 'stringi')
for (pack in packages) {
  if (!require(pack, character.only = TRUE)) {
    install.packages(pack)
  }
  library(pack, character.only = TRUE, verbose = F)
}

# args <- commandArgs(TRUE)
parser <- ArgumentParser(description='Performs friedman and Nenemyi Tests. Also, it generates the Critical Difference Diagrams.')


parser$add_argument('files', nargs='+', help='the files that be processed (CSV is expected)')
parser$add_argument('--test', default=FALSE, type='logical', help='run Friedman and Nemenyi Tests (default = FALSE)')
parser$add_argument('--cd', default=TRUE, type='logical', help='generate CD plot (default = TRUE)')
parser$add_argument('--location', default='./', help='path to save the plots and outputs (default = ./)')
parser$add_argument('--delimiter', default='\t', help='the delimiter in the files (default = \\t <TAB>)')
parser$add_argument('--row', default=0, type='integer', help='the index of the names of the rows (default = 0)')
parser$add_argument('--col', default=LETTERS, help='the name of the columns (default = capital letters)')
parser$add_argument('--head', default=FALSE, type='logical', help='the first row is the columns names? (default = FALSE)')
parser$add_argument('--alpha', default=0.05, type='double', help='The significance level of the test (default = 0.05)')


get_data <- function(file, header=FALSE, row_names=0, sep=',') {
    if(row_names != 0) {
        data <- as.matrix(read.csv(file, header=header, row.names=row_names, sep=sep))
    } else {
        data <- as.matrix(read.csv(file, header=header, sep=sep))
        rownames(data) <- 1:nrow(data)
    }
    return(data)
}

params <- parser$parse_args()

cat('ALHPA::', params$alpha)

for(file in params$files) {
  file_name <- strsplit(file, "[.]")[[1]][1]
  cat("FILE:")
  print(file_name)
  data <- get_data(file, params$head, params$row, params$delimiter)
  data <- data[,1:length(params$col[1:ncol(data)])]
  print(data)
  colnames(data) <- unlist(strsplit(params$col, ','))[1:ncol(data)]
  if (params$test) {
    cat('Friedman Test of ', file_name, '\n', rep('-', 30), '\n')
    print(friedmanTest(data))
    cat('\n\nPOST-HOC Test of ', file_name, '\n', rep('=', 30), '\n\n\n')
    print(frdAllPairsNemenyiTest(data))
  }
  if (params$cd) {
    cat(paste(params$location, file_name, '.png', sep=''))
    png(paste(params$location, file_name, '.png', sep=''), 800, 480,
        bg = 'transparent')
    par(family='Verdana')
    plotCD(data, alpha = params$alpha, cex = 1.6)
    title(file_name)
    dev.off()
  }
}
