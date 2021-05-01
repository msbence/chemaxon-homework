from flask import Flask
app = Flask(__name__)


@app.route('/')
def index():
    """Application main entrypoint, provides usage information."""
    return '''
    Clock mirror2real API<br>
    <br>
    Usage: GET /{hour}/{minute}
    '''

@app.route('/health')
def healthcheck():
    """Returns something if the application is running."""
    return 'OK'

@app.route('/<int:hour_in_mirror>/<int:minute_in_mirror>')
def get_real_time(hour_in_mirror, minute_in_mirror):
    """
    Converts mirrored time into real time.

    Parameters
    ----------
    hour_in_mirror : int
        The hour visible in mirror
    minute_in_mirror : int
        The minute visible in mirror

    Returns
    -------
    str
        The real time as string, in HH:mm format
    """
    real_hour = 11 - hour_in_mirror
    real_minute = 60 - minute_in_mirror

    if minute_in_mirror == 0:
        real_minute = 0
        real_hour += 1
    
    if real_hour <= 0:
        real_hour = 12 + real_hour

    return '{hour:02d}:{minute:02d}'.format(hour=real_hour, minute=real_minute)