#!/bin/bash
echo "begin install"

JAVABAAS_SERVICE="http://7xr649.dl1.z0.glb.clouddn.com/jbshell.zip"

if [ -z "$JAVABAAS_DIR" ]; then
    JAVABAAS_DIR="$HOME/.javabaas"
fi

javabaas_bashrc="${HOME}/.bashrc"
javabaas_zhsrc="${HOME}/.zshrc"

javabaas_init_snippet=$( cat << EOF
JBSHELL_DIR="$JAVABAAS_DIR/jbshell/bin"
export JBSHELL_DIR
export PATH=\$JBSHELL_DIR:\$PATH
EOF
)


echo "Looking for a previous installation of javabaasshell..."
if [ -d "$JBSHELL_DIR" ]; then
	echo "javabaasshell found."
	echo ""
	echo "======================================================================================================"
	echo " You already have javabaasshell installed."
	echo " javabaasshell was found at:"
	echo ""
	echo "    ${JBSHELL_DIR}"
	echo ""
	echo " Please consider running the following if you need to upgrade."
	echo ""
	echo "    $ jbshell selfupdate force"
	echo ""
	echo "======================================================================================================"
	echo ""
	exit 0
fi

echo "Looking for unzip..."
if [ -z $(which unzip) ]; then
	echo "Not found."
	echo "======================================================================================================"
	echo " Please install unzip on your system using your favourite package manager."
	echo ""
	echo " Restart after installing unzip."
	echo "======================================================================================================"
	echo ""
	exit 0
fi

echo "Looking for curl..."
if [ -z $(which curl) ]; then
	echo "Not found."
	echo ""
	echo "======================================================================================================"
	echo " Please install curl on your system using your favourite package manager."
	echo ""
	echo " Restart after installing curl."
	echo "======================================================================================================"
	echo ""
	exit 0
fi

echo "Looking for java..."
if [ -z $(which java) ]; then
	echo "Not found."
	echo ""
	echo "======================================================================================================"
	echo " Please install java(1.8+) on your system using your favourite package manager."
	echo ""
	echo " Restart after installing curl."
	echo "======================================================================================================"
	echo ""
	exit 0
fi

jbshell_zip_file="${JAVABAAS_DIR}/javabaasshell.zip"

echo "create distribution directories..."
mkdir -p "$JAVABAAS_DIR"
echo "create dir success..."
curl -L "$JAVABAAS_SERVICE" > "$jbshell_zip_file"
echo "download file success..."
unzip -qo "$jbshell_zip_file" -d "$JAVABAAS_DIR" -x __MACOSX/*
rm -f "$jbshell_zip_file"
echo "unzip zip success"

echo "Attempt update of bash profiles..."
if [ ! -f "$javabaas_bashrc" ]; then
	echo "#!/bin/bash" > "$javabaas_bashrc"
	echo "$javabaas_init_snippet" >> "$javabaas_bashrc"
	echo "Created and initialised ${javabaas_bashrc}"
	#source "$javabaas_bashrc"
else
	if [[ -z $(grep 'JBSHELL_DIR' "$javabaas_bashrc") ]]; then
		echo -e "\n$javabaas_init_snippet" >> "$javabaas_bashrc"
		echo "Updated existing ${javabaas_bashrc}"
		#source "$javabaas_bashrc"
	fi
fi

echo "Attempt update of zsh profiles..."
if [ ! -f "$javabaas_zhsrc" ]; then
	echo "$javabaas_init_snippet" >> "$javabaas_zhsrc"
	echo "Created and initialised ${javabaas_zhsrc}"
	#source "$javabaas_zhsrc"
else
	if [[ -z $(grep 'JBSHELL_DIR' "$javabaas_zhsrc") ]]; then
		echo -e "\n$javabaas_init_snippet" >> "$javabaas_zhsrc"
		echo "Updated existing ${javabaas_zhsrc}"
		#source "$javabaas_zhsrc"
	fi
fi


echo "Success install javabaasshell"
echo "Please open a new terminal, or run the following in the existing one:"
echo ""
echo "    source \"${JAVABAAS_DIR}/jbshell/export/jbexport\""
echo ""
echo ""
echo "Enjoy!!!"
