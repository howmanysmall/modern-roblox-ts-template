//!optimize 2

import React from "@rbxts/react";

export interface ErrorBoundaryContextType {
	readonly didCatch: boolean;
	readonly error: unknown;
	readonly resetErrorBoundary: Callback;
}

export const ErrorBoundaryContext = React.createContext<ErrorBoundaryContextType | undefined>(undefined);
export default ErrorBoundaryContext;
