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

local function ProgressBar(iteration: number, total: number, options: ProgressOptions?): string
	local trueOptions: ProgressOptions = if options then options else {}
	local length = trueOptions.Length or 100
	local surrounding = trueOptions.Surrounding or "|"

	local filledLength = length * iteration // total
	return `{trueOptions.PrintStart or "\r"}{surrounding}{string.rep(trueOptions.Fill or BAR, filledLength)}{string.rep(
		"-",
		length - filledLength
	)}{surrounding}{trueOptions.PrintEnd or "\r"}`
end

return ProgressBar
