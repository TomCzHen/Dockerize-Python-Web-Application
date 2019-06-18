ARG python_version="3.7.3"
FROM python:${python_version}-slim as builder
ENV PIP_NO_CACHE_DIR=1 PYTHONDONTWRITEBYTECODE=1
RUN apt-get update && apt-get install -yqq gcc libpcre3-dev\
    python3-dev \
    libpq-dev \
    && pip install pipenv

COPY ["Pipfile","Pipfile.lock","/app/"]
WORKDIR /app
ENV PIPENV_PYPI_MIRROR="https://mirrors.aliyun.com/pypi/simple/"
ARG uwsig_version="2.0.18"
RUN mkdir .venv \
    && pipenv install --deploy \
    && pipenv install uwsgi==${uwsig_version} --skip-lock

FROM python:${python_version}-slim

COPY --chown=root:root ["docker/docker-entrypoint.sh","/usr/local/bin/"]
RUN apt-get update && apt-get install -yqq libpq5 \
    && chmod +x "/usr/local/bin/docker-entrypoint.sh"

ENV PATH="/app/.venv/bin:${PATH}" \
    PYTHONDONTWRITEBYTECODE=1 \
    UWSGI_HTTP_SOCKET=":3031" \
    UWSGI_MASTER=1 \
    UWSGI_WORKERS=2 \
    UWSGI_THREADS=4 \
    UWSGI_WSGI_FILE="app.py" \
    UWSGI_CALLABLE="app" \
    UWSGI_VIRTUALENV="/app/.venv" \
    UWSGI_STATUS=":9191"

WORKDIR /app
COPY --from=builder ["/app","/app"]
COPY . /app

ENTRYPOINT ["docker-entrypoint.sh"]
USER nobody
CMD ["uwsgi"]