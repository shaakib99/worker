FROM ubuntu:latest

WORKDIR /app

COPY . .

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Setup SSH
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# Fix SSH issues related to privilege separation (in Docker)
RUN echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config

# Install Python requirements
RUN pip3 install -r requirements.txt --break-system-packages

# Start SSH and FastAPI
CMD ["/bin/bash", "-c", "/usr/sbin/sshd && fastapi run main.py --port=6969"]
