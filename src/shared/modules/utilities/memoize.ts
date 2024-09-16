//!native
//!optimize 2

import { LFUCache, LRUCache } from "@rbxts/data-structures";

export function memoize<T, U>(memoizeFunction: (index: T) => U) {
	const cache = new Map<T, U>();

	function memoized(index: T): U {
		const cached = cache.get(index);
		if (cached !== undefined) return cached;

		const result = memoizeFunction(index);
		cache.set(index, result);
		return result;
	}

	return memoized;
}

export function memoizeMemorySafe<T, U extends defined>(memoizeFunction: (index: T) => U, capacity = 15) {
	const cache = new LFUCache<T, U>(capacity);

	function memoized(index: T): U {
		const cached = cache.get(index);
		if (cached !== undefined) return cached;

		const result = memoizeFunction(index);
		cache.set(index, result);
		return result;
	}

	return memoized;
}

export function memoizeMemorySafeRecent<T extends defined, U extends defined>(
	memoizeFunction: (index: T) => U,
	capacity = 15,
) {
	const cache = new LRUCache<T, U>(capacity);

	function memoized(index: T): U {
		const cached = cache.get(index);
		if (cached !== undefined) return cached;

		const result = memoizeFunction(index);
		cache.set(index, result);
		return result;
	}

	return memoized;
}
