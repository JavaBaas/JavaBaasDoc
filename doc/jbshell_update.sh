#!/bin/bash
echo "开始安装"

JAVABAAS_SERVICE="http://file.kerust.com/jbshell_2013.zip"

if [ -z "$JAVABAAS_DIR" ]; then
    JAVABAAS_DIR="$HOME/.javabaas"
fi

javabaas_bash_profile="${HOME}/.bash_profile"
javabaas_zhsrc="${HOME}/.zshrc"

javabaas_init_snippet=$( cat << EOF
JBSHELL_DIR="$JAVABAAS_DIR/jbshell/bin"
export JBSHELL_DIR
export PATH=\$JBSHELL_DIR:\$PATH
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
jbshell_dir_del="${JAVABAAS_DIR}/jbshell"

# 判断之前是否有配置文件，如果有拷贝出来
echo "保留旧的配置文件"
if [ -f "${jbshell_dir_del}/lib/jbshell.properties" ]; then
    cp -f "${jbshell_dir_del}/lib/jbshell.properties" "${JAVABAAS_DIR}"
fi
# 删除之前的文件
rm -f -r "$jbshell_dir_del"
unzip -qo "$jbshell_zip_file" -d "$JAVABAAS_DIR" -x __MACOSX/*
rm -f "$jbshell_zip_file"
echo "解压成功"

if [ -f "${JAVABAAS_DIR}/jbshell.properties" ]; then
    mv -f "${JAVABAAS_DIR}/jbshell.properties" "${jbshell_dir_del}/lib"
fi

echo "添加bash环境变量..."
if [ ! -f "$javabaas_bash_profile" ]; then
	echo "#!/bin/bash" > "$javabaas_bash_profile"
	echo "$javabaas_init_snippet" >> "$javabaas_bash_profile"
	echo "创建并更新 ${javabaas_bash_profile}"
	#source "$javabaas_bash_profile"
else
	if [[ -z $(grep 'JBSHELL_DIR' "$javabaas_bash_profile") ]]; then
		echo -e "\n$javabaas_init_snippet" >> "$javabaas_bash_profile"
		echo "更新 ${javabaas_bash_profile}"
		#source "$javabaas_bash_profile"
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
