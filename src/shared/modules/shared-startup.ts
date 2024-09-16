//!optimize 2

import { Modding } from "@flamework/core";
import { Inspect, TableToString } from "@rbxts/rbx-debug";
import Log, { LogClass } from "@rbxts/rbxts-sleitnick-log";
import { TextChatService } from "@rbxts/services";
import { GlobalEvents, GlobalFunctions } from "shared/network";

const logger = Log.ForName("Runtime");

export default function sharedStartup() {
	assert(
		TextChatService.ChatVersion === Enum.ChatVersion.TextChatService,
		"TextChatService is not the correct version",
	);

	Modding.registerDependency<LogClass>((constructor) => {
		let useInfoLog = false;
		if ("useInfoLog" in constructor && typeIs(constructor.useInfoLog, "boolean"))
			useInfoLog = constructor.useInfoLog;
		return Log.ForName(tostring(constructor), useInfoLog);
	});

	GlobalEvents.registerHandler("onBadRequest", (player, data) =>
		logger.Warning(
			`[OnBadRequest] Player ${player} failed to send ${TableToString(data.networkInfo, true, "NetworkInfo")} at ${data.argIndex} (${Inspect(data.argValue)})`,
		),
	);
	GlobalFunctions.registerHandler("onBadRequest", (player, data) =>
		logger.Warning(
			`[OnBadRequest] Player ${player} failed to send ${TableToString(data.networkInfo, true, "NetworkInfo")} at ${data.argIndex} (${Inspect(data.argValue)})`,
		),
	);
	GlobalFunctions.registerHandler("onBadResponse", (player, data) =>
		logger.Warning(
			`[OnBadRequest] Player ${player} failed to send ${TableToString(data.networkInfo, true, "NetworkInfo")} (${Inspect(data.value)})`,
		),
	);
}
