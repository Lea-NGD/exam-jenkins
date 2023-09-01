# FROM python:3.8-slim
# WORKDIR /app
# COPY ./requirements.txt /app/requirements.txt
# RUN apt-get update \
#     && apt-get install gcc -y \
#     && apt-get clean
# RUN pip install -r /app/requirements.txt \
#     && rm -rf /root/.cache/pip
# COPY ./app/main.py /app/
# COPY ./app/api/ /app/api/
# EXPOSE 8000
# CMD ["uvicorn", "app.main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]


FROM python:3.8-slim
WORKDIR /app
RUN apt-get update && apt-get install -y gcc
COPY ./requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt
COPY ./app /app/app
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]