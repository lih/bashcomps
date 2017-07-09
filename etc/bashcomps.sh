#!/bin/bash
if [ -n "$BASH_VERSION" ]; then
    if [[ $- == *i* ]]; then
        source /usr/share/bash/bashcomps.shl
    fi
fi
