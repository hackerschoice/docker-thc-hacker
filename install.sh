#! /bin/sh

THC_HACKER_HOSTNAME="thc-hax0r"

# Given a filename, a regex pattern to match and a replacement string:
# Replace string if found, else no change.
# (# $1 = filename, $2 = pattern to match, $3 = replacement)
replace() {
	grep $2 $1 >/dev/null
	if [ $? -eq 0 ]; then
		# Pattern found; replace in file
		sed -i "s/$2/$3/g" $1 >/dev/null
	fi
}

# Given a filename, a regex pattern to match and a string:
# If found, no change, else append file with string on new line.
append1() {
        grep $2 $1 >/dev/null
	if [ $? -ne 0 ]; then
		# Not found; append on new line (silently)
		echo $3 | sudo tee -a $1 >/dev/null
	fi
}

# First parameter is the home directory
user_setup()
{
	ln -s /etc/zshrc-user $1/.zshrc
	ln -s /etc/oh-my-zsh $1/.oh-my-zsh

	rm -f $1/.zsh_history $1/.bash_history
	ln -s /dev/null $1/.zsh_history
	ln -s /dev/null $1/.bash_history

	# Otherwise /etc/vim/vimrc is skipped
	touch $1/.vimrc
}

THC_DOCKER_VERSION="`cat /THC-DOCKER-VERSION`"

# Make sure we are on a docker instance...
if [ x"${THC_DOCKER_VERSION}" != x1.1 ]; then
	echo "Oops. This does not appear to be a THC docker instance"
	exit -1
fi

if [ -f /THC-INSTALLED ]; then
	echo "/THC-INSTALLED already exists. Looks like you already ran this script."
	exit 0
fi
touch /THC-INSTALLED

# We like to hack from 'bob' (su - bob)
useradd "bob" -s "/usr/bin/zsh"
mkdir -p "/home/bob/.ssh"
chsh -s /usr/bin/zsh

user_setup /root root
user_setup /home/bob bob

git clone https://github.com/robbyrussell/oh-my-zsh.git /etc/oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/etc/oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/etc/oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
cp /etc/oh-my-zsh/templates/zshrc.zsh-template /etc/zshrc-user
replace /etc/zshrc-user '="robbyrussell"' '="dpoggi"'
replace /etc/zshrc-user 'plugins=(git)' 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions)'

echo "shell /usr/bin/zsh" >>/etc/screenrc
echo "startup_message off" >>/etc/screenrc

bash -c "echo '
set showcmd
set showmatch
set ignorecase
set smartcase
set incsearch
set hlsearch
set viminfo=
set mouse=
set noswapfile
syntax on' >>/etc/vim/vimrc"

echo $THC_HACKER_HOSTNAME >/etc/hostname
echo 127.0.2.1 $THC_HACKER_HOSTNAME >>/etc/hosts

echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >>/etc/zshrc-user

# Opportunitic build of socat2 beta
echo "Installing socat2 beta..."
(
curl http://www.dest-unreach.org/socat/download/socat-2.0.0-b8.tar.gz | tar xfz - 
cd socat-2.0.0-b8
./configure && make all install
) &>/dev/null

echo "Installing Impacket static binary /usr/bin/wmiexec..."
(
curl -s -o /usr/bin/wmiexec -L https://github.com/ropnop/impacket_static_binaries/releases/download/0.9.19-dev-binaries/wmiexec_linux_x86_64
chmod 755 /usr/bin/wmiexec
) &>/dev/null

echo "
SUCCESS! Now start your docker instance:

# Here at THC we keep our exploits in ~/hax and ~/hax/secrfs is
# an encrypted remote file share where we share stuff.
    $ mkdir -p ~/hax/secrfs &>/dev/null

# Optional: Mount a secure remote file system:
    $ thc-rfs mount <SHARE-SECRET> ~/hax/secrfs

# Run it. ~/hax is imagined inside the docker instance at '/hax'. Enjoy.
    $ docker run -it -p 2222:22 --log-driver=none -v ~/hax:/hax thc-hacker-platform
"

