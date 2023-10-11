FROM quay.io/centos/centos:7

ENV NAME=centos-toolbox VERSION=7
LABEL com.github.containers.toolbox="true" \
      com.github.debarshiray.toolbox="true" \
      com.redhat.component="$NAME" \
      name="$FGC/$NAME" \
      version="$VERSION" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Base image for CentOS 7 and ihep CVMFS mounting JUNO offline" \
      maintainer="Qiyu yan <yanqiyu17@mails.ucas.ac.cn>"

COPY missing /
COPY cvmfs /etc/cvmfs
COPY custom.sh /etc/profile.d/custom.sh

# Install the required packages
# packages like mesa-dri-drivers will be useful for serena.exe
# all those devel packages are what needed to compile JUNO offline
RUN sed -i '/tsflags=nodocs/d' /etc/yum.conf && \
    yum install -y  $(<missing) mesa-dri-drivers epel-release && \
    yum-config-manager --add-repo "https://storage-ci.web.cern.ch/storage-ci/eos/diopside/tag/testing/el-7/x86_64/" && \
    yum-config-manager --add-repo "https://storage-ci.web.cern.ch/storage-ci/eos/diopside-depend/el-7/x86_64/" && \
    yum install -y --nogpgcheck eos-client eos-fusex && \
    yum update -y && \
    yum install -y  https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm && \
    yum install -y  cvmfs cvmfs-fuse3 && \
    yum install -y  libxml2-devel curl-devel \
                    libXmu-devel mesa-libGLU-devel libX11-devel mesa-libEGL-devel libtiff \
                    libXpm-devel libicu-devel libXft git openssh-clients gsl-devel make patch glibc-devel && \
    yum clean all && \
    rm missing && \
    echo VARIANT_ID=container >> /etc/os-release 

# Set the default command
CMD /bin/sh
