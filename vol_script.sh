#!/usr/bin/env bash


if [ -z "$1" -o "$1" == "-h" ]; then
    printf "usage:\n"
    printf "\t$ vol_script.sh [imagename] [OS_profile]"
    exit 1
fi

imagename=$1
profile="--profile=$2"
result_dir="result"
plugins=(
"pslist"
"pstree"
"netscan"
"connscan"
"dlllist"
"sockscan"
"svcscan --verbose"
"malfind"
"userassist --output=text"
"shimcache --output=text"
"shellbags --output=text"
"prefetchparser"
"uninstallinfo"
"firefoxhistory"
"chromehistory"
"autoruns"
)

if [ ! -e ${result_dir} ]; then
    mkdir "${result_dir}"
fi

# Proceed vol.py plugins
for var in "${plugins[@]}"
do
    echo "${var}......"
    vol.py -f ${imagename} ${profile} ${var} > "${result_dir}/${var}.txt"
    echo "Done!"
    echo ""
done

# Extract memory timeline
echo "Memory timeline......"
vol.py -f ${imagename} ${profile} timeliner --output=body > timelines.txt
vol.py -f ${imagename} ${profile} shellbags --output=body >> timelines.txt
vol.py -f ${imagename} ${profile} mftparser --output=body >> timelines.txt

mactime -b timelines.txt -z Japan > timelines.csv
echo ""
echo ""

echo "FINISHED!!!"
