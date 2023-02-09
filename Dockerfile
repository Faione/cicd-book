From peaceiris/mdbook:v0.4.21 as build

ADD . /book

WORKDIR /book

RUN mdbook build && ls -R

From nginx:stable-alpine

COPY --from=build /book/book /usr/share/nginx/html