#!/bin/sh

cd $(dirname $0)
exec s6-svscan scandir/
