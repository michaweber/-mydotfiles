## Inspirations

- https://github.com/nicksp/dotfiles

# Install Remotly

## Install using curl

```sh
sh -c "`curl -fsSL https://raw.githubusercontent.com/michaweber/mydotfiles/master/setup.sh`"
```

## Install using wget
```sh
wget -O - https://raw.githubusercontent.com/michaweber/mydotfiles/master/setup.sh | sh
```


# Setup for iSH
```sh
mkdir -p /mnt/mydotfiles
mount -t ios mydotfiles /mnt/mydotfiles
/mnt/mydotfiles/iSH/boostrap_alpine.sh
```
