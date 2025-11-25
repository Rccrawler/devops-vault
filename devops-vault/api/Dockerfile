FROM node:20-alpine AS base
WORKDIR /app
COPY package.json package-lock.json* tsconfig.json ./
COPY src ./src
RUN npm install && npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=base /app/dist ./dist
COPY package.json package-lock.json* ./
RUN npm install --production
ENV NODE_ENV=production
CMD ["node", "dist/main.js"]
