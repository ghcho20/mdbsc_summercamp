ip_4=$1
new_hostname=$2

if [ "${ip_4:-notset}" = "notset" ]; then
  echo "1st arg must be the 4th IP value in 192.168.206.xx"
  exit
elif [ "${new_hostname:-notset}" = "notset" ]; then
  echo "2nd arg must be a new hostname to be set"
  exit
fi

sudo sed -i -e "s/192.168.206.[[:digit:]]\+\/24/192.168.206.${ip_4}\/24/g" /etc/netplan/50-cloud-init.yaml
sudo netplan apply
sudo hostnamectl set-hostname "${new_hostname}"

echo "new IP=$(ip a | grep -E '192.168.206.[0-9]+/24' | awk '{ print $2 }')"
echo "new hostname=$(hostname -f)"
