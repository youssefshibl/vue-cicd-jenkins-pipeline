# Base image
FROM nginx

# Remove default NGINX configuration
RUN rm /etc/nginx/conf.d/default.conf
RUN rm -rf /usr/share/nginx/html/*


COPY ./nginx.conf /etc/nginx/nginx.conf

# Copy the built Vue.js app files into the container
COPY dist/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 8080

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]




