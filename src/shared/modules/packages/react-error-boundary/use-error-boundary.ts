//!optimize 2

import assertErrorBoundaryContext from "./assert-error-boundary-context";
import ErrorBoundaryContext from "./error-boundary-context";
import type { Error } from "@rbxts/luau-polyfill";
import { useContext, useMemo, useState } from "@rbxts/react";

export interface UseErrorBoundaryApi<TError extends Error> {
	readonly resetBoundary: () => void;
	readonly showBoundary: (exception: TError) => void;
}

type HookState<TError extends Error> =
	| {
			readonly error: TError;
			readonly hasError: true;
	  }
	| {
			readonly error: undefined;
			readonly hasError: false;
	  };

/**
 * Convenient hook for imperatively invoking or resetting error boundaries.
 *
 * #### Invoking the nearest error boundary from an event handler
 *
 * React only handles errors thrown during render or during component lifecycle methods (e.g., useEffect, componentDidMount).
 * Error thrown in event handlers or in separate lua threads will not be automatically caught.
 *
 * A convenient pattern is to invoke the nearest error boundary when an error occurs in event handlers or in separate lua threads.
 *
 * #### Resetting the nearest error boundary
 *
 * `resetBoundary()` requests the nearest boundary to retry the render that originally failed and if passed,
 * invokes the boundary's `onReset` callback.
 *
 * A pattern is to just retry the render blindly and hope it succeeds on the second try. See
 * [RetryError](https://github.com/chriscerie/react-error-boundary/blob/main/stories/RetryError.story.lua) for a full example.
 *
 * A more common pattern is to revert some state and retry the render with the reverted state. See
 * [ResetCount](https://github.com/chriscerie/react-error-boundary/blob/main/stories/ResetCount.story.lua) for a full example.
 *
 * @returns
 */
export function useErrorBoundary<TError extends Error>(): Readonly<UseErrorBoundaryApi<TError>> {
	const context = assertErrorBoundaryContext(useContext(ErrorBoundaryContext));
	const [state, setState] = useState<HookState<TError>>({
		error: undefined,
		hasError: false,
	});

	const memoized = useMemo<Readonly<UseErrorBoundaryApi<TError>>>(
		() =>
			table.freeze({
				resetBoundary: () => {
					context.resetErrorBoundary();
					setState({
						error: undefined,
						hasError: false,
					});
				},

				showBoundary: (exception: TError) =>
					setState({
						error: exception,
						hasError: true,
					}),
			}),
		[context],
	);

	if (state.hasError) throw state.error;
	return memoized;
}

export default useErrorBoundary;
