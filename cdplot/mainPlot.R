#!/usr/bin/Rscript

source('~/workspace/cd-plots/cdplot/cd.R') # Esse arquivo tem toda a criação do plot

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

parser$add_argument(
  'files',
  nargs='+',
  help='the files that be processed (CSV is expected)'
)

parser$add_argument(
  '--test',
  default=FALSE,
  type='logical',
  help='run Friedman and Nemenyi Tests (default = FALSE)'
)

parser$add_argument(
  '--cd',
  action='store_true',
  help='generate CD plot (default = TRUE)'
)

parser$add_argument(
  '--location',
  default='./',
  help='path to save the plots and outputs (default = ./)'
)

parser$add_argument(
  '--delimiter',
  default='\t',
  help='the delimiter in the files (default = \\t <TAB>)'
)

parser$add_argument(
  '--row',
  default=0,
  type='integer',
  help='the index of the names of the rows (default = 0)'
)

parser$add_argument(
  '--col',
  default=LETTERS,
  help='the name of the columns (default = capital letters)'
)

parser$add_argument(
  '--head',
  action='store_true',
  help='the first row is the columns names? (default = FALSE)'
)

parser$add_argument(
  '--alpha',
  default=0.05,
  type='double',
  help='The significance level of the test (default = 0.05)'
)

parser$add_argument(
  '--only',
  default='',
  help='List with all columns should be considered to create the plot (default = ""). Usage --only 1,3,6'
)

parser$add_argument(
  '--suffix',
  default='',
  help='Sufix of a plot name (default = "")'
)

parser$add_argument(
  '--decreasing',
  action='store_true',
  help='Use this option when the evaluated metric is a minimization metric. It means the loweest results must be has the best ranks.'
)

parser$add_argument(
  '--cex',
  default=1.6,
  type='double',
  help='The height of the lines of the saved figure (default = 1.6)'
)

parser$add_argument(
  '--width',
  default=800,
  type='integer',
  help='The width of the saved figure (default = 800)'
)

parser$add_argument(
  '--height',
  default=480,
  type='integer',
  help='The height of the saved figure (default = 480)'
)

#' @description Perform the Statistical test and send the output to the
#'    terminal.
#'
#' @param file_name name of the file.
#' @param data the dataframe object to be evaluated in the test.
#'
perform_friedman_test <- function(file_name, data) {
    cat('Friedman Test of ', file_name, '\n', rep('-', 30), '\n')
    print(friedmanTest(data))
    cat('\n\nPOST-HOC Test of ', file_name, '\n', rep('=', 30), '\n\n\n')
    print(frdAllPairsNemenyiTest(data))
}

#' @description generate a CD diagram and save it.
#'
#' @param data The dataframe to be used to generate the CD diagram.
#' @param plot_name name of the plot when figure is saved.
#' @param file_name Figure's title.
#' @param decreasing informs if the best results are the highest one or lowest.
#' @param alpha the alpha to be considered when calculating the CD line.
#' @param cex height of the lines in drawed figure.
#' @param width the width of the saved figure.
#' @param height the height of the saved figure.
#'
save_plot <- function(
    data,
    plot_name,
    file_name,
    decreasing,
    alpha,
    cex,
    width,
    height
) {
    png(plot_name, width, height)
    plotCD(
      data,
      decreasing=decreasing,
      alpha=alpha,
      cex=cex,
    )
    title(file_name)
    dev.off()
}

#' @description determine the plot name.
#'
#' @param file_name the name of the evaluated file.
#' @param location the location on disk where the figure is saved.
#' @param suffix the suffix of the figure, if exists.
#'
#' @return the full location on disk where the figure must be saved.
#'
plot_location <- function(file_name, location, suffix) {
    if (suffix != '') {
        return(paste(location, file_name, '_', suffix, '.png', sep=''))
    }
    return(paste(location, file_name, '.png', sep=''))
}

#' @description read a structured file (csv, tsv, etc)
#' 
#' @param file path to the file.
#' @param header is the file has a header? Default is False.
#' @param row_names the index of the id row, if exists. 0 to not use.
#' @param sep separator used in case if not using csv. Default is comma.
#'
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
for(file in params$files) {
    file_name <- strsplit(file, "[/.]")[[1]][3]
    data <- get_data(file, params$head, params$row, params$delimiter)
    print("Data is stored")
    if (params$only != '') {
        params$only <- c(as.numeric(strsplit(params$only, ',')[[1]]))
    } else {
        params$only <- c(1:length(params$col[1:ncol(data)]))
    }
    data <- data[, params$only]
    colnames(data) <- unlist(strsplit(params$col, ','))[1:ncol(data)]
    if (params$test) {
        perform_friedman_test(file_name, data)
    }
    if (params$cd) {
        print("Starting location")
        plot_name <- plot_location(file_name, params$location, params$suffix)
        print("Location stored!")
        cat('\n\n', plot_name, '\nFILE: ', file, '\n\n')
        save_plot(
            data,
            plot_name,
            file_name,
            params$decreasing,
            params$alpha,
            params$cex,
            params$width,
            params$height
        )
    }
}
