class PID():
    def __init__(self, kp, ki, kd) -> None:
        self.kp = kp
        self.ki = ki
        self.kd = kd
        self.old_error = 0
        self.error_sum = 0

    def result(self, error):
        self.error_sum += error
        error_change = error - self.old_error
        self.old_error = error
        return -self.kp * error - self.ki * self.error_sum - self.kd * error_change
