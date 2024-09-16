//!optimize 2

import { useErrorBoundary } from "../packages/react-error-boundary";
import React, { useEffect } from "@rbxts/react";

export function FallbackResetBoundaryNoMemo(): React.Element {
	const { resetBoundary } = useErrorBoundary();

	function resetEffect() {
		resetBoundary();
	}
	useEffect(resetEffect, [resetBoundary]);

	return <></>;
}

export const FallbackResetBoundary = React.memo(FallbackResetBoundaryNoMemo);
FallbackResetBoundary.displayName = "FallbackResetBoundary";
export default FallbackResetBoundary;
