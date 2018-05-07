## text [to_remove]
## Remove ending spaces from text.
##
## Params:
##   text:      {String} Text.
##   to_remove: {String} String to remove.
##              Optional. Default: " ".
##
## Out: {String} Trimed text.

local a="$1"
local b=''
local s="${2:- }"

while [[ ${#a} -ne ${#b} ]]; do
  b="$a"
  a="${a%$s}" # RTRIM
done

echo -n "$a"
