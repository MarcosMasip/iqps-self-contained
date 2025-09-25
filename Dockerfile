FROM python:3.8-slim
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	default-mysql-client \
	libmariadb-dev-compat libmariadb-dev \
	&& rm -rf /var/lib/apt/lists/*
RUN mkdir -p /iqps
RUN mkdir -p /var/www/static
RUN mkdir -p /var/log/iqps
ADD requirements.runtime.txt /iqps/
RUN pip install --upgrade pip && pip install -r /iqps/requirements.runtime.txt
ADD . /iqps/

WORKDIR /iqps/iqps/
