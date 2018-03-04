# this is adopted from the oh-my-zsh install script

main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
  fi

  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  if [ "$EUID" -ne 0 ]
    then echo "Please run as ${RED}root${NORMAL}"
    exit 1
  fi

  locale-gen --purge en_US.UTF-8
  echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

  export LC_ALL=C

  BW=/bellwether
  printf "${YELLOW}This is the automatic and guided installation. ${NORMAL}\n"
  printf "${RED}You still need to install a webserver of your choosing and provide a mysql server. ${NORMAL}\n\n"
  printf "Everything will be configured by itelf.\n"
  printf "The configured installation path used will be ${GREEN}${BW}${NORMAL}\n"

  while true; do
    read -p "Do you want to define a custom path? ${GREEN}(y)${NORMAL}es or ${RED}(n)${NORMAL}o: " yn
    case $yn in
        [Yy]* ) read -p "Where should bellwether be installed? " BW; break;;
        [Nn]* ) break;;
        * ) echo "Please answer with the answers provided.";;
    esac
  done

  # # Prevent the cloned repository from having insecure permissions. Failing to do
  # # so causes compinit() calls to fail with "command not found: compdef" errors
  # # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # # that this will be ignored under Cygwin by default, as Windows ACLs take
  # # precedence over umasks except for filesystems mounted with option "noacl".
  # umask g-w,o-w

  # printf "${BLUE}Installing the package requirements...${NORMAL}\n"
  # if hash apt >/dev/null 2>&1; then
  #   apt update
  #   apt install -y python3 python3-dev python3-pip ruby ruby-dev redis-server libmysqlclient-dev libxml2-dev libxslt1-dev libssl-dev libffi-dev git supervisor
  # elif hash yum >/dev/null 2>&1; then
  #   echo "I should install everything with yum...."
  # else
  #   printf "Your package manager is currently not supported. Please contact the maintainer\n"
  #   printf "${BLUE}opensource@indietyp.com${NORMAL} or open an issure\n"
  # fi


  # hash git >/dev/null 2>&1 || {
  #   echo "Error: git is not installed"
  #   exit 1
  # }

  # printf "${BLUE}Cloning the project...${NORMAL}\n"
  # env git clone https://github.com/indietyp/bellwether $BW || {
  #   printf "${RED}Error:${NORMAL} git clone of bellwether repo failed\n"
  #   exit 1
  # }

  # printf "${BLUE}Installing python3 dependencies...${NORMAL}\n"
  # pip3 install gunicorn
  # pip3 install -r $BW/requirements.txt

  # printf "${BLUE}Installing ruby and npm dependencies...${NORMAL}\n"
  # curl -sL deb.nodesource.com/setup_8.x | sudo -E bash -
  # apt install -y nodejs
  # npm install -g pug coffeescript
  # gem install sass --no-user-install

  # printf "${BLUE}Configuring the project...${NORMAL}\n"
  # cp $BW/panel/local.default.py $BW/panel/local.py
  # cp $BW/supervisor.default.conf $BW/supervisor.conf
  mkdir -p /var/log/bellwether

  printf "\n\n${YELLOW}Database configuration:${NORMAL}\n"
  while true; do
    read -p 'Host     (default: localhost):  ' dbhost
    read -p 'Port     (default: 3006):       ' dbport
    read -p 'User     (default: root):       ' dbuser
    read -p 'Database (default: bellwether): ' dbname
    read -p 'Password:                       ' dbpwd

    dbhost=${dbhost:-localhost}
    dbport=${dbport:-3306}
    dbuser=${dbuser:-root}
    dbname=${dbname:-bellwether}

    export MYSQL_PWD=$dbpwd
    export MYSQL_HOST=$dbhost
    export MYSQL_TCP_PORT=$dbport

    if mysql -u $dbuser -p -e "CREATE DATABASE IF NOT EXISTS $dbname"; then
      printf "connected"
    else
      printf "not connected"
    fi
    # try to connect - if not mention bind_user and loop, else continue
    break;
  done
  return

  printf "\n\n${YELLOW}SteamAPI configuration:${NORMAL}\n"
  read -p 'Steam API key:                   ' stapi

  printf "\n\n${GREEN}Just doing some file transmutation magic:${NORMAL}\n"
  # replace the stuff in the local.py and supervisor.conf file
  sed -i "s/'HOST': 'localhost'/'HOST': '$dbhost'/g" $BW/panel/local.py
  sed -i "s/'PORT': 'root'/'PORT': '$dbport'/g" $BW/panel/local.py
  sed -i "s/'NAME': 'bellwether'/'NAME': '$dbname'/g" $BW/panel/local.py
  sed -i "s/'USER': 'root'/'USER': '$dbuser'/g" $BW/panel/local.py
  sed -i "s/'PASSWORD': ''/'PASSWORD': '$dbpwd'/g" $BW/panel/local.py

  sed -i "s/SOCIAL_AUTH_STEAM_API_KEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'/SOCIAL_AUTH_STEAM_API_KEY = '$stapi'/g" $BW/panel/local.py
  sed -i "s#directory=\<replace\>#directory=$BW#g" $BW/supervisor.conf

  printf "${BLUE}Executing project setupcommands...${NORMAL}\n"
  sed -iE "s/SECRET_KEY = (?:.*)/SECRET_KEY = '$(python3 $BW/manage.py generatesecret | tail -1)'/g" $BW/panel/local.py

  python3 $BW/manage.py migrate
  python3 $BW/manage.py compilestatic
  python3 $BW/manage.py collectstatic

  printf "${BLUE}Linking to supervisor...${NORMAL}\n"
  ln -sr $BW/supervisor.conf /etc/supervisor/conf.d/bellwether.conf
  supervisorctl reread
  supervisorctl update
  supervisorctl restart bellwether
  printf "Started the unix socket at: ${YELLOW}/tmp/bellwether.sock${NORMAL}\n"

  printf "\n\n${GREEN}You did it (Well rather I did). Everything seems to be installed.${NORMAL}"
  printf "Please look over the ${RED}panel/local.py${NORMAL} to see if you want to configure anything. And restart the supervisor with ${YELLOW}supervisorctl restart bellwether${NORMAL}"
  printf "To configure your webserver please refer to the project wiki: ${YELLOW}https://github.com/indietyp/bellwether/wiki/Webserver-Configuration"
  env zsh
}

main
