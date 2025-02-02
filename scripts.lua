package.path = package.path .. ";/Users/davudmagomedov/.config/popusk/lua/?.lua"

require("rgb")

local function make_header(libentity)
	local header
	if libentity.etype == "document" then
		header = Styled:new_with(
			"[DOCUMENT]  " .. libentity.name,
			true,
			false,
			false,
			OwnColorMode,
			DefaultColorMode,
			{ 255, 128, 0 }
		):format()
	elseif libentity.etype == "section" then
		header = Styled:new_with(
			"[SECTION]  " .. libentity.name,
			true,
			false,
			false,
			OwnColorMode,
			DefaultColorMode,
			{ 255, 128, 0 }
		):format()
	else
		header = Styled:new_with(
			"[REGULAR]  " .. libentity.name,
			true,
			false,
			false,
			OwnColorMode,
			DefaultColorMode,
			{ 255, 128, 0 }
		):format()
	end

	return header
end

local function stringify_inoneline(array)
	local res = ""

	for i, ele in pairs(array) do
		if i == 1 then
			res = ele
		else
			res = res .. " " .. ele
		end
	end

	return res
end

function look_output(libentity, context)
	local res = ""

	local styled_name = make_header(libentity)

	local styled_id_kw = Styled:new_with("ID", false, false, true, DefaultColorMode, DefaultColorMode):format()
	local styled_path_kw = Styled:new_with("Path", false, false, true, DefaultColorMode, DefaultColorMode):format()
	local styled_tags_kw = Styled:new_with("Tags", false, false, true, DefaultColorMode, DefaultColorMode):format()

	local styled_id_val = Styled:new_with(libentity.id, true, false, false, DefaultColorMode, DefaultColorMode):format()
	local styled_path_val = Styled:new_with(libentity.path, true, false, false, DefaultColorMode, DefaultColorMode)
		:format()
	local styled_tags_val =
		Styled:new_with(stringify_inoneline(libentity.tags), true, false, false, DefaultColorMode, DefaultColorMode)
			:format()

	res = res .. styled_name .. "\n"

	if libentity.description ~= nil then
		local styled_description =
			Styled:new_with(libentity.description, false, true, false, OwnColorMode, DefaultColorMode, { 189, 99, 0 })
				:format()

		res = res .. styled_description .. "\n"
	end

	res = res .. "   " .. styled_id_kw .. ": " .. styled_id_val .. "\n"
	res = res .. "   " .. styled_path_kw .. ": " .. styled_path_val .. "\n"
	res = res .. "   " .. styled_tags_kw .. ": " .. styled_tags_val

	if libentity.etype == "document" then
		local styled_progress_kw = Styled:new_with("Progress", false, false, true, DefaultColorMode, DefaultColorMode)
			:format()
		local styled_progress_val = Styled:new_with(
			libentity.progress.passed .. "/" .. libentity.progress.ceiling,
			true,
			false,
			false,
			DefaultColorMode,
			DefaultColorMode
		):format()

		res = res .. "\n   " .. styled_progress_kw .. ": " .. styled_progress_val
	end

	return res
end

function list_output_narrow(libentities, context)
	local res = ""

	for _, libentity in pairs(libentities) do
		local styled_name = make_header(libentity)

		local styled_path = Styled:new_with(
			"[" .. libentity.path .. "]",
			false,
			true,
			false,
			OwnColorMode,
			DefaultColorMode,
			-- { 92, 92, 92 }
			{ 153, 76, 0 }
		)

		res = res .. styled_name:format() .. " " .. styled_path:format() .. "\n"
	end

	return res
end

function list_output_wide(libentities, context)
	local res = ""

	for _, libentity in pairs(libentities) do
		local look_res = look_output(libentity, context)
		res = res .. look_res .. "\n\n"
	end

	return res
end
