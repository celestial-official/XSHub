local randomString = function(length)
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local result = ""

	for i = 1, length do
		local rand = math.random(1, #chars)
		result = result .. chars:sub(rand, rand)
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
	local obfuscated = "if (true) then\n"
	obfuscated = obfuscated .. code .. "\nend"
	return obfuscated
end

local obfuscate = function(source, varName, watermark)
	varName = varName or "ObfVar_"
	watermark = watermark or "Celestial"

	local ticks = tick()
	local watermarkComment = string.format("--[[ %s | Secure by cel.offiii ]]--\n\n", watermark)
	local encryptedSource = encryptString(source)

	local sourceChunks = {}
	for i = 1, #encryptedSource, 10 do
		table.insert(sourceChunks, encryptedSource:sub(i, i + 9))
	end

	local randomVarName = varName .. randomString(10)
	local assembledSource = "local " .. randomVarName .. " = {"
	for _, chunk in ipairs(sourceChunks) do
		assembledSource = assembledSource .. string.format('"%s", ', chunk)
	end

	assembledSource = assembledSource .. "}"

	local finalCode = controlFlowObfuscate(assembledSource) .. "\n"
	finalCode = finalCode .. string.format("loadstring(table.concat(%s))()", randomVarName)

	setclipboard(finalCode)
end

return function(source, customVarName, watermark)
	task.spawn(function()
		obfuscate(source, customVarName, watermark)
	end)
end
