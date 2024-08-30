# Use the official NGINX image from the Docker Hub
FROM nginx:alpine

# Copy the index.html file into the container
COPY simple-web-app/index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]
