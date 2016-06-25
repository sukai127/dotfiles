#!/bin/bash

CWD=`(cd "$(dirname $0)" && pwd)`
FLAG_FILE=${CWD}/.have_been_updated.flag

function error_exit()
{
	error $*
	exit 1
}

function warning_exit()
{
	warning $*
	exit 0
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

function which_system()
{
	echo "Check system type......"
	if [ "$(uname)" == 'Darwin' ]; then
		OS='Mac'
	elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
		OS='Linux'
	else
		error_exit "Your platform ($(uname -a)) is not supported."
	fi
	echo "Yours system is $OS"
}

function have_been_updated()
{
	echo "Do not remove this file, only if you want crash system." >> ~/${FLAG_FILE}
}

function update_git()
{
	echo git config --global include.path ${CWD}/git/.gitconfig
	git config --global include.path ${CWD}/git/.gitconfig
	echo ln -sf ${CWD}/git/.gitignore_global ~/.gitignore_global
	ln -sf ${CWD}/git/.gitignore_global ~/.gitignore_global
}

function update_vim()
{
	if [[ -f ~/.vimrc ]]; then
		echo add "source ${CWD}/vim/.vimrc" to ~/.vimrc
		echo "source ${CWD}/vim/.vimrc" >> ~/.vimrc
	else
		echo ln -sf ${CWD}/vim/.vimrc ~/.vimrc
		ln -sf ${CWD}/vim/.vimrc ~/.vimrc
	fi
}

function update_zsh()
{
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	# you can add your private config in this file
	[[ ! -f ${CWD}/zsh/.initrc.private ]] && echo "" > ${CWD}/zsh/.initrc.private

	echo ". ${CWD}/zsh/.initrc" >> ~/.zshrc
	echo ". ${CWD}/zsh/.initrc.private" >> ~/.zshrc
	sed -i -- 's/robbyrussell/tjkirch_mod/' ~/.zshrc
	source ~/.zshrc
}

# check environment status
[[ -f ~/${FLAG_FILE} ]] && warning_exit "All environment have been update."
which_system
which git > /dev/null || error_exit "Please install git on your system."
which zsh > /dev/null || error_exit "Please install zsh on your system."

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
