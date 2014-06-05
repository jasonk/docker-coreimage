#!/bin/bash

describe "critical services are running"

ps xauwwww

it_runs_xinetd() {
    update-service --check xinetd
}

it_runs_cron() {
    update-service --check cron
}
