#read -p "Input passwd: " -s Passwd
#echo Password is $Passwd.

echo '
FILTER=$(git log -1000 --pretty=format:"%h %s" | grep -E "into '"'"'ft_|into '"'"'dev'"'"'|into '"'"'test'"'"'|into '"'"'sit'"'"'")

'
