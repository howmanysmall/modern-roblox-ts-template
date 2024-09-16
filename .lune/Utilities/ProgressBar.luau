--!optimize 2
--!strict

type ProgressOptions = {
	Fill: string?,
	Length: number?,
	PrintEnd: string?,
	PrintStart: string?,
	Surrounding: string?,
}
local BAR = utf8.char(9608)

local function ProgressBar(Iteration: number, Total: number, Options: ProgressOptions?)
	local TrueOptions: ProgressOptions = if Options then Options else {}
	local Length = TrueOptions.Length or 100
	local Surrounding = TrueOptions.Surrounding or "|"

	local FilledLength = math.floor(Length * Iteration // Total)
	return `{TrueOptions.PrintStart or "\r"}{Surrounding}{string.rep(TrueOptions.Fill or BAR, FilledLength)}{string.rep(
		"-",
		Length - FilledLength
	)}{Surrounding}{TrueOptions.PrintEnd or "\r"}`
end

return ProgressBar
