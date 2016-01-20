FROM debian:jessie

COPY wikimedia.list /etc/apt/sources.list.d/wikimedia.list
COPY wikimedia.key /tmp/wikimedia.key
RUN apt-key add /tmp/wikimedia.key

#? ???????
RUN cat /etc/resolv.conf

RUN apt-get update

RUN apt-get -y install --no-install-recommends  \
  lsb-release                                   \
  cowbuilder                                    \
  build-essential                               \
  fakeroot                                      \
  debhelper                                     \
  cdbs                                          \
  devscripts                                    \
  dh-make                                       \
  dh-autoreconf                                 \
  openstack-pkg-tools                           \
  git-buildpackage                              \
  quilt                                         \
  wdiff                                         \
  lintian                                       \
  zip                                           \
  unzip                                         \
  debian-archive-keyring                        \
  ubuntu-archive-keyring

COPY pbuilderrc /etc/pbuilderrc
COPY create_cowbuilder_envs.sh /usr/local/bin/create_cowbuilder_envs.sh
RUN chmod 744 /usr/local/bin/create_cowbuilder_envs.sh

# RUN /usr/local/bin/create_cowbuilder_envs.sh
