FROM python:3.10

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

WORKDIR /app/To_Do

RUN chmod +x ../scripts/entrypoint.sh

ENTRYPOINT ["sh", "../scripts/entrypoint.sh"]
