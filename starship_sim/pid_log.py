from matplotlib import pyplot as plt


class PidLog():
    def __init__(self) -> None:
        self.errors = []
        self.p_outputs = []
        self.i_outputs = []
        self.d_outputs = []

    def save(self, error, p, i, d):
        self.errors.append(error)
        self.p_outputs.append(p)
        self.i_outputs.append(i)
        self.d_outputs.append(d)

    def __get_output_sum(self):
        return [sum(output) for output in zip(self.p_outputs, self.i_outputs, self.d_outputs)]

    def plot(self):
        plt.plot(self.errors, color='black')
        plt.plot(self.p_outputs, color='r')
        plt.plot(self.i_outputs, color='g')
        plt.plot(self.d_outputs, color='b')
        plt.plot(self.__get_output_sum(), color='grey')
        plt.show()