# Stage 1: Dependencies
FROM node:18 AS dependencies

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Stage 2: Development
FROM node:18

# Set working directory
WORKDIR /app

# Copy only the necessary files from the dependencies stage
COPY --from=dependencies /app /app

# Expose the port the app runs on
EXPOSE 3000

# Set environment variables (if any, adjust as needed)
# ENV LIVEBLOCKS_SECRET_KEY=sk_your_secret_key_here

# Command to run the application in development mode
CMD ["npm", "run", "dev"]
