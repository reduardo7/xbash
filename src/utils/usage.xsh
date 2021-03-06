## src [prefix]
## Print basic script usage.
##
## Params:
##   src:    {String} File to read usage.
##   prefix: {String} Usage prefix.
##           Optional. Default: ${BX_SCRIPT_FILE_NAME}.
##   cmd:    Optional. Default: File name.
##
## Out: {String} Usage text.

local src="$1"
local prefix="${2:-${BX_SCRIPT_FILE_NAME}}"
local cmd="${3:-$(@file.name "${src}" true)}"

local lp='    '
local lpl=${#lp}
local first_line=true
local sd="$(@style)"
local info

if [ -z "${src}" ] || [ ! -f "${src}" ]; then
  @throw "Invalid file '${src}'"
fi

if [ ! -z "${prefix}" ]; then
  prefix="$(@style color:red)${prefix}"
fi

# Get comments from file
egrep "^${BASHX_DOC_MARK}" "${src}" | egrep -v "^${BASHX_DOC_MARK}#" | while read line
  do
    if ${first_line}; then
      first_line=false
      @log "  ${prefix} $(@style color:green)${cmd}${sd} $(@str.replace "${line}" "^${BASHX_DOC_MARK}\\s*" '')"
    else
      @log "$(@str.replace "${line}" "^${BASHX_DOC_MARK}\\s" "${sd}${lp}")"
    fi
  done

@log

# vim: filetype=sh tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
