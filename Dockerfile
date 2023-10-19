FROM python:3.7
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install -y cron
RUN mkdir /app
WORKDIR /app
COPY ./requirements.txt /app
RUN pip3 install -r requirements.txt
COPY . /app/

ADD crontab /etc/cron.d/app
RUN chmod 0644 /etc/cron.d/app
RUN crontab /etc/cron.d/app
RUN touch /var/log/cron.log
RUN ["chmod", "0644", "/var/spool/cron/crontabs/root"]

COPY ./start-celeryworker /start-celeryworker
RUN sed -i 's/\r$//g' /start-celeryworker
RUN chmod +x /start-celeryworker

COPY ./start-celerybeat /start-celerybeat
RUN sed -i 's/\r$//g' /start-celerybeat
RUN chmod +x /start-celerybeat

COPY ./start-flower /start-flower
RUN sed -i 's/\r$//g' /start-flower
RUN chmod +x /start-flower

EXPOSE 8000

CMD ["/bin/bash", "start_api.sh"]
