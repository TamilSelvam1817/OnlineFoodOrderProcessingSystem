# ===================================================================
# Stage 1: Build React Vite Application using Node 20
# ===================================================================
FROM node:20-alpine AS builder
WORKDIR /app

# Declare build argument for dynamic backend URL on Railway
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

# Copy dependency manifests and install dependencies
COPY package.json package-lock.json* ./
RUN npm install

# Copy application source code and build production bundle
COPY . .
RUN npm run build

# ===================================================================
# Stage 2: Production Nginx Runtime Image
# ===================================================================
FROM nginx:alpine AS runner
WORKDIR /usr/share/nginx/html

# Remove default Nginx static files
RUN rm -rf ./*

# Copy built dist artifacts from builder stage
COPY --from=builder /app/dist ./

# Copy custom Nginx configuration for React Router SPA support
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
