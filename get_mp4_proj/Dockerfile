# Purpose: Build Docker image in order to run get_mp4* shell scripts
#
# Requirements: 
# - Create Docker volume in order to map /data from container
# ---> docker volume create --driver local --opt type=none --opt device=/data --opt o=bind myVolume
#
# 
# 
# Image to install
FROM fedora:latest

# Perform upgrade and install necessary packages
RUN dnf upgrade -y
RUN dnf update && \
  dnf install -y  \
  man \
  wget \
  vim \
  mlocate \
  file \
  iputils\
  && rm -rf /var/lib/apt/lists/*
RUN dnf clean all


# Create directories
RUN mkdir -p /app
RUN mkdir -p /data

# Copy files from HOST to image
# Requires FQN (/home/washingd/GIT_REPO/python_course/get_mp4_proj) OR run build command in the FQN path
ADD ./get* /bin/

# When connecting to container start in this directory
WORKDIR /data

ENTRYPOINT [ "/bin/get_mp4_index.sh" ]
