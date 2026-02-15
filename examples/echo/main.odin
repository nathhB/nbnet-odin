package main

import nbn "../../nbnet"
import "core:log"
import "core:strings"
import "core:time"
import "vendor:raylib"

main :: proc() {
	context.logger = log.create_console_logger()

	nbn.GameClient_Init("echo-example", "127.0.0.1", 42042)

	writer := nbn.GameClient_WriteConnectionRequestData()

	if nbn.GameClient_Start() < 0 {
		log.error("Failed to start client")
		return
	}

	exit := false
	connected := false

	for !exit {
		has_event := true

		for has_event {
			ev := nbn.GameClient_Poll()

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
				reader := nbn.GameClient_ReadMessage()
				len: u32
				nbn.ReadUInt32(reader, &len)
				data := make([]u8, len + 1)
				defer delete(data)
				nbn.ReadBytes(reader, raw_data(data), uint(len))
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
			writer := nbn.GameClient_CreateReliableMessage(0)
			msg := "Hello, World!"
			data := raw_data(msg)

			nbn.WriteUInt32(writer, u32(len(msg)))
			nbn.WriteBytes(writer, data, len(msg))

			if nbn.GameClient_EnqueueMessage() < 0 {
				log.error("Failed to enqueue message")
				break
			}
		}

		if nbn.GameClient_Flush() < 0 {
			log.error("Failed to flush")
			break
		}
	}

	nbn.GameClient_Stop()
}
