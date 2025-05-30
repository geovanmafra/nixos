# nixos

> oh-my-bash
```
bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
```
> bashrc
```
OSH_THEME="absimple"
```
> bash_profile
```
if uwsm check may-start; then
	exec uwsm start hyprland-uwsm.desktop
fi
```

Themes
GTK https://www.pling.com/p/1715554 // Mocha .themes/ and .config/gtk-4.0
ICONS https://www.pling.com/p/1715570 // Mocha .icons/
CURSOR https://github.com/catppuccin/cursors // Lavender .icons/
EDITOR https://github.com/catppuccin/micro .config/micro/colorschemes/ "set colorscheme catppuccin-mocha-transparent"
TERMINAL .config/ghostty/config "theme = catppuccin-mocha"
