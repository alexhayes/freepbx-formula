#!/bin/bash

amportal restart 1>/dev/null;

RC=$?
echo $RC

if (($RC == 1)); then exit 0; else exit $RC; fi