#!/bin/bash
find . -type f -regex ".*sol-.*h5.*$" -exec rm -f {} \;
find . -type f -regex ".*sol-.*xmf$" -exec rm -f {} \;
find . -type f -regex ".*sol-.*lock$" -exec rm -f {} \;
