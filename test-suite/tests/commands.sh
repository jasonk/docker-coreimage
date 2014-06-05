#!/bin/bash

describe "custom commands were installed"

ps xauwwww

it_has_docker_coreimage() {
    command -v docker-coreimage
}

it_has_make_pristine_container() {
    command -v make-pristine-container
}

it_has_cleanup_container() {
    command -v cleanup-container
}

it_has_secret() {
    command -v secret
}

it_has_template() {
    command -v template
}

it_has_waitlinks() {
    command -v waitlinks
}
