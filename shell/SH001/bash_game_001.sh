#!/bin/env bash 
#. functions.sh

#/************************************************************************************
# 功能描述: 请输入程序功能描述
# 执行说明: 
# 输入参数: 日期 yyyymmdd 如:20190601
# 输出结果: 
# 创建人员: zoukh
# 创建日期: 2020-08-03 15:13:14
# 修改人员: zoukh
# 修改日期: 2020-08-05 11:19:43
#/************************************************************************************
#
# ( ･_･)ﾉ⌒●~* 注释写的少,bug改不好 *~●⌒㇏(･_･ ) 
#


#!/usr/bin/env bash

rm -f /tmp/zpipe
mkfifo /tmp/zpipe
declare RTIMEOUT=1

#important variables
declare -ia board    # array that keeps track of game status
declare -i pieces    # number of pieces present on board
declare -i score=0   # score variable
declare -i flag_skip # flag that prevents doing more than one operation on
                     # single field in one step
declare -i moves     # stores number of possible moves to determine if player lost 
                     # the game
declare ESC=$'\e'    # escape byte
#declare header="Bash 2048 v1.1 (https://github.com/mydzor/bash2048)"
declare header="Bash tetries v1.0"

declare -i start_time=$(date +%s)

#default config
declare -i board_size=10
declare -i target=2048
declare -i reload_flag=0
declare config_dir="$HOME/.bash2048"

#for colorizing numbers
declare -a colors
colors[2]=33         # yellow text
colors[4]=32         # green text
colors[8]=34         # blue text
colors[16]=36        # cyan text
colors[32]=35        # purple text
colors[64]="33m\033[7"        # yellow background
colors[128]="32m\033[7"       # green background
colors[256]="34m\033[7"       # blue background
colors[512]="36m\033[7"       # cyan background
colors[1024]="35m\033[7"      # purple background
colors[2048]="31m\033[7"      # red background (won with default target)

exec 3>/dev/null     # no logging by default

trap "end_game 0 1" INT #handle INT signal

#simplified replacement of seq command
function _seq {
  local cur=1
  local max
  local inc=1
  case $# in
    1) let max=$1;;
    2) let cur=$1
       let max=$2;;
    3) let cur=$1
       let inc=$2
       let max=$3;;
  esac
  while test $max -ge $cur; do
    printf "$cur "
    let cur+=inc
  done
}

# print currect status of the game, last added pieces are marked red
function print_board {
  clear
  printf "$header pieces=$pieces target=$target score=$score\n"  > /tmp/bash_game_001
  printf "Board status:\n" >&3
  printf "\n" >> /tmp/bash_game_001
  printf '/------' >> /tmp/bash_game_001
  for l in $(_seq 1 $index_max); do
    printf '+------' >> /tmp/bash_game_001
  done
  printf '\\\n' >> /tmp/bash_game_001
  for l in $(_seq 0 $index_max); do
    printf '|' >> /tmp/bash_game_001
    for m in $(_seq 0 $index_max); do
      if let ${board[l*$board_size+m]}; then
        if let '(last_added==(l*board_size+m))|(first_round==(l*board_size+m))'; then
          #printf '\033[1m\033[31m %4d \033[0m|' ${board[l*$board_size+m]} >> /tmp/bash_game_001
          printf '\033[40m %4d \033[0m|' ${board[l*$board_size+m]} >> /tmp/bash_game_001

        else
         # printf "\033[1m\033[${colors[${board[l*$board_size+m]}]}m %4d\033[0m |" ${board[l*$board_size+m]} >> /tmp/bash_game_001
          printf "\033[40m %4d \033[0m|" ${board[l*$board_size+m]} >> /tmp/bash_game_001
        fi
      else
        printf '      |' >> /tmp/bash_game_001
      fi
    done
    let l==$index_max || {
      printf '\n|------' >> /tmp/bash_game_001
      for l in $(_seq 1 $index_max); do
        printf '+------' >> /tmp/bash_game_001
      done
      printf '|\n' >> /tmp/bash_game_001
      printf '\n' >&3
    }
  done
  printf '\n\\------' >> /tmp/bash_game_001
  for l in $(_seq 1 $index_max); do
    printf '+------' >> /tmp/bash_game_001
  done
  printf '/\n' >> /tmp/bash_game_001

  cat /tmp/bash_game_001 > /tmp/zpipe &
  cat /tmp/zpipe
}

# Generate new piece on the board
# inputs:
#         $board  - original state of the game board
#         $pieces - original number of pieces
# outputs:
#         $board  - new state of the game board
#         $pieces - new number of pieces

# 修改一次性生成4个方块
# 四个方向,x+1,x-1,x+board_size,x-board_size,如果越界,就修改为反方向
function generate_piece {
  while true; do
    #let pos=RANDOM%fields_total
    #let pos=63

    let pos1=(board_size-4)/2
    let pos2=(board_size-4)/2+4-1
    #let pos3=(board_size-4)/2+4*board_size
    #let pos4=(board_size-4)/2+4+4*board_size

    #转换x,y
    #x((0-4)+pos1)
    #y(0-4)
    let randomx=RANDOM%4+pos1
    let randomy=RANDOM%4
    let pos=randomx+randomy*10

    let board[$pos] || {
    #let value=RANDOM%10?2:4
    let value=1

    board_his1[0]="$randomx,$randomy"
    #echo "+++++${board_his1[0]}999+++$randomx,$randomy"
    board[$pos]=$value
    generate_piece2
    board[$pos]=$value
    board_his1[1]="$randomx,$randomy"

    generate_piece2
    board[$pos]=$value
    board_his1[2]="$randomx,$randomy"

    generate_piece2
    board[$pos]=$value
    board_his1[3]="$randomx,$randomy"

    last_added=$pos
    printf "Generated new piece with value $value at position [$pos]\n" >&3
    break;
    }
  done
  let pieces++
}
function generate_piece2 {
    #开始随机形状,遇到越界往返方向,遇到重复,转换坐标
    randomx_bak=$randomx
    randomy_bak=$randomy
    let randomt=RANDOM%4
    ##echo =====$randomt++++$pos===$check_exists_rs
    if [[ $randomt = 0 ]];then
        let randomx=randomx_bak+1
        let randomy=randomy
        if [[ $randomx -gt $pos2 ]];then
            let randomx=randomx_bak-1
        fi

        check_exists_his
        if [[ $check_exists_rs = 1 ]];then
            let randomx=randomx_bak
            let randomy=randomy_bak-1
            check_exists_his
            if [[ $randomy -lt 0 ]] || [[ $check_exists_rs = 1 ]];then
            let randomy=randomy_bak+1
            fi
        fi
  
    elif [[ $randomt = 1 ]];then
        let randomx=randomx_bak-1
        let randomy=randomy
        if [[ $randomx -lt $pos1 ]];then
            let randomx=randomx_bak+1
        fi
        check_exists_his
        if [[ $check_exists_rs = 1 ]];then
            let randomx=randomx_bak
            let randomy=randomy_bak-1
            check_exists_his
            if [[ $randomy -lt 0 ]] || [[ $check_exists_rs = 1 ]];then
            let randomy=randomy_bak+1
            fi
        fi
        
    elif [[ $randomt = 2 ]];then
        let randomx=randomx_bak
        let randomy=randomy_bak-1
        if [[ $randomy -lt 0 ]];then
            let randomy=randomy_bak+1
        fi
        check_exists_his
        if [[ $check_exists_rs = 1 ]];then
            let randomx=randomx_bak+1
            let randomy=randomy_bak

            check_exists_his
            if [[ $randomx -gt $pos2 ]] || [[ $check_exists_rs = 1 ]];then
            let randomx=randomx_bak-1
            fi
        fi

    elif [[ $randomt = 3 ]];then
        let randomx=randomx_bak
        let randomy=randomy_bak+1
        if [[ $randomy -gt 3 ]];then
            let randomy=randomy_bak-1
        fi
        check_exists_his

        if [[ "$check_exists_rs" = "1" ]];then
            let randomx=randomx_bak+1
            let randomy=randomy_bak
            check_exists_his
            if [[ $randomx -gt $pos2 ]] || [[ $check_exists_rs = 1 ]];then
            let randomx=randomx_bak-1
            fi
        fi

    fi
    let pos=randomx+randomy*10
}

function check_exists_his {
  echo $randomx,$randomy,$randomx_bak,$randomy_bak+$randomt+$pos+$check_exists_rs

  for i in $(seq 4);do
    if [[ "${board_his1[i-1]}" = "$randomx,$randomy" ]];then
       check_exists_rs=1
       return 1;
    fi
  done
  check_exists_rs=0
  return 0;

}

function update_his {
  option_type=$1
  #清空
  check_right=0
  check_left=0
  check_down=0
  for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    let his_pos=his_pos_x+10*his_pos_y
    board[$his_pos]=0
    echo 12312---$check_left==$his_pos_x
    [[ $his_pos_x -gt 0  ]] && [[ ${check_left:=0} -lt 1 ]]
    check_left=$?
    #echo 12312---$check_left==$his_pos_x
    
    [[ $his_pos_x+1 -lt $board_size  ]] && [[ ${check_right:=0} -lt 1 ]]
    check_right=$?

    [[ $his_pos_y+1 -lt $board_size  ]] && [[ ${check_down:=0} -lt 1 ]]
    check_down=$?
  done

  if [[ $check_down = 1 ]];then
    for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    let his_pos=his_pos_x+10*his_pos_y
    board[$his_pos]=1
  done
  
  generate_piece

  return
  fi
  
  #echo $check_left===$check_right===$check_down
  #新位置
  case $option_type in
  up)
  for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    let his_pos=his_pos_x+10*his_pos_y
    board[$his_pos]=1
  done
  ;;
  down)
  if [[ $check_down = 1 ]];then
  for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    let his_pos=his_pos_x+10*his_pos_y
    board[$his_pos]=1
  done
  check_down=0
    return 
  fi
  for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    let his_pos_y=his_pos_y+1
    board_his1[i-1]="$his_pos_x,$his_pos_y"
    let his_pos_new=his_pos_x+10*his_pos_y
    board[$his_pos_new]=1
  done
  ;;
  left)
  if [[ $check_left = 1 ]];then
  for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    let his_pos=his_pos_x+10*his_pos_y
    board[$his_pos]=1
  done
  check_right=0
  check_left=0
    return 
  fi
  for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    #let his_pos_y=his_pos_y+1
    let his_pos_x=his_pos_x-1

    board_his1[i-1]="$his_pos_x,$his_pos_y"
    let his_pos_new=his_pos_x+10*his_pos_y
    board[$his_pos_new]=1
  done
  ;;
  right)
  if [[ $check_right = 1 ]];then
  for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    let his_pos=his_pos_x+10*his_pos_y
    board[$his_pos]=1
  done
  check_right=0
  check_left=0

    return 
  fi
  for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    #let his_pos_y=his_pos_y+1
    let his_pos_x=his_pos_x+1

    board_his1[i-1]="$his_pos_x,$his_pos_y"
    let his_pos_new=his_pos_x+10*his_pos_y
    board[$his_pos_new]=1
    done
   ;;
  esac

}

function check_border {
  :
}

function update_his_auto {
  while true ;do
  option_type=$1
  #清空
  for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    let his_pos=his_pos_x+10*his_pos_y
    board[$his_pos]=0
  done

  for i in $(seq 4);do
    his_pos_x=$(echo ${board_his1[i-1]} |awk -F "," '{print $1}')
    his_pos_y=$(echo ${board_his1[i-1]} |awk -F "," '{print $2}')
    let his_pos_y=his_pos_y+1
    board_his1[i-1]="$his_pos_x,$his_pos_y"
    let his_pos_new=his_pos_x+10*his_pos_y
    board[$his_pos_new]=1
  done
  print_board
  sleep 2
  done
}
# perform push operation between two pieces
# inputs:
#         $1 - push position, for horizontal push this is row, for vertical column
#         $2 - recipient piece, this will hold result if moving or joining
#         $3 - originator piece, after moving or joining this will be left empty
#         $4 - direction of push, can be either "up", "down", "left" or "right"
#         $5 - if anything is passed, do not perform the push, only update number 
#              of valid moves
#         $board - original state of the game board
# outputs:
#         $change    - indicates if the board was changed this round
#         $flag_skip - indicates that recipient piece cannot be modified further
#         $board     - new state of the game board
function push_pieces {
  case $4 in
    "up")
      let "first=$2*$board_size+$1"
      let "second=($2+$3)*$board_size+$1"
      ;;
    "down")
      let "first=(index_max-$2)*$board_size+$1"
      let "second=(index_max-$2-$3)*$board_size+$1"
      ;;
    "left")
      let "first=$1*$board_size+$2"
      let "second=$1*$board_size+($2+$3)"
      ;;
    "right")
      let "first=$1*$board_size+(index_max-$2)"
      let "second=$1*$board_size+(index_max-$2-$3)"
      ;;
  esac
  let ${board[$first]} || { 
    let ${board[$second]} && {
      if test -z $5; then
        board[$first]=${board[$second]}
        let board[$second]=0
        let change=1
        printf "move piece with value ${board[$first]} from [$second] to [$first]\n" >&3
      else
        let moves++
      fi
      return
    }
    return
  }
  let ${board[$second]} && let flag_skip=1
  let "${board[$first]}==${board[second]}" && { 
    if test -z $5; then
      let board[$first]*=2
      let "board[$first]==$target" && end_game 1
      let board[$second]=0
      let pieces-=1
      let change=1
      let score+=${board[$first]}
      printf "joined piece from [$second] with [$first], new value=${board[$first]}\n" >&3
    else
      let moves++
    fi
  }
}

function apply_push {
  printf "\n\ninput: $1 key\n" >&3
  for i in $(_seq 0 $index_max); do
    for j in $(_seq 0 $index_max); do
      flag_skip=0
      let increment_max=index_max-j
      for k in $(_seq 1 $increment_max); do
        let flag_skip && break
        push_pieces $i $j $k $1 $2
      done 
    done
  done
}

function check_moves {
  let moves=0
  apply_push up fake
  apply_push down fake
  apply_push left fake
  apply_push right fake
}

function key_react {
  let change=0
  read -d '' -sn 1 -t1
  #echo $REPLY
  test "$REPLY" = "$ESC" && {
    read -d '' -sn 1 -t1
    test "$REPLY" = "[" && {
      read -d '' -sn 1 -t1
      case $REPLY in
        A) apply_push up;;
        B) apply_push down;;
        C) apply_push right;;
        D) apply_push left;;
      esac
    }
  } || {
    case $REPLY in
      k) apply_push up;;
      j) apply_push down;;
      l) apply_push right;;
      h) apply_push left;;

      w) apply_push up;;
      s) apply_push down;;
      d) apply_push right;;
      a) apply_push left;;
    esac
  }
}

function key_react2 {
  let change=0
  read -d '' -sn 1 -t2
  echo 111$REPLY==222
  if [[ "Z$REPLY" = "Z" ]];then
   
  echo 222$REPLY==222

   return
  fi
  test "$REPLY" = "$ESC" && {
    read -d '' -sn 1 
    test "$REPLY" = "[" && {
      read -d '' -sn 1 -t1
      case $REPLY in
        A) update_his up;;
        B) update_his down;;
        C) update_his right;;
        D) update_his left;;
      esac
    }
  } || {
    case $REPLY in
      k) update_his up;;
      j) update_his down;;
      l) update_his right;;
      h) update_his left;;

      w) update_his up;;
      s) update_his down;;
      d) update_his right;;
      a) update_his left;;
    esac
  }
}

#得分判断,检查整个面板,每行的总和等于边长即消去,得分,
function check_score {
  :
}

function save_game {
  rm -rf "$config_dir"
  mkdir "$config_dir"
  echo "${board[@]}" > "$config_dir/board"
  echo "$board_size" > "$config_dir/board_size"
  echo "$pieces" > "$config_dir/pieces"
  echo "$target" > "$config_dir/target"
#  echo "$log_file" > "$config_dir/log_file"
  echo "$score" > "$config_dir/score"
  echo "$first_round" > "$config_dir/first_round"
}

function reload_game {
  printf "Loading saved game...\n" >&3

  if test ! -d "$config_dir"; then
    return
  fi
  board=(`cat "$config_dir/board"`)
  board_size=(`cat "$config_dir/board_size"`)
  board=(`cat "$config_dir/board"`)
  pieces=(`cat "$config_dir/pieces"`)
  first_round=(`cat "$config_dir/first_round"`)
  target=(`cat "$config_dir/target"`)
  score=(`cat "$config_dir/score"`)

  fields_total=board_size*board_size
  index_max=board_size-1
}

function end_game {
  # count game duration
  end_time=$(date +%s) 
  let total_time=end_time-start_time
  
  print_board
  kill -9 $update_pid
  printf "Your score: $score\n"
  
  printf "This game lasted "

  `date --version > /dev/null 2>&1`
  if [[ "$?" -eq 0 ]]; then
      date -u -d @${total_time} +%T
  else
      date -u -r ${total_time} +%T
  fi
  
  stty echo
  let $1 && {
    printf "Congratulations you have achieved $target\n"
    exit 0
  }
  let test -z $2 && {
    read -n1 -p "Do you want to overwrite saved game? [y|N]: "
    test "$REPLY" = "Y" || test "$REPLY" = "y" && {
      save_game
      printf "\nGame saved. Use -r option next to load this game.\n"
      exit 0
    }
    test "$REPLY" = "" && {
      printf "\nGame not saved.\n"
      exit 0
    }
  }
  printf "\nYou have lost, better luck next time.\033[0m\n"
  exit 0
}

function help {
  cat <<END_HELP
Usage: $1 [-b INTEGER] [-t INTEGER] [-l FILE] [-r] [-h]
  -b			specify game board size (sizes 3-9 allowed)
  -t			specify target score to win (needs to be power of 2)
  -l			log debug info into specified file
  -r			reload the previous game
  -h			this help
END_HELP
}

function main {
#parse commandline options
while getopts "b:t:l:rh" opt; do
  case $opt in
    b ) board_size="$OPTARG"
      let '(board_size>=3)&(board_size<=9)' || {
        printf "Invalid board size, please choose size between 3 and 9\n"
        exit -1 
      };;
    t ) target="$OPTARG"
      printf "obase=2;$target\n" | bc | grep -e '^1[^1]*$'
      let $? && {
        printf "Invalid target, has to be power of two\n"
        exit -1 
      };;
    r ) reload_flag="1";;
    h ) help $0
        exit 0;;
    l ) exec 3>$OPTARG;;
    \?) printf "Invalid option: -"$opt", try $0 -h\n" >&2
            exit 1;;
    : ) printf "Option -"$opt" requires an argument, try $0 -h\n" >&2
            exit 1;;
  esac
done

#init board
let fields_total=board_size*board_size
let index_max=board_size-1
for i in $(_seq 0 $fields_total); do board[$i]="0"; done
let pieces=0
generate_piece
first_round=$last_added
generate_piece

#load saved game if flag is set
if test $reload_flag = "1"; then
  reload_game
fi

while true; do
  print_board
  key_react
  let change && generate_piece
  first_round=-1
  let pieces==fields_total && {
   check_moves
   let moves==0 && end_game 0 #lose the game
  }
done

}

# main "$@"

function mytest {
let fields_total=board_size*board_size
let index_max=board_size-1

#echo $board_size---$fields_total---$index_max

for i in $(_seq 0 $fields_total); do board[$i]="0"; done
let pieces=0
generate_piece
first_round=$last_added
#echo $last_added
#generate_piece
#print_board
#update_his_auto &
#update_pid=$!

while true; do
print_board
key_react2
#sleep 1
done

#/f/git/myGit/Hadoop-Cluster-Easy/shell/SH001

# 1.造随机块
# 2.移动(变形)
# 3.边界
# 4.得分
# 5.结束

# 6.多线程 / 管道

}

mytest "$@"

