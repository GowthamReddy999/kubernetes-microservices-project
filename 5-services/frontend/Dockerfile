FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY index.html .
COPY nginx.conf /etc/nginx/conf.d/default.conf
 
EXPOSE 80





####################################################
# This architecture is work in this Docker file
####################################################


  
# Your computer
# │
# └── frontend/
#     └── index.html
#           │
#           │ COPY
#           ↓
# Docker container
# │
# └── /usr/share/nginx/html/
#     └── index.html
#           │
#           ↓
#        Nginx
#           │
#           ↓
#       Port 80