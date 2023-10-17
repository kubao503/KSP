from pid import PID
from pid_log import PidLog


def starship_profit(pitch_params):
    # error, acceleration, acceleration change
    pid_kit = StarshipPIDKit(pitch_params)
    sim = StarshipSim(pitch_inertia=1, roll_inertia=1, step=1, pid_kit=pid_kit)
    sim.simulate(500)
    return 1


class StarshipPIDKit():
    def __init__(self, pitch_params) -> None:
        self.pitch = PID(*pitch_params[:3])
        self.pitch_speed = PID(*pitch_params[3:])
        #self.roll = PID(roll_params[:3])
        #self.roll_speed = PID(roll_params[3:])


class StarshipSim():
    def __init__(self, pitch_inertia, roll_inertia, step, pid_kit: StarshipPIDKit) -> None:
        self.pitch = 20
        self.roll = 0

        self.pitchSpeed = 0
        self.rollSpeed = 0

        self.PITCH_INERTIA = pitch_inertia
        self.ROLL_INERTIA = roll_inertia
        self.STEP = step

        self.pid_kit = pid_kit
        self.log = PidLog()


    def __iteration(self, pitch_acceleration, roll_acceleration):
        self.pitchSpeed += pitch_acceleration * self.PITCH_INERTIA
        self.rollSpeed += roll_acceleration * self.ROLL_INERTIA

        self.pitch += self.pitchSpeed
        self.roll += self.rollSpeed


    def simulate(self, iterations):
        for _ in range(iterations):
            pitchAcceleration = self.pid_kit.pitch.update(self.pitch, self.log)
            #rollAcceleration = self.pid_kit.roll.result(self.roll)
            self.__iteration(pitchAcceleration, 0)
        #self.log.plot()
