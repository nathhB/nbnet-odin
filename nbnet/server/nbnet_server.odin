package nbnet_server

import nbn ".."

when ODIN_OS == .Windows {
	// TODO:
} else when ODIN_OS == .Linux {
	// TODO:
} else when ODIN_OS == .Darwin {
	foreign import nbnet "../libnbnet_udp.dylib"
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
	// TODO:
} else {
	#panic("Unknown platform")
}

Server_Event :: enum {
	Error              = -1,
	No_Event           = 0,
	Connection_Request = 1,
	Disconnection      = 2,
	Message_Received   = 3,
}

Disconnection_Info :: struct {
	conn_id:   u64,
	user_data: rawptr,
}

foreign nbnet {
	@(link_name = "NBN_GameServer_Init")
	init :: proc(protocol_name: cstring, port: u16) ---
	@(link_name = "NBN_GameServer_Start")
	start :: proc() -> int ---
	@(link_name = "NBN_GameServer_Stop")
	stop :: proc() ---
	@(link_name = "NBN_GameServer_CreateChannel")
	create_channel :: proc(mode: nbn.Channel_Mode, buffer_size: uint, max_message_len: uint) ---
	@(link_name = "NBN_GameServer_Poll")
	poll :: proc() -> Server_Event ---
	@(link_name = "NBN_GameServer_Flush")
	flush :: proc() -> int ---
	@(link_name = "NBN_GameServer_CloseClient")
	close_client :: proc(conn: ^nbn.Connection_Handle) -> int ---
	@(link_name = "NBN_GameServer_CloseClientWithCode")
	close_client_with_code :: proc(conn: ^nbn.Connection_Handle, code: int) -> int ---
	@(link_name = "NBN_GameServer_CreateMessage")
	create_message :: proc(type: u8, channel: u8, receiver: nbn.Connection_Handle) -> ^nbn.Writer ---
	@(link_name = "NBN_GameServer_CreateReliableMessage")
	create_reliable_message :: proc(type: u8, receiver: nbn.Connection_Handle) -> ^nbn.Writer ---
	@(link_name = "NBN_GameServer_CreateUnreliableMessage")
	create_unreliable_message :: proc(type: u8, receiver: nbn.Connection_Handle) -> ^nbn.Writer ---
	@(link_name = "NBN_GameServer_ReadMessage")
	read_message :: proc() -> ^nbn.Reader ---
	@(link_name = "NBN_GameServer_WriteConnectionData")
	write_connection_data :: proc() -> ^nbn.Writer ---
	@(link_name = "NBN_GameServer_AcceptIncomingConnection")
	accept_connection :: proc() -> int ---
	@(link_name = "NBN_GameServer_RejectIncomingConnection")
	reject_connection :: proc() -> int ---
	@(link_name = "NBN_GameServer_RejectIncomingConnectionWithCode")
	reject_connection_with_code :: proc(code: int) -> int ---
	@(link_name = "NBN_GameServer_GetIncomingConnection")
	get_incoming_connection :: proc() -> ^nbn.Connection_Handle ---
	@(link_name = "NBN_GameServer_ReadConnectionRequestData")
	read_connection_request :: proc() -> ^nbn.Reader ---
	@(link_name = "NBN_GameServer_GetDisconnectionInfo")
	get_disconnection_info :: proc() -> ^Disconnection_Info ---
	@(link_name = "NBN_GameServer_GetMessageInfo")
	get_message_info :: proc() -> nbn.Message_Info ---
}
