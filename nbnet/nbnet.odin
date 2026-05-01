package nbnet

when ODIN_OS == .Windows {
	// TODO:
} else when ODIN_OS == .Linux {
	// TODO:
} else when ODIN_OS == .Darwin {
	foreign import nbnet "./libnbnet_udp.dylib"
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
	// TODO:
} else {
	#panic("Unknown platform")
}

Log_Level :: enum {
	Error,
	Info,
	Warning,
	Debug,
}

Reader :: struct {
	buffer:   [^]u8,
	length:   u16,
	position: u16,
}

Writer :: struct {
	buffer:   [^]u8,
	length:   u16,
	position: u16,
}

Connection_Id :: u64

Connection_Handle :: struct {
	id:        Connection_Id,
	user_data: rawptr,
}

Message_Info :: struct {
	type:       u8,
	channel_id: u8,
	data:       [^]u8,
	length:     u16,
	sender:     ^Connection_Handle,
}

Channel_Mode :: enum {
	Unreliable,
	Reliable,
}

foreign nbnet {
	@(link_name = "NBN_SetLogLevel")
	set_log_level :: proc(log_level: Log_Level) ---
	@(link_name = "NBN_Writer_Init")
	writer_init :: proc(writer: ^Writer, buffer: [^]u8, length: uint) ---
	@(link_name = "NBN_Writer_WriteInt8")
	write_i8 :: proc(writer: ^Writer, value: i8) ---
	@(link_name = "NBN_Writer_WriteInt16")
	write_i16 :: proc(writer: ^Writer, value: i16) ---
	@(link_name = "NBN_Writer_WriteInt32")
	write_i32 :: proc(writer: ^Writer, value: i32) ---
	@(link_name = "NBN_Writer_WriteInt64")
	write_i64 :: proc(writer: ^Writer, value: i64) ---
	@(link_name = "NBN_Writer_WriteUInt8")
	write_u8 :: proc(writer: ^Writer, value: u8) ---
	@(link_name = "NBN_Writer_WriteInt16")
	write_u16 :: proc(writer: ^Writer, value: u16) ---
	@(link_name = "NBN_Writer_WriteUInt32")
	write_u32 :: proc(writer: ^Writer, value: u32) ---
	@(link_name = "NBN_Writer_WriteUInt64")
	write_u64 :: proc(writer: ^Writer, value: u64) ---
	@(link_name = "NBN_Writer_WriteFloat")
	write_float :: proc(writer: ^Writer, value: f32) ---
	@(link_name = "NBN_Writer_WriteBool")
	write_bool :: proc(writer: ^Writer, value: bool) ---
	@(link_name = "NBN_Writer_WriteBytes")
	write_bytes :: proc(writer: ^Writer, bytes: [^]u8, length: uint) ---
	@(link_name = "NBN_Writer_WriteString")
	write_string :: proc(writer: ^Writer, str: cstring, max_length: uint) ---

	@(link_name = "NBN_Reader_Init")
	reader_init :: proc(reader: ^Reader, buffer: [^]u8, length: uint) ---
	@(link_name = "NBN_Reader_ReadInt8")
	read_i8 :: proc(reader: ^Reader, value: ^i8) -> int ---
	@(link_name = "NBN_Reader_ReadInt16")
	read_i16 :: proc(reader: ^Reader, value: ^i16) -> int ---
	@(link_name = "NBN_Reader_ReadInt32")
	read_i32 :: proc(reader: ^Reader, value: ^i32) -> int ---
	@(link_name = "NBN_Reader_ReadInt64")
	read_i64 :: proc(reader: ^Reader, value: ^i64) -> int ---
	@(link_name = "NBN_Reader_ReadUInt8")
	read_u8 :: proc(reader: ^Reader, value: ^u8) -> i32 ---
	@(link_name = "NBN_Reader_ReadUInt16")
	read_u16 :: proc(reader: ^Reader, value: ^u16) -> int ---
	@(link_name = "NBN_Reader_ReadUInt32")
	read_u32 :: proc(reader: ^Reader, value: ^u32) -> int ---
	@(link_name = "NBN_Reader_ReadUInt64")
	read_u64 :: proc(reader: ^Reader, value: ^u64) -> int ---
	@(link_name = "NBN_Reader_ReadFloat")
	read_float :: proc(reader: ^Reader, value: ^f32) -> int ---
	@(link_name = "NBN_Reader_ReadBool")
	read_bool :: proc(reader: ^Reader, value: ^bool) -> int ---
	@(link_name = "NBN_Reader_ReadBytes")
	read_bytes :: proc(reader: ^Reader, bytes: [^]u8, length: uint) -> int ---
	@(link_name = "NBN_Reader_ReadString")
	read_string :: proc(reader: ^Reader, str: cstring, max_length: uint) -> int ---
}
