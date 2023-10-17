from starship_sim import starship_profit
from evolutionary_solver import EvolutionarySolver as ES
import numpy as np


def get_init_population(population_size, genotype_size):
    return np.zeros((population_size, genotype_size))

def main():
    solver = ES(t_max=500, pc=0.1, pm=0.1)
    population = get_init_population(20, 6)
    pid, profit = solver.solve(starship_profit, population)
    print(pid, profit)

main()