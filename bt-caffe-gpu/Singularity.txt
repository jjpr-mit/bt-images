Bootstrap: docker
From: bvlc/caffe:gpu

%labels
AUTHOR jjpr@mit.edu

%post

apt-get update && apt-get -y install nano
