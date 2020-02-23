# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

PATH=$PATH:$HOME/bin
export PATH

export PS1='\u@\h:\W $ '
alias	ll='ls -Fl'

# User specific environment and startup programs
