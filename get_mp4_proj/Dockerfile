# Purpose: Build Docker image in order to run get_mp4* shell scripts
#
# Requirements: 
# - Create Docker volume in order to map /data from container
# ---> docker create --driver local --opt type=none --opt device=/data --opt o=bind myVolume
#
# 
# 
# Image to install
FROM ubuntu

# Perform upgrade and install necessary packages
RUN apt-get upgrade -y
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  man \
  wget \
  vim \
  mlocate \
  file \
  iputils-ping \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get clean 


# Create directories
RUN mkdir -p /app
RUN mkdir -p /data

# Copy files from HOST to image
ADD ./get_mp4_proj/get* /bin/

# When connecting to container start in this directory
WORKDIR /data

ENTRYPOINT [ "/bin/get_mp4_index.sh" ]
