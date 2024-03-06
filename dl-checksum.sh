#!/usr/bin/env bash
set -e
readonly DIR=~/Downloads
readonly MIRROR=https://github.com/BeryJu/korb/releases/download
dl()
{
    local lchecksum=$1
    local ver=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform=${os}_${arch}
    local file=korb_${ver}_${platform}.${archive_type}
    local url=$MIRROR/v$ver/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksum | awk '{print $1}')
}

dl_ver () {
    local ver=$1
    # https://github.com/BeryJu/korb/releases/download/v2.2.0/korb_2.2.0_SHA256SUMS
    local checksum_url=${MIRROR}/v${ver}/korb_${ver}_SHA256SUMS
    printf "  # %s\n" $checksum_url
    local lchecksum=$DIR/korb-${ver}-checksums.txt

    if [ ! -e $lchecksum ];
    then
        curl -sSLf -o $lchecksum $checksum_url
    fi

    printf "  %s:\n" $ver
    dl $lchecksum $ver darwin amd64
    dl $lchecksum $ver darwin arm64
    dl $lchecksum $ver linux amd64
    dl $lchecksum $ver linux arm
    dl $lchecksum $ver linux arm64
    dl $lchecksum $ver windows amd64
    dl $lchecksum $ver windows arm
    dl $lchecksum $ver windows arm64
    dl $lchecksum $ver freebsd amd64
    dl $lchecksum $ver freebsd arm64
    dl $lchecksum $ver freebsd arm
}

dl_ver ${1:-2.2.0}
