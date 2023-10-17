from pid import PID
from pid_log import PidLog


class PidSim():
    def __init__(self, pitch_inertia, roll_inertia, step) -> None:
        self.pitch = 20
        self.roll = 0

        self.pitchSpeed = 0
        self.rollSpeed = 0

        self.PITCH_INERTIA = pitch_inertia
        self.ROLL_INERTIA = roll_inertia
        self.STEP = step

        self.pitch_pid = PID(0.02, 0, 1)
        self.roll_pid = PID(1, 0, 0)

        self.log = PidLog()


    def iteration(self, pitchMomentum, rollMomentum):
        self.pitchSpeed += pitchMomentum / self.PITCH_INERTIA
        self.rollSpeed += rollMomentum / self.ROLL_INERTIA

        self.pitch += self.pitchSpeed
        self.roll += self.rollSpeed


    def simulate(self, iterations):
        for _ in range(iterations):
            pitchMomentum = self.pitch_pid.update(self.pitch, self.log)
            #rollMomentum = self.roll_pid.result(self.roll)
            self.iteration(pitchMomentum, 0)
        self.log.plot()


sim = PidSim(pitch_inertia=10, roll_inertia=1, step=1)
sim.simulate(500)
