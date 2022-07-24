#!/bin/bash

# Add your email addresses here

from_addr="{from_email}"
to_addr="{to_address"
hostname=$(hostname -f)

UP="All packages are up to date."
PKG_CNT=$(sudo apt update 2>/dev/null | grep packages | sed -n '$p' | cut -d '.' -f 1 | xargs -I "%" echo %.)

if [[ $PKG_CNT = $UP ]]; then

    echo $PKG_CNT
    exit 1

fi

#echo $PKG_CNT | sed -e 's/[^0-9]//g'

subject="Host: [${hostname}] has ${PKG_CNT}"

LIST_PKG=$(apt-get -V -s dist-upgrade \
   |grep -E "^   .*=>.*" \
       |awk 'BEGIN {
            ul=sprintf("%*s",40,""); gsub(/ /,"-",ul);
            printf "%-50s %-30s %-30s\n", "Package", "Installed", "Available";
            printf "%-50.30s %-30.30s %-30.30s\n", ul, ul, ul;
            }
        {
            printf "%-50s %-30s %-30s\n",
                $1,
                substr($2,2),
                substr($4,1,length($4)-1)
        }')

if [[ -n $LIST_PKG ]];
    then
        echo "$LIST_PKG"  > /tmp/packages
fi

packages=/tmp/packages

if [[ -f $packages ]];
    then
    (
        echo "From: $from_addr"
        echo "To: $to_addr"
        echo "MIME-Version: 1.0"
        echo "Subject: $subject" | sed 's/packages/& that/'
        echo "Content-Type: text/html"
        echo "<FONT FACE='COURIER NEW'>"
        echo -e "\nThe Following Packages Have Updates Ready To Be Installed:\n"
        echo "</FONT><PRE>"
        echo "<FONT FACE='COURIER NEW'><PRE>"
        cat $packages
        echo "</PRE></FONT>" ) | /usr/sbin/sendmail -t

fi

if [[ -f "/tmp/packages" ]];
    then
        rm /tmp/packages
fi
