#urls="https://github.com/shmpwk/CI_practice/pull/32"
#for url in $urls; do
#  gh_url=$(echo $url | sed 's/https:\/\/github.com/\/repos/g' | sed 's/pull/pulls/g')
#  echo $gh_url
#  gh api -H "Accept: application/vnd.github+json" $gh_url | jq '.body'
#  sleep 2.0
#done

#gh_url="/repos/shmpwk/CI_practice/pulls/32"
#gh api -H "Accept: application/vnd.github+json" $gh_url | jq '.body'

url="https://github.com/autowarefoundation/autoware.universe/pull/2314"
gh_url=$(echo $url | sed 's/https:\/\/github.com/\/repos/g' | sed 's/pull/pulls/g')
body=$(gh api -H "Accept: application/vnd.github+json" $gh_url | jq '.body' | sed 's/\\r\\n\\r\\n/\\r\\n/g' | sed 's/\\r\\n\\r\\n/\\r\\n/g' | sed 's/\\r\\n/"CHAR(10)"/g')
description=$(echo $body | awk -F "##" '{print $1, $2}' | sed 's/<!--.*-->//g' | sed 's/Signed.*\.jp//g' | sed 's/Signed.*\.ai//g')
related_links=$(echo $body | awk -F "##" '{print $3}' | awk '/Related links/{print}' | sed 's/<!--.*-->//g')
tests_performed=$(echo $body | awk -F "##" '{print $4}' | awk '/Tests performed/{print}' | sed 's/<!--.*-->//g')
note_for_reviewers=$(echo $body | awk -F "##" '{print $5}' | awk '/Note for reviwers/{print}' | sed 's/<!--.*-->//g')
bodies=$(jq -n --arg description "$description" \
  --arg related_links "$related_links" \
  '{"description": $description, "related_links": $related_links}')
sub=$(jq -n --arg description "$tests_performed" \
  --arg related_links "$note_for_reviewers" \
  '{"tests_performed": $description, "note_for_reviewers": $related_links}')
#mul=$(echo $bodies | jq -n --arg sub "$sub" '. + $sub')
#mul=$(jq -n --arg sub "$sub" --arg bodies "$bodies" '$bodies + $sub')
mul=$(jq -nr --arg sub "$sub" --arg bodies "$bodies" '$bodies + $sub')
arr=$nil
#urls={{"hoge":"1"}, {"hoge":"2"}, {"hoge":"3"}}
urls=$(cat << EOS
[{"hoge":"1"}, {"hoge":"2"}, {"hoge":"3"}]
EOS
)
refs=$(cat << EOS
[{"fuga":1}, {"fuga":2}, {"fuga":3}]
EOS
)
echo $urls | jq '.[].hoge'
#url_length=$(echo $urls | jq length) 
#for i in `seq 0 $(($url_length - 1))`; do
#  url=$(echo $urls | jq .[$i])
#  echo $url
#  arr=$(jq -nr --arg arr "$arr" --arg url "$url" '$arr + $url')
#  #echo $arr
#done
#echo $arr | jq '.hoge'

url_list=$(echo $urls | jq -cr .[])
echo $url_list
arr=
for url in $url_list; do
  arr=$(jq -nr --arg arr "$arr" --arg url "$url" '$arr + $url')
done
echo $arr | jq -r 'reduce range(.|length) as $i(.;.number="\($i+1)")'
arr_list=$(echo $arr | jq '. | map({ })')
echo $arr_list
echo "--------------"
echo $urls | jq '.[].hoge'
echo $refs | jq 'reduce .[] as $n (0; . + $n.fuga)'
echo $refs | jq -rc --argjson urls "$urls" '$urls | .[].hoge'
echo $refs | jq -rc '.[]'
echo "--------------"
echo $refs | jq -rc --argjson urls "$urls" '$urls | .[] '
echo $refs | jq -rc --argjson urls "$urls" --argjson refs "$refs" '($urls) | .[] + ($refs | .[])'
echo $refs | jq -rc --argjson urls "$urls" --argjson refs "$refs" 'map({$urls, $refs}) | add'
echo "--------------"
echo $refs | jq -rc --argjson urls "$urls" --argjson refs "$refs" 'reduce .[] as $n (0; ($urls | .[]) + $n)'
echo $urls $refs | jq -s 'add' 
echo "--------------"
echo $urls $refs | jq -s 'map({hoge: .[0].hoge, fuga: .[1].fuga})' 
echo $urls $refs | jq -s '(.[0] | .[]), (.[1] | .[]) | jq -s add' 
echo "--------------"
echo $urls $refs | jq -s '(.[0] | .[]) + (.[1] | .[])' 

#echo $refs | jq -rc --argjson urls "$urls" --argjson refs "$refs" ''

#echo $body
#echo $description
#echo $related_links
#echo $tests_performed
#echo $note_for_reviewers
#
#echo $bodies
#echo $sub
#echo $mul
