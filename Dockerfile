FROM tkaaad97/haskell:8.2.2 AS build

# install dev tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends neovim && \
    apt-get install -y --no-install-recommends tmux

# stack config
RUN printf "\nallow-different-user: true\n" >> ~/.stack/config.yaml

# install haskell packages
RUN stack install hoogle happy

# install haskell-ide-engine
RUN mkdir -p /source
RUN git clone --depth 1 -b master https://github.com/haskell/haskell-ide-engine /source/haskell-ide-engine
WORKDIR /source/haskell-ide-engine
RUN stack setup
RUN stack install --only-dependencies
RUN stack install

# generate hoogle database
RUN stack exec hoogle generate

WORKDIR /

ENTRYPOINT ["bash"]
CMD []
