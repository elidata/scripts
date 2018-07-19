#!/bin/bash
# COMpare TWO CVS FILES BY COLUMN HEADER

FILE1=$1
FILE2=$2
DELIM=" "

#FILE1=518.out
#FILE2=merged518.out

echo "Comparing $1 and $2 CSV files - expecting SPACE delimiter"
COLUMNS1=`head -1 $FILE1`
COLUMNS2=`head -1 $FILE2`
POS1=1
for a in $COLUMNS1; 
do
	#Find column with same heading in second file

	echo $POS1':'$a
	POS2=`echo $COLUMNS2| awk -v X=$a '{ for(i=1;i<=NF;i++) { if($i == X) {printf("%d", i); exit } }}'`
	if [ "$POS2" == "" ]
	then
		echo $a" does not appear in " $FILE2
	else
		echo $a" found at position "$POS2
		cut -d'	' -f$POS1 < $FILE1 > /tmp/diff1
		cut -d'	' -f$POS2 < $FILE2 > /tmp/diff2
		mydiff=`cmp -s /tmp/diff1 /tmp/diff2`
		if [ "$?" -ne "0" ]
		then
			echo "Differences in column "$a
			paste -d"	" /tmp/diff1 /tmp/diff2
		fi
	fi
	POS1=$(expr $POS1 + 1)
done

