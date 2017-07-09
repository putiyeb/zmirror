FROM alpine

MAINTAINER TIANLAN <yitiandelan@outlook.com>

RUN apk --update --no-cache add gcc g++ curl python3 python3-dev \
    && apk add libc-dev && pip3 install --upgrade --no-cache-dir pip \
    && pip3 install --no-cache-dir gunicorn gevent requests flask cchardet fastcache lru-dict \
    && apk del gcc g++ libc-dev

RUN mkdir /var/www && cd /var/www \
    && curl -o tmp.tar.gz -L https://codeload.github.com/putiyeb/zmirror/tar.gz/master \
    && tar -xvf tmp.tar.gz && rm tmp.tar.gz \
    && mv zmirror-master zmirror && cp zmirror/more_configs/config_google_and_zhwikipedia.py zmirror/config.py

EXPOSE 80

CMD cd /var/www/zmirror && gunicorn --bind 0.0.0.0:80 --workers 2 --worker-connections 100 wsgi:application

