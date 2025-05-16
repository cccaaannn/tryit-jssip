# Stage 1: Build the application
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json* ./
RUN npm install --legacy-peer-deps
RUN npm install -g gulp-cli

# Copy the rest of the application source code
COPY . .

# Build the application
RUN gulp prod

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Copy the built static files from the builder stage
COPY --from=builder /app/out /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]