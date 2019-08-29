#!/bin/bash
for aa1 in                     \
    hugo-theme-docdock/            \
    hugo-theme-w3css-basic/        \
    hugo-tracks-theme/             \
    meghna-hugo/                   \

do
    echo
    find ${aa1}/ -type f      \
        |grep -v \\\.go$      \
        |grep -v \\\.txt$     \
        |grep -v \\\.yml$     \
        |grep -v \\\.xml$     \
        |grep -v \\\.yaml$    \
        |grep -v \\\.css$     \
        |grep -v \\\.scss$    \
        |grep -v \\\.svg$     \
        |grep -v \\\.json$    \
        |grep -v \\\.js$      \
        |grep -v \\\.toml$    \
        |grep -v \\\.html$    \
        |grep -v \\\.md$      \
        |grep -v \\\.php$     \
        |grep -v \\\.pdf$     \
        |grep -v /.keep$      \
        |grep -v /.keepme$    \
        |grep -v /LICENSE$    \
        \
        |grep -v \\\.jpg$     \
        |grep -v \\\.gif$     \
        |grep -v \\\.png$     \
        |grep -v \\\.ttf$     \
        |grep -v \\\.mp4$     \
        |grep -v \\\.mp3$     \
        |grep -v \\\.eot$     \
        |grep -v \\\.otf$     \
        |grep -v \\\.doc$     \
        |grep -v \\\.docx$    \
        |grep -v \\\.xls$     \
        |grep -v \\\.xlsx$    \
        |grep -v \\\.woff$    \
        |grep -v \\\.woff2$   \
        \
        |xargs -n 1

    if [ 1 = "${1}" ]
    then
        find ${aa1}/ -type f      \
            \
            |grep -v \\\.ttf$     \
            |grep -v \\\.mp4$     \
            |grep -v \\\.mp3$     \
            |grep -v \\\.eot$     \
            |grep -v \\\.otf$     \
            |grep -v \\\.doc$     \
            |grep -v \\\.docx$    \
            |grep -v \\\.xls$     \
            |grep -v \\\.xlsx$    \
            |grep -v \\\.woff$    \
            |grep -v \\\.woff2$   \
            | xargs -n 20 sed -i \
            -e 's;http:;hddp:;g' \
            -e 's;https:;hddps:;g' 

    fi


done

#            |grep -v \\\.jpg$     \
#            |grep -v \\\.gif$     \
#            |grep -v \\\.png$     \

#            |grep -v \\\.jpg$     \
#            |grep -v \\\.gif$     \
#            |grep -v \\\.png$     \
#            |grep -v \\\.ttf$     \
#            |grep -v \\\.mp4$     \
#            |grep -v \\\.mp3$     \
#            |grep -v \\\.eot$     \
#            |grep -v \\\.otf$     \
#            |grep -v \\\.doc$     \
#            |grep -v \\\.docx$    \
#            |grep -v \\\.xls$     \
#            |grep -v \\\.xlsx$    \
#            |grep -v \\\.woff$    \
#            |grep -v \\\.woff2$   \
