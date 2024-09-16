//!optimize 2

import ErrorBoundary from "./error-boundary";
import type { ErrorBoundaryProperties } from "./types";
import React from "@rbxts/react";

/**
 *  This is a higher-order component that makes it easy to add an error boundary to an existing component. See
 *  [ErrorIn1SecondHOC](https://github.com/chriscerie/react-error-boundary/blob/main/stories/ErrorIn1SecondHOC.story.lua) for a full example.
 *
 * @param Component
 * @param errorBoundaryProps
 */
export function withErrorBoundary<Properties extends object>(
	Component: React.ComponentClass<Properties> | React.FunctionComponent<Properties> | string,
	errorBoundaryProperties: ErrorBoundaryProperties,
) {
	const Wrapped = React.forwardRef((properties: Properties, reference) => {
		const componentProperties = { ...properties, ref: reference };

		return (
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			<ErrorBoundary {...(errorBoundaryProperties as any)}>
				<Component {...componentProperties} key="component" />
			</ErrorBoundary>
		);
	});

	return Wrapped;
}

export default withErrorBoundary;
