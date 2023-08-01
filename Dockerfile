FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y

#RUN http_proxy=$http_proxy https_proxy=$http_proxy add-apt-repository ppa:deadsnakes/ppa -y
#RUN http_proxy=$http_proxy https_proxy=$http_proxy apt-get update
#RUN http_proxy=$http_proxy https_proxy=$http_proxy apt-get install python3.8 python3-dev python3-setuptools -y
#RUN http_proxy=$http_proxy https_proxy=$http_proxy apt-get install python3.8-distutils -y
#RUN http_proxy=$http_proxy https_proxy=$http_proxy apt-get install python3.8-distutils -y
#RUN http_proxy=$http_proxy https_proxy=$http_proxy curl https://bootstrap.pypa.io/get-pip.py | http_proxy=$http_proxy https_proxy=$http_proxy python3.8
#RUN http_proxy=$http_proxy https_proxy=$http_proxy python3.8 -m pip install pip
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN http_proxy=$http_proxy https_proxy=$http_proxy apt-get -y install software-properties-common zip jq unzip postgresql curl gettext-base libpq-dev
RUN apt-get -y install zip jq unzip postgresql curl gettext-base libpq-dev
RUN apt-get update
RUN apt-get install python3 python3-pip python3-dev python3-setuptools -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


########### USE USERPROXY CERTS ############
COPY certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates
############################################

########### INSTALL PYTHON3.8 FOR COMPATIBILITY WITH CDE ############
##RUN http_proxy=$http_proxy https_proxy=$http_proxy add-apt-repository ppa:deadsnakes/ppa -y
##RUN http_proxy=$http_proxy https_proxy=$http_proxy apt-get update
##RUN http_proxy=$http_proxy https_proxy=$http_proxy apt-get install python3.8 -y
####################################################################

###################UNCOMMENT###########################
############ INSTALL Node + aws-cdk ############
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs
#RUN npm config set registry http://registry.npmjs.org/
# cdk v2
RUN npm config set strict-ssl false && npm install -g aws-cdk@2.88.0
#Uncomment for cdk v1
#RUN npm install -g aws-cdk cdk-assume-role-credential-plugin
####################################
#
#
############ INSTALL DOCKER ############
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN curl -sSL https://get.docker.com/ | sh
########################
#
############ INSTALL AWS CLI + PIP UPGRADE ############
RUN python3 -m pip install pip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

RUN git config --global http.proxyAuthMethod 'basic'
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | https_proxy=$http_proxy bash
###################UNCOMMENT###########################

RUN echo export PATH="\
/root/.nvm/versions/node/${NODE_VERSION}/bin:\
$(python3 -m site --user-base)/bin:\
$PATH" >> ~/.bashrc && \
    echo "nvm install ${NODE_VERSION}" && \
    echo "nvm use ${NODE_VERSION} 1> /dev/null" >> ~/.bashrc

###################UNCOMMENT###########################
########### INSTALL NGINX FOR FRONTEND CONTAINER ############
RUN apt-get install -y nginx
###############################################
###################UNCOMMENT###########################

###################UNCOMMENT###########################
RUN /bin/bash -c  ". ~/.nvm/nvm.sh && npm --version && node --version "
RUN #/bin/bash -c  ". ~/.nvm/nvm.sh && npm install"

ENV PATH="./node_modules/.bin:$PATH"

RUN /bin/bash -c  ". ~/.nvm/nvm.sh && cdk --version"
###################UNCOMMENT###########################

#CMD service nginx start  && service docker start
#RUN apt-get -y install docker.io containerd
