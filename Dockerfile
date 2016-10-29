FROM ruby:2.2-onbuild
MAINTAINER Kek <1-7-1@plus4u.net>
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0"]
EXPOSE 9292
