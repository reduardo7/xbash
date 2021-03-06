## *
## String to lower case.
##
## Params:
##   *: {String} String to convert.
##
## Out: {String} Result string.

local text="$@"

# https://superuser.com/a/642932/84212
[ ! -z "${text}" ] && echo "${text}" | tail -n +1 | tr '[A-Z]' '[a-z]'

# vim: filetype=sh tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
