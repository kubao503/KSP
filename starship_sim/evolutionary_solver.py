import random
import numpy as np


class EvolutionarySolver():
    def __init__(self, t_max, pc, pm):
        self.set_parameters(t_max, pc, pm)

    def set_parameters(self, t_max, pc, pm):
        self.t_max = t_max
        self.pc = pc
        self.pm = pm

    def solve(self, profit_func, population, profit_const=0):
        assessment = self.__assess_population(population, profit_func)
        best_individual, best_profit = self.__find_best_individual(population, assessment)

        for _ in range(self.t_max):
            population = self.__selection(population, assessment, profit_const)
            population = self.__crossover(population)
            population = self.__mutation(population)
            assessment = self.__assess_population(population, profit_func)
            good_individual, good_profit = self.__find_best_individual(population, assessment)
            if good_profit > best_profit:
                best_individual = good_individual
                best_profit = good_profit

        return best_individual, best_profit


    def __assess_population(self, population, profit_func, const=0):
        return np.array([profit_func(individual) + const for individual in population])

    def __find_best_individual(self, population, assessment):
        return max(zip(population, assessment), key=lambda x: x[1])

    def __selection(self, population, assessment, const):
        assessment += const
        total_profit = sum(assessment)
        roulette_wheel = assessment / total_profit
        results = []
        for _ in range(len(population)):
            selected_individual = population[self.__roulette(roulette_wheel)]
            results.append(selected_individual)
        return np.array(results)

    # Returns index of random element from roulette_wheel
    # Probability is based on elements value
    def __roulette(self, roulette_wheel):
        sum = 0
        ball_position = random.random()
        for index, roulette_number in enumerate(roulette_wheel):
            sum += roulette_number
            if sum > ball_position:
                return index

    def __crossover(self, population: np.array):
        result = []
        if len(population) % 2 == 1:
            raise ValueError(len(population))
        np.random.shuffle(population)
        for pair in np.split(population, len(population) / 2):
            if random.random() < self.pc:
                result.extend(self.__pair_crossover(pair)) # Do crossover
            else:
                result.extend(pair) # Leave pair as it is
        return result

    def __pair_crossover(self, pair):
        individual1, individual2 = pair
        if (len(individual1) != len(individual2)):
            raise ValueError()
        cutting_point = random.randrange(1, len(individual1))
        return\
            np.concatenate((individual1[:cutting_point], individual2[cutting_point:])),\
            np.concatenate((individual2[:cutting_point], individual1[cutting_point:]))

    def __mutation(self, population):
        result = []
        for individual in population:
            for index, gene in enumerate(individual):
                if random.random() < self.pm:
                    individual[index] = max(np.random.normal(gene, 1), 0) # Switching gene value
            result.append(individual)
        return result
