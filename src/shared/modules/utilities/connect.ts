//!native
//!optimize 2

export interface ConnectionLike {
	Disconnect(): void;
}

export interface SignalLike {
	Connect?(callback: Callback): ConnectionLike;
	connect?(callback: Callback): ConnectionLike;
}

export type InferSignalParameters<S> = S extends SignalLike
	? Parameters<
			Parameters<
				S["Connect"] extends Callback ? S["Connect"] : S["connect"] extends Callback ? S["connect"] : never
			>[0]
		>
	: never;

const BASE_CONNECTION_LIKE: ConnectionLike = {
	Disconnect() {},
};

export default function connect<T extends SignalLike>(
	event: T,
	callback: (...signalArguments: InferSignalParameters<T>) => void,
) {
	if ("Connect" in event) {
		assert(typeIs(event.Connect, "function"), "not a function");
		return event.Connect(callback);
	}

	if ("connect" in event) {
		assert(typeIs(event.connect, "function"), "not a function");
		return event.connect(callback);
	}

	return BASE_CONNECTION_LIKE;
}
