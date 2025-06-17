# Base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and lock file
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files
COPY . .

# Build Strapi admin UI
RUN npm run build

# Expose Strapi default port
EXPOSE 1337

# Start the app
CMD ["npm", "start"]

