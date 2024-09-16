//!native
//!optimize 2

export function createNextLayoutOrder(startAt = 0) {
	let layoutOrder = startAt;
	function getNext() {
		return layoutOrder++;
	}

	return getNext;
}

export function createUniqueKey() {
	const names = new Map<string, number>();

	function uniqueKeyGenerator(name: string): string {
		if (!names.has(name)) {
			names.set(name, 1);
			return name;
		}

		while (true) {
			const newValue = names.get(name)! + 1;
			names.set(name, newValue);
			const finalName = `${name}-${newValue}`;
			if (!names.has(finalName)) return finalName;
		}
	}

	return uniqueKeyGenerator;
}
