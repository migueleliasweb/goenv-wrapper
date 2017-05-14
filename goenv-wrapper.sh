#!/usr/bin/env bash

GOROOT="/usr/local/go/bin/go"
DEFAULT_CONFIG_PATH="`pwd`/goenv.sh"

function yesno {
    read -e -p "${1} Yes/[No]: " -i "Yes" yesno
    if [ "${yesno}" != 'n' ] && [ "${yesno}" != ' ' ] && [ "${yesno}" != ' ' ] && [ "${yesno}" != 'No' ] && [ "${yesno}" != 'no' ]; then
        echo 'Answered: Yes'
        $2
    else
        echo 'Answered: No'
        $3
    fi
}

function ensure_trailling_slash () {
    if [ ${1: -1} != '/' ]; then
        return ${1}/
    else
        return $1
    fi
}

function setup_goroot () {
    read -e -p "GOROOT:" GOROOT
}

function setup_gopath () {
    read -e -p "GOPATH:" -i `pwd` GOPATH
}

function setup_configuration () {
    read -e -p "Write configuration to \"${DEFAULT_CONFIG_PATH}\" ? " -e ${DEFAULT_CONFIG_PATH} config_path
    touch config_path
    echo "#!/usr/bin/env bash" >> config_path
    echo "" >> config_path
    echo 'export GOROOT="${GOROOT}"' > config_path
    echo 'export GOPATH="${GOPATH}"' > config_path
    echo 'export PATH="$PATH:${GOROOT}bin/"' > config_path

    echo "Activating configuration..."
    chmod 755 config_path
    source config_path

    echo "Next time use 'source ${config_path}' to activate!"
}

function flee {
    echo "Exiting..."
    exit 0
}

function run {
    if [[ -d "${GOROOT}" ]]; then
        echo -n "Found a Go installation at ${GOROOT}! "
    else
        echo -n "GOROOT not found in ${GOROOT}. "
    fi

    yesno "Want to setup a new location for Go ?" setup_goroot flee

    if [[ -d "${GOPATH}" ]]; then
        echo -n "GOPATH is set to ${GOPATH}. "
    else
        echo -n "GOPATH not set. "
    fi

    yesno "Want to change the GOPATH ?" setup_gopath flee

    yesno "Write configuration?" setup_configuration flee
}

run
