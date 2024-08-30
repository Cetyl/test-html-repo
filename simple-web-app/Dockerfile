# Use the official Nginx image based on Alpine Linux
FROM nginx:alpine

# Set the working directory in the container
WORKDIR /usr/share/nginx/html

# Copy the web application files into the container
COPY index.html .

# Expose port 80 to the outside world
EXPOSE 80

# Nginx runs by default, so no need to specify the command
