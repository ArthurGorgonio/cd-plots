import pandas as pd
from geneticfuncs import search_solution
from time import time
from utils import decoder_human

data = pd.read_csv('~/Cephas/st-fm.csv', sep='\t', header=None)

for i in range(3):
    begin = time()
    solution, fit = search_solution(data)
    end = time()
    print(f'Iteration: {i}\nBest solution datasets {decoder_human(solution)}'
          f'\nQTD = {len(decoder_human(solution))}\tFit = {fit}'
          f'\nEnlapsed = {end - begin} secs\n\n---------------------------')
