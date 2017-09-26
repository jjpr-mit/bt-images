FROM ubuntu
LABEL maintainer jjpr@mit.edu

ENV DEBIAN_FRONTEND noninteractive

# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E375BC9D
# RUN echo "deb http://archive.panda3d.org/ubuntu xenial main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
        bison \
        blender \
        build-essential \
        flex \
        git \
        libgl1-mesa-dev \
        libsdl1.2-dev \
        libtiff5-dev \
        # panda3d \
        python-dev \
        python-pip \
        wget \
        && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install --upgrade setuptools

RUN pip install boto
RUN pip install matplotlib
RUN pip install numpy
RUN pip install Pillow
RUN pip install pymongo
RUN pip install tornado

RUN pip install git+https://github.com/yamins81/scikit-data.git#egg=skdata
RUN pip install git+https://github.com/jaberg/pyll.git#egg=pyll
RUN pip install git+https://github.com/yamins81/yamutils.git#egg=yamutils

ENV PATH_TO_GENTHOR=/home/genthor
RUN mkdir -m 777 $PATH_TO_GENTHOR

WORKDIR /home
RUN git clone https://github.com/dicarlolab/genthor.git
RUN git clone https://github.com/yamins81/tabular.git
# RUN wget https://www.panda3d.org/download/panda3d-1.9.4/panda3d-1.9.4.tar.gz
# RUN tar -zxvf panda3d-1.9.4.tar.gz
RUN wget https://www.panda3d.org/download/panda3d-1.8.1/panda3d-1.8.1.tar.gz
RUN tar -zxvf panda3d-1.8.1.tar.gz

WORKDIR /home/panda3d-1.8.1
RUN python makepanda/makepanda.py --everything --no-vision
RUN python makepanda/installpanda.py
RUN sed -i 's/load-display pandagl$/#load-display pandagl/' /etc/Config.prc
RUN sed -i 's/#load-display p3tinydisplay$/load-display p3tinydisplay/' /etc/Config.prc

# RUN wget https://www.panda3d.org/download/panda3d-1.9.4/panda3d1.9_1.9.4~xenial_amd64.deb
# RUN apt install ./panda3d1.9_1.9.4~xenial_amd64.deb

WORKDIR /home/tabular
RUN sed -i.bak -e '39,54d' setup.py
RUN python setup.py install

WORKDIR $PATH_TO_GENTHOR
RUN sed -i.bak -e '39,54d' setup.py
RUN python setup.py install

RUN ldconfig
