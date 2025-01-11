# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

use agl.nu
use aaz.nu
use util.nu

let nu_config_dir = $"($env.XDG_CONFIG_HOME)/nushell"

$env.config.show_banner = false

load-env (util env_vars)
