
#!/bin/sh

#�������
Interval=2

#��������(ȡ��ǰ����)
Now=`date +%Y%m%d`

Len=`expr length "$Now"`
if [ $Len != 8 ]
then
        echo "�Ƿ���������[$Len]!!"
        exit
fi
year=`echo $Now|awk '{print substr($1,1,4)}'`
month=`echo $Now|awk '{print substr($1,5,2)}'`
day=`echo $Now|awk '{print substr($1,7,2)}'`
DateP=$Now

day=`expr $day - $Interval`
Ss="ǰ"


####����mon_max_day���ÿ�����������
####���:��ʾ�������
mon_max_day()
{
day=0
if [ $1 -gt 0 -a $1 -lt 13 ]
then
case $1 in
            1|01|3|03|5|05|7|07|8|08|10|12) day=31;;
            4|04|6|06|9|09|11) day=30;;
            2|02)
                if [ `expr $year % 4` -eq 0 ]; then
                        if [ `expr $year % 400` -eq 0 ]; then
                                day=29
                        elif [ `expr $year % 100` -eq 0 ]; then
                                day=28
                        else
                                day=29
                        fi
                else
                        day=28
                fi;;
esac
fi
printf $day
}

####������ʼ
Max=`mon_max_day $month`

while [ $day -le 0 ]
do
        month=`expr $month - 1`
        if [ $month -eq 0 ]
        then
            month=12
            year=`expr $year - 1`
        fi
        Max=`mon_max_day $month`
        day=`expr $day + $Max`
done

DateA=`printf "%02d%02d%02d" $year $month $day`
#echo "��������Ϊ[$DateP],[$Interval]��$Ss�����ڞ�[$DateA]"
echo "$DateA"c


mvtopath1=$HOME/backup/log
logfilepath=$HOME/log

#������־�ļ�
cd $logfilepath
tar -cvf logfile$DateA.tar ./$DateA
gzip logfile$DateA.tar
mv logfile$DateA.tar.gz $mvtopath1
