# Stage 1: Build
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Production
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/node_modules ./node_modules

# Install the "serve" package to serve the built application
RUN npm install -g serve

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["serve", "-s", ".next", "-p", "3000"]
