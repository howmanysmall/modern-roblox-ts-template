import type { LogClass } from "@rbxts/rbxts-sleitnick-log";

declare function catchFactory(
	functionName: string,
	logFunction?: LogClass["Info"],
): (...exceptions: Array<unknown>) => void;
export = catchFactory;
