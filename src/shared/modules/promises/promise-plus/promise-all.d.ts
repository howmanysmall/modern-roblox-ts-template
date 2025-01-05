/**
 * This exists solely to fix the problematic type I have with the default `Promise.all` type.
 *
 * Accepts an array of Promises and returns a new promise that:
 * - is resolved after all input promises resolve.
 * - is rejected if _any_ input promises reject.
 *
 * Note: Only the first return value from each promise will be present in the resulting array.
 *
 * After any input Promise rejects, all other input Promises that are still pending will be cancelled if they have no other consumers.
 *
 * ```lua
 * local promises = {
 *     returnsAPromise("example 1"),
 *     returnsAPromise("example 2"),
 *     returnsAPromise("example 3"),
 * }
 *
 * return Promise.all(promises)
 * ```
 */
declare function promiseAll<T extends Array<unknown>>(values: T): Promise<{ [P in keyof T]: Awaited<T[P]> }>;

export = promiseAll;
