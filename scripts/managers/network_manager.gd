extends Node

const PORT            = 42069 as int
const LISTEN_PORT 		= 42070 as int
const BROADCAST_PORT  = 42071 as int
const MAX_PEERS       = 8 as int 

func get_ipv4_address() -> String:
		return IP.get_local_addresses()[0]
