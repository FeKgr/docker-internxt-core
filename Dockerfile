
FROM ubuntu:latest
ARG VERSION
RUN apt-get update -y \
&& apt-get install -y wget git python build-essential\
&& cd ~ \
&& wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash\
&& export NVM_DIR="$HOME/.nvm"\
&& [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"\
&& [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"\
&& nvm install 8.15\
&& export STORJ_NETWORK=INXT\
&& git clone https://github.com/internxt/core-daemon\
&& cd core-daemon\
&& npm i && npm link\
&& mkdir /root/.xcore\
&& mkdir /root/.xcore/configs\
&& mkdir /root/.xcore/logs

COPY entrypoint.sh /root/entrypoint.sh

CMD ["/bin/bash", "/root/entrypoint.sh"]