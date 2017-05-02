FROM ruby:2.3.3

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get -yy install libmysqld-dev libpq-dev libsqlite3-dev
RUN apt-get -yy install nginx nodejs
RUN apt-get install -y qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -yy p7zip-full
RUN curl -Ls https://install.convox.com/linux.zip > convox.zip && 7z e convox.zip -o/usr/local/bin
RUN mkdir /usr/src/terminus

ENV PORT 5000

WORKDIR /usr/src/app

COPY Gemfile      /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock

RUN bundle install

COPY config/convox.rb /usr/src/app/config/initializers/convox.rb
COPY bin/web /usr/src/app/bin/web
COPY config/nginx.conf /etc/nginx/nginx.conf

COPY . /usr/src/app

# TODO:  BAD IDEA!
COPY id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN ssh-keyscan -H github.com >> ~/.ssh/known_hosts


#RUN bundle exec rake assets:clobber
#RUN bundle exec rake assets:precompile

# CMD ["./bin/web"]
# docker exec  argos-the-loyal-web rake  db:migrate