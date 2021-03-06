output="$(@log 'no print' 3>/dev/null)"
@@assert.empty "${output}"

output="$(@log "foo\tbar" 3>&1)"
@@assert.notEmpty "${output}"
@@assert.notContains "${output}" "foo  bar"
@@assert.contains "${output}" 'foo'
@@assert.contains "${output}" 'bar'
@@assert.contains "${output}" "${BASHX_APP_PRINT_PREFIX}"
# @@assert.endWith "${output}" "$(@style reset)"

# vim: filetype=sh tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
