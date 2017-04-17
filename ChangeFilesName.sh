#!/bin/bash
# -f parentFloder  -p  pattern  -r name 
#
set --  $(getopt f:p:r: "$@")
date=$(date "+%y-%m-%d" )
#

#######################################
#        处理脚本命令参数
while [ -n "$1" ]
do
        case $1 in 
        -f)pf=$2
           shift;; 
        -p)pattern=$2
           shift;; 
        -r)name=$2
           shift;; 
        --)shift;;
        *)echo "没有此选项！$1" 
          exit    
          ;;      
        esac    
#
        shift   
#
done
#

#####################################
#  define the  get_answer function
#####################################

get_answer(){
#
unset answer
ask_count=0
#
while [ -z "$answer" ]
do
        ((ask_count++))
        #
        case $ask_count in
        2)echo
          echo "请回答问题进行后续的操作！"
          echo
          ;;
        3)echo
          echo "最后一次询问！"
          echo
          ;;
        4)echo
          echo "因为您拒绝回答。。。。"
          echo "脚本退出。。。"
          echo
          exit
          ;;
        esac
        #
        #
        echo
        #
        if [ -n "$line2" ]
        then
            echo $line1
            echo -e $line2"\c"
        else
            echo -e $line1"\c"
        fi
        #
        read -t 60 answer
done
#
        unset line1
        unset line2
#
}

##############################################
#       用户确认信息处理函数
process_answer(){
#
        case $answer in
        y|Y|yes|Yes)  # do  nothing
                  ;;
        *)echo
          echo $e_line1
          exit $e_line2
          ;;
        esac
#
        unset e_line1
        unset e_line2
#
}

#################################################
#       对文件进行批量改名操作的函数
#################################################
# 定义一个改名日志文件
log=/logs/cname$date.log
#查看日志文件是否已经存在，每天只有一个
if [ ! -f "$log" ]
then
touch $log
fi
# 定义文件改名计数器
count=0
#不进行递归
cname(){
        #当决定进行递归时，我将递归深度设置为100，缺点：如果深度大于一百，则可能递归不到
        #但是几乎不可能
        if [ "$bool" = "true" ]
        then
        depth=100
        else
        depth=1
        fi
#
        echo "递归的深度为：$depth"
        find $1  -maxdepth $depth -type f  -name "$pattern" | while read line
        do
        count=$[$count+1]
        echo "修改序号：$count"
        mv $line $line.$name
        echo "将文件$line改名为$line.$name,操作人员:$(whoami),时间：$date" >> $log
        echo "将文件$line改名为$line.$name,操作人员:$(whoami),时间：$date"
        done
#
        echo -e "您可以去/logs目录下查看 $log 日志文件获取详细的信息！"
}
#
#
echo
echo "step #1 - 请确认需要操作的文件夹以及您输入的正则表达式！"
line1="you want to rename these files that under the folder($pf) and conform to"
line2="the pattern($pattern),is that right?[y/n]"
get_answer
#
e_line1="您选择了否，脚本即将退出，请重新输入正确的参数运行该脚本！"
e_line2="bye!!"
process_answer
#

#
line1="您想要递归改名所有的文件吗?[y/n]"
get_answer
#
case $answer in
        y|Y|yes) bool="true";;
        *)       bool="false";;
        esac
#
line1="您即将对文件进行批量改名，你选择了对文件进行递归？（$bool）"
line2="请确认您的操作[y/n]"
get_answer
#

#
e_line1="因为您并不确定您的操作。。。"
e_line2="脚本退出。。。bye！"
process_answer
#
echo "正在对文件进行改名。。。"
cname $pf
echo "bye！"
exit
