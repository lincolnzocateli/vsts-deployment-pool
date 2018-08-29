FROM ubuntu:18.04

LABEL maintainer="Lincoln Zocateli <lincoln@nuuve.com.br>" \
        org.label-schema.description="Agent VSTS deployment pool with base linux ubuntu" \
        org.label-schema.name="vsts-deployment-pool" \
        org.label-schema.url="https://nuuve.com.br" \
        org.label-schema.vcs-url="https://github.com/lincolnzocateli/vsts-deployment-pool/tree/master" \
        org.label-schema.usage="https://github.com/lincolnzocateli/vsts-deployment-pool/blob/master/README.md" \
        org.label-schema.vendor="Nuuve Information Technology" \
        org.label-schema.version="v1.0.0" \
        org.label-schema.schema-version="1.0.0" \
        org.label-schema.docker.cmd="docker run --name vsts-deployment-pool \
        -d \
        -e VS_TENANT=your vsts tenant \
        -e AGENT_PAT=your vsts PAT \
        -e AGENT_POOL=your vsts pool \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        -v /home/my dir/teste:/vsts-deployment-pool/_works \
        lzocateli/vsts-deployment-pool:vX.Y.Z " \
        org.label-schema.docker.cmd.test="docker run --name vsts-deployment-pool \
        -ti \
        -e VS_TENANT=your vsts tenant \
        -e AGENT_PAT=your vsts PAT \
        -e AGENT_POOL=your vsts pool \
        --rm \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        -v /home/my dir/teste:/vsts-deployment-pool/_works \
        lzocateli/vsts-deployment-pool:vX.Y.Z "  


# Install basic command-line utilities
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-utils \
    curl \
    dnsutils \
    file \
    ftp \
    iproute2 \
    iputils-ping \
    locales \
    openssh-client \
    sudo \
    telnet \
    time \
    unzip \
    wget \
    zip \
    tzdata \
    vim \
    gedit \
    rsync \
    software-properties-common \
 && rm -rf /var/lib/apt/lists/*

# Install essential build tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

#Intall dotnet core dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libuuid1 \
    libicu60 \
    libunwind8 \
    apt-transport-https \    
 && apt-add-repository ppa:git-core/ppa \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    git \
 && rm -rf /var/lib/apt/lists/*

# Install azcopy 
RUN wget -O azcopy.tar.gz https://aka.ms/downloadazcopylinux64 \
 && tar -xf azcopy.tar.gz \
 && ./install.sh \
 && rm ./install.sh \
 && rm -rf azcopy \
 && rm -rf azcopy.tar.gz

# Install .NET Core SDK and initialize package cache
RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb > packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && rm packages-microsoft-prod.deb \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-transport-https \
    dotnet-sdk-2.1 \
 && rm -rf /var/lib/apt/lists/*
RUN dotnet help
ENV dotnet=/usr/bin/dotnet

# Install Azure Cli:
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/azure-cli.list \
 && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && apt-get update \
 && apt-get install -y apt-transport-https \    
    azure-cli \
 && rm -rf /var/lib/apt/lists/*

# Install PowerShell:
RUN curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v6.0.2/powershell-6.0.2-linux-x64.tar.gz \
 && mkdir -p /opt/microsoft/powershell/6.0.2 \
 && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/6.0.2 \
 && rm /tmp/powershell.tar.gz \
 && chmod +x /opt/microsoft/powershell/6.0.2/pwsh \
 && ln -s /opt/microsoft/powershell/6.0.2/pwsh /usr/bin/pwsh

# Intall NodeJs
RUN NODE_VERSION=$( \
        curl -sL https://nodejs.org/dist/latest/ | \
        tac | \
        tac | \
        grep -oPa -m 1 '(?<=node-v)(.*?)(?=-linux-x64\.tar\.xz)' | \
        head -1 \
    ) \
 && echo $NODE_VERSION \
 && curl -SLO "https://nodejs.org/dist/latest/node-v$NODE_VERSION-linux-x64.tar.xz" -o "node-v$NODE_VERSION-linux-x64.tar.xz" \
 && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
 && rm "node-v$NODE_VERSION-linux-x64.tar.xz"


WORKDIR /vsts-deployment-pool
RUN curl -fkSL -o vstsagent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.138.6/vsts-agent-linux-x64-2.138.6.tar.gz \
 && tar -zxvf vstsagent.tar.gz \
 && rm vstsagent.tar.gz

RUN git clone -b master https://github.com/lincolnzocateli/vsts-deployment-pool.git \
 && cp ./vsts-deployment-pool/agent/*.sh . \
 && rm -rf vsts-deployment-pool \
 && chmod +x *.sh 

CMD ["/vsts-deployment-pool/depConfigureOrRun.sh"]