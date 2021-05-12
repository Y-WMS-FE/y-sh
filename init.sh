#! /bin/bash
set -u

abort() {
  printf "%s\n" "$@"
  exit 1
}

get_c() {
  read -p "输入需要检验的分支名称(空格分隔)：" "$@"
}

append_pre_post() {
  echo -e "$@" >> ./pre-post.sh
}

append_prepare_commit_msg() {
  echo "$@" >> ./prepare-commit-msg.sh
}

init_pre_post() {
  local s="ft dev test sit"
#  get_c s
  append_pre_post '#! /bin/bash

if [ -z "$SKIP_BRANCH" ]; then
  SKIP_BRANCH=('$s')
fi
for SKIP in "${SKIP_BRANCH[@]}"
do
  IS_SKIP=$(git symbolic-ref --short HEAD | grep -c "^$SKIP")
  if [ $IS_SKIP -eq 1 ]; then
    exit 0
  fi
done

FILTER=$(git log -1000 --pretty=format:"%h %s" | grep -E "into '"'"'ft_|into '"'"'dev'"'"'|into '"'"'test'"'"'|into '"'"'sit'"'"'")
if [ -n "$FILTER" ]; then
  echo "当前分支merge了开发、测试或者验收。" 1>&2
  exit 1
fi'
}

init_prepare_commit_msg() {
  append_prepare_commit_msg '#! /bin/bash
COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2
SHA1=$3

/usr/bin/perl -i.bak -ne "print unless(m/^. Please enter the commit message/..m/^#$/)" "$COMMIT_MSG_FILE"

if [ -z "$BRANCHES_TO_SKIP" ]; then
  BRANCHES_TO_SKIP=(master develop test)
fi

BRANCH_NAME=$(git symbolic-ref --short HEAD)
BRANCH_EXCLUDED=$(printf "%s\\n" "${BRANCHES_TO_SKIP[@]}" | grep -c "^$BRANCH_NAME$")
BRANCH_IN_COMMIT=$(grep -c "\\[$BRANCH_NAME\\]" $1)

if [ -n "$BRANCH_NAME" ] && ! [[ $BRANCH_EXCLUDED -eq 1 ]] && ! [[ $BRANCH_IN_COMMIT -ge 1 ]]; then
  sed -i .bak -e "1s/^/[$BRANCH_NAME] /" $COMMIT_MSG_FILE
fi
'
}

mv_sh() {
  mv ./pre-post.sh ./.git/hooks/pre-post
  mv ./prepare-commit-msg.sh ./.git/hooks/prepare-commit-msg
}

init_pre_post
init_prepare_commit_msg
mv_sh
chmod a+x .git/hooks/*
#
#if [ -z "$@" ]; then
#  SKIP_BRANCH=(ft dev test sit)
#fi
#
#for SKIP in "${SKIP_BRANCH[@]}"
#do
#  abort "12"
#done

# chmod a+x .git/hooks/*
