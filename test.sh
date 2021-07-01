#!/bin/bash

source argparser.sh

echo "Test case:"
# shellcheck disable=SC1004
echo 'testFunc -h \
	--params \
	--longarg \
	--longarg_underscore \
	--longargvalue=someVal \
	--longargspace="space & equal=xyz" \
	--longargfollow "value which follows" \
	--longarg-dash \
	--longarg-dash-value="dash value" \
	--longarg-dash-follow "dash follow" \
	simplearg "composite arg" \
	-a -bc -D'
echo
echo 'parse_args "$@"'
echo

# shellcheck disable=SC2154
function testFunc() {
	parse_args "$@"

	echo "\$longarg = $longarg"
	echo "\$longarg_underscore = $longarg_underscore"
	echo "\$longargvalue = $longargvalue"
	echo "\$longargspace = $longargspace"
	echo "\$longargfollow = $longargfollow"
	echo "\$longargDash = $longargDash"
	echo "\$longargDashValue = $longargDashValue"
	echo "\$longargDashFollow = $longargDashFollow"
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
	echo "Test mapping --params to -p"
	echo "\$optp = $optp"
	echo "\$params = $params"
	echo

	#Check method 1 : if true without bracket
	if $opta; then
		echo "-a activated"
	fi

	#Check method 2 : linear logic
	$optb && echo "-b activated"
	! $optx && echo "-x not activated"

	#Chech method 3 : linear bracket
	[[ $optc ]] && echo "-c activated"
	[[ ! $optc ]] && echo "-c not activated"

	#Combine logic
	$optb && $optc && echo "-bc activated"

	#Inversion check : if ! $optd; then
	$optd || echo "-d not activated"

	#Check method 4 : traditional explicit
	if [ "$optD" == true ]; then
		echo "-D activated"
	fi
}

declare -A ARGPARSER_MAP
ARGPARSER_MAP=(
	[h]=help
	[p]=params
)

testFunc -h \
	--params \
	--longarg \
	--longarg_underscore \
	--longargvalue=someVal \
	--longargspace="space & equal=xyz" \
	--longargfollow "value which follows" \
	--longarg-dash \
	--longarg-dash-value="dash value" \
	--longarg-dash-follow "dash follow" \
	simplearg \
	"composite arg" \
	-a -bc -D
