# Stackwindow

## Installing

```shell
mkdir -p ~/.hammerspoon/stackwindow
git clone https://github.com/codegik/stackwindow.git ~/.hammerspoon/stackwindow
echo 'require("stackwindow")' >> ~/.hammerspoon/init.lua
```

## TODO

- subscribe to event in order to change focused window, then should change focused icon
- subscribe to events in order to recreate the stack
  - creating window
  - removing window
