package main

import nbn "../../nbnet"
import nbn_cli "../../nbnet/client"
import "core:log"
import "core:time"

main :: proc() {
	context.logger = log.create_console_logger()

	nbn_cli.init("echo-example", "127.0.0.1", 42042)

	if nbn_cli.start() < 0 {
		log.error("Failed to start client")
		return
	}

	exit := false
	connected := false

	for !exit {
		has_event := true

		for has_event {
			ev := nbn_cli.poll()

			switch ev {
			case .No_Event:
				has_event = false
			case .Connected:
				log.debug("Connected")
				connected = true
			case .Disconnected:
				log.debug("Disconnected")
				exit = true
			case .Message_Received:
				reader := nbn_cli.read_message()
				len: u32
				nbn.read_u32(reader, &len)
				data := make([]u8, len + 1)
				defer delete(data)
				nbn.read_bytes(reader, raw_data(data), uint(len))
				data[len] = 0
				str := string(data)
				log.infof("Message received: %s", str)
			case .Error:
				log.error("Error")
				exit = true
			}
		}

		time.sleep(time.Second / 2)

		if connected {
			log.debug("Send")
			writer := nbn_cli.create_reliable_message(0)
			msg := "Hello, World!"
			data := raw_data(msg)

			nbn.write_u32(writer, u32(len(msg)))
			nbn.write_bytes(writer, data, len(msg))

			if nbn_cli.enqueue_message() < 0 {
				log.error("Failed to enqueue message")
				break
			}
		}

		if nbn_cli.flush() < 0 {
			log.error("Failed to flush")
			break
		}
	}

	nbn_cli.stop()
}
