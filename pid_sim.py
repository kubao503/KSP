from pid import PID


class PidSim():
    def __init__(self, pitch_inertia, roll_inertia, step) -> None:
        self.pitch = 0.1
        self.roll = 0

        self.pitchSpeed = 0
        self.rollSpeed = 0

        self.PITCH_INERTIA = pitch_inertia
        self.ROLL_INERTIA = roll_inertia
        self.STEP = step

        self.pitch_pid = PID(0.05, 0, 0)
        self.roll_pid = PID(1, 0, 0)


    def iteration(self, pitchMomentum, rollMomentum):
        self.pitchSpeed += pitchMomentum / self.PITCH_INERTIA
        self.rollSpeed += rollMomentum / self.ROLL_INERTIA

        self.pitch += self.pitchSpeed
        self.roll += self.rollSpeed


    def print_results(self):
        print(f'{self.pitch:.5f}')


    def simulate(self, iterations):
        for _ in range(iterations):
            pitchMomentum = self.pitch_pid.result(self.pitch)
            #rollMomentum = self.roll_pid.result(self.roll)
            self.iteration(pitchMomentum, 0)
            self.print_results()


sim = PidSim(1, 1, 1)
sim.simulate(10)
