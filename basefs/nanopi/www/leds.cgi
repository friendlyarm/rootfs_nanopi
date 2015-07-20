#!/bin/sh

type=0
period=1

case $QUERY_STRING in
	*ping*)
		type=0
		;;
	*counter*)
		type=1
		;;
	*stop*)
		type=2
		;;
esac

case $QUERY_STRING in
	*slow*)
		period=0.25
		;;
	*normal*)
		period=0.125
		;;
	*fast*)
		period=0.0625
		;;
esac

/bin/echo $type $period > /tmp/led-control

echo "Content-type: text/html; charset=gb2312"
echo
/bin/cat led-result.template

exit 0
