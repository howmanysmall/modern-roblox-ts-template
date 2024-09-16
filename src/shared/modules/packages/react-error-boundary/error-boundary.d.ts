import type { ErrorBoundaryProperties } from "./types";
import React from "@rbxts/react";

type PropertiesWithReference<T> = {
	readonly ref?: unknown;
} & T;

/**
 * This is a React component. Wrap an `ErrorBoundary` around other React components to "catch" errors
 * and render a fallback UI. The component supports several ways to render a fallback (shown below).
 *
 * First, create a fallback component.
 * ```ts
 * const Fallback: Roact.FunctionComponent<FallbackProperties> = () => (
 * 	<textlabel
 * 		AnchorPoint={new Vector2(0.5, 0.5)}
 * 		Position={UDim2.fromScale(0.5, 0.5)}
 * 		Size={UDim2.fromScale(0.5, 0.5)}
 * 		Text="An error was encountered!."
 * 	/>
 * );
 * ```
 *
 * Next, in your other components, wrap in an `ErrorBoundary` where needed. When an error is encountered somewhere in your app,
 * the nearest `ErrorBoundary` will catch and handle it. You don't need to wrap every component in an `ErrorBoundary`. Consider
 * the [granularity of error boundaries](https://aweary.dev/fault-tolerance-react/) and where it makes sense to display an error
 * message or revert states.
 *
 * `ErrorBoundary` requires a fallback component to be passed in as props. There are 3 ways to pass fallback components. See their
 * types documentation for usage.
 *
 * #### onError
 * When passed, `onError` gets called when an error is caught. This is useful for logging errors.
 *
 * ```ts
 * 	return (
 * 		<ErrorBoundary
 * 			FallbackComponent={Fallback}
 * 			onError={
 * 				(exception: Error, info: { componentStack: string }) =>
 * 					warn("Caught error:", exception, info)
 * 			}
 * 		>
 * 			<ComponentThatErrors key="ComponentThatErrors" />
 * 		</ErrorBoundary>
 * 	);
 * ```
 *
 * ### onReset
 * When passed, `onReset` gets called when the error boundary is reset by a call to `resetErrorBoundary` or when the `resetKeys` change.
 * This is useful for reverting state.
 *
 * See [ResetCount](https://github.com/chriscerie/react-error-boundary/blob/main/stories/ResetCount.story.lua) for a full example.
 *
 * ```ts
 * return (
 * 	<ErrorBoundary FallbackComponent={Fallback} onReset={(details) => warn("Error boundary was reset:", details)}>
 * 		<ComponentThatErrors key="ComponentThatErrors" />
 * 	</ErrorBoundary>
 * );
 * ```
 */
declare function ErrorBoundary(
	properties: PropertiesWithReference<React.PropsWithChildren<ErrorBoundaryProperties>>,
): React.Element;
// declare const ErrorBoundary: Roact.FunctionComponent<
// 	PropertiesWithRef<Roact.PropsWithChildren<ErrorBoundaryProperties>>
// >;

export = ErrorBoundary;
