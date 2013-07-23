#!/bin/bash

## XBash
##
## Extended Bash Framework.
##
## Version: 1.3
## URL: https://github.com/reduardo7/xbash
##
## Author: Eduardo Cuomo | eduardo.cuomo.ar@gmail.com

# #############################################################################

# Init.

## #!/bin/bash
## . ./src/xbash.sh

# #############################################################################

# Test if running with "bash" interpreter.
if [ -z "$BASH" ]; then
    bash "$0" "$@"
    exit $?
fi

# Reset color for command output
# (this one is invoked every time before a command is executed):
trap 'echo -ne "\e[0m"' DEBUG

# #############################################################################

### CONFIG
# Rewrite with your configuration.

    # APP Title.
    APP_TITLE="XBash"

    # APP Version.
    APP_VERSION="1.3"

    # Default APP color. See "style" for more information.
    #COLOR_DEFAULT="system" # Default system color
    COLOR_DEFAULT="cyan"

    # Start character for formated print screen (see "e" function).
    ECHO_CHAR="#"

    # Application requeirements.
    # To extend requeirements, use:
    #   APP_REQUEIREMENTS="${APP_REQUEIREMENTS} other app command extra foo"
    APP_REQUEIREMENTS="echo printf sed grep tput read date dirname readlink basename tar let"

    # Default action to call
    # Action to use if script called without arguments.
    DEFAULT_ACTION=""

    # XBash SRC path.
    XBASH_SRC_PATH="src"

### Load files

    # Config
    if [ -z "${CONFIG_FILE}" ]; then
        # Default file
        CONFIG_FILE="${XBASH_SRC_PATH}/config.ini"
    fi
    if [ -f "${CONFIG_FILE}" ]; then
        # Load file
        . ./${CONFIG_FILE}
    fi

### VARS

    # Current path
    CURRENT_DIR="$(pwd)"

    # XBash File Name
    XBASH_FILE_NAME="./${XBASH_SRC_PATH}/xbash.sh"

    # Null path.
    DEV_NULL="/dev/null"

    # Boolean true.
    TRUE=1

    # Boolean false.
    FALSE=0

    # Key: ESC
    KEY_ESC=$'\e'

    # Result value for some functions
    RESULT=""

    # Called action
    ACTION=""

    # Actions directory name
    ACTIONS_DIR="actions"

    # Actions path
    ACTIONS_PATH="./${XBASH_SRC_PATH}/${ACTIONS_DIR}"

### PRIVATE VARS

    # On exit command
    _ON_EXIT=''

   # TRUE if APP is terminated
   _APP_EXIT=$FALSE

### UTILS

    # Check if run as Root.
    #
    # Out: {Boolean} TRUE if is root.
    # Return: 0 if is root, 1 is not root.
    function is_root() {
        # Is ROOT user?
        if [ "$(id -u)" -ne 0 ]; then
            # No Root
            echo $FALSE
            return 1
        else
            # Root
            echo $TRUE
            return 0
        fi
    }

    # Check if running as ROOT, or exit from script.
    #
    # *: (Optional) Message.
    function root_validator() {
        if [ "$(is_root)" == $FALSE ]; then
            if [ $# -eq 0 ] ; then
                local m="This script must be run as root!"
            else
                local m="$@"
            fi
            e "$m"
            e
            end 1
        fi
    }

    # Check if is empty.
    #
    # 1: {*} Variable to check if emtpy.
    # Out: {Boolean} TRUE if variable is emtpy.
    # Return: The same as "Out".
    function is_empty() {
        if [ -z "$1" ]; then
            # Empty
            echo $TRUE
        else
            # No empty
            echo $FALSE
        fi
    }

    # Check if is a number.
    #
    # 1: {*} Variable to check if is a number.
    # Out: {Boolean} TRUE if variable is a number.
    # Return: 0 if variable is a number, 1 if variable is not a number.
    function is_number() {
        if [[ "$1" =~ ^[0-9]+$ ]]; then
            echo $TRUE
            return 0
        else
            echo $FALSE
            return 1
        fi
    }

    # Check if function exists.
    #
    # 1: {String} Function name.
    # Out: {Boolean} TRUE if function exists.
    # Return: 0 if function exists, 0 if file not exists.
    function function_exists() {
        declare -f "$1" > /dev/null
        if [ $? -eq 0 ]; then
            echo $TRUE
            return 0
        else
            echo $FALSE
            return 1
        fi
    }

    # Print vars.
    #
    # *: Vars to print.
    function xdie() {
        echo
        echo "## XDIE ##"
        echo
        echo $@
        echo
        end 1
    }

### STRING

    # Escape string for Bash.
    #
    # *: {String} String to escape for Bash.
    # Out: {String} Escaped string.
    function str_escape() {
        printf '%q' "$@"
    }

    # Repeat string.
    #
    # 1: {Integer} Number of repetitions.
    # 2: {String} String to repeat.
    # Out: {String} Repeated string.
    function str_repeat() {
        let fillsize=$1
        local fill=$2
        while [ ${fillsize} -gt 1 ] ; do
            fill="${fill}$2"
            let fillsize=${fillsize}-1
        done
        echo $fill
    }

    # Replace string.
    #
    # 1: {String} String where replace.
    # 2: {String} Search string (REG EXP).
    # 3: {String} Replace.
    # 4: {Boolean} (Default: 1) 1 to ignore case.
    # Out: {String} Result string.
    function str_replace() {
        local options="g"
        if [ $# -lt 4 ] || [ "$4" -ne $TRUE ]; then
            options="${options}i"
        fi
        echo "$1" | sed "s/$2/$3/$options"
    }

    # Explode string into $RESULT as Array.
    #
    # 1: {String} Separator.
    # 2: {String} String to explode.
    # Result in $RESULT.
    # Return: Array length.
    # Use:
    #    str_explode ";" "bla@some.com bbb;john@home.com jjj"
    #    for i in ${RESULT[@]} ; do
    #        echo $i
    #    done
    function str_explode() {
        IFS="$1"
        RESULT=( $(echo "$2") )
        return ${#RESULT[@]}
    }

    # Trim text.
    #
    # 1: {String} String where trim.
    # 2: {String} (Default: " ") String to trim.
    # Out: {String} Trimed text.
    function trim() {
        local chr=" "
        if [ $# -gt 1 ]; then
            local chr="$2"
        fi
        echo "$1" | sed "s/^${chr}//g" | sed "s/${chr}$//g"
    }

    # Left trim text.
    #
    # 1: {String} String where trim.
    # 2: {String} (Default: " ") String to trim.
    # Out: {String} Trimed text.
    function ltrim() {
        local chr=" "
        if [ $# -gt 1 ]; then
            chr="$2"
        fi
        echo "$1" | sed "s/^${chr}//g"
    }

    # Right trim text.
    #
    # 1: {String} String where trim.
    # 2: {String} (Default: " ") String to trim.
    # Out: {String} Trimed text.
    function rtrim() {
        local chr=" "
        if [ $# -gt 1 ]; then
            chr="$2"
        fi
        echo "$1" | sed "s/${chr}$//g"
    }

    # String length.
    #
    # 1: {String} Text.
    # Out: {Integer} String length.
    function str_len() {
        echo ${#1}
    }

    # Sub string.
    # 1: {String} String to cut.
    # 2: {Integer} Limit.
    # 3: {Integer} (Optional) Offset.
    # Out: {String} Result string
    function sub_str() {
        if [ $# -eq 2 ]; then
            echo ${1:0:$2}
        else
            echo ${1:$3:$2}
        fi
    }

    # String position.
    #
    # 1: {String} String where search.
    # 2: {String} String to search.
    # 3: {Boolean} (Default: TRUE) TRUE for case sensitive.
    # Out: {Integer|NULL} String position or NULL if not found.
    # Return: 0 on fonud, 1 on not found.
    function str_pos() {
        if [ $# -lt 3 ] || [ $3 = $TRUE ]; then
            # Case sensitive
            local p="-bo"
        else
            # Case insensitive
            local p="-boi"
        fi
        local r=$(echo "$1" | grep $p "$2" | sed 's/:.*$//')
        echo $r
        if [ $(is_empty "$r") = $FALSE ]; then
            # Found
            return 0
        else
            # No found
            return 1
        fi
    }

    # String contains substring?
    #
    # 1: {String} String where search.
    # 2: {String} Substring to search.
    # 3: {Boolean} (Default: TRUE) TRUE for case sensitive.
    # Out: {Boolean} TRUE if contains substring.
    # Return: TRUE if contains substring.
    function in_str() {
        if [ $# -lt 3 ]; then
            str_pos "$1" "$2" > $DEV_NULL
            local r=$?
        else
            str_pos "$1" "$2" "$3" > $DEV_NULL
            local r=$?
        fi
        echo $r
        return $r
    }

### ERROR

    # Last execution returns > 0 (error)?
    #
    # 1: {String} Command to execute on error.
    # 2: {Integer} Change exit code.
    function check_error() {
        local c=$?
        if [ $c -ne 0 ]; then
            # Error
            $1
            if [ $# -gt 1 ]; then
                c=$2
            fi
            error "" $c
        fi
    }

    # Show error message and exit.
    #
    # 1: {String} Error message.
    # 2: {Integer} (Default: 1) Exit code.
    function error() {
        if ! [ -z "$1" ]; then
            e
            e "$(style color:red)Error! $1"
        fi
        e
        if [ $# -gt 1 ]; then
            end $2
        else
            end 1
        fi
    }

### UI

    # Screen width.
    #
    # Out: {Integer} Screen width.
    function screen_width() {
        check_requirements tput
        tput cols
    }

    # Change screen print style.
    #
    # *:
    # Out: {String} Style console string.
    # Example: e "normal color $(style color:red)text in red $(style color:black background:yellow)black color$(style) normal color"
    function style() {
        if [ $# -eq 0 ] || [ "$@" == "default" ]; then
            # Default color
            style color:${COLOR_DEFAULT}
        else
            local c=""
            for p in $@ ; do
                if [[ "$p" =~ ^\s*[a-zA-Z0-9]+\s*\[\=:\]\s*.+$ ]]; then
                    str_explode "[=:]" "$p"
                    local s="$(trim "${RESULT[0]}")"
                    local v="$(trim "${RESULT[1]}")"
                    case "$s" in
                        "color")
                            case "$v" in
                                "black")
                                    echo "\e[30m"
                                    ;;
                                "blue")
                                    echo "\e[34m"
                                    ;;
                                "blue-light")
                                    echo "\e[94m"
                                    ;;
                                "cyan")
                                    echo "\e[36m"
                                    ;;
                                "cyan-light")
                                    echo "\e[96m"
                                    ;;
                                "red")
                                    echo "\e[31m"
                                    ;;
                                "red-light")
                                    echo "\e[91m"
                                    ;;
                                "gray")
                                    echo "\e[90m"
                                    ;;
                                "gray-light")
                                    echo "\e[37m"
                                    ;;
                                "green")
                                    echo "\e[32m"
                                    ;;
                                "green-light")
                                    echo "\e[92m"
                                    ;;
                                "magenta" | "purple")
                                    echo "\e[35m"
                                    ;;
                                "magenta-light")
                                    echo "\e[95m"
                                    ;;
                                "purple-light")
                                    echo "\e[1;35m"
                                    ;;
                                "yellow" | "coffe")
                                    echo "\e[33m"
                                    ;;
                                "yellow-light")
                                    echo "\e[93m"
                                    ;;
                                "white")
                                    echo "\e[97m"
                                    ;;
                                [0-9]) # 0 - 255
                                    # Color
                                    echo "\e[38;5;${v}m"
                                    ;;
                                "default" | "normal")
                                    if [ "${COLOR_DEFAULT}" == "default" ] || [ "${COLOR_DEFAULT}" == "normal" ]; then
                                        style color:system
                                    else
                                        style color:${COLOR_DEFAULT}
                                    fi
                                    ;;
                                "system")
                                    echo "\e[0m"
                                    ;;
                            esac
                            ;;
                        "background")
                            case "$v" in
                                "black")
                                    echo "\e[40m"
                                    ;;
                                "blue")
                                    echo "\e[44m"
                                    ;;
                                "blue-light")
                                    echo "\e[104m"
                                    ;;
                                "cyan")
                                    echo "\e[46m"
                                    ;;
                                "cyan-light")
                                    echo "\e[106m"
                                    ;;
                                "gray")
                                    echo "\e[100m"
                                    ;;
                                "gray-light")
                                    echo "\e[47m"
                                    ;;
                                "green")
                                    echo "\e[42m"
                                    ;;
                                "green-light")
                                    echo "\e[102m"
                                    ;;
                                "magenta" | "purple")
                                    echo "\e[45m"
                                    ;;
                                "magenta-light")
                                    echo "\e[105m"
                                    ;;
                                "red")
                                    echo "\e[41m"
                                    ;;
                                "red-light")
                                    echo "\e[101m"
                                    ;;
                                "yellow" | "coffe")
                                    echo "\e[43m"
                                    ;;
                                "yellow-light")
                                    echo "\e[103m"
                                    ;;
                                "white")
                                    echo "\e[107m"
                                    ;;
                                [0-9]) # 0 - 255
                                    # Color
                                    echo "\e[48;5;${v}m"
                                    ;;
                                "system")
                                    echo "\e[49m"
                                    ;;
                            esac
                            ;;
                        "underline")
                            case "$v" in
                                "on" | "true" | "1" | "${TRUE}")
                                    echo "\e[4m"
                                    ;;
                                * | "off" | "false" | "0" | "${FALSE}")
                                    echo "\e[24m"
                                    ;;
                            esac
                            ;;
                        "bold")
                            case "$v" in
                                "on" | "true" | "1" | "${TRUE}")
                                    echo "\e[1m"
                                    ;;
                                "off" | "false" | "0" | "${FALSE}")
                                    echo "\e[21m"
                                    ;;
                            esac
                            ;;
                        "dim")
                            case "$v" in
                                "on" | "true" | "1" | "${TRUE}")
                                    echo "\e[2m"
                                    ;;
                                "off" | "false" | "0" | "${FALSE}")
                                    echo "\e[22m"
                                    ;;
                            esac
                            ;;
                        "blink")
                            # Parpadeo
                            case "$v" in
                                "on" | "true" | "1" | "${TRUE}")
                                    echo "\e[5m"
                                    ;;
                                "off" | "false" | "0" | "${FALSE}")
                                    echo "\e[25m"
                                    ;;
                            esac
                            ;;
                        "reverse" | "negative")
                            case "$v" in
                                "on" | "true" | "1" | "${TRUE}")
                                    echo "\e[7m"
                                    ;;
                                "off" | "false" | "0" | "${FALSE}")
                                    echo "\e[27m"
                                    ;;
                            esac
                            ;;
                        "display")
                            case "$v" in
                                "visible" | "show")
                                    echo "\e[28m"
                                    ;;
                                "hidden" | "none")
                                    echo "\e[8m"
                                    ;;
                            esac
                            ;;
                    esac
                else
                    case "$p" in
                        "reset")
                            # Reset all attributes
                            echo "\e[0m"
                            ;;
                        "bold")
                            echo "\e[1m"
                            ;;
                        "normal") # No bold
                            echo "\e[21m"
                            ;;
                        "dim")
                            echo "\e[2m"
                            ;;
                        "underline")
                            echo "\e[4m"
                            ;;
                        "blink")
                            # Parpadeo
                            echo "\e[5m"
                            ;;
                        "reverse" | "negative")
                            echo "\e[7m"
                            ;;
                        "hide" | "none")
                            echo "\e[8m"
                            ;;
                        "show" | "visible")
                            echo "\e[28m"
                            ;;
                    esac
                fi
            done
            echo "${c}"
        fi
    }

    # Print gradiant line.
    #
    # 1: {Integer} [0-255] From color.
    # 2: {Integer} [0-255] To color.
    # 3: {Char} (Default: #) Character to print.
    # Out: {String} Colorized line.
    function print_colorized_line_char() {
        # Char
        if [ $# -gt 2 ]; then
            local c="$3"
        else
            local c="#"
        fi
        # Print
        for i in {${1}..${2}} {${2}..${1}} ; do
            echo -en "$(style color:${i})${c}"
        done
        # Default
        style default
    }

    # Print gradiant line.
    #
    # 1: {Integer} [0-255] From color.
    # 2: {Integer} [0-255] To color.
    # 3: {Char} (Default: #) Character to print.
    # Out: {String} Colorized line.
    function print_colorized_line_background() {
        # Char
        if [ $# -gt 2 ]; then
            local c="$3"
        else
            local c="#"
        fi
        # Print
        for i in {${1}..${2}} {${2}..${1}} ; do
            echo -en "$(style background:${i})${c}"
        done
        # Default
        style default
    }

    # Print at screen.
    #
    # *: {String} Text to print.
    # Out: {String} Text.
    function e() {
        local c="$(style default)"
        echo -e "${c}${ECHO_CHAR} $@${c}"
    }

    # Re-print last line.
    #
    # 1: {Integer} (Default: 1) Lines to meve back. If is not a number, used as text.
    # *: {String} Text to print.
    # Out: {String} Text.
    function echo_back() {
        local n=1
        local text="$@"
        if [ $# -gt 1 ]; then
            if [ $(is_number "$1") = $TRUE ]; then
                n=$1
                text="${@:2}"
            fi
        fi
        local bl="\033[${n}A"
        echo -e "${bl}$(style default)${ECHO_CHAR} ${text}$(style system)" # Clear line
        str_repeat 80 ' '
    }

    # Pause.
    #
    # *: {String} (Optional) Message.
    function pause() {
        if [ $# -le 1 ]; then
            local m="Press any key to continue..."
        else
            local m="$@"
        fi
        e "$(style default)"
        read -n 1 -p "${ECHO_CHAR} ${m}"
        e
        e
    }

    # Set on-exit callback.
    #
    # *: Command to execute on APP exit.
    function set_on_exit() {
         _ON_EXIT="$@"
    }

    # Exit from APP and execute the function setted in "set_on_exit".
    #
    # 1: {Integer} (Default: 0) Exit code.
    function end() {
        if [ "$_APP_EXIT" == "$FALSE" ]; then
            if [ ! -z "$_ON_EXIT" ]; then
                $_ON_EXIT
            fi
            _APP_EXIT=$TRUE
            e $(style system)
            echo
            if [ $# -gt 1 ]; then
                exit $1
            else
                exit 0
            fi
        fi
    }
    # CTRL + C
    trap end EXIT

    # Time out.
    #
    # 1: {Integer} Time out for count down.
    # 2: {String} Command to execute on count down finish.
    # Return: {Integer} Return command exit code or "255" on user cancel.
    function timeout() {
        if [ $# -ne 2 ] || [ $(is_number "$1") -eq $FALSE ] || [ -z "$2" ]; then
            error "Invalid call 'timeout'" 70
        fi
        e
        local COUNT=$1
        local rta=0
        while [ ${COUNT} -gt 0 ] && [ ${rta} -eq 0 ] ; do
            echo_back "Count down [${COUNT}]... Press [C] or [ESC] to cancel..."
            read -n 1 -t 1 -p "" i
            local r=$?
            if [ "${i}" == "c" ] || [ "${i}" == "C" ] || [ "${i}" == "$KEY_ESC" ]; then
                rta=1
            else
                # 142 == No user input
                if [ "${r}" == "142" ]; then
                    let COUNT=COUNT-1
                fi
            fi
        done
        echo_back # Remove last line
        if [ ${COUNT} -eq 0 ]; then
            echo_back
            $2
            return $?
        else
            # Canceled
            echo_back "   Cancel by user!"
            e
            return 255
        fi
    }

    # Print command and their result.
    #
    # 1: {String} Command to print and execute.
    # Out: {String} Command executed and result.
    # Return: Executed command exit code.
    function cmd_log() {
        echo
        str_repeat 80 '-'
        $1
        local r=$?
        str_repeat 80 '-'
        return $r
    }

    # Print APP title and version.
    #
    # Out: APP title and version.
    function print_app_info() {
        echo "${APP_TITLE} v${APP_VERSION}"
    }

### DATE / TIME

    # Current time.
    #
    # Out: {String} Time.
    function now_time() {
        date '%H:%M:%S'
    }

    # Current date.
    #
    # Out: {String} Date.
    function now_date() {
        date '+%Y-%m-%d'
    }

    # Current date and time.
    #
    # Out: {String} Date and time.
    function now_date_time() {
        date '+%Y-%m-%d %H:%M:%S'
    }

### TAR

    # Compress file as .tar.gz.
    #
    # 1: {String} Input file.
    # 2: {String} Output file (.tar.gz).
    # Out: {String} Log output.
    function tar_compress() {
        tar zcvf "$2" "$1"
        return $?
    }

    # Extract .tar.gz file.
    #
    # 1: {String} Input file (.tar.gz).
    # 2: {String} Output path.
    # Out: {String} Log output.
    function tar_extract() {
        tar zxvf "$1" -C "$2"
        return $?
    }

### FILE / PATH

    # Check if file exists.
    #
    # 1: {String} File path.
    # Out: {Boolean} TRUE if file exists, 0 if not exists.
    # Return: 0 if file exists, 1 if not exists.
    function file_exists() {
        if [ -f "$1" ]; then
            # Exists
            echo $TRUE
            return 0
        else
            # Not exists
            echo $FALSE
            return 1
        fi
    }

    # Get file name.
    #
    # 1: {Boolean} (Default: FALSE) Remove file extension from file name?
    # Out: {String} File name.
    function file_name() {
        # Remove path
        local _fname="$(str_replace "${f}" "^.*\/" "")"
        if [ "$2" == "$TRUE" ]; then
            # Remove extension
            _fname="$(str_replace "${_fname}" "\..*$" "")"
        fi
        echo ${_fname}
    }

    # Current directory.
    #
    # Out: {String} Current directory.
    function current_directory() {
        dirname "$(readlink -f "$0")"
    }

    # Current script file name.
    #
    # Out: {String} Current script file name.
    function script_file_name() {
        basename "$0"
    }

    # Script full path.
    #
    # Out: {String} Current script full path.
    function script_full_path() {
        echo "$(current_directory)/$(script_file_name)"
    }

    # Check if directory exists.
    #
    # 1: {String} Directory path.
    # Out: {Boolean} TRUE if directory exists, FALSE if not exists.
    # Return: 0 if directory exists, 1 if not exists.
    function directory_exists() {
        if [ -d $(str_escape "$1") ]; then
            # Exists
            echo $TRUE
            return 0
        else
            # Not exists
            echo $FALSE
            return 1
        fi
    }

    # Wait for file exists.
    #
    # 1: {String} File path.
    # 2: {Integer} (Optional) Time out.
    # Return: 0 if file exists, 1 if file not exists (time-out).
    function wait_for_file_exists() {
        local p="..."
        local COUNT=0
        while [ ! -f "$1" ] ; do
            if [ $# -gt 1 ]; then
                if [ $2 -lt $COUNT ]; then
                    # Time out!
                    return 1
                else
                    let COUNT=COUNT+1
                fi
            fi
            echo_back "Waiting for '${1}'${p}"
            sleep 1
            if [ "${p}" == "..." ]; then
                p="."
            else
                p="${p}."
            fi
        done
        # Exists
        return 0
    }

    # Wait for directory exists.
    #
    # 1: {String} Directory path.
    # 2: {Integer} (Optional) Time out.
    # Return: 0 if file exists, 1 if file not exists (time-out).
    function wait_for_directory_exists() {
        local p="..."
        local COUNT=0
        while [ ! -d "$1" ] ; do
            if [ $# -gt 1 ]; then
                if [ $2 -gt $COUNT ]; then
                    # Time out!
                    return 1
                else
                    let COUNT=COUNT+1
                fi
            fi
            echo_back "Waiting for '${1}'${p}"
            sleep 1
            if [ "${p}" == "..." ]; then
                p="."
            else
                p="${p}."
            fi
        done
        # Exists
        return 0
    }

    # Check if file contains text.
    #
    # 1: {String} Text to search.
    # 2: {String} File where check.
    # Out: {Boolean} TRUE if file contains the text, FALSE if not contains the text.
    # Return: 0 if file contains the text, 1 if not contains the text.
    function file_contains() {
        grep -rils $(str_escape "$1") $(str_escape "$2") > /dev/null
        if [ $? -eq 1 ]; then
            # Not contains
            echo $FALSE
            return 1
        else
            # Contains
            echo $TRUE
            return 0
        fi
    }

### EXEC

    # VOID function.
    # Used in empty functions.
    function void() {
        echo 0 > $DEV_NULL
    }

    # Check if all parameters are installed.
    #
    # *: {String} Command to check.
    function check_requirements() {
        for req in $@ ; do
            hash "$req" 2>&-
            if [ $? == 1 ]; then
                error "Error! Please install '${req}' to continue."
            fi
        done
    }

    # Print basic usage.
    # Using "__" at begin of function name to set as argument method.
    # Put "#" before function to write extra help text.
    # Special chars: \n, \t (4 spaces)
    #
    # 1: {String} (Default: Current executed file) File to render usage.
    # 2: {String} (Optional) Action to show.
    # Out: {String} Usage text.
    # Use: usage "$0" actionName # For action in current file
    #      usage file.sh actionName # For action in other file
    function usage() {
        local src="$(script_full_path)"
        if [ $# -gt 0 ] && [ ! -z "$1" ]; then
            src="$1"
            if [ $(file_exists "${src}") == $FALSE ]; then
                src="$(script_full_path)"
            fi
        fi


        if [[ "${src}" =~ \/${XBASH_SRC_PATH}\/${ACTIONS_DIR}\/.+ ]]; then
            # Action file
            local cmd="$(file_name "${src}" $TRUE)"
            if [ $# -lt 2 ] || ([ $# -gt 1 ] && ([ -z "$2" ] || [ "$2" == "$cmd" ] || [ "$2" == "*" ])); then
                local info="$(grep "^#\{2\}[^#]" "${src}" | sed "s/^#\{2\}[^#]\s\?/$(str_escape "$(style default)")/g" | sed "s/^/$(str_escape "$(style default)")${ECHO_CHAR}     > /g" | sed "s/\t/    /g" | sed "s/^------------------/  -----  /g")"
                if [ ! -z "$info" ]; then
                    info="|||${info}"
                fi
                e "  bash $(style red)${0}$(style blue) ${cmd}$(style default)${info}" | sed "s/|||.\+${ECHO_CHAR}\s\+>\s/ /g"
                e
            fi
        else
            # USAGE before function
            grep "^\s*\(function\s\+\)\?__.\+()\s*{.*$" "${src}" | while read line ; do
                local cmd=$(echo "$line" | sed "s/()\s*{.*//g" | sed "s/\s*\(function\s\+\)\?__//g")
                if [ $# -lt 2 ] || ([ $# -gt 1 ] && ([ -z "$2" ] || [ "$2" == "$cmd" ] || [ "$2" == "*" ])); then
                    local info="$(grep -C0 -A0 -B1 "^\s*\(function\s\+\)\?__$cmd\s*()\s*{" "$src" | sed "N;s/\n.*//g" | sed "s/^\s*#\s*/$(str_escape "$(style default)")/g" | sed "s/\s*\\\n/\n$(str_escape "$(style default)")${ECHO_CHAR}     > /g" | sed "s/\\\t/    /g")"
                    e "  bash $(style red)${0}$(style blue) ${cmd}$(style default) ${info}"
                    e
                fi
            done
        fi
    }

    #time command\nPrint basic usage (this).\nAdd action name to display the action usage.
    function __usage() {
        e
        e "Usage:"
        e
        # Base file
        usage "$(script_file_name)" "$1"
        # Actions
        if [ -d "${ACTIONS_PATH}" ]; then
            for f in ${ACTIONS_PATH}/* ; do
                if [ -f "${f}" ]; then
                    usage "${f}" "$1"
                fi
            done
        fi
        # XBash
        if [ "$(script_file_name)" != "${XBASH_FILE_NAME}" ]; then
            usage "${XBASH_FILE_NAME}" "$1"
        fi
    }

    # Alias of "usage", with less.
    function __help() {
        check_requirements less
        __usage "$@" | less
    }

    # Run APP.
    # Run arguments as commands if any, or show "usage".
    #
    # See "usage" to see how to use.
    #
    # Use: At end of file, put next:
    #   run "$@"
    function run() {
        APPINFO=" $(print_app_info) "
        local APPINFOB="+-$(str_repeat $(str_len "${APPINFO}") "-")-+"
        local r=1
        echo
        e ${APPINFOB}
        e "| ${APPINFO} |"
        e ${APPINFOB}
        e
        # Check requeirements
        check_requirements "${APP_REQUEIREMENTS}"
        if [ $# -gt 0 ]; then
            if [ $(function_exists "__$1") == $TRUE ]; then
                # Exec
                if [ "$1" == "help" ]; then
                    ACTION="usage"
                else
                    ACTION="$1"
                fi
                __"$@"
                r=$?
            else
                error "Parameter '$(style color:blue)${1}$(style color:red)' not found. Call 'usage' to see help."
            fi
        fi
        if [ ${#1} == 0 ]; then
            if [ -z "${DEFAULT_ACTION}" ]; then
                # Show usage
                ACTION="usage"
                __usage
                r=1
            else
                # Call default action
                ACTION="$DEFAULT_ACTION"
                __${DEFAULT_ACTION}
            fi
        fi
        # Return result code
        end $r
    }

# #############################################################################
