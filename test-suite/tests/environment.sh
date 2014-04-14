#!/bin/bash

describe "environment is being setup correctly"

it_sets_DEBIAN_FRONTEND() {
    test "$DEBIAN_FRONTEND" = "noninteractive"
}

it_sets_INITRD() {
    test "$INITRD" = "no"
}

it_sets_LC_ALL() {
    test "$LC_ALL" = "C"
}
