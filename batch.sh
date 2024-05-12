#!/bin/zsh

pp=/Users/xiayu


# 列出/Users/xiayu/picture目录下的所有文件
file_list=`find /Users/xiayu/picture -type f`


# 循环遍历文件列表
for file in $file_list; do
  cd $pp/facefusion && source venv/bin/activate
  # 执行python run.py命令
  python run.py -s /Users/xiayu/缩略图/source1.png -t $file &
  # 获取python run.py进程的PID
  pid=$!
  echo "正在处理: $file"
  # 等待10秒
  sleep 10
  # 杀掉python run.py进程
  echo "终止进程: $pid"
  kill $pid
done

echo "所有文件处理完成。"
