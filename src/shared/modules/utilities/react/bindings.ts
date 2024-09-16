//!optimize 2

import { stableLerp } from "../primitives/number-utilities";
import { type Binding, createBinding, joinBindings } from "@rbxts/react";
import type { BindingOrValue } from "types/react-types";

export interface BindingApi<T> {
	readonly getValue: () => T;
	readonly subscribe: (callback: (newValue: T) => void) => () => void;
	readonly update: (newValue: T) => void;
}

export interface Lerpable<T> {
	readonly Lerp: (this: T, to: T, alpha: number) => T;
}

type Bindable<T = unknown> = Binding<T> | NonNullable<T>;

type ComposeBindings<T extends Array<Bindable>> = {
	readonly [K in keyof T]: T[K] extends Bindable<infer U> ? U : T[K];
};

type BindingCombiner<T extends Array<Bindable>, U> = (...values: ComposeBindings<T>) => U;

/**
 * Returns whether the given value is a binding.
 * @param value The value to check.
 * @returns Whether the value is a binding.
 */
export function isBinding<T>(value: Binding<T> | T): value is Binding<T>;
export function isBinding<T = unknown>(value: unknown): value is Binding<T>;
export function isBinding(value: unknown): value is Binding<unknown> {
	return typeIs(value, "table") && "getValue" in value && "map" in value;
}

/**
 * Converts a value to a binding. If the given value is already a binding, it
 * will be returned as-is.
 * @param value The value to convert.
 * @returns The converted binding.
 */
export function toBinding<T>(value: Binding<T> | T): Binding<T> {
	if (isBinding(value)) return value;

	const [result] = createBinding(value);
	return result;
}

/**
 * Returns the value of a binding. If the given value is not a binding, it will
 * be returned as-is.
 * @param binding The binding to get the value of.
 * @returns The value of the binding.
 */
export function getBindingValue<T>(binding: Binding<T> | T): T {
	return isBinding(binding) ? binding.getValue() : binding;
}

/**
 * Maps a binding to a new binding. If the given value is not a binding, it will
 * be passed to the mapper function and returned as a new binding.
 * @param binding The binding to map.
 * @param callback The mapper function.
 * @returns The mapped binding.
 */
export function mapBinding<T, U>(binding: Binding<T> | T, callback: (value: T) => U): Binding<U> {
	if (isBinding(binding)) return binding.map(callback);

	const [result] = createBinding(callback(binding as T));
	return result;
}

/**
 * Joins a map of bindings into a single binding. If any of the given values
 * are not bindings, they will be wrapped in a new binding.
 * @param bindings The bindings to join.
 * @returns The joined binding.
 */
export function joinAnyBindings<T extends Readonly<Record<string, unknown>>>(
	bindings: T,
): Binding<{ [K in keyof T]: T[K] extends BindingOrValue<infer U> ? U : T[K] }>;
export function joinAnyBindings<T extends ReadonlyArray<unknown>>(
	bindings: readonly [...T],
): Binding<{ [K in keyof T]: T[K] extends BindingOrValue<infer U> ? U : T[K] }>;
export function joinAnyBindings(bindings: object): Binding<unknown> {
	const bindingsToMap = {} as Record<number | string, Binding<unknown>>;
	for (const [k, v] of pairs(bindings)) bindingsToMap[k as keyof object] = toBinding(v);
	return joinBindings(bindingsToMap);
}

/**
 * Gets the internal API of a binding. This is a hacky way to get access to the
 * `BindingInternalApi` object of a binding, which is not exposed by React.
 * @param binding The binding to get the internal API of.
 * @returns The binding's API.
 */
export function getBindingApi<T>(binding: Binding<T>) {
	for (const [key, value] of pairs(binding)) {
		const name = `${key}`;
		if (name === "Symbol(BindingImpl)" || name.sub(1, 12) === "RoactBinding")
			return value as unknown as BindingApi<T>;
	}

	return undefined;
}

/**
 * Returns a binding that lerps between two values using the given binding as
 * the alpha.
 * @param binding The binding to use as the alpha.
 * @param from The value to lerp from.
 * @param to The value to lerp to.
 * @returns A binding that lerps between two values.
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function lerpBinding<T extends Lerpable<any> | number>(
	binding: Binding<number> | number,
	from: T,
	to: T,
): Binding<T> {
	return mapBinding(binding, (alpha) =>
		typeIs(from, "number") ? stableLerp(from, to as number, alpha) : from.Lerp(to, alpha),
	);
}

/**
 * Composes multiple bindings or values together into a single binding.
 * Calls the combiner function with the values of the bindings when any
 * of the bindings change.
 * @param ...bindings A list of bindings or values.
 * @param combiner The function that maps the bindings to a new value.
 * @returns A binding that returns the result of the combiner.
 */
export function composeBindings<T extends Array<Bindable>, U>(...bindings: [...T, BindingCombiner<T, U>]): Binding<U>;

export function composeBindings<T>(
	...values: [...ReadonlyArray<Bindable>, BindingCombiner<Array<Bindable>, T>]
): Binding<T> {
	const combiner = values.pop() as BindingCombiner<Array<Bindable>, T>;
	const bindings = values.map(toBinding);

	return joinBindings(bindings).map((bindings) => combiner(...bindings));
}
