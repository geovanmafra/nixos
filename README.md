# nixos

> bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"

bashrc
OSH_THEME="absimple"

bash_profile
if uwsm check may-start; then
	exec uwsm start hyprland-uwsm.desktop
fi
