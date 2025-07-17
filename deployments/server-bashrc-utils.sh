# Creates a pseudo sudo ;) function
function as_sudo {
        local firstArg=$1
        if [ $(type -t $firstArg) = function ]
        then
                shift && command sudo bash -c "$(declare -f $firstArg);$firstArg $*"
        elif [ $(type -t $firstArg) = alias ]
        then
                alias sudo='\sudo '
                eval "sudo $@"
        else
                command sudo "$@"
        fi
}

# Create a function which will allow me to automatically enable an
# existing nginx site.
function nginx_enable() {
  as_sudo ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled;
}

function nginx_disable() {
  as_sudo unlink /etc/nginx/sites-enabled/$1;
}

# Creates a function to list all the available sites
function nginx_available() {
  ls /etc/nginx/sites-available;
}
alias nginx_avail='nginx_available';

# Creates a function to list all the enabled sites
function nginx_enabled() {
  ls /etc/nginx/sites-enabled;
}

# Create a function to edit an nginx site
function nginx_edit() {
  as_sudo nano /etc/nginx/sites-available/$1;
}

# Create a function which will test the nginx config.
function nginx_test() {
  as_sudo nginx -t
}

# Create a function which will restart nginx.
function nginx_restart() {
  as_sudo systemctl restart nginx;
}

# Create a function which will stop nginx
function nginx_stop() {
  as_sudo systemctl stop nginx;
}

# Create a function which will start nginx
function nginx_start() {
  as_sudo systemctl start nginx;
}

function nginx_status() {
  as_sudo systemctl status nginx;
}

function nginx_clone() {
 as_sudo cp /etc/nginx/sites-available/$1 /etc/nginx/sites-available/$2;
}

# Create a function which will create new SSL certs
function new_cert() {
  as_sudo certbot certonly --standalone --rsa-key-size 4096 --agree-tos --preferred-challenges http -d $1;
}

function get_certs() {
  as_sudo certbot certificates;
}

# Renew an SSL cert
function renew_cert() {
  as_sudo certbot renew --cert-name $1;
}

# Renwer all SSL certs
function renew_all_certs() {
  as_sudo certbot renew --renew-by-default
}
