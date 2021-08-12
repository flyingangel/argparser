# Command-line arguments parser

The script extract arguments from the arguments of the **script or function** and _auto-wire_ to shell variables

Advantages over the traditional `getopts` :
* less code to write thus boost development speed
* variables are auto-populated so no manual assignment needed
* every option has the visibility of other options so it's easier to do a combination ie `if -a and -b activated, then read --longarg`
* options and order agnostic, can easily be used in any script without the need to declare `:a:b::cd`; it parses everything the user put into arguments (even garbages)
* can be applied to top-level script, functions or even pure string

## How to use

Include this library to your project using git submodule

    git submodule add https://github.com/flyingangel/argparser.git shell_modules/argparser

Inside your script or even a function, simply call

```bash
#make sure to include the script once then call parse_args
source argparser.sh
parse_args "$@"
```

## Example

```bash
testCommand -h \
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
    -a -bc -D
```

Then at the beginning of your script or function

```bash
parse_args "$@"

#Now variables will be pre-populated within the environment with the following values
$longarg = true
$longarg_underscore = true
$longargvalue = someVal
$longargspace = space & equal=xyz
$longargfollow = value which follows
$longargDash = true
$longargDashValue = dash value
$longargDashFollow = dash follow

$opta = true
$optb = true
$optc = true
$optd = false
$optD = true
$optE = false

$argument1 = simplearg
$argument2 = composite arg

#map -h to --help
$opth = true
$help = true

#map -p to --params
$optp = true
$params = true

#boolean opt can now easily be tested with
if $opta; then do_smt fi
if [ $optb == true ]; then do_smt fi
[[ $optc ]] && do_case_active
[[ ! $optd ]] && do_case_inactive
$optd || do_case_inactive
[[ $opta && $optb ]] && do_case_both_combine
```

All long opts will wire to the same variable name ie `--help` will populate `$help`  
All short opts will wire to variable with prefix **opt[letter]** i.e `-h` will populate `$opth`  
All arguments will wire to variable with prefix **argument[number]** i.e `$argument1, $argument2 ..`

## Config

Define options mapping by configuring `$ARGPARSER_MAP`. Ex when we want to consider `-h` is the same as `--help`

```bash
declare -A ARGPARSER_MAP
ARGPARSER_MAP=(
    [h]=help
    [p]=params
)
```

Change short opt or argument prefix

```bash
#default
ARGPARSER_SHORT_PREFIX="opt"
ARGPARSER_ARGUMENT_PREFIX="argument"
```
