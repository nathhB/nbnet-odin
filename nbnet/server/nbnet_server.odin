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

Event :: enum {
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

Server :: distinct rawptr

foreign nbnet {
	@(link_name = "NBN_Server_Create")
	create :: proc(protocol_name: cstring, port: u16) -> Server ---
	@(link_name = "NBN_Server_Start")
	start :: proc(server: Server) -> int ---
	@(link_name = "NBN_Server_Stop")
	stop :: proc(server: Server) ---
	@(link_name = "NBN_Server_CreateChannel")
	create_channel :: proc(server: Server, mode: nbn.Channel_Mode, buffer_size: uint, max_message_len: uint) ---
	@(link_name = "NBN_Server_Poll")
	poll :: proc(server: Server) -> Event ---
	@(link_name = "NBN_Server_Flush")
	flush :: proc(server: Server) -> int ---
	@(link_name = "NBN_Server_CloseClient")
	close_client :: proc(server: Server, conn: ^nbn.Connection_Handle) -> int ---
	@(link_name = "NBN_Server_CloseClientWithCode")
	close_client_with_code :: proc(server: Server, conn: ^nbn.Connection_Handle, code: int) -> int ---
	@(link_name = "NBN_Server_CreateMessage")
	create_message :: proc(server: Server, type: u8, channel: u8, receiver: ^nbn.Connection_Handle) -> ^nbn.Writer ---
	@(link_name = "NBN_Server_CreateReliableMessage")
	create_reliable_message :: proc(server: Server, type: u8, receiver: ^nbn.Connection_Handle) -> ^nbn.Writer ---
	@(link_name = "NBN_Server_CreateUnreliableMessage")
	create_unreliable_message :: proc(server: Server, type: u8, receiver: ^nbn.Connection_Handle) -> ^nbn.Writer ---
	@(link_name = "NBN_Server_ReadMessage")
	read_message :: proc(server: Server) -> ^nbn.Reader ---
	@(link_name = "NBN_Server_WriteConnectionData")
	write_connection_data :: proc(server: Server) -> ^nbn.Writer ---
	@(link_name = "NBN_Server_AcceptIncomingConnection")
	accept_connection :: proc(server: Server) -> int ---
	@(link_name = "NBN_Server_RejectIncomingConnection")
	reject_connection :: proc(server: Server) -> int ---
	@(link_name = "NBN_Server_RejectIncomingConnectionWithCode")
	reject_connection_with_code :: proc(server: Server, code: int) -> int ---
	@(link_name = "NBN_Server_GetIncomingConnection")
	get_incoming_connection :: proc(server: Server) -> ^nbn.Connection_Handle ---
	@(link_name = "NBN_Server_ReadConnectionRequestData")
	read_connection_request :: proc(server: Server) -> ^nbn.Reader ---
	@(link_name = "NBN_Server_GetDisconnectionInfo")
	get_disconnection_info :: proc(server: Server) -> Disconnection_Info ---
	@(link_name = "NBN_Server_GetMessageInfo")
	get_message_info :: proc(server: Server) -> nbn.Message_Info ---
	@(link_name = "NBN_Server_GetConnection")
	__get_client_connection :: proc(server: Server, conn_id: nbn.Connection_Id) -> ^nbn.Connection_Handle ---
}

get_client_connection :: proc(
	server: Server,
	conn_id: nbn.Connection_Id,
) -> (
	handle: ^nbn.Connection_Handle,
	ok: bool,
) {
	handle = __get_client_connection(server, conn_id)
	ok = handle != nil
	return
}
