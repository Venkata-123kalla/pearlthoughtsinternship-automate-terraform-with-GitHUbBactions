# Use official Node.js image (non-Alpine to avoid sqlite issues)
FROM node:18

# Set working directory
WORKDIR /app

# Copy dependency files first
COPY package*.json tsconfig.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build Strapi admin panel and TypeScript code
RUN npm run build

# Expose the default Strapi port
EXPOSE 1337

# Start the application
CMD ["npm", "start"]

