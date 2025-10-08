# Stage 1: Dependency Installation and Build
# Use a specific, stable node version for consistency
FROM node:20-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install dependencies (only production dependencies are needed for the final image)
# Use 'npm ci' for clean installs in automated environments
RUN npm ci

# Copy the rest of the application code
COPY . .

# Run the Next.js build command
# Next.js will automatically create the .next folder
RUN npm run build

# Stage 2: Production Runtime
# Use a lean, minimal base image for the final production container
FROM node:20-alpine AS runner

# Set environment variables for Next.js
ENV NODE_ENV=production
# Define the port the app will run on
ENV PORT=3000

# Set the working directory
WORKDIR /app

# Copy built files and production dependencies from the builder stage
# Copy only necessary files for the runtime environment
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Expose the application port
EXPOSE 3000

# Command to start the Next.js application in production mode
# 'next start' is the recommended production startup command
CMD ["npm", "start"]