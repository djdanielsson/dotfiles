# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Put your fun stuff here.
#if [ $(cat /etc/*release | cut -c 1-8 | head -n 1) == CHROMEOS ] ; then
#	alias update="crew update"
#	alias install="crew install"
#	alias remove="crew remove"
#elif [ $(cat /etc/issue | cut -c 1-6 | head -n 1) == Ubuntu ] ; then
#	alias update="sudo apt-get update && sudo apt-get upgrade"
#	alias install="sudo apt-get install"
#	alias remove="sudo apt-get remove"
#else [ $(cat /etc/*release | cut -c 1-8 | head -n 1) == fedora ]
#        alias update="sudo yum update"
#	alias install="sudo yum install"
#	alias remove="sudo yum remove"
#fi


#export PS1='\[\e[1;34m\]\u\[\e[1;37m]@\[\e[1;31m]\h:\w:\\$ \[$(tputsgr0)\]]'
export PS1='\[\e[1;34m\]\u\[\e[1;36m\]@\[\e[1;31m\]\h:\[\e[1;36m\]\w:\[\e[1;37m\]\$ '
#export PS1='\u@\h\w:$ '
alias ls="ls --color"
alias ll="ls -l"
alias llz="ls -laZh"
alias vi="vim"
alias emacs="emacs -nw"
alias minecraft="java -jar ~/Downloads/Minecraft.jar"
alias cleanMem="sudo su -c 'sync; echo 1 > /proc/sys/vm/drop_caches; echo 2 > /proc/sys/vm/drop_caches; echo 3 > /proc/sys/vm/drop_caches'"
alias brlSysUpgrade="sudo pacman -Syu;sudo apt-get update;sudo apt-get upgrade;sudo dnf update"

zsh
