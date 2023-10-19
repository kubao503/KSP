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
        fig, ax1 = plt.subplots()
        ax1.plot(self.errors, color='black')
        ax1.axhline(0, color='black')
        ax1.set_ylabel('error')

        ax2 = ax1.twinx()
        ax2.plot(self.__get_output_sum(), color='grey')
        ax2.axhline(0, color='grey')
        ax2.plot(self.p_outputs, color='r')
        ax2.plot(self.i_outputs, color='g')
        ax2.plot(self.d_outputs, color='b')
        ax2.set_ylabel('output')

        fig.tight_layout()
        plt.show()