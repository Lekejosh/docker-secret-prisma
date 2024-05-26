FROM node:alpine

WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Install TypeScript globally if you need to compile TypeScript files
RUN npm install -g typescript

# Compile TypeScript files (if any)
RUN tsc || true  

# Generate Prisma client and build the application
RUN npx prisma generate && npm run build

# Copy the entry script and ensure it is executable
COPY entry.sh /usr/src/app/entry.sh
RUN chmod +x /usr/src/app/entry.sh

# Start the application using the entry script
CMD ["/usr/src/app/entry.sh"]
