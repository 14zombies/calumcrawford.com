---
title: "Homelab — Software"
description: "Homelab software as of February 2025"
date: "2025-02-10"
series: 
  - "homelab"
aliases:
  - "/projects/homelab/current-software"
# When updating remove alias to current software.
# Add lastmod: with todays date to frontmatter.
---

My main "[server](/posts/2025-02-homelab-hardware#dell-optiplex-5040-sff)" is running Proxmox as it's host operating system. Proxmox is an open source virtualisation platform that allows me to run virtual computers (VMs) on one physical device. I have several VMs that provide services to my network.

## VMs
### net-router-opnsense

The router for the whole network is run as a VM. This gives me the flexibility to experiment with various routing software easily. I simply pass through the 4 port NIC and configure the new OS appropriately. 

Currently I'm using [OPNsense](https://opnsense.org) — a FreeBSD based firewall and routing OS. In the past I've used [pfSense](https://www.pfsense.org) which is the parent project of OPNsense. And a Linux based router called [OpenWrt](https://openwrt.org) which was migrated from a SOHO[^1] router made by Netgear.

OPNsense is a fantastic, flexible piece of software that allows my to manage my network with ease.

I have it configured to route between several VLANs.
    - VLAN 1: LAN — All household computer, tablets, & phones are on this network.
    - VLAN 2: VPN — Used to allow me to connect back to my LAN when using an external connection.
    - VLAN 3: IoT — Internet of things devices. I've various smart speakers, plugs, and other devices on this VLAN.
    - VLAN 4: Guest — Keeps any devices of guests separate from out home devices.
    - VLAN 6: Blackhole — Unused switch ports set to use this network All traffic dropped.
    - VLAN 7: Services — Various web services expose their UI on this network.
    - VLAN 8: Management — All servers, routers, switches, & AP's run on this network and expose their configuration interfaces here.
    - VLAN 9: WAN — My ISP provided modem is located quite far away from where it's convenient to have the core of the network. I've been able to route it over this VLAN to keep cabling to a minimum and keep the historical society (my partner) happy.
    
The firewall is configured in such a way to drop traffic between VLANs. I've then punched holes in the firewall to allow access to various services running on separate networks.

It also runs the most critical parts of my home network: DHCP, some DNS, VPN, NTP, & Radius.

### vm-docker-mgmt-1
This VM runs the Manager node for Docker Swarm. From there the services (containers) are split between running on the manager node and the raspberry pi which is setup as a worker node.

I'm running the following stacks:
    - [Blocky](https://0xerr0r.github.io/blocky/latest/) — DNS server with ad/malware blocking
    - [Jellyfin](https://jellyfin.org) — media server
    - [Unifi Controller](https://github.com/jacobalberty/unifi-docker) — Configuration for my Access point and switches.
    - SMTP — Allows services to send emails for alerts, etc.
    - [Gitea](https://about.gitea.com) — Selfhosted Github
    - [Keycloak](https://www.keycloak.org) — Single-sign-on allows service access to be controlled from a centralised place.
    - [Drone](https://www.drone.io) — CI/CD software (Builds this site and a few other container images).


### storage-truenas-1
Storage is provided by a [TrueNAS scale](https://www.truenas.com/truenas-scale/) VM. This is where the HBA card is passed through to allowing TrueNAS (and by extension ZFS) to control the 2x2TB SSDs. Truenas itself runs off of a virtual hard drive managed by Proxmox. There are a few network shares on here including an NFS storage backend for docker swarm and a media share which contains ripped copies of all my Music, TV shows, and Films. Running a centralised storage server is great as it allows all my data to be contained in one place and makes backups[^2] a breeze.

### vm-freeipa
[FreeIPA](https://www.freeipa.org/page/Main_Page) This is the directory for the network. It provides identity management amongst other features, hooked into Keycloak this allows my household to sign into the WiFi/Media Server/etc with a single username and password.

### vm-homeassistant
I've started using [Home Assistant](https://www.home-assistant.io) to connect all my "smart" devices and media players. With the future goal of expanding the number of devices and creating more complex automations. For now it's a complicated way to turn on some lights when it's about to get dark and let me know when the garden bin needs to go out.

## Idempotence
To configure everything — host OSs, VMs, DNS, & software packages — I'm using a mixture of [Ansible](https://docs.ansible.com/ansible/latest/index.html) and [OpenTofu](https://opentofu.org)[^3]. These tools allow me to version changes to the environment and hopefully one day automatically apply the changes.

## Future

- Document and open source my configs where possible.
- Right now I'm trying to configure IPv6 to my liking. Unfortunately my ISP only provides IPv4[^4], making this process a little more involved, however I have it at a state where if I want to remove IPv4 from my LAN networking stack then everything still works.
- In the near future i'd like to replace Gitea with [Forgejo](https://forgejo.org) and Drone will be retired and replaced with Forgejo actions. This is quite a big project as a lot of my containers are customised and build using Drone.
- I've an on going certificate authority project which is frankly kicking my ass. I'm using Letsencrypt for the human facing side of the network, I would like to encrypt most of the communication between services using my own certificates. 

[^1]: 🛜 SOHO: small offices and home offices
[^2]: 💰 I'm using [Backblaze](https://secure.backblaze.com/r/029ro6) B2 for backups.
[^3]: 🤫 It's mostly still terraform.
[^4]: 😔 [It's been more than 15 years I should probably give up already.](https://www.havevirginmediaenabledipv6yet.co.uk/)
