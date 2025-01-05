//!optimize 2

export interface ConnectionLike {
	Disconnect(): void;
}

export interface SignalLike<T extends Callback = Callback> {
	Connect?(callback: T): ConnectionLike;
	connect?(callback: T): ConnectionLike;
}

export type InferSignalParameters<S> = S extends SignalLike<infer U> ? Parameters<U> : never;

const BASE_CONNECTION_LIKE: ConnectionLike = {
	Disconnect() {},
};

export default function connect<T extends SignalLike>(
	event: T,
	callback: (...signalArguments: InferSignalParameters<T>) => void,
): ConnectionLike {
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
