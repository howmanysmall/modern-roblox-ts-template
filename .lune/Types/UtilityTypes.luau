--!optimize 2
--!strict

export type Result<O, E> = {
	Success: true,
	Value: O,
} | {
	Success: false,
	Error: E,
}

return false
