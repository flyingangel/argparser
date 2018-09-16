#!/bin/bash

source argparser.sh

echo 'Test case: testFunc -h --params --longarg --longargvalue=someVal --longargspace="space & equal=xyz" simplearg "composite arg" -a -bc -D'
echo
echo 'parse_args "$@"'
echo

function testFunc {
    parse_args "$@"
    
    echo "\$longarg = $longarg"
    echo "\$longargvalue = $longargvalue"
    echo "\$longargspace = $longargspace"
    echo
    echo "\$opta = $opta"
    echo "\$optb = $optb"
    echo "\$optc = $optc"
    echo "\$optd = $optd"
    echo "\$optD = $optD"
    echo "\$optE = $optE"
    echo
    echo "\$argument1 = $argument1"
    echo "\$argument2 = $argument2"
    echo
    echo "Test mapping -h to --help"
    echo "\$opth = $opth"
    echo "\$help = $help"
    echo
    echo "Test mapping -p to --params"
    echo "\$optp = $optp"
    echo "\$params = $params"
    echo
    
    if $opta; then
        echo "-a activated"
    fi
    
    if $optb; then
        echo "-b activated"
    fi
    
    if $optc; then
        echo "-c activated"
    fi
    
    if $optd; then
        echo "-d activated"
    fi
    
    if [ "$optD" == true ]; then
        echo "-D activated"
    fi
}

declare -A ARGPARSER_MAP
ARGPARSER_MAP=(
    [h]=help
    [p]=params
)

testFunc -h --params --longarg --longargvalue=someVal --longargspace="space & equal=xyz" simplearg "composite arg" -a -bc -D