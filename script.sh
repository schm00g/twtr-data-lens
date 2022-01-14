#!/bin/bash -e

source ./.env

declare -a NFT_INFLUENZAS=("326514675" "3369243892" "2621412174" "1432402638868389892")

# clear file contents
echo > flattened.txt
echo > consolidation.txt
echo > dupes.txt
echo > followers.json

# if [ -f .env ]
# then
#   export $(cat .env | sed 's/#.*//g' | xargs)
# fi

# *** !!! REMOVE TOKEN !!! *** # .env

for i in "${NFT_INFLUENZAS[@]}"
do
    curl -X GET -H "Authorization: Bearer "$BEARER_TOKEN"" "https://api.twitter.com/2/users/"$i"/following" > followers.json
    cat followers.json | jq .data | jq 'map(.username)' >> consolidation.txt
done

# is user list most recent follows??

while IFS= read -r line; do
    if [ "$line" != "]" ] && [ "$line" != "[" ]; then
        # echo "$line"
        echo "$line" >> flattened.txt
    fi
done < consolidation.txt

sort flattened.txt | uniq -d >> dupes.txt

[ -s dupes.txt ] || echo "no dupes bro"
