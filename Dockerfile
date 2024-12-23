FROM nginx:1.27.3

COPY public /usr/share/nginx/html

EXPOSE 80
