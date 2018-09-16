#!/bin/bash
# Argument parse

function parse_args {
    local _i count=0
    
    #scope only func
    #parse long args
    function parse_long {
        local _arg _name _value _i
        
        #strip --
        _arg=${1#--}
        #strip after =
        _name="${_arg%%=*}"
        #if arg contains =
        if [[ $_arg = *=* ]]; then
            #strip before =
            _value="${_arg#*=}"
        else
            _value=true
        fi
        
        eval $_name="\$_value"
        
        #set short if mapping is defined
        if [[ "${ARGPARSER_MAP[@]}" =~ "$_name" ]]; then
            for _i in "${!ARGPARSER_MAP[@]}"; do
                if [ ${ARGPARSER_MAP[${_i}]} == "$_name" ]; then
                    _name=$ARGPARSER_SHORT_PREFIX$_i
                    eval $_name=true
                fi
            done
        fi
    }
    
    #parse short args
    function parse_short {
        local _i _arg _name _letter
        
        #strip -
        _arg=${1#-}
        
        #for each char
        for _i in $(seq 1 ${#_arg}); do
            _letter=${_arg:_i-1:1}
            _name=$ARGPARSER_SHORT_PREFIX$_letter
            eval $_name=true
            
            #set long if mapping is defined
            if [ ${ARGPARSER_MAP[${_letter}]} ]; then
                _name=${ARGPARSER_MAP[${_letter}]}
                eval $_name=true
            fi
        done
    }
    
    #parse argument
    function parse_argument {
        local _name _value
        
        _name="$ARGPARSER_ARGUMENT_PREFIX$count"
        _value=$1
        
        eval $_name=\$_value
    }
    
    #default short prefix if not configured
    if [ -z "$ARGPARSER_SHORT_PREFIX" ]; then
        ARGPARSER_SHORT_PREFIX="opt"
    fi
    
    #default argument prefix if not configured
    if [ -z "$ARGPARSER_ARGUMENT_PREFIX" ]; then
        ARGPARSER_ARGUMENT_PREFIX="argument"
    fi
    
    #init all short opt to false
    for _i in {{a..z},{A..Z}}; do
        _name=$ARGPARSER_SHORT_PREFIX$_i
        eval $_name=false
    done
    
    #analyze args
    for _i in "$@"
    do
        case $_i in
            --* ) parse_long "$_i"; shift;;
            -* ) parse_short "$_i"; shift;;
            *) ((count++)); parse_argument "$_i"; shift;;
        esac
    done
}
