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


    def iteration(self, pitch_acceleration, roll_acceleration):
        self.pitchSpeed += pitch_acceleration * self.PITCH_INERTIA
        self.rollSpeed += roll_acceleration * self.ROLL_INERTIA

        self.pitch += self.pitchSpeed
        self.roll += self.rollSpeed


    def simulate(self, iterations):
        for _ in range(iterations):
            pitchAcceleration = self.pitch_pid.update(self.pitch, self.log)
            #rollAcceleration = self.roll_pid.result(self.roll)
            self.iteration(pitchAcceleration, 0)
        self.log.plot()


sim = PidSim(pitch_inertia=1, roll_inertia=1, step=1)
sim.simulate(500)
