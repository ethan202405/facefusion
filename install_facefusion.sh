#!/bin/zsh

# 检查Homebrew是否已安装
if ! command -v brew &>/dev/null; then
  echo "Homebrew未安装，现在开始安装..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew已安装。"
fi

brew install jq

# 使用系统Python检查版本
system_python_version=$(python3 --version 2>&1)
echo "系统Python版本: $system_python_version"

# 使用Homebrew检查Python版本
brew_python_version=$(brew info python@3.10 --json | jq -r '.[0].linked_keg' 2>&1)
echo "Homebrew Python版本: $brew_python_version"

# 检查两者中的任何一个是否为3.10
if [[ "$system_python_version" == *"3.10"* ]] || [[ "$brew_python_version" == "3.10"* ]]; then
  echo "Python版本为3.10，继续执行脚本。"
  # 脚本的其余部分...
else
  echo "Python版本不是3.10，退出脚本。"
  exit 1
fi

# 检查Python 3.10是否已安装
if ! brew list python@3.10 &>/dev/null; then
  echo "Python 3.10未安装，现在开始安装..."
  brew install python@3.10
else
  echo "Python 3.10已安装。"
fi

# 确保pip已安装
 python3 -m ensurepip --upgrade

# 检查git是否已安装
if ! command -v git &>/dev/null; then
  echo "git未安装，现在开始安装..."
  brew install git
else
  echo "git已安装。"
fi

# 检查ffmpeg是否已安装
if ! command -v ffmpeg &>/dev/null; then
  echo "ffmpeg未安装，现在开始安装..."
  brew install ffmpeg
else
  echo "ffmpeg已安装。"
fi

# 克隆facefusion仓库指定的2.5.3版本
if [[ ! -d "facefusion" ]]; then
  git clone --branch 2.5.3 https://github.com/facefusion/facefusion
fi

# 进入facefusion目录
cd facefusion 

# 创建并激活虚拟环境
if [[ ! -d "venv" ]]; then
  python3.10 -m venv venv
fi
source venv/bin/activate

# 安装依赖
python3 install.py --skip-conda

# 运行程序
python3 run.py
