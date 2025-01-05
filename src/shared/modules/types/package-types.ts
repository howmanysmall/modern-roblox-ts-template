//!optimize 2

type AnyObject = { [key: string]: unknown };
type PrimitiveType = boolean | number | string;
type AtomicObject = Callback | Promise<unknown>;

/**
 * If the lib "ES2015.Collection" is not included in tsconfig.json,
 * types like ReadonlyArray, WeakMap etc. fall back to `any` (specified nowhere)
 * or `{}` (from the node types), in both cases entering an infinite recursion in
 * pattern matching type mappings
 * This type can be used to cast these types to `void` in these cases.
 */
type IfAvailable<T, Fallback = void> =
	| false // fallback if any
	| true extends (T extends never ? true : false)
	? Fallback // fallback if empty type
	: keyof T extends never
		? Fallback // original type
		: T;

/**
 * These should also never be mapped but must be tested after regular Map and
 * Set
 */
type WeakReferences = IfAvailable<WeakMap<AnyObject, unknown>> | IfAvailable<WeakSet<AnyObject>>;

/**
 * Types for the Immut package.
 */
namespace PackageTypes {
	export type WritableDraft<T> = { -readonly [K in keyof T]: Draft<T[K]> };
	export type Draft<T> = T extends PrimitiveType
		? T
		: T extends AtomicObject
			? T
			: T extends ReadonlyMap<infer K, infer V> // Map extends ReadonlyMap
				? Map<Draft<K>, Draft<V>>
				: T extends ReadonlySet<infer V> // Set extends ReadonlySet
					? Set<Draft<V>>
					: T extends WeakReferences
						? T
						: T extends object
							? WritableDraft<T>
							: T;
}

/**
 * Types for Flamework.
 */
namespace PackageTypes {
	export interface ClientReceiver<I extends Array<unknown>> {
		/**
		 * Connect to this networking event.
		 * @param callback The callback that will be fired
		 */
		connect(callback: (...parameters: I) => void): RBXScriptConnection;

		/**
		 * Fires a client event.
		 */
		predict(...parameters: I): void;
	}
	export interface ClientSender<I extends Array<unknown>, O> {
		(...parameters: I): Promise<O>;

		/**
		 * Sends this request to the server.
		 */
		invoke(...parameters: I): Promise<O>;

		/**
		 * Sends this request to the server, specifying a timeout.
		 * @param timeout The maximum time to wait before timing out
		 */
		invokeWithTimeout(timeout: number, ...parameters: I): Promise<O>;
	}

	export interface ServerSender<I extends Array<unknown>> {
		(player: Array<Player> | Player, ...parameters: I): void;

		/**
		 * Sends this request to all connected players.
		 */
		broadcast(...parameters: I): void;

		/**
		 * Sends this request to all players, excluding the specified player(s).
		 * @param players The player(s) that will not receive this event
		 */
		except(players: Array<Player> | Player, ...parameters: I): void;

		/**
		 * Sends this request to the specified player(s).
		 * @param players The player(s) that will receive this event
		 */
		fire(players: Array<Player> | Player, ...parameters: I): void;
	}
}

export = PackageTypes;
