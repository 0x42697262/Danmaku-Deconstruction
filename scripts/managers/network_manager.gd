extends Node

const PORT                = 42069 as int
const LISTEN_PORT 		    = 42070 as int
const BROADCAST_PORT      = 42071 as int
const MAX_PEERS           = 8 as int 

func get_ipv4_address() -> String:
	print(IP.get_local_addresses())
	for address in IP.get_local_addresses():
		var parts = address.split('.')
		if parts == '127.0.0.1'.split('.'):
			continue
		if (parts.size() == 4):
			return '.'.join(parts)

	return "127.0.0.1"


func broadcast_address() -> String:
	var address = get_ipv4_address()
	var parts = address.split('.')
	parts[3] = '255'

	return '.'.join(parts)
