#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Deploys sample to LightSail II
#
# rsync-destination must be defined in a .rsync-file for each sample
# -----------------------------------------------------------------------------

# Vars die in .bashrc gesetzt werden. ~ (DEV_DOCKER, DEV_SEC, DEV_LOCAL) ~~~~~~
# [] müssen entfernt werden (IJ Bug https://goo.gl/WJQGMa)
if [[ -z ${DEV_BASH+set} ]]; then echo "Var 'DEV_DOCKER' nicht gesetzt!"; exit 1; fi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Abbruch bei Problemen (https://goo.gl/hEEJCj)
#
# Wenn ein Fehler nicht automatisch zu einem exit führen soll dann
# kann 'command || true' verwendet werden
#
# Für die $1, $2 Abfragen kann 'CMDLINE=${1:-}' verwendet werden
#
# -e Any subsequent(*) commands which fail will cause the shell script to exit immediately
# -o pipefail sets the exit code of a pipeline to that of the rightmost command
# -u treat unset variables as an error and exit
# -x print each command before executing it
set -eou pipefail

APPNAME="`basename $0`"

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname ${SCRIPT}`

#------------------------------------------------------------------------------
# Einbinden der globalen Build-Lib
#   Hier sind z.B. Farben, generell globale VARs und Funktionen definiert
#

SAMPLES_LIB="samples.lib.sh"
. "${DEV_BASH}/${SAMPLES_LIB}"

#------------------------------------------------------------------------------
# Config

#------------------------------------------------------------------------------
# Functions
#

#------------------------------------------------------------------------------
# Options
#

usage() {
    echo
    echo "Usage: ${APPNAME} [ options ]"
    echo
    echo -e "\t${YELLOW}[ Status ─────────────────────────────────────────────────────────── ]${NC}"
    echo -e "\t-l | --list                             Lists all examples"
    echo -e "\t                                        from '${YELLOW}${EXAMPLE_FOLDER}'${NC}-folder"
    echo -e "\t     --urls                             Lists url's"
    echo -e "\t     --urls-readme                      List url's in MD-Format"
    echo
    echo -e "\t${YELLOW}[ Day2Day ─────────────────────────────────────────────────────────── ]${NC}"
    echo -e "\t-u | --update                           Updates the sample"
    echo -e "\t-d | --deploy  [--release|dev]          Creates 'deploy'-dir for Dart"
    echo -e "\t-p | --publish [--force]                Publish samples to AWS/S3"
    echo -e "\t                                        (only on day ${PUBLISH_ONLY_ON_DAY})"
    echo -e "\t                                        use --force to ignore"
    echo -e "\t                                        Monday as publishing day"
}

CMDLINE=${1:-}
OPTION1=${2:-}
OPTION2=${3:-}

# Per default sollten die Beispiele in 'examples' sein
EXAMPLE_FOLDER="."
declare -a EXAMPLES=( "." )

case "${CMDLINE}" in
    -l|list|-list|--list)
        listSamples "${EXAMPLES[@]}"
    ;;

    --urls)
        echo ".rsync" | xargs awk 'FNR==4' | cut -d ' ' -f 5- | sed -e "s/.*http:\/\/\([^/]*\)\/.*/http:\/\/\1/"
    ;;

    --urls-readme)
        echo ".rsync" | xargs awk 'FNR==14' | cut -d ' ' -f 5- | sed -e "s/.*http:\/\/\([^/]*\)\/.*/- \[\1\]\(http:\/\/\1\)/"
    ;;

    -u|update|-update|--update)
       updateSamples "${EXAMPLES[@]}"
    ;;

    -d|deploy|-deploy|--deploy)
       deploySamples "${EXAMPLES[@]}"
    ;;

    -p|publish|-publish|--publish)
        publishSamples "${EXAMPLES[@]}"
    ;;

    -h|-help|--help|*)
        usage
    ;;

esac

#------------------------------------------------------------------------------
# Alles OK...

exit 0
