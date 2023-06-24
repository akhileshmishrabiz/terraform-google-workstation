FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# Install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg2 \
    software-properties-common \
    unzip

# Install Java 1.8
RUN apt-get install -y openjdk-8-jdk

# Install Git
RUN apt-get install -y git

# Install Node.js 14.17.4 and npm 6.14.14
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g npm@6.14.14

# Install PostgreSQL (psql)
RUN apt-get install -y postgresql-client

# Install Kubernetes CLI (kubectl)
RUN curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh

# Configuration  configuration - if you want any custom script to run, keep it
# under /etc/workstation-startup.d/ and it will run will deploying

COPY workstation-custom-setup.sh  /etc/workstation-startup.d/