Copy one of the existing blocks and change the name. There are three cases:

**A directory inside `~/.config`** (e.g. `kitty`):
```bash
# Kitty
rm -rf .config/kitty
cp -r "$HOME/.config/kitty" .config
```

**A single file in your home folder** (e.g. `.gitconfig`):
```bash
# Git
cp "$HOME/.gitconfig" .
```

**A directory in your home folder** (e.g. `.tmux`):
```bash
# Tmux
rm -rf .tmux
cp -r "$HOME/.tmux" .
```

Keep these in mind:
- Anything under `~/.config` is already covered by the secrets check. For a new file or folder outside `.config`, add it to the last `grep` line, next to `.zshrc .config`.
- Always keep the `rm -rf` before `cp -r` for directories. Without it, files you delete from your config stay in the backup.
- Don't back up anything holding private keys, such as `~/.ssh` or `~/.gnupg`, since the repo goes to GitHub.
