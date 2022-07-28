# Mac M1 setup for Plutus Pioneer Program

some useful infos:
[https://cardano.stackexchange.com/questions/6287/lessons-learned-setting-up-plutus-playground-feedback-welcome](https://cardano.stackexchange.com/questions/6287/lessons-learned-setting-up-plutus-playground-feedback-welcome)

[https://docs.plutus-community.com/docs/setup/MacOS.html](https://docs.plutus-community.com/docs/setup/MacOS.html) (do not use the "plutus" repo! instead use "plutus-apps")

For Intel Macs: [https://github.com/Til-D/cardano-plutus](https://github.com/Til-D/cardano-plutus)

And finalised thanks to @nrkramer Nolan Kramer!

## Step by step

1 ensure you have [Rosetta 2](https://support.apple.com/en-us/HT211861) installed so that you can run programs built for `x86_64-darwin`
```console
sudo softwareupdate --install-rosetta --agree-to-license
```

2 download the nix package manager and install it
```console
sh <(curl -L https://nixos.org/nix/install)
```
3 restart terminal

4 open the nix config file
```console
sudo nano /etc/nix/nix.conf
```
5 be sure these lines are all inside the file
```console
build-users-group = nixbld

substituters        = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/
trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=

system = x86_64-darwin
extra-platforms = x86_64-darwin aarch64-darwin

sandbox = false
extra-sandbox-paths = /System/Library/Frameworks /System/Library/PrivateFrameworks /usr/lib /private/tmp /private/var/tmp /usr/bin/env
experimental-features = nix-command
extra-experimental-features = flakes
```
6 restart mac

to make some space on your harddrive without deleting nix - if you do not use nix for a while:

[https://www.reddit.com/r/NixOS/comments/mndp6a/garbage_collection/](https://www.reddit.com/r/NixOS/comments/mndp6a/garbage_collection/)

[https://nixos.org/guides/nix-pills/garbage-collector.html](https://nixos.org/guides/nix-pills/garbage-collector.html)


or to uninstall nix, maybe you want to reinstall after macOS update?

Use [https://github.com/renzwo/cardano-plutus-apps-install-m1/blob/main/uninstall-nix-osx.sh](https://github.com/renzwo/cardano-plutus-apps-install-m1/blob/main/uninstall-nix-osx.sh)

Do a "chmod 777 uninstall-nix-osx.sh" before using it with "sudo".
