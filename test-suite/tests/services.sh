#!/bin/bash

describe "critical services are running"

ps xauwwww

it_enables_xinetd() {
    test -L "/etc/service/xinetd"
}

it_runs_xinetd() {
    test -n "$(pidof xinetd)"
}

it_enables_cron() {
    test -L "/etc/service/cron"
}

it_runs_cron() {
    test -n "$(pidof cron)"
}

it_generates_ssh_dsa_keys() {
    test -f "/etc/ssh/ssh_host_dsa_key"
    test -f "/etc/ssh/ssh_host_dsa_key.pub"
}

it_generates_ssh_rsa_keys() {
    test -f "/etc/ssh/ssh_host_rsa_key"
    test -f "/etc/ssh/ssh_host_rsa_key.pub"
}

it_generates_ssh_ecdsa_keys() {
    test -f "/etc/ssh/ssh_host_ecdsa_key"
    test -f "/etc/ssh/ssh_host_ecdsa_key.pub"
}
