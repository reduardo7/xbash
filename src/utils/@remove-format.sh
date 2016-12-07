# Remove color codes (special characters).
#
# *: {String} Text.
# Out: {String} Text without format.

# http://www.commandlinefu.com/commands/view/3584/remove-color-codes-special-characters-with-sed

local pr

$OS_IS_MAC && pr='E' || pr='r'

echo "$@" | sed -${pr} "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"
