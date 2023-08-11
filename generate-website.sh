#!/bin/bash
# ==============================================================================
#
#          FILE: generate-website.sh
#
#         USAGE: ./generate-website.sh TARGET REPO [DOMAIN]
#
#   DESCRIPTION: This script is executed by the github action to generate a
#                website from the latex templates.
#
#       OPTIONS: TARGET   target directory
#                REPO     name of remote repository, 'user/reponame'
#                DOMAIN   github custom domain (optional)
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Fabian Eberts
#  ORGANIZATION: ---
#       CREATED: ---
#      REVISION: ---
#
# ==============================================================================

function fatal
{
    printf "$0: error: $1\n"
    exit 1
}

function debug
{
    printf "$1\n"
    return
}

# ------------------------------------------------------------------------------
#  arguments
# ------------------------------------------------------------------------------

TARGET="$1"/ # remote repo root directory
REPO="$2"    # name of remote repository
DOMAIN="$3"  # github pages custom domain (optional)

DOCS="$TARGET"/docs/ # html document root
TEMPLATES=templates/ # local latex templates
WEB=web/             # local website template

[ $# -lt 2 ] && fatal "too few arguments"

# rm -rf "$TARGET" &>/dev/null; mkdir "$TARGET" # for local debugging only! TODO entfernen

# ------------------------------------------------------------------------------
#  generate website
# ------------------------------------------------------------------------------

function add_to_config
{
    printf "$1" >> "$DOCS"/"$template_name"/config.js
}

function add_to_readme
{
    printf "$1" >> "$TARGET"/README.md
}

function strip_parent_directory
{
    printf "${1##*/}"
}

# copy latex templates to html document root:
mkdir "$DOCS"
cp -r "$TEMPLATES"/* "$DOCS"/

# create readme:
add_to_readme "# LaTeX-Vorlagen\n\n"
URL="$(echo "$REPO" | sed 's/\//.github.io\//g')"

# generate website for each latex template:
for template_dir in "$TEMPLATES"/*/ # only directories
do
    debug "Directory: '$template_dir'"

    # ---------- write configuration file ----------

    # template name:
    template_name="${template_dir%/}" # strip trailing slash
    template_name="$(strip_parent_directory "$template_name")"
    debug "    Template name: '$template_name'"
    add_to_config 'const template_name = "'"$template_name"'";'"\n"

    # main tex file (contains '\documentclass'):
    main_tex_file="$(grep -rl --fixed-strings '\documentclass' "$template_dir")"
    main_tex_file="$(strip_parent_directory "$main_tex_file")"
    debug "    Main tex file: '$main_tex_file'"
    add_to_config 'const main_tex_file = "'"$main_tex_file"'";'"\n"

    # project files:
    add_to_config 'const files = ['
    debug "    Project files:"

    for file in "$template_dir"*.* # only files
    do
        file_name="$(strip_parent_directory "$file")"
        debug "        '$file_name'"
        add_to_config '"'"$file_name"'",'
    done

    add_to_config "];\n"

    # placeholders:
    placeholders=($(grep -E --only-matching "{{[^{}]+}}" "$template_dir"/"$main_tex_file" | sed 's/[{}]//g'))
    add_to_config 'const placeholders = ['
    debug "    Placeholders: "

    for placeholder in "${placeholders[@]}"
    do
        add_to_config '"'"$placeholder"'",'
        debug "        '$placeholder'"
    done

    add_to_config "];\n"

    # ---------- copy website files ----------

    cp -r "$WEB"/* "$DOCS"/"$template_name"/

    # ---------- add markdown link to readme ----------

    TEMPLATE_URL="$(echo "$URL"/"$template_name")"
    debug "    Link: $TEMPLATE_URL"
    add_to_readme "* ${template_name}: [${TEMPLATE_URL}](http://${TEMPLATE_URL})\n"
done

# ------------------------------------------------------------------------------
#  create CNAME file
# ------------------------------------------------------------------------------

if [ -n "$DOMAIN" ]
then
    echo -n "$DOMAIN" > "$DOCS"/CNAME
fi
