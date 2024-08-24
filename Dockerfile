FROM quay.io/centos/centos:stream9

ENV NAME=juno-centos-toolbox VERSION=9
LABEL com.github.containers.toolbox="true" \
      com.github.debarshiray.toolbox="true" \
      com.redhat.component="$NAME" \
      name="$FGC/$NAME" \
      version="$VERSION" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Base image for CentOS 9 and ihep CVMFS mounting JUNO offline" \
      maintainer="Qiyu yan <yanqiyu17@mails.ucas.ac.cn>"

COPY missing /
COPY cvmfs /etc/cvmfs
COPY custom.sh /etc/profile.d/custom.sh

# Install the required packages
# packages like mesa-dri-drivers will be useful for serena.exe
# all those devel packages are what needed to compile JUNO offline
RUN sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf && \
    rm /etc/rpm/macros.image-language-conf && \
    dnf -y swap coreutils-single coreutils-full && \
    dnf -y swap glibc-minimal-langpack glibc-all-langpacks && \
    dnf -y install 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled crb && \
    dnf install -y  $(<missing) mesa-dri-drivers epel-release epel-next-release flatpak-xdg-utils flatpak-spawn && \
    dnf install -y  https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm && \
    dnf install -y  cvmfs cvmfs-fuse3 && \
    dnf install -y  gcc gcc-c++ gcc-gfortran gdb bear && \
    dnf install -y  libxml2-devel curl-devel /usr/lib64/libexpat.so /usr/lib64/libfreetype.so ftgl \
                    libXmu-devel mesa-libGLU-devel libX11-devel mesa-libEGL-devel libtiff clang-tools-extra\
                    libXpm-devel libicu-devel libXft git openssh-clients gsl-devel make patch glibc-devel \
                    /usr/lib64/libnsl.so.3 && \
    dnf clean all && \
    rm missing && \
    ln -sf /usr/bin/flatpak-xdg-open /usr/bin/xdg-open 

