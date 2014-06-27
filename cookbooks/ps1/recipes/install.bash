#!/bin/bash

function install()
{
    local users="${@}"

    users+="$(whoami)"

    local user=''

    for user in ${users}
    do
        local profileFile="$(getProfileFile "${user}")"

        if [[ "$(isEmptyString "${profileFile}")" = 'false' ]]
        then
            if [[ "$(whoami)" = "${user}" ]]
            then
                local prompt="export PS1=\"${ps1RootPrompt}\""
            else
                local prompt="export PS1=\"${ps1UserPrompt}\""
            fi

            echo -e "Updating '\033[1;32m${profileFile}\033[0m'"

            touch "${profileFile}"
            appendToFileIfNotFound "${profileFile}" "${prompt}" "${prompt}" 'false' 'false'
        else
            warn "WARN: home directory of user '${user}' not found!"
        fi
    done
}

function main()
{
    local appPath="$(cd "$(dirname "${0}")" && pwd)"

    source "${appPath}/../../../lib/util.bash" || exit 1
    source "${appPath}/../attributes/default.bash" || exit 1

    checkRequireDistributor

    header 'INSTALLING PS1'

    checkRequireRootUser

    install "${@}"
    installCleanUp
}

main "${@}"