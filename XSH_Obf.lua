local randomString = function(length)
	local chars = "..."
	local result = ""

	for i = 1, length do
		local rand = math.random(1, #chars)

		result = result..chars:sub(rand, rand)
	end
	
	return result
end

local encryptString = function(str)
	local key = "!XSH_"
	local encrypted = {}

	for i = 1, #str do
		local char = str:byte(i)
		local keyChar = key:byte((i - 1) % #key + 1)

		table.insert(encrypted, string.char(bit.bxor(char, keyChar)))
	end

	return table.concat(encrypted)
end

local stringToBinary = function(str)
	local binaryString = {}

	for i = 1, #str do
		local byte = str:byte(i)

		binaryString[i] = string.format("%08b", byte)
	end

	return table.concat(binaryString, " ")
end

local controlFlowObfuscate = function(code)
	local obfuscated = "if true then"

	obfuscated = obfuscated..code
	obfuscated = obfuscated.." end"

	return obfuscated
end

local obfuscate = function(source, varName, watermak)
	varName = varName or "ObfVar_"
	watermak = watermak or "Celestial"

	local ticks = tick()
	local watermarkComment = string.format("--[[ %s | Secure by cel.offiii ]]--\n\n", watermak)
	local encryptedSource = encryptString(source)

	local sourceChunks = {}
	for i = 1, #encryptedSource, 10 do
		table.insert(sourceChunks, encryptedSource:sub(i, i + 9))
	end

	local assembledSource = "local "..varName..randomString(10).." = {"
	for _, chunk in ipairs(sourceChunks) do
		assembledSource = assembledSource..string.format('"%s", ', chunk)
	end

	assembledSource = assembledSource.."}"

	local finalCode = controlFlowObfuscate(assembledSource)

	finalCode = finalCode..string.format("loadstring(table.concat(%s))()", varName..randomString(10))

	setclipboard(finalCode)
end

return function(source, customVarName, watermark)
	task.spawn(function()
		obfuscate(source, customVarName, watermark)
	end)
end
