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

Event :: enum {
	Error            = -1,
	No_Event         = 0,
	Connected        = 1,
	Disconnected     = 2,
	Message_Received = 3,
}

Client :: distinct rawptr

foreign nbnet {
	@(link_name = "NBN_Client_Create")
	create :: proc(protocol_name: cstring, host: cstring, port: u16) -> Client ---
	@(link_name = "NBN_Client_Start")
	start :: proc(client: Client) -> int ---
	@(link_name = "NBN_Client_Stop")
	stop :: proc(client: Client) ---
	@(link_name = "NBN_Client_CreateChannel")
	create_channel :: proc(client: Client, mode: nbn.Channel_Mode, buffer_size: uint, max_message_len: uint) -> u8 ---
	@(link_name = "NBN_Client_WriteConnectionRequestData")
	write_connection_request_data :: proc(client: Client) -> ^nbn.Writer ---
	@(link_name = "NBN_Client_ReadServerData")
	read_server_data :: proc(client: Client) -> ^nbn.Reader ---
	@(link_name = "NBN_Client_Poll")
	poll :: proc(client: Client) -> Event ---
	@(link_name = "NBN_Client_Flush")
	flush :: proc(client: Client) -> int ---
	@(link_name = "NBN_Client_CreateMessage")
	create_message :: proc(client: Client, type: u8, channel_id: u8) -> ^nbn.Writer ---
	@(link_name = "NBN_Client_CreateReliableMessage")
	create_reliable_message :: proc(client: Client, type: u8) -> ^nbn.Writer ---
	@(link_name = "NBN_Client_CreateUnreliableMessage")
	create_unreliable_message :: proc(client: Client, type: u8) -> ^nbn.Writer ---
	@(link_name = "NBN_Client_ReadMessage")
	read_message :: proc(client: Client) -> ^nbn.Reader ---
	@(link_name = "NBN_Client_GetMessageInfo")
	get_message_info :: proc(client: Client) -> nbn.Message_Info ---
	@(link_name = "NBN_Client_IsConnected")
	is_connected :: proc(client: Client) -> bool ---
}
