//!optimize 2
/* eslint-disable unicorn/prefer-export-from */

import ErrorBoundaryImp from "./error-boundary";
import ErrorBoundaryContextImp, {
	type ErrorBoundaryContextType as ErrorBoundaryContextTypeImp,
} from "./error-boundary-context";
import type {
	ErrorBoundaryProperties as ErrorBoundaryPropertiesImp,
	FallbackProperties as FallbackPropertiesImp,
} from "./types";
import useErrorBoundaryImp, { type UseErrorBoundaryApi as UseErrorBoundaryApiImp } from "./use-error-boundary";
import withErrorBoundaryImp from "./with-error-boundary";
import type { Error } from "@rbxts/luau-polyfill";

namespace ReactErrorBoundary {
	export const ErrorBoundary = ErrorBoundaryImp;
	export const ErrorBoundaryContext = ErrorBoundaryContextImp;
	export const useErrorBoundary = useErrorBoundaryImp;
	export const withErrorBoundary = withErrorBoundaryImp;

	export type ErrorBoundaryContextType = ErrorBoundaryContextTypeImp;
	export type ErrorBoundaryProperties = ErrorBoundaryPropertiesImp;
	export type FallbackProperties = FallbackPropertiesImp;
	export type UseErrorBoundaryApi<TError extends Error> = UseErrorBoundaryApiImp<TError>;
}

export = ReactErrorBoundary;
