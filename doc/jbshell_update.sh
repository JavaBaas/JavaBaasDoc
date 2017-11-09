#!/bin/bash
echo "开始安装"

JAVABAAS_SERVICE="http://7xr649.dl1.z0.glb.clouddn.com/jbshell_1000.zip"

if [ -z "$JAVABAAS_DIR" ]; then
    JAVABAAS_DIR="$HOME/.javabaas"
fi

JBSHELL_VERSION=2000

javabaas_bashrc="${HOME}/.bashrc"
javabaas_zhsrc="${HOME}/.zshrc"

javabaas_init_snippet=$( cat << EOF
JBSHELL_DIR="$JAVABAAS_DIR/jbshell/bin"
export JBSHELL_DIR
export PATH=\$JBSHELL_DIR:\$PATH
JBSHELL_VERSION="$JBSHELL_VERSION"
EOF
)

echo "检查是否安装了unzip..."
if [ -z $(which unzip) ]; then
	echo "没有发现unzip."
	echo "======================================================================================================"
	echo " 请安装unzip."
	echo ""
	echo " 安装完unzip后请重新安装jbshell."
	echo "======================================================================================================"
	echo ""
	exit 0
fi

echo "检查是否安装了curl..."
if [ -z $(which curl) ]; then
	echo "没有发现curl."
	echo ""
	echo "======================================================================================================"
	echo " 请安装curl."
	echo ""
	echo " 安装完curl后请重新安装jbshell."
	echo "======================================================================================================"
	echo ""
	exit 0
fi

echo "检查是否安装了java..."
if [ -z $(which java) ]; then
	echo "没有发现java."
	echo ""
	echo "======================================================================================================"
	echo " 请安装java（最低版本1.7）."
	echo ""
	echo " 安装完java后请重新安装jbshell."
	echo "======================================================================================================"
	echo ""
	exit 0
fi

jbshell_zip_file="${JAVABAAS_DIR}/javabaasshell.zip"

echo "创建jbshell目录..."
mkdir -p "$JAVABAAS_DIR"
echo "创建jbshell目录成功..."
curl -L "$JAVABAAS_SERVICE" > "$jbshell_zip_file"
echo "下载jbshell..."
rm -f "$JAVABAAS_DIR/jbshell"
unzip -qo "$jbshell_zip_file" -d "$JAVABAAS_DIR" -x __MACOSX/*
rm -f "$jbshell_zip_file"
echo "解压成功"

echo "添加bash环境变量..."
if [ ! -f "$javabaas_bashrc" ]; then
	echo "#!/bin/bash" > "$javabaas_bashrc"
	echo "$javabaas_init_snippet" >> "$javabaas_bashrc"
	echo "创建并更新 ${javabaas_bashrc}"
	#source "$javabaas_bashrc"
else
	if [[ -z $(grep 'JBSHELL_DIR' "$javabaas_bashrc") ]]; then
		echo -e "\n$javabaas_init_snippet" >> "$javabaas_bashrc"
		echo "更新 ${javabaas_bashrc}"
		#source "$javabaas_bashrc"
	fi
fi

echo "添加zsh环境变量..."
if [ ! -f "$javabaas_zhsrc" ]; then
	echo "$javabaas_init_snippet" >> "$javabaas_zhsrc"
	echo "创建并更新 ${javabaas_zhsrc}"
	#source "$javabaas_zhsrc"
	#之所以不打开是因为咱们是没有解决zsh报的错误信息，如果有人知道怎么解决帮忙解决一下：
	#/Users/test/.oh-my-zsh/oh-my-zsh.sh: line 12: autoload: command not found
    #/Users/test/.oh-my-zsh/oh-my-zsh.sh: line 31: syntax error near unexpected token `('
    #/Users/test/.oh-my-zsh/oh-my-zsh.sh: line 31: `for config_file ($ZSH/lib/*.zsh); do'
else
	if [[ -z $(grep 'JBSHELL_DIR' "$javabaas_zhsrc") ]]; then
		echo -e "\n$javabaas_init_snippet" >> "$javabaas_zhsrc"
		echo "更新 ${javabaas_zhsrc}"
		#source "$javabaas_zhsrc"
	fi
fi

echo ""
echo "成功更新jbshell"
echo ""
