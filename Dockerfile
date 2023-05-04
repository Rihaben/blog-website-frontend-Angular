# Base image
FROM node:latest AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build --prod

# Use a lightweight nginx image to serve the application
FROM nginx:latest

# Copy the built app from the previous stage
COPY --from=build /app/dist/blog-website-frontend-Angular /usr/share/nginx/html

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
