FROM python:alpine

WORKDIR /app

COPY django-crm/requirements.txt .

# Build deps to compile mysqlclient, then remove them.
# Keep the MySQL runtime library (libmariadb.so.3) for mysqlclient at runtime.
RUN apk add --no-cache --virtual .build-deps gcc musl-dev mariadb-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del .build-deps \
    && apk add --no-cache mariadb-connector-c

COPY django-crm .
COPY settings.py /app/webcrm/settings.py

EXPOSE 8000
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
