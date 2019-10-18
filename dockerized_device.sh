#!/usr/bin/env bash

echo "Usage: dockerized_device.sh '<command>' <device_id> [<usb_device> e.g. /003/002, see full list lsusb]"
device_id=""
usb_device=""
if [[ "$#" -eq 2 ]]; then
	device_id=$2
elif [[ "$#" -eq 3 ]]; then
    device_id=$2
    usb_device=$3
else
	exit 1
fi

container_name=box-${device_id}
home_dir=/home/user
project_dir=${home_dir}/project
echo "Check for container $container_name"
docker ps | grep ${container_name}

if [[ "$?" -eq 1 ]]; then
	echo "No docker container, run it"
	docker rm ${container_name}
	docker run -d -it --privileged -e ANDROID_SERIAL=${device_id}\
		-v /dev/bus/usb${usb_device}:/dev/bus/usb${usb_device}\
		-v $HOME/.android:${home_dir}/.android\
		-v $(pwd):${project_dir}\
		-w ${project_dir}\
		--name ${container_name} vbratashchuk/docker-android bash
fi

echo "Use ANDROID_HOME env instead of local.properties"
adb kill-server
docker exec -i ${container_name} rm local.properties
docker exec -i ${container_name} $1
result=$?

docker stop ${container_name}

exit ${result}
