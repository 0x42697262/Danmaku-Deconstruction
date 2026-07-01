extends Node

const PORT                = 42069 as int
const LISTEN_PORT         = 42070 as int
const BROADCAST_PORT      = 42071 as int
const MAX_PEERS           = 8 as int 

func get_ipv4_address() -> String:
	for address in IP.get_local_addresses():
		var parts = address.split('.')
		if parts == '127.0.0.1'.split('.'):
			continue
		if (parts.size() == 4):
			return '.'.join(parts)

	return "127.0.0.1"


func broadcast_address() -> String:
	# Use the limited (link-local) broadcast address instead of a /24 directed
	# broadcast. Computing "x.x.x.255" only reaches hosts on a /24 subnet, so
	# discovery failed on larger private ranges such as 172.16.0.0/12 or
	# 10.0.0.0/8 (issue #51). 255.255.255.255 reaches every host on the local
	# link regardless of the subnet mask.
	return "255.255.255.255"
