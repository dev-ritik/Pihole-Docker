# Pihole Docker
This repo has the Docker environment for Pihole (DNS sinkhole and DHCP Server) + Cloudflared (DNS over HTTPS proxy).

## Use Case
I don't want to bother my ISP with handling my DNS queries! \
Ohh... And that Pihole thing is jff! (Helps me filter out useless advertisements)

## Bash function
```bash
dns_pihole() {
	# Pihole DNS controls
	if [ $@ = "on" ]; then
		# Use Pihole DNS
		sudo sed -r -i.orig '/nameserver.*$/ d' /run/systemd/resolve/resolv.conf && echo 'nameserver 127.0.0.1' | sudo tee -a /run/systemd/resolve/resolv.conf
		docker start pihole
	elif [ $@ = "off" ]; then
		# Stop Pihole DNS and use plain DNS
		sudo sed -r -i.orig '/nameserver.*$/ d' /run/systemd/resolve/resolv.conf && echo 'nameserver 8.8.8.8' | sudo tee -a /run/systemd/resolve/resolv.conf
		docker stop pihole
	elif [ $@ = "start" ]; then
		# Start Pihole and setup DNS
		sudo killall -9 dnsmasq
		cd ~/proj/pihole;
		docker-compose up -d;
		sudo sed -r -i.orig '/nameserver.*$/ d' /run/systemd/resolve/resolv.conf && echo 'nameserver 127.0.0.1' | sudo tee -a /run/systemd/resolve/resolv.conf
	elif [ $@ = "status" ]; then
		# Print Debug info on Pihole and DNS
		echo "-----------------Nameserver--------------"
		cat /etc/resolv.conf | grep nameserver;
		echo "------------------Docker-----------------"
		docker ps --filter "name=pihole";
		echo ""
		docker logs --tail 10 pihole
		echo ""
		echo "-----------------Netstat-----------------"
		# 67: DHCP, 53: DNS, 5053: Cloudflared DoH
		sudo netstat -ltnpu | egrep ':67\s|:53\s|:5053'
	fi
}
```
