# Copyright 2026 Quintauris GmbH
# Licensed under the Apache License, Version 2.0 (the "License").
# https://www.apache.org/licenses/LICENSE-2.0

FROM ubuntu:noble

RUN apt-get update
RUN apt-get install -y build-essential=12.10ubuntu1
RUN apt-get install -y cmake=3.28.3-1build7
RUN apt-get install -y clang=1:18.0-59~exp2
RUN apt-get install -y lld=1:18.0-59~exp2
RUN apt-get install -y asciidoctor=2.0.20-1
RUN apt-get install -y libglib2.0-dev
RUN apt-get install -y git
RUN apt-get install -y rustup
RUN rustup default 1.90
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN ln -s $(find /usr/lib -name llvm-ar) /usr/bin/llvm-ar
RUN ln -s $(find /usr/lib -name llvm-ranlib) /usr/bin/llvm-ranlib
RUN ln -s $(find /usr/lib -name llvm-objcopy) /usr/bin/llvm-objcopy
