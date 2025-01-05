//!optimize 2

export type DeepPartial<T> = { [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P] };
export type DeepReadonly<T> = { readonly [P in keyof T]: T[P] extends object ? DeepReadonly<T[P]> : T[P] };
export type DeepWritable<T> = { -readonly [P in keyof T]: T[P] extends object ? DeepWritable<T[P]> : T[P] };

export interface Disconnectable {
	Disconnect(): void;
}
export interface HeartbeatLike {
	Connect(callback: (deltaTime: number) => void): Disconnectable;
}

export type AnyArray<T> = Array<T> | ReadonlyArray<T>;
export type AnyMap<K, V> = Map<K, V> | ReadonlyMap<K, V>;
export type AnySet<T> = ReadonlySet<T> | Set<T>;
