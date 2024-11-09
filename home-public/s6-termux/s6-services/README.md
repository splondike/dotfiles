This dir contains long running user services running under the s6 process supervisor system. I use it inside Termux on Android.

# Usage

## Cheatsheet

To manage individual services use s6-svc with the path to the service directory as the identifier:

- Stop service `s6-svc -d scandir/my-service/`
- Start service `s6-svc -u scandir/my-service/`
- Restart service `s6-svc -r scandir/my-service/`
- Process status `s6-svstat scandir/my-service/`
- Print crashes `s6-svdt scandir/my-service/ | s6-tai64nlocal`

And to manage the supervision tree as a whole

- Pick up changes to the file system `s6-svscanctl -h .`

## New services

Make subdirectories and drop a 'run' executable inside them. Make sure it's got +x and also that it doesn't fork the process it's managing. Technically you're meant to exec into the process, but I don't think it matters much.

# Setup

I tried Termux:Boot but it didn't seem to keep the process running in the background. So I just run the s6-supervisor.sh shell script in its own Termux window.
