package nbnet_client

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

import nbn ".."

Client_Event :: enum {
	Error            = -1,
	No_Event         = 0,
	Connected        = 1,
	Disconnected     = 2,
	Message_Received = 3,
}

foreign nbnet {
	@(link_name = "NBN_GameClient_Init")
	init :: proc(protocol_name: cstring, host: cstring, port: u16) ---
	@(link_name = "NBN_GameClient_Start")
	start :: proc() -> int ---
	@(link_name = "NBN_GameClient_Stop")
	stop :: proc() ---
	@(link_name = "NBN_GameClient_WriteConnectionRequestData")
	write_connection_request_data :: proc() -> ^nbn.Writer ---
	@(link_name = "NBN_GameClient_ReadServerData")
	read_server_data :: proc() -> ^nbn.Reader ---
	@(link_name = "NBN_GameClient_Poll")
	poll :: proc() -> Client_Event ---
	@(link_name = "NBN_GameClient_Flush")
	flush :: proc() -> int ---
	@(link_name = "NBN_GameClient_CreateMessage")
	create_message :: proc(type: u8, channel_id: u8) -> ^nbn.Writer ---
	@(link_name = "NBN_GameClient_CreateReliableMessage")
	create_reliable_message :: proc(type: u8) -> ^nbn.Writer ---
	@(link_name = "NBN_GameClient_CreateUnreliableMessage")
	create_unreliable_message :: proc(type: u8) -> ^nbn.Writer ---
	@(link_name = "NBN_GameClient_EnqueueMessage")
	enqueue_message :: proc() -> int ---
	@(link_name = "NBN_GameClient_ReadMessage")
	read_message :: proc() -> ^nbn.Reader ---
	@(link_name = "NBN_GameClient_GetMessageInfo")
	get_message_info :: proc() -> nbn.Message_Info ---
}
