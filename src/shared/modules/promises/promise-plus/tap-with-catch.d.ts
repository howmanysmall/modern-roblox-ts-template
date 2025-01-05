/**
 * Similar to `Promise.tap`, except it supports a catch function.
 * If you return a Promise from the tap handler callback, its value will be discarded but `tap` will still wait until it resolves before passing the original value through.
 */
declare function tapWithCatch<T>(
	promise: Promise<T>,
	tapHandler: (value: T) => void,
	tapCatchHandler?: (value: T) => void,
): Promise<T>;

export = tapWithCatch;
