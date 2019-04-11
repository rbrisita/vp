#!/usr/bin/env bash

#####################################################################
#
# A composite script to expose virtualenv and pip functionality.
# For developers who want project reproducibility with no need to
# switch out Python interpreter or libraries.
# Exposes a similar worklfow as npm and composer.
#
# Dependency on virtualenv; Installation checked and attempted.
# All OSes have python natively installed which also includes pip.
# Tested on MAC OS X 10.13.6 and bash shell v3.2.57.
#
# @note Copy file into an exectuable path.
#
# @version 0.1
# @date 2019-01-31T2200Z
# @author Robert Brisita <[first-initial][last name] at gmail dot com>
#
#####################################################################

VP_VERSION='0.1'
VP_ENV_DIR='.virtualenv'
VP_REQ_FILE='requirements.txt'
VP_SUBSHELL=0

###
# Enter virtual environment.
###
enter () {
    # First check if virtual environment is created.
    if ! create ""; then
        return $?
    fi

    # In virtual environment already?
    # VIRTUAL_ENV created when 'activate' is sourced.
    if [ -z "${VIRTUAL_ENV}" ]; then
        # shellcheck disable=SC1090
        source "${VP_ENV_DIR}/bin/activate"
        # shellcheck disable=SC2046
        PS1="[(${VP_ENV_DIR}) \\u@\\h $(basename $(pwd))]> "
        VP_SUBSHELL=1
    fi

    return 0
}

###
# Create virtual environment.
###
create () {
    # Check if virtualenv is installed.
    if ! command -v virtualenv >/dev/null 2>&1; then
        pip install virtualenv
    fi

    if [ -d "${VP_ENV_DIR}" ] || [ -L "${VP_ENV_DIR}" ]; then
        echo "${VP_ENV_DIR} exists."
        return 0
    fi

    # Check if any other arguments were passed.
    local args
    if [ -n "${*}" ]; then
        args=("${@}" "${VP_ENV_DIR}")
    else
        args=("${VP_ENV_DIR}")
    fi

    if virtualenv "${args[@]}"; then
        return $?
    fi

    if [ -r .gitignore ]; then
        echo "${VP_ENV_DIR}/" >> .gitignore
        echo "Added '${VP_ENV_DIR}' name to .gitignore."
    fi

    return 0
}

###
# Delete virtual environment.
###
delete () {
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo "Please exit out of virtual environment subshell with 'exit' before deleting it."
        return 1
    fi

    if [ -d "${VP_ENV_DIR}" ] && [ ! -L "${VP_ENV_DIR}" ]; then
        rm -rf "${VP_ENV_DIR}"
        echo "Deleted virtual environment folder: ${VP_ENV_DIR}"
    else
        echo "No ${VP_ENV_DIR} to delete."
    fi

    if [ -r .gitignore ]; then
        sed -i "" "N;s%${VP_ENV_DIR}/\\n*%%g" .gitignore
        echo "Deleted '${VP_ENV_DIR}/' name from .gitignore."
    fi

    return 0
}

###
# Install package into virtual environment
# and update requirements.txt file.
###
install () {
    if ! enter; then
        return $?
    fi

    if pip install "${@}"; then
        pip freeze > "${VP_REQ_FILE}"
        echo "Updated '${VP_REQ_FILE}'."
    fi

    return $?
}

###
# Uninstall package from virtual environment
# and update requirements.txt file.
###
uninstall () {
    if ! enter; then
        return $?
    fi

    if pip uninstall "${@}"; then
        pip freeze > "${VP_REQ_FILE}"
        echo "Updated '${VP_REQ_FILE}'."
    fi

    return $?
}

###
# Handle command line.
###
CMD=${1:-h}

case "${CMD}" in
    -\?|-h|--help|\?|h|help )
        echo "Version: ${VP_VERSION}"
        echo
        echo "Usage:"
        echo -e "\\tvp <command>"
        echo "Commands:"
        echo -e "\\t-?, -h, --help"
        echo -e "\\t?, h, help\\t\\tDisplay this help message."
        echo -e "\\tcreate [args]\\t\\tCreate virtual environment."
        echo -e "\\tdelete\\t\\t\\tDelete virtual environment."
        echo -e "\\tenter\\t\\t\\tEnter virtual environment to start working."
        echo -e "\\tinstall [pkg]\\t\\tInstall package and update requirements.txt file."
        echo -e "\\tuninstall [pkg]\\t\\tUninstall package and update requirements.txt file."
        echo
        echo "Notes:"
        echo "To exit out of virtual environment subshell type: exit"
        echo "Any arguments for the create command are passed to virtualenv."
        echo "Any commands not on the list (other than create) are passed to pip."
    ;;
    create|delete|enter|install|uninstall )
        shift

        ${CMD} "${@}"

        if [ "${VP_SUBSHELL}" -eq 1 ]; then
            bash
        fi
    ;;
    * )
        pip "${@}"
    ;;
esac
