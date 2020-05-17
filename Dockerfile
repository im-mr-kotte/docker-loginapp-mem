#base image
FROM node:alpine

#install dependancies
WORKDIR /usr/loginapp
COPY ./package.json ./
RUN npm install
COPY ./ ./

EXPOSE 9999

#start-up command
CMD npm start