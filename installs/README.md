# Installs

## install.yaml
**Description** - installs a new package on all machines

**Default host group** - debian

Notes:
* This only takes one package at a time


## uninstall.yaml
**Description** - uninstalls a package on all machines

**Default host group** - debian

Notes:
* This uses `apt` - if a package needs to be removed by another way, a custom script should be created.
