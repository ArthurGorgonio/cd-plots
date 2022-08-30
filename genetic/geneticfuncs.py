from mygenetic import MyGenetic
from random import randrange
from utils import decoder
from statstest import run_friedman, run_posthoc


# def fitness(solution, database):
#     # TODO trocar a função fit para utilizar a média do conjunto..
#     datasets = database.loc[decoder(solution)]
#     baseline = datasets.describe().iloc[1, 0]
#
#     if (run_friedman(datasets) < 0.05
#             and (baseline < datasets.describe().iloc[1, -1]
#                  or baseline < datasets.describe().iloc[1, -2])):
#         nemenyi = run_posthoc(datasets)
#         fit = sum(sum(nemenyi.iloc[1:, :-1].values < 0.05))
#
#         return fit
#     else:
#         return 0


# def fitness(solution, database):
#     # TODO trocar a função fit para utilizar a média do conjunto..
#     datasets = database.loc[decoder(solution)]
#
#     if run_friedman(datasets) < 0.05:
#         nemenyi = run_posthoc(datasets)
#         fit = sum(sum(nemenyi.iloc[1:, :-1].values < 0.05))
#
#         return fit
#     else:
#         return 0

def fitness(solution, database):
    # TODO trocar a função fit para utilizar a média do conjunto..
    datasets = database.loc[decoder(solution)]
    baseline = datasets.describe().iloc[1, 0]

    if (baseline < datasets.describe().iloc[1, -1]
            or baseline < datasets.describe().iloc[1, -2]):

        return run_friedman(datasets)
    else:

        return 1


def mutate(solution):
    mutate_idx = randrange(len(solution))

    solution[mutate_idx] = [1, 0][solution[mutate_idx]]


def crossover(solution_1, solution_2):
    idx = randrange(len(solution_1))
    solution_1[:idx], solution_2[:idx] = solution_2[:idx], solution_1[:idx]

    return [solution_1, solution_2]


# def selection(gen):
#     bests = []
#
#     for i in range(len(gen) // 5):
#         bests.append(gen[i])
#
#     return choice(bests)

def create_solution(datasets):
    individual = [1] * len(datasets)

    off_dataset = randrange(1, len(datasets) - 29)

    while off_dataset > 0:
        off_dataset -= 1
        i = randrange(0, len(individual))
        individual[i] = [1, 0][individual[i]]

    return individual


def search_solution(data):
    ga = MyGenetic(data, population_size=100, generations=50,
                   crossover_probability=0.80, mutation_probability=0.15,
                   elitism=True, maximise_fitness=False)
    ga.create_individual = create_solution
    ga.mutate_function = mutate
    ga.crossover_function = crossover
    # ga.selection_function = selection
    ga.fitness_function = fitness
    # application of ga
    ga.run()

    return ga.best_individual()[1], ga.best_individual()[0]
