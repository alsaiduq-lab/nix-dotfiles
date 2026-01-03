# Cobray's dotfiles

My config for Hyprland desktop that I normally use as my daily driver (read: all my bloat).

## Useful commands

list generations

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

perform garbage collection by deleting old derivations

```bash
nix-collect-garbage --delete-old
```

recommeneded to sometimes run as sudo to collect additional garbage

```bash
sudo nix-collect-garbage -d
```

as a separation of concerns - you will need to run this command to clean out boot

```bash
sudo /run/current-system/bin/switch-to-configuration boot
```

rollback to previous generation

```bash
sudo nixos-rebuild switch --flake . --rollback
```

bonus: in case you're stuck in some limbo state

```bash
sudo /run/current-system/sw/bin/nixos-rebuild switch --flake .
```
