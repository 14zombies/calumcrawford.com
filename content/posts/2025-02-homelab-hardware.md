---
title: "Homelab — Hardware"
description: "Homelab hardware as of February 2025"
date: "2025-02-09"
series: 
  - "homelab"
aliases:
  - "/projects/homelab/current-hardware"
# When updating remove alias to current-hardware.
# Add lastmod: with todays date to frontmatter.
---

This is a list of my current homelab hardware as of February 2025. The whole could be considered outdated, but it is still able to keep up with my modest requirements and most importantly it was all cheap. 

My homelab has been build up piecemeal from eBay. It currently consists of the following hardware:

- [Dell Optiplex 5040 SFF](#dell-optiplex-5040-sff)
- [Raspberry Pi 4 Model B 8GB](#raspberry-pi-4-model-b--8gb)
- [TP-Link TL--SG108PE](#tp-link-tl--sg108pe)
- [UniFi AC Lite Access Point](#unifi-ac-lite-access-point)
- [UniFi Flex Mini](#unifi-flex-mini)


### Dell Optiplex 5040 SFF

This old [Dell workstation](https://www.dell.com/support/product-details/en-uk/product/optiplex-5040-sff/resources/search) is the "server" for my homelab. It currently runs Proxmox as a host operating system with several virtual machines running atop it.
It came with an Intel Core i5-6600 CPU @ 3.30GHz, 16 GB of RAM, 256GB SSD, and a 500GB spinning rust drive and cost me around £100 shipped in early 2023.

Since then I have doubled the ram to 32GB, updated the storage to 4x2TB SSD's, added a 4 port Ethernet card, and a Host Bus Adapter.

#### Processor
The i5-6600 is old, and is the limiting factor for a lot of what I would like to use my homelab for.

#### Memory
Fortunately the system came with two empty slots for RAM, it had 2x8GB installed and for about £15 I was able to get two more doubling the RAM to 64GB (4x8GB)

#### Storage

The storage is split into two parts 1x2TB m.2 SSD and 1x2TB SSD attached to the motherboard directly. They are set up in a ZFS mirrored pool for Proxmox. 

The remaining 2x2TB SSD's are also in a ZFS mirrored pool, but are connected to an LSI SAS HBA (specifically the 9211-4i) this card is passed directly into a VM running on the host system allowing it to manage the drives.

#### Networking

The onboard Gigabit ethernet is fine, but I wanted to experiment with a virtualised router. I was able to get a Dell Pro 1000 VT PCI-E Quad Port NIC to give me more flexability.

Currently is has one port connected to my cable modem, one port connected to my main switch, and the builtin port is used to administer Proxmox.

### Raspberry PI 4 Model B — 8GB

I love the [Raspberry Pi 4](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/), it's got a tiny footprint and with a [POE hat](https://www.raspberrypi.com/products/poe-hat/) only requires one cable for both power and data.
Currently this is serving as a worker node running several containers.

### TP-Link TL--SG108PE

The [TP-Link TL-SG108PE](https://www.tp-link.com/uk/business-networking/easy-smart-switch/tl-sg108pe/) is a very basic managed switch, it was cheap, had Power-over-ethernet, and supports VLANs so it ticked all the boxes.

### UniFi AC Lite Access Point

The [UniFi AC Lite](https://techspecs.ui.com/unifi/wifi/uap-ac-lite) is a  PoE powered compact access point supports 5GHz, but is only WiFi 5 capable.

### UniFi Flex Mini

The [UniFi Flex Mini](https://store.ui.com/us/en/products/usw-flex-mini) is a 5 port PoE switch that connects my TV & Xbox to the network.

## Hardware Diagram
![](/images/posts/homelab-hardware-2025-02.png)


## Future

- Upgrade my "server" to one with more cores. This would allow more VMs to be run concurrently. It would then free up the Optiplex to be a dedicated NAS machine.
- Replace the AC Lite with a WiFi 7 capable access point — Update (2025-03-03) Definitely getting replaced with a [U7 Lite](https://uk.store.ui.com/uk/en/products/u7-lite) 
- Replace TP-Link POE Switch with a UniFi one. After getting the Flex Mini this is a no brainer, being able to manage all the features of the switch and APs in one interface is fantastic.
- Move beyond 10 Gigabit networking, this is some ways in the future, but bearing it in mind when performing other upgrades (such as the switch) will be essential to keeping costs down.


