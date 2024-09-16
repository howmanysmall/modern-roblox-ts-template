//!native
//!optimize 2

import { memoizeMemorySafe } from "../memoize";

export const fromEqual = memoizeMemorySafe((value: number) => new Vector2(value, value), 15);
export const fromX = memoizeMemorySafe((value: number) => new Vector2(value, 0), 15);
export const fromY = memoizeMemorySafe((value: number) => new Vector2(0, value), 15);

export const fromVector3 = memoizeMemorySafe((value: Vector3) => new Vector2(value.X, value.Z), 5);
export const fromVector3XY = memoizeMemorySafe((value: Vector3) => new Vector2(value.X, value.Y), 5);

export function fromVector3NoCache(value: Vector3) {
	return new Vector2(value.X, value.Z);
}
export function fromVector3XYNoCache(value: Vector3) {
	return new Vector2(value.X, value.Y);
}

export const center = new Vector2(0.5, 0.5);
export const infinity = new Vector2(math.huge, math.huge);
