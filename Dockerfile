FROM python:3.10.16-bullseye

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

RUN chmod +x /app/scripts/setup_django_dev.sh

WORKDIR /app/To_Do

ENTRYPOINT ["sh", "/app/scripts/setup_django_dev.sh"]
