#!/bin/bash

Xinput01=input.mp4
Xinput02=input.srt
Xinput03=output.mp4
[ -n "$1" ] && input01=$1 || input01=${Xinput01}
[ -n "$2" ] && input02=$2 || input02=${Xinput02}
[ -n "$3" ] && input03=$3 || input03=${Xinput03}

# rm -f out.mp4 ; /usr/bin/ffmpeg -i na_1177529858890485760.mp4 -vf subtitles=na_1177529858890485760.mp4.srt  out.mp4

okok=XXX
if [ -n "$4" -a -z "$5" ]; then
    if [ "$4" = "play" ] ; then

        echo
        echo "rm -f ${input03};/usr/bin/ffmpeg -i ${input01} -vf subtitles=${input02}:force_style=Fontsize=24 ${input03}"
        echo
        okok=YYY1
    fi
    if [ "$4" = "conv" ] ; then
        echo
        echo "ffplay -vf subtitles=${input02}:force_style=Fontsize=24   ${input01}"
        echo
        okok=YYY2
    fi
fi

if [ "${okok}" = "XXX" ]; then
    echo
    echo example : 
    echo "$0 ${input01} ${input02}  ${input03} <conv|play>"
    echo
    echo "rm -f ${input03};/usr/bin/ffmpeg -i ${input01} -vf subtitles=${input02}:force_style=Fontsize=24 ${input03}"
    echo
    echo "ffplay -vf subtitles=${input02}:force_style=Fontsize=24   ${input01}"
    echo
    #echo "mplayer -ass -sub 2.ass na_1177529858890485760.mp4"
    #echo
fi
