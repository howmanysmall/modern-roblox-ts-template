//!optimize 2

import { useEffect, useMemo } from "@rbxts/react";

/**
 * Runs an async effect and cancels the promise when unmounting the effect.
 * Note that effects paused by `await` still run while cancelled, so prefer
 * to use promise chaining instead.
 *
 * @param effect The async effect to run.
 * @param dependencies The dependencies to run the effect on.
 */
export default function useAsyncEffect(effect: () => Promise<unknown>, dependencies?: ReadonlyArray<unknown>) {
	// eslint-disable-next-line react-roblox-hooks/exhaustive-deps
	const cachedEffect = useMemo(() => effect, dependencies);
	function asyncEffect() {
		const promise = cachedEffect();
		return () => promise.cancel();
	}
	useEffect(asyncEffect, [cachedEffect]);
}
