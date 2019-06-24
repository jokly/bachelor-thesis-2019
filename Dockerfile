FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

WORKDIR /src

RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN apt update && apt install -y \
      wget \
      apt-transport-https \
      unzip \
      texlive-base \
      texlive-latex-extra \
      texlive-xetex \
      texlive-lang-cyrillic \
      texlive-fonts-extra \
      texlive-science \
      texlive-latex-recommended \
      latexmk

# Install fonts
RUN apt install -y --reinstall ttf-mscorefonts-installer && \
    wget -O /usr/share/fonts/xits-math.otf https://github.com/khaledhosny/xits-math/raw/master/XITSMath-Regular.otf && \
    fc-cache -f -v

COPY fonts /root/.fonts
RUN fc-cache -f -v
