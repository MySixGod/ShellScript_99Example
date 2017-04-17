#/bin/bash
# @author cwt
# @decription:delete_user

##########################################
#      define get_answer  function
##########################################

getanswer(){
#
        unset answer
        ask_count=0
#
#  -z: check the str.length is 0?
#
while [ -z "$answer" ]  #while on answer is given,keep asking
        do      
        ((ask_count++))
#
        case $ask_count in
        2)      
        echo    
        echo "please answer the question"
        echo    
        ;;      
        3)      
        echo    
        echo "one last try...please answer the question"
        echo    
        ;;      
        4)      
        echo    
        echo "since you refuse to answer the question"
        echo"exiting program"
        echo
#
        exit
        ;;
        esac
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

#########################################
#     define process_answer function：
#########################################
process_answer(){
#
        case $answer in
#
        y|yes|Y)
        # do nothing
        ;;
#
        *)
        echo
        echo $exit_line1
        echo $exit_line2
        echo
        exit
        ;;
        esac
#
        unset exit_line1
        unset exit_line2
#
}


###################################
#   end of function definitions
############# Main Script #########
# get name of user account to check
###################################

echo "step #1 - determine user account name to delete"
echo
line1="please enter the username of user"
line2="account you wish to delete from system:"
#
getanswer
user_account=$answer
#
line1="is $user_account the user account you want to removed?[y/n]"
getanswer
#
exit_line1="because the account,$user_account,is not exit"
exit_line2="the one you wish to delete,we are leaving the script..."
#
process_answer
#
###################################################################
#       check that user_account is really an account on the system
###################################################################
#
user_account_record=$(cat /etc/passwd | grep -w "$user_account")
#
if [ $? -eq 1 ]   # if the account is not found,exit script
then
        echo
        echo "account:$user_account,not found"
        echo "leaving this script..."
        echo
fi
#
echo "i found the record:"
echo "$user_account"
#
line1="is this the corrent user account[y/n]"
getanswer
#
#
exit_line1="because the account,$user_account,is not"
exit_line="the one you wish to delete,wo are leaving the script"
#
process_answer
#
################################################################################
#       serching for any running processes that belong to the user_account
#
echo
echo "step #2 - find process on system belonging to user_account"
echo
#
ps -u $user_account >/dev/null
#
case $? in
        1)
        echo "there are no processes for this account currently running!"
        ;;
        0)
        echo "$user_account has the following processes running:"
        echo $(ps -u $user_account)
#
        line="would you like to kill the processed?[y/n]"
        getanswer
#
        case $answer in
        y|Y|yes)
        echo
        echo "killing off processes..."
#
        command_1="ps -u $user_account --no-heading"
        command_2="xargs -d \\n /user/bin/sudo  /bin/kill -9"
        $command_1 | awk '{printf $1}' | $command_3
#
        echo
        echo  "processes killed."
        ;;
        *)
        echo
        echo "would not kill these processes"
        ;;
        esac
;;
esac

#########################################################################
#         create a report of all files owned by user_account
#########################################################################
echo
echo "step #3 - find files on system bolong to user_account"
echo
echo "creating a report of all files owned by $user_account"
echo
echo "it is recommended that you backup these files"
echo
echo "and then do one of two things"
echo "1) delete these files"
echo "2) change the files ownership to a current user account"
echo
echo "please wait.this may take a while"
echo
#
report_date=$(date +%y%m%d)
report_file=$user_accounr"_files_"$report_date".rpt"
#
find / -user $user_account > $report_file 2>/dev/null
#
echo
echo "report is complete!"
echo "name of report:$report_file"“
echo "location of report:$(pwd)"
echo

###############################################################################
#       remove user account
echo
echo "step #4 - remove user account"
echo
#i
line1="remove the"$user_account"from system?[y/n]"
getanswer
#
exit_line1="since you do not wish to remove the user_account"
exit_line2=$user_account "at this time,exiting the script"
#
process_answer
#
userdel $user_account
echo
echo "user_account,"$user_account "has been removed"
echo
#
exit


find | grep "a.*" | while read line
do rename=$(echo "$line" | awk -F. '{printf $1$2}')
mv $line .$rename
done
