# =========================
# Stage 1: Build Angular App
# =========================
FROM node:20-alpine AS build

# Set working directory inside the container
WORKDIR /app

# Copy package files first to leverage caching of dependencies
COPY package.json yarn.lock ./

# Install node modules
RUN yarn install

# Copy the rest of the source code
COPY . .

# Build the Angular app in production mode
RUN yarn build --configuration production

# =========================
# Stage 2: Runtime image (Nginx)
# =========================
FROM nginx:alpine

# Copy the compiled Angular app from the build stage to Nginx web root
COPY --from=build /app/dist /usr/share/nginx/html

# Expose default Nginx port (optional, Docker Compose can handle ports)
# EXPOSE 80

# Nginx runs automatically in the container
# No CMD needed since nginx:alpine has default CMD
