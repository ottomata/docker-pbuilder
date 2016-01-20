#!/bin/bash

set -e

function cowbuilder_create {
    distribution=$1
    components="$2"
    architecture="$3"
    mirror=$4
    cowdir=$5
    keyring=$6

    /usr/sbin/cowbuilder --create \
        --mirror "${mirror}" \
        --distribution ${distribution} \
        --components "'${components}'" \
        --architecture "${architecture}" \
        --basepath "${cowdir}" \
        --debootstrapopts "--variant=buildd" \
        --debootstrapopts "--keyring=${keyring}" &
}


basepath='/var/cache/pbuilder'


#
# amd64 architecture
#
arch=amd64

# precise-amd64
dist=precise
cowdir="${basepath}/base-${dist}-${arch}.cow"
cowbuilder_create                                      \
    $dist                                              \
    'main universe'                                    \
    $arch                                              \
    'http://mirrors.wikimedia.org/ubuntu'              \
    $cowdir                                            \
    '/usr/share/keyrings/ubuntu-archive-keyring.gpg'

# trusty-amd64
dist=trusty
cowdir="${basepath}/base-${dist}-${arch}.cow"
cowbuilder_create                                      \
    $dist                                              \
    'main universe'                                    \
    $arch                                              \
    'http://mirrors.wikimedia.org/ubuntu'              \
    $cowdir                                            \
    '/usr/share/keyrings/ubuntu-archive-keyring.gpg'

# jessie-amd64
dist=jessie
cowdir="${basepath}/base-${dist}-${arch}.cow"
cowbuilder_create                                      \
    $dist                                              \
    'main'                                             \
    $arch                                              \
    'http://mirrors.wikimedia.org/debian'              \
    $cowdir                                            \
    '/usr/share/keyrings/debian-archive-keyring.gpg'

# sid-amd64
dist=sid
cowdir="${basepath}/base-${dist}-${arch}.cow"
cowbuilder_create                                      \
    $dist                                              \
    'main'                                             \
    $arch                                              \
    'http://mirrors.wikimedia.org/debian'              \
    $cowdir                                            \
    '/usr/share/keyrings/debian-archive-keyring.gpg'

wait
# Make an 'unstable' distribution alias for sid-amd64
ln -sf ${cowdir} ${basepath}/base-unstable-${arch}.cow

