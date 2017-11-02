#!/bin/bash
echo "开始安装"

JAVABAAS_SERVICE="http://7xr649.dl1.z0.glb.clouddn.com/jbshell.zip"

if [ -z "$JAVABAAS_DIR" ]; then
    JAVABAAS_DIR="$HOME/.javabaas"
fi

javabaas_bashrc="${HOME}/.bashrc"
javabaas_zhsrc="${HOME}/.zshrc"

javabaas_init_snippet=$( cat << EOF
#**********JBSHELL PROFILE BEGIN**********
JBSHELL_DIR="$JAVABAAS_DIR/jbshell/bin"
export JBSHELL_DIR
export PATH=\$JBSHELL_DIR:\$PATH
#**********JBSHELL PROFILE END************
EOF
)


echo "检查是否已经安装jbshell..."
if [ -d "$JBSHELL_DIR" ]; then
	echo "发现jbshell"
	echo ""
	echo "======================================================================================================"
	echo "你已经安装了jbshell "
	echo " 地址为:"
	echo ""
	echo "    ${JBSHELL_DIR}"
	echo ""
	echo "请检查"
	echo " 如果你想更新jbshell 请使用"
	echo "    $ jb u    或   $ jb update"
	echo ""
	echo "======================================================================================================"
	echo ""
	exit 0
fi

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
else
	if [[ -z $(grep 'JBSHELL_DIR' "$javabaas_zhsrc") ]]; then
		echo -e "\n$javabaas_init_snippet" >> "$javabaas_zhsrc"
		echo "更新 ${javabaas_zhsrc}"
		#source "$javabaas_zhsrc"
	fi
fi


echo "成功安装jbshell"
echo "请打开一个新的终端，或者在当前终端执行下面命令:"
echo ""
echo "    source \"${JAVABAAS_DIR}/jbshell/export/jbexport\""
echo ""
echo ""
echo "开始造吧!!!"
