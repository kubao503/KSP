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

    def print(self):
        print(self.errors)

    def plot(self):
        plt.plot(self.errors, color='r')
        plt.plot(self.p_outputs, color='b')
        plt.plot(self.i_outputs, color='y')
        plt.plot(self.d_outputs, color='g')
        plt.show()