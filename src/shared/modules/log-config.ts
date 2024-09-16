import type { LogConfig } from "@rbxts/rbxts-sleitnick-log";

const logConfiguration: LogConfig = {
	Default: "Warning",
	Development: {
		Client: "Warning",
		PlaceIds: [],
		Server: "Warning",
	},
	Studio: "Debug",
};

export = logConfiguration;
