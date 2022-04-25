#!/usr/bin/bash

:<<'COMMENTS'
- Download index.html
- Generate an array using all available categories from index.html where categories appear in this format:
<a href="/laughoutloud/funny-wtf/videos" class="pop plain">
- Select 5 random items in array


Sites:
m_ot
COMMENTS


# There has to be a better way to do this:
grep -E "a href.*videos.*pop plain" index.html | awk -F'[""]' '{print $2}' | awk '{gsub(/\//, ":") ; print }' | awk -F":" '{print $3}

# grep -E "a href.*videos.*pop plain" index.html ---> Extract the lines from index.html
# awk -F'[""]' '{print $2}' --> Prints second field (0,1,2...) of each line
# awk '{gsub(/\//, ":") ; print }'  --> Replaces all "/" characters with ":"
# awk -F":" '{print $3}' --> prints 3rd field