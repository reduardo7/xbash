## @
## Add action to execute on stdout callback.
## You can access current line data from ${OUT_LINE} variable.
##
## Params:
##   @: Command to execute on each stdout line.
##
## Example:
##   _onStdOut() {
##     local line="$1"
##     echo "++ ${line}"
##   }
##
##   @on.stdout '_onStdOut "${OUT_LINE}"'

# Not implemented
exit 1

local cmd="$@"

if [[ ! -z "${cmd}" ]]; then
  [ -z "${BX_ON_STDOUT}" ] || BX_ON_STDOUT="${BX_ON_STDOUT};"
  BX_ON_STDOUT="${BX_ON_STDOUT}( ${cmd} )"
fi

# vim: filetype=sh tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
