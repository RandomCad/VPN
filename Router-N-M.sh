Red="\033[1;31m"
Green="\033[1;32m"
Yellow="\033[1;33m"
Blue="\033[1;34m"
White="\033[0m"

Total=10
Work=1

echo "$Green Running the central setup script for the middel router.$White"
echo ""

echo "$Blue Checking network setup. Start $Work of $Total  $White"

if ! $(ip a | grep -q "enp0s3"); then
	echo "$Red No enp0s3 network interface detected. This interface while be used to conect to the internet. Pleas set it up. $White"
	return 1
fi
if ! $(ip a | grep -q "enp0s8"); then
	echo "$Red No enp0s8 network interface detected. This interface while be used to conect to the first network. Pleas set it up. $White"
  return 1
fi
if ! $(ip a | grep -q "enp0s9"); then
	echo "$Red No enp0s9 network interface detected. This interface while be used to conect to the second network. Pleas set it up. $White"
  return 1
fi

echo "$Blue Checking network setup. Done $Work of $Total  $White"
Work=$(($Work + 1))

#chek the instalation of netplan
