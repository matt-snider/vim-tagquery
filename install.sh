#!/usr/bin/env sh
#
# Download the `ctags-query` binary, falling back to building with `cargo` if that fails.
#
# Script modified from autozimu/LanguageClient-neovim
# https://github.com/autozimu/LanguageClient-neovim/blob/next/LICENSE.txt
#
# Copyright (c) 2017 Junfeng Li <autozimu@gmail.com> and contributors.

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

name=ctags-query
url=https://github.com/matt-snider/$name
version=0.1.1

try_curl() {
    command -v curl > /dev/null && \
        curl --fail --location "$1" --output bin/$name
}

try_wget() {
    command -v wget > /dev/null && \
        wget --output-document=bin/$name "$1"
}

download() {
    echo "Downloading binary ${name}..."
    mkdir -p bin/

    url=$url/releases/download/$version/${1}
    if (try_curl "$url" || try_wget "$url"); then
        chmod a+x bin/$name
        return
    else
        try_build || echo "Prebuilt binary not found, please try again shortly or report the issue\n\nhttps://github.com/matt-snider/vim-tagquery/issues"
    fi
}

try_build() {
    if command -v cargo > /dev/null; then
        echo "Building locally..."

        # Get/update repo
        cd $name/ \
            || git clone $url \
            && cd $name/
        git pull
        cargo build --release

        # Create bin
        cd ..
        mkdir bin/
        cp $name/target/release/$name bin/
        chmod a+x bin/ctags-query
    else
        return 1
    fi
}

rm -f bin/$name

arch=$(uname -sm)
case "${arch}" in
    "Linux x86_64") download $name-$version-x86_64-unknown-linux-gnu ;;
    # "Linux i686") download $name-$version-i686-unknown-linux-musl ;;
    # "Linux aarch64") download $name-$version-aarch64-unknown-linux-gnu ;;
    # "Darwin x86_64") download $name-$version-x86_64-apple-darwin ;;
    # "FreeBSD amd64") download $name-$version-x86_64-unknown-freebsd ;;
    *) echo "No pre-built binary available for ${arch}."; try_build ;;
esac

