#!/bin/bash

current_dir=`dirname $0`
flag_file=.have_been_updated.flag

function error_exit()
{
		error $*
    exit 1
}

function error()
{
    printf "\e[41m\e[30mERROR:\e[0m $*\n"
}
function warning()
{
    printf "\e[43m\e[30mWARNING:\e[0m $*\n"
}

function info()
{
    printf "\e[44m\e[30mINFO:\e[0m $*\n"
}

function system_type()
{
	if [ "$(uname)" == 'Darwin' ]; then
		OS='Mac'
	elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
		OS='Linux'
	else
		error_exit "Your platform ($(uname -a)) is not supported."
	fi
}

function have_been_updated()
{
	echo "Must not remove this file, only if you want crash system." >> ~/${flag_file}
}
function update_git()
{
	echo git config --global include.path ${current_dir}/git/.gitconfig
	git config --global include.path ${current_dir}/git/.gitconfig
	echo ln -sf ${current_dir}/git/.gitignore_global ~/.gitignore_global
	ln -sf ${current_dir}/git/.gitignore_global ~/.gitignore_global
}

function update_vim()
{
	if [[ -f ~/.vimrc ]]; then
		echo add "source ${current_dir}/vim/.vimrc" to ~/.vimrc
		echo "source ${current_dir}/vim/.vimrc" >> ~/.vimrc
	else
		echo ln -sf ${current_dir}/vim/.vimrc ~/.vimrc
		ln -sf ${current_dir}/vim/.vimrc ~/.vimrc
	fi
}

function update_zsh()
{
	if [[ -d ~/.oh-my-zsh ]]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	fi
	sed -i -- 's/robbyrussell/tjkirch_mod/' ~/.zshrc
}

# check environment status
[[ -f ~/${flag_file} ]] && warning "All environment have been update" && exit 0
which git > /dev/null && error_exit "Please install git on your system."
which zsh > /dev/null && error_exit "Please install zsh on your system."

# Start update environment
update_git
update_vim
update_zsh
have_been_updated

echo "Update environment successfully!"

#if [[ "x$OS" -eq "xMac"]]; then
#	#statements
#
#elif [[ "x$OS" -eq "xLinux" ]]; then
#	#statements
#fi
