#! /bin/bash -e

    export scriptName=`basename "${0}"`;
    export appDir="$(pwd)";
    export cliArgs=( "${@}" );
    export serverAction="${cliArgs[0]}";
    export serverEnvironment="${cliArgs[1]}";
    if [ -z "${serverEnvironment}" ];
    then
        export serverEnvironment="development";
    fi;
    export prerequisites=(
        "g++"
        "gcc"
        "cron"
        "curl"
        "make"
        "wget"
        "tar"
        "tzdata"
        "bzip2"
        "nano"
        "automake"
        "apt-utils"
        "coreutils"
        "apt-transport-https"
        "dpkg"
        "aptitude"
        "screen"
        "libtool"
        "bison"
        "perl"
        "perl-base"
        "build-essential"
        "software-properties-common"
    );
    export dependencies=(
        "libgdbm-dev"
        "libncurses5-dev"
        "libssl-dev"
        "libreadline-dev"
        "libyaml-dev"
        "libsqlite3-dev"
        "libxml2-dev"
        "libxslt1-dev"
        "libcurl4-openssl-dev"
        "libarchive-zip-perl"
        "libbz2-dev"
        "libffi-dev"
        "libc-dev-bin"
        "libc6-dev"
        "libcurl3-gnutls"
        "libgcrypt20"
        "libkeyutils1"
        "libmysqlclient-dev"
        "libmysqld-dev"
        ### "libicu55"
        "libc-ares2"
        "libv8-3.14.5"
        "libssl1.0.0"
        "libstdc++6"
        "zlib1g-dev"
        "diffutils"
        "imagemagick"
        ### "qrencode"
        "javascript-common"
        "openssl"
        "openssh-client"
        "openssh-server"
        "sqlite3"
        "xml-core"
        "mariadb-common"
        ### "mariadb-server"
        "git-core"
        ### "yarn"
        "nodejs"
    );
    export railsreq=(
        "mime-support"
        "bundler"
        "ruby-full"
        "ruby-rails"
        "ruby-rails-admin"
        "rubygems-integration"
    );

    function helpText()
    {
        echo "";
        echo "USAGE: ./${scriptName} [help|install|force-install|update|start|debug|stop|clear]";
        echo "";
        echo "    help            -   shows the help message";
        echo "    install         -   prepares server installation, only installs missing modules (work in progress)";
        echo "    force-install   -   prepares server installation, forcing updates of existing modules (work in progress)";
        echo "    update          -   updates server app dependencies (gems)";
        echo "    start           -   starts the server in the background with no stdout";
        echo "    debug           -   starts the server in debug mode, with verbose stdout";
        echo "    restart         -   restarts the server in the background with no stdout";
        echo "    stop            -   kills all associated pids";
        echo "    clear           -   clears app cache";
        echo "";
        echo "Code Machine Script has been written for use on minimal Debian systems, such as TurnKey.";
        echo "If errors are encountered when installing modules, use aptitude to resolve dependency conflicts.";
        echo "ie, sudo aptitude install nodejs;";
        echo "";
        return;
    }
    function installPrep()
    {
        export method="${1}";
        export toinstall=();
        echo "Starting installation...";
        echo "WORK IN PROGRESS!";
        installList "${prerequisites[@]}";
        addKey "https://dl.yarnpkg.com/debian/pubkey.gpg";
        addRepo "deb http://gb.archive.ubuntu.com/ubuntu/ xenial universe";
        addRepo "deb https://dl.yarnpkg.com/debian/ stable main";
        installList "${dependencies[@]}";
        ### installList "${railsreq[@]}";
        installRubyRails;
        bundle install;
        bundle update;
        echo "Finished installation!";
        return;
    }
    function installRubyRails()
    {
        ### makeInstall "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz";
        makeInstall "http://ftp.ruby-lang.org/pub/ruby/2.5/ruby-2.5.3.tar.gz";
        sudo gem install bundler;
        sudo gem install rails;
        cd "${appDir}";
        return;
    }
    function makeInstall()
    {
        export installURL="${1}";
        if [ ! -z "$(echo "${installURL}" | grep -Pi "^.*\.tar\.gz$")" ];
        then
            export pkgName="$(echo "${installURL}" | perl -pe "s/^.*\/(.*)\.tar\.gz$/\1/gim";)";
            cd ~;
            wget -O "${pkgName}.tar.gz" "${installURL}";
            tar -xzvf "${pkgName}.tar.gz";
            cd "${pkgName}";
            ./configure;
            sudo make;
            sudo make install;
            cd ~;
            sudo rm -rf "${pkgName}"*;
        else
            echo "Not a valid installation package!";
        fi;
        cd "${appDir}";
        return;
    }
    function addKey()
    {
        thisKey="${1}";
        curl -sS "${thisKey}" | sudo apt-key add -
        return;
    }
    function addRepo()
    {
        insertRepo="${1}";
        if [ -z "$(cat /etc/apt/sources.list | grep -Pi "${insertRepo}";)" ];
        then
            sudo add-apt-repository "${insertRepo}";
        fi;
        return;
    }
    function installList()
    {
        installList=( "${@}" );
        export toinstall=( $(checkInstalled "${installList[@]}") );
        if [ "${#toinstall[@]}" != "0" ];
        then
            sudo apt-get update -y;
            sudo apt-get install -yf ${toinstall[*]};
            sudo apt-get autoremove -yf;
        fi;
        return;
    }
    function checkInstalled()
    {
        export toinstall=();
        export checklist=( "${@}" );
        export installed="$(sudo apt list --installed;)";
        for require in "${checklist[@]}";
        do
            if ( [ -z "$(echo "${installed}" | grep -Pi "${require}";)" ] && [ ! -z "$(echo "${method}" | grep -Pi "normal";)" ] );
            then
                toinstall+=( "${require}" );
            elif ( [ ! -z "$(echo "${method}" | grep -Pi "force";)" ] );
            then
                toinstall+=( "${require}" );
            fi;
        done;
        echo "${toinstall[@]}";
        return;
    }
    function startApp()
    {
        appmode="${1}";
        if [ "${appmode}" == "start" ];
        then
            sudo rails server -b "$(hostname -I | awk '{print $1}';)" -p 80 > /dev/null 2>&1 &
            sudo ps -aux | grep -Pi "([r]ails|[p]uma|[u]nicorn|[s]idekiq)" | awk '{print $2}' | sudo xargs -i bash -c 'appname="$(cat /proc/${0}/cmdline | perl -pe "s/^.*\/([a-zA-Z].*)$/\1\n/gim";)"; echo "${appname} (pid: ${0}) Started";' "{}";
        elif [ "${appmode}" == "debug" ];
        then
            sudo rails server -b "$(hostname -I | awk '{print $1}';)" -p 80;
        else
            echo "Unknown mode... exiting!";
        fi;
        return;
    }
    function killApp()
    {
        sudo ps -aux | grep -Pi "([r]ails|[p]uma|[u]nicorn|[s]idekiq)" | awk '{print $2}' | sudo xargs -i bash -c 'appname="$(cat /proc/${0}/cmdline | perl -pe "s/^.*\/([a-zA-Z].*)$/\1\n/gim";)"; sudo kill -9 ${0}; echo "${appname} (pid: ${0}) Killed";' "{}";
        clearAppCache;
        return;
    }
    function updateApp()
    {
        bundle install;
        bundle update;
        echo "Finished.";
        return;
    }
    function clearAppCache()
    {
        sudo rake assets:clean;
        sudo rake tmp:cache:clear;
        return;
    }

    if [ "${serverAction}" == "install" ];
    then
        installPrep "normal";
    elif [ "${serverAction}" == "force-install" ];
    then
        installPrep "force";
    elif [ "${serverAction}" == "update" ];
    then
        updateApp;
    elif [ "${serverAction}" == "clear" ];
    then
        clearAppCache;
        echo "cleared app cache";
    elif [ "${serverAction}" == "start" ];
    then
        clearAppCache;
        startApp "start";
    elif [ "${serverAction}" == "debug" ];
    then
        clearAppCache;
        startApp "debug";
    elif [ "${serverAction}" == "restart" ];
    then
        killApp;
        clearAppCache;
        startApp "start";
    elif [ "${serverAction}" == "stop" ];
    then
        killApp;
    else
        helpText;
    fi;

exit 0