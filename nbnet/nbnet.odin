package nbnet

when ODIN_OS == .Windows {
	// TODO:
} else when ODIN_OS == .Linux {
	// TODO:
} else when ODIN_OS == .Darwin {
	foreign import nbnet "libnbnet_udp.dylib"
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
	// TODO:
} else {
	#panic("Unknown platform")
}

import "base:runtime"
import "core:c"
import "core:c/libc"
import "core:fmt"
import "core:strings"

LogLevel :: enum {
	ERROR,
	INFO,
	WARNING,
	DEBUG,
}

Client_Event :: enum {
	Error            = -1,
	No_Event         = 0,
	Connected        = 1,
	Disconnected     = 2,
	Message_Received = 3,
}

Server_Event :: enum {
	Error              = -1,
	No_Event           = 0,
	Connection_Request = 1,
	Disconnection      = 2,
	Message_Received   = 3,
}

Reader :: struct {
	buffer:   [^]u8,
	length:   uint,
	position: uint,
}

Writer :: struct {
	buffer:   [^]u8,
	length:   uint,
	position: uint,
}

Connection_Handle :: struct {
	id:        u64,
	user_data: rawptr,
}

Message_Info :: struct {
	type:       u8,
	channel_id: u8,
	data:       [^]u8,
	length:     u16,
	sender:     ^Connection_Handle,
}

@(link_prefix = "NBN_")
foreign nbnet {
	GameClient_Init :: proc(protocol_name: cstring, host: cstring, port: u16) ---
	GameClient_Start :: proc() -> int ---
	GameClient_Stop :: proc() ---
	GameClient_WriteConnectionRequestData :: proc() -> ^Writer ---
	GameClient_ReadServerData :: proc() -> ^Reader ---
	GameClient_Poll :: proc() -> Client_Event ---
	GameClient_Flush :: proc() -> int ---
	GameClient_CreateMessage :: proc(type: u8, channel_id: u8) -> ^Writer ---
	GameClient_CreateReliableMessage :: proc(type: u8) -> ^Writer ---
	GameClient_CreateUnreliableMessage :: proc(type: u8) -> ^Writer ---
	GameClient_EnqueueMessage :: proc() -> int ---
	GameClient_ReadMessage :: proc() -> ^Reader ---
	GameClient_GetMessageInfo :: proc() -> Message_Info ---

	Writer_Init :: proc(writer: ^Writer, buffer: [^]u8, length: uint) ---

	@(link_name = "NBN_Writer_WriteInt8")
	WriteInt8 :: proc(writer: ^Writer, value: i8) ---
	@(link_name = "NBN_Writer_WriteInt16")
	WriteInt16 :: proc(writer: ^Writer, value: i16) ---
	@(link_name = "NBN_Writer_WriteInt32")
	WriteInt32 :: proc(writer: ^Writer, value: i32) ---
	@(link_name = "NBN_Writer_WriteInt64")
	WriteInt64 :: proc(writer: ^Writer, value: i64) ---
	@(link_name = "NBN_Writer_WriteUInt8")
	WriteUInt8 :: proc(writer: ^Writer, value: u8) ---
	@(link_name = "NBN_Writer_WriteInt16")
	WriteUInt16 :: proc(writer: ^Writer, value: u16) ---
	@(link_name = "NBN_Writer_WriteUInt32")
	WriteUInt32 :: proc(writer: ^Writer, value: u32) ---
	@(link_name = "NBN_Writer_WriteUInt64")
	WriteUInt64 :: proc(writer: ^Writer, value: u64) ---
	@(link_name = "NBN_Writer_WriteFloat")
	WriteFloat :: proc(writer: ^Writer, value: f32) ---
	@(link_name = "NBN_Writer_WriteBool")
	WriteBool :: proc(writer: ^Writer, value: bool) ---
	@(link_name = "NBN_Writer_WriteBytes")
	WriteBytes :: proc(writer: ^Writer, bytes: [^]u8, length: uint) ---
	@(link_name = "NBN_Writer_WriteString")
	WriteString :: proc(writer: ^Writer, str: cstring, max_length: uint) ---

	Reader_Init :: proc(reader: ^Reader, buffer: [^]u8, length: uint) ---

	@(link_name = "NBN_Reader_ReadInt8")
	ReadInt8 :: proc(reader: ^Reader, value: ^i8) -> int ---
	@(link_name = "NBN_Reader_ReadInt16")
	ReadInt16 :: proc(reader: ^Reader, value: ^i16) -> int ---
	@(link_name = "NBN_Reader_ReadInt32")
	ReadInt32 :: proc(reader: ^Reader, value: ^i32) -> int ---
	@(link_name = "NBN_Reader_ReadInt64")
	ReadInt64 :: proc(reader: ^Reader, value: ^i64) -> int ---
	@(link_name = "NBN_Reader_ReadUInt8")
	ReadUInt8 :: proc(reader: ^Reader, value: ^u8) -> int ---
	@(link_name = "NBN_Reader_ReadUInt16")
	ReadUInt16 :: proc(reader: ^Reader, value: ^u16) -> int ---
	@(link_name = "NBN_Reader_ReadUInt32")
	ReadUInt32 :: proc(reader: ^Reader, value: ^u32) -> int ---
	@(link_name = "NBN_Reader_ReadUInt64")
	ReadUInt64 :: proc(reader: ^Reader, value: ^u64) -> int ---
	@(link_name = "NBN_Reader_ReadFloat")
	ReadFloat :: proc(reader: ^Reader, value: ^f32) -> int ---
	@(link_name = "NBN_Reader_ReadBool")
	ReadBool :: proc(reader: ^Reader, value: ^bool) -> int ---
	@(link_name = "NBN_Reader_ReadBytes")
	ReadBytes :: proc(reader: ^Reader, bytes: [^]u8, length: uint) -> int ---
	@(link_name = "NBN_Reader_ReadString")
	ReadString :: proc(reader: ^Reader, str: cstring, max_length: uint) -> int ---
}
