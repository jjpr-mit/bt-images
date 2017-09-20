FROM ubuntu
LABEL maintainer jjpr@mit.edu

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        python-dev \
        python-pip \
        bison \
        flex \
        libgl1-mesa-dev \
        libtiff5-dev \
        libsdl1.2-dev \
        blender \
        && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install pymongo
RUN pip install panda3d
RUN pip install numpy
RUN pip install skdata
RUN pip install boto
RUN pip install matplotlib
RUN pip install bson
RUN pip install tornado
RUN pip install Pillow
RUN pip install git+https://github.com/jaberg/pyll.git#egg=pyll
RUN pip install git+https://github.com/yamins81/yamutils.git#egg=yamutils

ENV PATH_TO_GENTHOR=/home/genthor
RUN mkdir -m 777 $PATH_TO_GENTHOR
WORKDIR $PATH_TO_GENTHOR/..
RUN git clone https://github.com/dicarlolab/genthor.git
RUN git clone https://github.com/yamins81/tabular.git

WORKDIR $PATH_TO_GENTHOR/../tabular
RUN sed -i.bak -e '39,54d' setup.py
RUN python setup.py install

WORKDIR $PATH_TO_GENTHOR
RUN sed -i.bak -e '39,54d' setup.py
RUN python setup.py install
