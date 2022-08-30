source('cd.R') # Esse arquivo tem toda a criação do plot

# Instalação e carregamento de pacotes necessário para utilizar os diagramas
packages <- c('PMCMRplus')
for (pack in packages) {
  if (!require(pack, character.only = TRUE)) {
    install.packages(pack)
  }
  library(pack, character.only = TRUE, verbose = F)
}

#' @description Carregar a base de dados para a memória.
#' @param file caminho do arquivo csv
#' @param header qual linha que possui o cabeçalho do csv (default = FALSE)
#'    isto é, o arquivo csv não tem cabeçalho.
#' @param row_names qual coluna tem o nome das linhas (default = 0)
#'    isto é, o arquivo csv não tem nome das linha (requerido pelo teste estatístico).
#' @param sep é o separador do arquivo csv (default = ',')
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

# Coloque aqui a lista de csv que deverá ser executada
#files <- c('')

# Se existirem muitos arquivos, é melhor usar a outra forma
files <- list.files(path='./', pattern='*.csv')

# Nomes dos algoritmos que estão sendo avaliados
alg_names <- c('NB', 'SMV', 'MLP', 'k-NN', 'RF')


# Parâmetros adicionais

location <- './' # Local para salvar o teste
verbose_test <- TRUE # Imprime na tela os resultados dos testes de Friedman e
                     #  do post-hoc para cada um dos arquivos csvs.
run_cd <- TRUE # Executa o diagrama de diferença crítica
alpha <- 0.05 # Nível de significância do diagrama de diferença crítica.

for(file in files) {
    file_name <- strsplit(file, "[.]")[[1]][1]
    cat("FILE:")
    print(file_name)
    data <- get_data(file, header=FALSE, row_names=0, sep='\t')
    colnames(data) <- alg_names
    if (verbose_test) {
        cat('Friedman Test of ', file_name, '\n', rep('-', 30), '\n')
        print(friedmanTest(data))
        cat('\n\nPOST-HOC Test of ', file_name, '\n', rep('=', 30), '\n\n\n')
        print(frdAllPairsNemenyiTest(data))
    }
    if (run_cd) {
        cat(paste(location, file_name, '.png', sep=''))
        png(paste(location, file_name, '.png', sep=''), 770, 480,
            bg = 'transparent')
        par(family='Verdana')
        plotCD(data, alpha = alpha, cex = 1.6)
        title(file_name)
        dev.off()
    }
}
