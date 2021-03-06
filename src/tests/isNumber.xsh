@@assert.noOut '@isNumber'
@@assert.noOut '@isNumber 0'
@@assert.noOut '@isNumber asd'
@@assert.noOut '@isNumber ""'
@@assert.noOut '@isNumber " "'

@@assert.exec '@isNumber' true '0'
@@assert.exec '@isNumber' true '1'
@@assert.exec '@isNumber' true '01'
@@assert.exec '@isNumber' true '10'
@@assert.exec '@isNumber' true '99'


@@assert.exec '@isNumber' false ''
@@assert.exec '@isNumber' false 'a'
@@assert.exec '@isNumber' false '" 0"'
@@assert.exec '@isNumber' false '"0 "'
@@assert.exec '@isNumber' false '" 0 "'
@@assert.exec '@isNumber' false '"1 0"'
@@assert.exec '@isNumber' false '""'

# vim: filetype=sh tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
