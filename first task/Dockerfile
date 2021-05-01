FROM tiangolo/uwsgi-nginx-flask:python3.8

# copy and install dependencies
COPY ./requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

# copy required application files
COPY ./clock.py /app/clock.py

# pass uwsgi module configuration
COPY ./uwsgi.ini /app/uwsgi.ini
