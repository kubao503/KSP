from pid_log import PidLog


class PID():
    def __init__(self, kp, ki, kd) -> None:
        self.kp = kp
        self.ki = ki
        self.kd = kd
        self.old_error = 0
        self.error_sum = 0

    def update(self, error, log: PidLog = None):
        self.error_sum += error
        error_change = error - self.old_error
        self.old_error = error

        p_output = -self.kp * error
        i_output = -self.ki * self.error_sum
        d_output = -self.kd * error_change

        if log is not None:
            log.save(error, p_output, i_output, d_output)

        return p_output + i_output + d_output
