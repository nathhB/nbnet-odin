package nbnet_odin

when ODIN_OS == .Darwin do foreign import nbnet "libnbnet_udp.dylib"

import "base:runtime"
import "core:c"
import "core:c/libc"
import "core:fmt"
import "core:log"
import "core:strings"

NBN_LogLevel :: enum {
	ERROR,
	INFO,
	WARNING,
	DEBUG,
}

Log_Func :: proc "c" (level: NBN_LogLevel, file: cstring, line: c.int, msg: cstring, args: ..any)

@(link_prefix = "NBN_")
foreign nbnet {
	SetLogFunction :: proc(func: Log_Func) ---
	SetLogLevel :: proc(level: NBN_LogLevel) ---
	GameClient_Init :: proc(protocol_name: cstring, host: cstring, port: c.uint16_t) ---
	GameClient_Start :: proc() -> c.int ---
}

log_func :: proc "c" (level: NBN_LogLevel, file: cstring, line: c.int, msg: cstring, args: ..any) {
	context = runtime.default_context()
	context.logger = log.create_console_logger()

	// libc.printf(msg, args)
	// libc.printf("\n")
	// str := fmt.aprintf(strings.clone_from_cstring(msg), args)
	//
	// log.debug(str)
}

main :: proc() {
	context.logger = log.create_console_logger()

	SetLogFunction(log_func)
	SetLogLevel(.DEBUG)
	GameClient_Init("foobar", "127.0.0.1", 42042)

	if GameClient_Start() < 0 {
		log.error("Failed to start client")
		return
	}
}
