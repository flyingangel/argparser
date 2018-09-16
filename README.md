# Command-line arguments parser

The script extract arguments from the arguments of the **script or function** and auto-wire to shell variable

## How to use

Example
> testFunc -h --params --longarg --longargvalue=someVal --longargspace="space & equal=xyz" simplearg "composite arg" -a -bc -D

Inside this script/function, simply call
```bash
#make sure to include the function
source argparser.sh
parse_args "$@"
```

Now variables will be pre-populated within the environment

```bash
$longarg = true
$longargvalue = someVal
$longargspace = space & equal=xyz

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
```

All long opts will wire to the same variable name ie `--help` will populate `$help`  
All short opts will wire to variable with prefix **opt[letter]** ie `-h` will populate `$opth`  
All arguments will wire to variable with prefix **argument[number]** ie `$argument1, $argument2 ..`

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
