extends Node

const PORT                = 42069 as int
const LISTEN_PORT 		    = 42070 as int
const BROADCAST_PORT      = 42071 as int
const MAX_PEERS           = 8 as int 

func get_ipv4_address():
	for address in IP.get_local_addresses():
		var parts = address.split('.')
		if (parts.size() == 4):
			return '.'.join(parts)


func broadcast_address():
	for address in IP.get_local_addresses():
		var parts = address.split('.')
		if (parts.size() == 4):
			parts[3] = '255'
			return '.'.join(parts)

