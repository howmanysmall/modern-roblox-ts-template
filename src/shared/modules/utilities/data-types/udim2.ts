//!native
//!optimize 2

import { memoizeMemorySafe } from "../memoize";

export const offset = memoizeMemorySafe((value: number) => UDim2.fromOffset(value, value), 15);
export function offsetFromVector2(value: Vector2) {
	return UDim2.fromOffset(value.X, value.Y);
}

export const scale = memoizeMemorySafe((value: number) => UDim2.fromScale(value, value), 15);
export function scaleFromVector2(value: Vector2) {
	return UDim2.fromScale(value.X, value.Y);
}

export const zero = new UDim2();

export const centerScale = UDim2.fromScale(0.5, 0.5);
export const oneScale = UDim2.fromScale(1, 1);
export const xScale = UDim2.fromScale(1, 0);
export const yScale = UDim2.fromScale(0, 1);

export const oneOffset = UDim2.fromOffset(1, 1);
export const xOffset = UDim2.fromOffset(1, 0);
export const yOffset = UDim2.fromOffset(0, 1);
