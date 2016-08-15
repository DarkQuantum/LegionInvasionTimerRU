
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local media = LibStub("LibSharedMedia-3.0")
local frame = LegionInvasionTimer
local db = legionTimerDB
local L
do
	local _, mod = ...
	L = mod.L
end

local function updateFlags()
	local flags = nil
	if db.monochrome and db.outline ~= "NONE" then
		flags = "MONOCHROME," .. db.outline
	elseif db.monochrome then
		flags = "MONOCHROME"
	elseif db.outline ~= "NONE" then
		flags = db.outline
	end
	return flags
end

local acOptions = {
	type = "group",
	name = "LegionInvasionTimer",
	get = function(info)
		return db[info[#info]]
	end,
	args = {
		lock = {
			type = "toggle",
			name = L.lock,
			order = 1,
			set = function(info, value)
				db.lock = value
				if value then
					frame:EnableMouse(false)
					frame.bg:Hide()
					frame.header:Hide()
				else
					frame:EnableMouse(true)
					frame.bg:Show()
					frame.header:Show()
				end
			end,
		},
		icon = {
			type = "toggle",
			name = L.barIcon,
			order = 2,
			set = function(info, value)
				db.icon = value
				frame.bar1:SetIcon(value and 236292) -- Interface\\Icons\\Ability_Warlock_DemonicEmpowerment
				frame.bar2:SetIcon(value and 236292)
			end,
		},
		timeText = {
			type = "toggle",
			name = L.showTime,
			order = 3,
			set = function(info, value)
				db.timeText = value
				frame.bar1:SetTimeVisibility(value)
				frame.bar2:SetTimeVisibility(value)
			end,
		},
		fill = {
			type = "toggle",
			name = L.fillBar,
			order = 4,
			set = function(info, value)
				db.fill = value
				frame.bar1:SetFill(value)
				frame.bar2:SetFill(value)
			end,
		},
		font = {
			type = "select",
			name = L.font,
			order = 5,
			values = media:List("font"),
			itemControl = "DDI-Font",
			get = function()
				for i, v in next, media:List("font") do
					if v == db.font then return i end
				end
			end,
			set = function(info, value)
				local list = media:List("font")
				local font = list[value]
				db.font = font
				frame.bar1.candyBarLabel:SetFont(media:Fetch("font", font), db.fontSize, updateFlags())
				frame.bar2.candyBarLabel:SetFont(media:Fetch("font", font), db.fontSize, updateFlags())
				frame.bar1.candyBarDuration:SetFont(media:Fetch("font", font), db.fontSize, updateFlags())
				frame.bar2.candyBarDuration:SetFont(media:Fetch("font", font), db.fontSize, updateFlags())
			end,
		},
		fontSize = {
			type = "range",
			name = L.fontSize,
			order = 6,
			max = 40,
			min = 6,
			step = 1,
			set = function(info, value)
				db.fontSize = value
				frame.bar1.candyBarLabel:SetFont(media:Fetch("font", db.font), value, updateFlags())
				frame.bar2.candyBarLabel:SetFont(media:Fetch("font", db.font), value, updateFlags())
				frame.bar1.candyBarDuration:SetFont(media:Fetch("font", db.font), value, updateFlags())
				frame.bar2.candyBarDuration:SetFont(media:Fetch("font", db.font), value, updateFlags())
			end,
		},
		monochrome = {
			type = "toggle",
			name = L.monochrome,
			order = 7,
			set = function(info, value)
				db.monochrome = value
				frame.bar1.candyBarLabel:SetFont(media:Fetch("font", db.font), db.fontSize, updateFlags())
				frame.bar2.candyBarLabel:SetFont(media:Fetch("font", db.font), db.fontSize, updateFlags())
				frame.bar1.candyBarDuration:SetFont(media:Fetch("font", db.font), db.fontSize, updateFlags())
				frame.bar2.candyBarDuration:SetFont(media:Fetch("font", db.font), db.fontSize, updateFlags())
			end,
		},
		outline = {
			type = "select",
			name = L.outline,
			order = 8,
			values = {
				NONE = L.none,
				OUTLINE = L.thin,
				THICKOUTLINE = L.thick,
			},
			set = function(info, value)
				db.outline = value
				frame.bar1.candyBarLabel:SetFont(media:Fetch("font", db.font), db.fontSize, updateFlags())
				frame.bar2.candyBarLabel:SetFont(media:Fetch("font", db.font), db.fontSize, updateFlags())
				frame.bar1.candyBarDuration:SetFont(media:Fetch("font", db.font), db.fontSize, updateFlags())
				frame.bar2.candyBarDuration:SetFont(media:Fetch("font", db.font), db.fontSize, updateFlags())
			end,
		},
		texture = {
			type = "select",
			name = L.texture,
			order = 9,
			values = media:List("statusbar"),
			itemControl = "DDI-Statusbar",
			get = function()
				for i, v in next, media:List("statusbar") do
					if v == db.texture then return i end
				end
			end,
			set = function(info, value)
				local list = media:List("statusbar")
				local texture = list[value]
				db.texture = texture
				frame.bar1:SetTexture(media:Fetch("statusbar", texture))
				frame.bar2:SetTexture(media:Fetch("statusbar", texture))
			end,
		},
		spacing = {
			type = "range",
			name = L.barSpacing,
			order = 10,
			max = 100,
			min = 0,
			step = 1,
			set = function(info, value)
				db.spacing = value
				if db.growUp then
					frame.bar2:SetPoint("BOTTOMLEFT", frame.bar1, "TOPLEFT", 0, value)
					frame.bar2:SetPoint("BOTTOMRIGHT", frame.bar1, "TOPRIGHT", 0, value)
				else
					frame.bar2:SetPoint("TOPLEFT", frame.bar1, "BOTTOMLEFT", 0, -value)
					frame.bar2:SetPoint("TOPRIGHT", frame.bar1, "BOTTOMRIGHT", 0, -value)
				end
			end,
		},
		width = {
			type = "range",
			name = L.barWidth,
			order = 11,
			max = 2000,
			min = 10,
			step = 1,
			set = function(info, value)
				db.width = value
				frame.bar1:SetWidth(value)
				frame.bar2:SetWidth(value)
			end,
		},
		height = {
			type = "range",
			name = L.barHeight,
			order = 12,
			max = 100,
			min = 5,
			step = 1,
			set = function(info, value)
				db.height = value
				frame.bar1:SetHeight(value)
				frame.bar2:SetHeight(value)
			end,
		},
		alignZone = {
			type = "select",
			name = L.alignZone,
			order = 13,
			values = {
				LEFT = L.left,
				CENTER = L.center,
				RIGHT = L.right,
			},
			set = function(info, value)
				db.alignZone = value
				frame.bar1.candyBarLabel:SetJustifyH(value)
				frame.bar2.candyBarLabel:SetJustifyH(value)
			end,
		},
		alignTime = {
			type = "select",
			name = L.alignTime,
			order = 14,
			values = {
				LEFT = L.left,
				CENTER = L.center,
				RIGHT = L.right,
			},
			set = function(info, value)
				db.alignTime = value
				frame.bar1.candyBarDuration:SetJustifyH(value)
				frame.bar2.candyBarDuration:SetJustifyH(value)
			end,
		},
		growUp = {
			type = "toggle",
			name = L.growUpwards,
			order = 15,
			set = function(info, value)
				db.growUp = value
				frame.bar1:ClearAllPoints()
				frame.bar2:ClearAllPoints()
				if value then
					frame.bar1:SetPoint("BOTTOM", frame, "TOP")
					frame.bar2:SetPoint("BOTTOMLEFT", frame.bar1, "TOPLEFT", 0, db.spacing)
					frame.bar2:SetPoint("BOTTOMRIGHT", frame.bar1, "TOPRIGHT", 0, db.spacing)
				else
					frame.bar1:SetPoint("TOP", frame, "BOTTOM")
					frame.bar2:SetPoint("TOPLEFT", frame.bar1, "BOTTOMLEFT", 0, -db.spacing)
					frame.bar2:SetPoint("TOPRIGHT", frame.bar1, "BOTTOMRIGHT", 0, -db.spacing)
				end
			end,
		},
		colorText = {
			name = L.textColor,
			type = "color",
			order = 16,
			get = function()
				return unpack(db.colorText)
			end,
			set = function(info, r, g, b, a)
				db.colorText = {r, g, b, a}
				frame.bar1:SetTextColor(r, g, b, a)
				frame.bar2:SetTextColor(r, g, b, a)
			end,
		},
		colorComplete = {
			name = L.completedBar,
			type = "color",
			order = 17,
			get = function()
				return unpack(db.colorComplete)
			end,
			set = function(info, r, g, b, a)
				db.colorComplete = {r, g, b, a}
				if frame.bar1:Get("LegionInvasionTimer:complete") == 1 then
					frame.bar1:SetColor(r, g, b, a)
				end
				if frame.bar2:Get("LegionInvasionTimer:complete") == 1 then
					frame.bar2:SetColor(r, g, b, a)
				end
			end,
		},
		colorIncomplete = {
			name = L.incompleteBar,
			type = "color",
			order = 18,
			get = function()
				return unpack(db.colorIncomplete)
			end,
			set = function(info, r, g, b, a)
				db.colorIncomplete = {r, g, b, a}
				if frame.bar1:Get("LegionInvasionTimer:complete") == 0 then
					frame.bar1:SetColor(r, g, b, a)
				end
				if frame.bar2:Get("LegionInvasionTimer:complete") == 0 then
					frame.bar2:SetColor(r, g, b, a)
				end
			end,
		},
	},
}

acr:RegisterOptionsTable(acOptions.name, acOptions, true)
acd:SetDefaultSize(acOptions.name, 400, 500)

