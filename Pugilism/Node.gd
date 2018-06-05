extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const SERVER_PORT = 31416

var players = {} # Dictionary containing player names and their ID
var player_name # Your own player name
const MAXIMUM_PLAYER_COUNT = 8

#SIGNALS to Main Menu (GUI)
signal refresh_lobby()
signal server_ended()
signal server_error()
signal connection_success()
signal connection_fail()

func join_game( name, ip_address ):
	
	player_name = name
	
	var host = NetworkedMultiplayerENet.new()
	host.create_client( ip_address, SERVER_PORT )
	get_tree().set_network_peer( host )

func host_game( name, max_players = MAXIMUM_PLAYER_COUNT ):
	player_name = name
	
	var host = NetworkedMultiplayerEnet.new()
	host.create_server( SERVER_PORT, max_players )
	get_tree().set_network_peer( host )

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# Networking signals for high level networking
	get_tree().connect( "network_peer_connected", self, "_player_connected" )
	get_tree().connect( "network_peer_disconnected", self, "_player_disconnected" )
	get_tree().connect( "connected_to_server", self, "_connected_ok" )
	get_tree().connect( "connection_failed", self, "_connection_fail")
	get_tree().connect( "server_disconnected", self, "_server_disconnected" ) 
	pass

func _player_disconnected( id ):
	#if I am the server, send a signal to inform that a player has disconnected
	unregister_player( id )
	rpc( "unregister_player", id )

func _connected_ok():
	#send signal to the server that we are ready to be assigned
	#either to a lobby or to game
	rpc_id( 1, "user_ready", get_tree().get_network_unique_id(), player_name )



#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
