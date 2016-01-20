#!/bin/bash

set -e

basepath='/var/cache/pbuilder'

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
        --components "${components}" \
        --architecture "${architecture}" \
        --basepath "${cowdir}" \
        --debootstrapopts "--variant=buildd" \
        --debootstrapopts "--keyring=${keyring}"

    mkdir -p $cowdir/tmp/hooks # ???
}

function create_wmf_apt_pbuilder_hook {
    distribution=$1
    components="$2"
    mirror='http://apt.wikimedia.org/wikimedia'

    mkdir -pv ${basepath}/hooks/${distribution}
    cat << END > ${basepath}/hooks/${distribution}/D01apt.wikimedia.org
#!/bin/sh

# Avoid running hooks if wikimedia is not specified
if [ "\${WIKIMEDIA}" = "yes" ]; then
	cat > /etc/apt/sources.list.d/wikimedia.list <<-'EOF'
	deb ${mirror} ${distribution}-wikimedia ${components}
	deb-src ${mirror} ${distribution}-wikimedia ${components}
EOF
	cat > /etc/apt/preferences.d/wikimedia.pref <<-'EOF'
	Package: *
	Pin: release o=Wikimedia
	Pin-Priority: 1001
EOF
	apt-get install wget -y
	wget -O - -o /dev/null http://apt.wikimedia.org/autoinstall/keyring/wikimedia-archive-keyring.gpg | apt-key add -
	apt-get update
fi
END
}




#
# amd64 architecture
#
arch=amd64


# # precise-amd64
# dist=precise
# cowdir="${basepath}/base-${dist}-${arch}.cow"
# create_wmf_apt_pbuilder_hook                           \
#     $dist                                              \
#     'main universe non-free thirdparty mariadb'
# cowbuilder_create                                      \
#     $dist                                              \
#     'main universe'                                    \
#     $arch                                              \
#     'http://mirrors.wikimedia.org/ubuntu'              \
#     $cowdir                                            \
#     '/usr/share/keyrings/ubuntu-archive-keyring.gpg'
#
# distribution => 'precise',
# components   => 'main universe non-free thirdparty mariadb',
# basepath     => $basepath,


# # trusty-amd64
# dist=trusty
# cowdir="${basepath}/base-${dist}-${arch}.cow"
# create_wmf_apt_pbuilder_hook                           \
#     $dist                                              \
#     'main universe non-free thirdparty'
# cowbuilder_create                                      \
#     $dist                                              \
#     'main universe'                                    \
#     $arch                                              \
#     'http://mirrors.wikimedia.org/ubuntu'              \
#     $cowdir                                            \
#     '/usr/share/keyrings/ubuntu-archive-keyring.gpg'


# jessie-amd64
dist=jessie
cowdir="${basepath}/base-${dist}-${arch}.cow"

create_wmf_apt_pbuilder_hook                           \
    $dist                                              \
    'main universe non-free thirdparty mariadb'

cowbuilder_create                                      \
    $dist                                              \
    'main'                                             \
    $arch                                              \
    'http://mirrors.wikimedia.org/debian'              \
    $cowdir                                            \
    '/usr/share/keyrings/debian-archive-keyring.gpg'


# # sid-amd64
# dist=sid
# cowdir="${basepath}/base-${dist}-${arch}.cow"
# cowbuilder_create                                      \
#     $dist                                              \
#     'main'                                             \
#     $arch                                              \
#     'http://mirrors.wikimedia.org/debian'              \
#     $cowdir                                            \
#     '/usr/share/keyrings/debian-archive-keyring.gpg'
#
# wait
# # Make an 'unstable' distribution alias for sid-amd64
# ln -sf ${cowdir} ${basepath}/base-unstable-${arch}.cow

