# Podbump

This is a kubernetes controller that watches pods with the label `podbump.bo0tzz.me/enabled: true`, and restarts 
them if the image tag they are running has a new version. This controller is not intended for general use, and you 
are especially discouraged for using it to update any production applications. 

To install, apply the files in the `manifests` directory.

## Env vars
PODBUMP_SCHEDULE: The interval on which to run the controller. Crontab format or one of https://hexdocs.pm/quantum/crontab-format.html#special-expressions 
