#!/bin/sh

. $(dirname $0)/setup-env.gitignored.sh
cd $(dirname $0)
exec s6-svscan scandir/
