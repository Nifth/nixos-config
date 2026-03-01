récupérer le bordel, le dégager dans ~/nixos-config

lancer une première fois

```bash
git -C ~/nixos-config add . && sudo nixos-rebuild switch --flake ~/nixos-config#nixos && sudo chown alexandre:users ~/nixos-config/flake.lock
```

récupérer magento-cloud + opencode:
```bash
curl -sS https://accounts.magento.cloud/cli/installer | php
bun add -g opencode-ai
```
