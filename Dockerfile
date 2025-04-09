ARG RUNNER_TOKEN
# Basis: offizielles Node.js-Image mit Debian
FROM node:20-bullseye

# Metadaten
LABEL maintainer="dein.name@domain.de"
LABEL description="UI5 / JavaScript / XML Linter und Test Umgebung"

# Installiere systemweite Tools
RUN apt-get update && apt-get install -y \
  git \
  curl \
  libxml2-utils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# sudo für evtl. manuelle Nachinstallationen
RUN apt-get update && apt-get install -y sudo
RUN apt-get install wget -y

RUN wget -q https://packages.cloudfoundry.org/stable?release=debian64 -O cf8-cli.deb && sudo dpkg -i cf8-cli.deb

RUN apt-get install -y neovim
RUN apt-get install -y jq

RUN npm install -g @ui5/cli
RUN npm install -g @sap/ux-ui5-tooling
RUN npm install -g mbt


RUN npm i -g @sap/cds-dk


# Optional: package.json schon vorbereiten
#COPY package.json package-lock.json* ./

# Installiere ESLint + UI5 Plugin + Jest
RUN npm install -g eslint 
# Optional: Beispiel-Config für ESLint
#COPY .eslintrc.js ./

# Default-Befehl (kannst du natürlich ändern)
CMD [ "bash" ]

# Erstelle Arbeitsverzeichnis
WORKDIR /workspace

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN mkdir actions-runner && cd actions-runner
RUN npm init -y

# Benutzer für runner
RUN useradd -m runner && \
    chown -R runner:runner /workspace

USER runner

RUN curl -o actions-runner-linux-x64-2.323.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-x64-2.323.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.323.0.tar.gz

CMD ["./run.sh"]
RUN echo 'docker run -it -e RUNNER_TOKEN= -e REPO_URL= --name runner runner-image  to start'
RUN echo 'docker exec -it --user root <container> eslint --init  to setup eslint'
