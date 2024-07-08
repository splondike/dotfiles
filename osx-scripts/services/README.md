This dir contains long running user services running under the s6 process supervisor system. It seemed easier to use that OSX's built in launchd system.

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

We can get launchd to run us on login. Put the following in the `~/Library/LaunchAgents/com.github.splondike.dotfiles.osx-s6.plist` file.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>S6 Process Supervisor</key>
        <string>com.github.splondike.dotfiles.osx-s6.plist</string>
        <key>Program</key>
        <string>/Users/stefansk/osx-scripts/services/s6-supervisor.sh</string>
        <key>KeepAlive</key>
        <true/>
    </dict>
</plist>
```

# TODO

- Haven't got launchd working yet
