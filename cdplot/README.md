# Diagrama de Diferença Crítica (CD)

## Instalação
para utilizar esse código são necessários os seguintes recursos (linguagens e pacotes):
- R > 4.0
  - PMCMRplus¹; e
  - argparse
- Python 3.8+

¹ Pode ser que seja necessário instalar libs complementares: `libgmp3-dev libmpfr-dev`
----
Em relação aos pacotes do R, o script verifica e faz o download se necesário.

## Utilização
Antes de tudo, abra o arquivo `mainPlot.R` e informe o path completo para o
diretório onde está o aquivo `cd.R`. Assim, é possível fazer as chamadas do
script de qualquer local em sua máquina.

### Gerando os CD's plots
Para executar o script é bem simples, há duas formas:
#### 1ª Forma: Supondo que você está na pasta que tem os seus csv's (RECOMENDADO).
```sh
$ Rscript ./cdplot/mainPlot.R *.csv --test TRUE
```
desta maneira, é esperado que sejam excutados tanto o teste de Friedman e o
post-hoc de Nemenyi, além de serem gerados os CD's de todos os arquivos csv
passados por parâmetro. Para mais opções de customização do script use a _flag_
-h para verificar a documentação.

**IMPORTANTE:** se for utilizar desta forma, lembre de alterar o _path_ do
arquivo `cd.R` para o path onde o script está localizado, para que consiga
utilizá-lo da forma mais eficaz.

----
#### 2ª Forma: Supondo que você esteja na pasta do script.
```sh
$ Rscript mainPlot.R ~/path/to/csv
```
---
### Ajustar o tamanho do CD
Após gerar os CD's plots, pode ser necessário fazer um crop na imagem. Haja
vista que o tamanho da figura é maior que a área que o gráfico ocupa. Para tal,
execute, do console, o programa _crop.py_:
```sh
$ python crop.py png 80 0 700 480
```

Esse script vai extrair uma subregião da figura, armazenando as novas imagens
numa nova pasta chamada _converted_. Altere os valores conforme a necessidade,
estes são os valores default do script. **É interessante utilizar esse script
no diretório das imagens.**
