//!native
//!optimize 2

import { memoizeMemorySafe } from "../memoize";

namespace NumberUtilities {
	export const twoPower = memoizeMemorySafe((index: number) => 2 ** index, 512);

	export function getNumberFromString(value: number | string, defaultValue = 0) {
		if (value === undefined || !typeIs(value, "string"))
			return value !== undefined && typeIs(value, "number") ? value : defaultValue;

		const number = tonumber(value);
		if (number !== undefined) return number;

		const [match] = value.match("%-?%d+%.?%d*");
		return match === undefined ? defaultValue : (tonumber(match) ?? defaultValue);
	}

	export function simpleNumberFormat(number: number | string, separator = ",") {
		let value = typeIs(number, "number") ? `${number}` : number;
		let index = -1;

		while (index !== 0) [value, index] = value.gsub("^(-?%d+)(%d%d%d)", `%1${separator}%2`);
		return value;
	}

	export function lerp(start: number, finish: number, alpha: number) {
		return start + (finish - start) * alpha;
	}

	export function stableLerp(start: number, finish: number, alpha: number) {
		return alpha < 0.5 ? start + (finish - start) * alpha : finish - (finish - start) * (1 - alpha);
	}

	export function safeLerp(start: number, finish: number, alpha: number) {
		return (1 - alpha) * start + alpha * finish;
	}
}

export = NumberUtilities;
