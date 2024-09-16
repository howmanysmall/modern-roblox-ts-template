//!optimize 2

import type { Error } from "@rbxts/luau-polyfill";
import React from "@rbxts/react";

type FallbackRender = (properties: FallbackProperties) => unknown;

/**
 * Props for fallback components.
 */
export interface FallbackProperties {
	readonly error: Error;

	/**
	 * Resets the error boundary and calls `onReset` if provided. This is useful for reverting state or retrying the render.
	 */
	readonly resetErrorBoundary: Callback;
}

interface ErrorBoundarySharedProperties {
	readonly onError?: (error: Error, info: { componentStack: string }) => void;
	readonly onReset?: (
		details:
			| {
					readonly args: Array<unknown>;
					readonly reason: "imperative-api";
			  }
			| {
					readonly next?: Array<unknown>;
					readonly prev?: Array<unknown>;
					readonly reason: "keys";
			  },
	) => void;

	readonly resetKeys?: Array<unknown>;
}

/**
 * One of 3 types of fallback that can be provided to an error boundary.
 */
export interface ErrorBoundaryPropertiesWithComponent extends ErrorBoundarySharedProperties {
	readonly FallbackComponent: React.FunctionComponent;
}

/**
 * One of 3 types of fallback that can be provided to an error boundary.
 *
 * [Render prop](https://react.dev/reference/react/Children#calling-a-render-prop-to-customize-rendering) function that returns the fallback UI.
 * This is helpful if you want to handle errors differently based on the error.
 *
 * See [ErrorIn1SecondFallbackComponent](https://github.com/chriscerie/react-error-boundary/blob/main/stories/ErrorIn1SecondFallbackRender.story.lua) for a full example.
 *
 * Render prop functions are normal functions and are not React components. Attempting to use hooks in them will error!
 */
export interface ErrorBoundaryPropertiesWithRender extends ErrorBoundarySharedProperties {
	readonly fallbackRender: FallbackRender;
}

export interface ErrorBoundaryPropertiesWithFallback extends ErrorBoundarySharedProperties {
	readonly fallback: React.Element;
}

export type ErrorBoundaryProperties =
	| ErrorBoundaryPropertiesWithComponent
	| ErrorBoundaryPropertiesWithFallback
	| ErrorBoundaryPropertiesWithRender;
