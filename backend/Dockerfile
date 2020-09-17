FROM python:3.7
WORKDIR /app
COPY ./requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 5001
ENTRYPOINT [ "/usr/local/bin/python", "app.py" ]
