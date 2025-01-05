// talk about INFURIATING? AM I RIGHT????

interface ConnectionLike {
	Disconnect?(): void;
	disconnect?(): void;
}

/**
 * Converts an event into a Promise which resolves the next time the event fires.
 *
 * The optional `predicate` callback, if passed, will receive the event arguments and should return `true` or `false`, based on if this fired event should resolve the Promise or not. If `true`, the Promise resolves. If `false`, nothing happens and the predicate will be rerun the next time the event fires.
 *
 * The Promise will resolve with the event arguments.
 *
 * > This function will work given any object with a `Connect` method. This includes all Roblox events.
 * ```lua
 * -- Creates a Promise which only resolves when `somePart` is touched by a part named `"Something specific"`.
 * return Promise.fromEvent(somePart.Touched, function(part)
 *     return part.Name == "Something specific"
 * end)
 * ```
 */
declare function promiseFromEvent<A extends Array<unknown>>(
	event: RBXScriptSignal<(...signalArguments: A) => void>,
	predicate?: (...signalArguments: A) => boolean,
): Promise<A>;
declare function promiseFromEvent(event: RBXScriptSignal<() => void>, predicate?: () => boolean): Promise<void>;

declare function promiseFromEvent<A extends Array<unknown>>(
	event: { Connect: (callback: (...signalArguments: A) => void) => ConnectionLike },
	predicate?: (...signalArguments: A) => boolean,
): Promise<A>;
declare function promiseFromEvent(
	event: { Connect: (callback: () => void) => ConnectionLike },
	predicate?: () => boolean,
): Promise<void>;

declare function promiseFromEvent<A extends Array<unknown>>(
	event: { connect: (callback: (...signalArguments: A) => void) => ConnectionLike },
	predicate?: (...signalArguments: A) => boolean,
): Promise<A>;
declare function promiseFromEvent(
	event: { connect: (callback: () => void) => ConnectionLike },
	predicate?: () => boolean,
): Promise<void>;

declare function promiseFromEvent<A extends Array<unknown>>(
	event: { Connect: (callback: (...signalArguments: A) => void) => () => void },
	predicate?: (...signalArguments: A) => boolean,
): Promise<A>;
declare function promiseFromEvent(
	event: { Connect: (callback: () => void) => () => void },
	predicate?: () => boolean,
): Promise<void>;

declare function promiseFromEvent<A extends Array<unknown>>(
	event: { connect: (callback: (...signalArguments: A) => void) => () => void },
	predicate?: (...signalArguments: A) => boolean,
): Promise<A>;
declare function promiseFromEvent(
	event: { connect: (callback: () => void) => () => void },
	predicate?: () => boolean,
): Promise<void>;

export = promiseFromEvent;
