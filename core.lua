-- A sample addon to demonstrate how to use AceConfig and AceDB to set and save options in your World of Warcraft Addon
--
--   Following http://www.wowace.com/addons/ace3/pages/getting-started/ was very unclear to me so I thought doing this up
--   would help me work things through
--

local addonName = ...
local addonTitle = select(2, GetAddOnInfo(addonName))

TestAddonAceConfig = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0")

-- Details on the options table can be found here:
--   http://www.wowace.com/addons/ace3/pages/ace-config-3-0-options-tables/
local options = {
    name = addonName,
	desc = "Optional description? for the group of options",
	descStyle = "inline",
	icon = "Interface/icons/inv_helmet_50", -- this doesn't seem to show on the top level
    handler = TestAddonAceConfig,
    type = 'group',
    args = {
        msg = {
            type = 'input',
            name = 'My Message',
            desc = 'The message for my addon',
            set = 'SetMyMessage',
            get = 'GetMyMessage',
			order = 90, -- default is 100 so this will put it at the top of non-ordered ones?
        },
        flag1 = {
            type = 'toggle',
            name = 'First flag for my addon',
            desc = 'This can show as a tooltip for the input?',
            set = 'SetFlag1',
            get = 'GetFlag1',
			width = 'full', -- this keeps the checkboxes on one line each
        },
        flag2 = {
            type = 'toggle',
            name = 'Second flag for my addon',
            desc = 'This can show as a tooltip for the input?',
            set = 'SetFlag2',
            get = 'GetFlag2',
			width = 'full',
        },
        rangetest = {
            type = 'range',
            name = 'Range Test',
            desc = 'A range of values - displayed as a slider?',
			min = 10,
			max = 42,
			step = 1,
            set = function(info, val) TestAddonAceConfig.db.profile.rangetest = val end,
            get = function(info) return TestAddonAceConfig.db.profile.rangetest end,
			width = 'double',
			order = 110,
        },
		moreoptions = {
			name = "More options",
			desc = "Description of the other options",
			icon = "Interface/icons/inv_helmet_51",
			type = "group",
			width = "double",
			args = {
				-- more options go here
				--   this post helped http://forums.wowace.com/showthread.php?t=13755
				selecttest = {
					type = "select",
					name = "Select Test Greetings",
					desc = "Should be rendered as a dropdown box?",
					style = "dropdown",
					values = { ["A"] = "Hi", ["B"] = "Bye", ["Z"] = "Omega"},
					set = function(info, val) TestAddonAceConfig.db.profile.selecttest = val end,
					get = function(info) return TestAddonAceConfig.db.profile.selecttest end,
				},
				selectradiotest = {
					type = "select",
					name = "Which station?",
					desc = "Should be rendered as a radiobuttions?",
					style = "radio",
					values = { [1] = "107.1", [2] = "Chez 102", [3] = "The Rock"},
					set = function(info, val) TestAddonAceConfig.db.profile.selectradiotest = val end,
					get = function(info) return TestAddonAceConfig.db.profile.selectradiotest end,
				},
			},
		},
    },
}

-- TODO demo defaults

-- loading the options table first time out I was getting the following error
--      Cannot find a library instance of "AceGUI-3.0".
-- turns out it has some undocumented dependancies, which I added.  Also learned that the order of the includes in embeds.xml is important as well
local optionsTable = LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options, {"myslash", "myslashtwo"})
-- If you want an actual GUI for your addon in the standard interface options panel, as documented none 'ace' way
--     @ http://wow.gamepedia.com/Using_the_Interface_Options_Addons_panel
-- You need to use http://www.wowace.com/addons/ace3/pages/api/ace-config-dialog-3-0/ (not mentioned on the Getting started at all)
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function TestAddonAceConfig:OnInitialize()
	-- Code that you want to run when the addon is first loaded goes here.
	self.db = LibStub("AceDB-3.0"):New(addonName .. "DB") -- set default values here as well with an additional parameter
	-- TODO talk about using 'profiles' vs global
	-- Assuming `options` is your top-level options table and `self.db` is your database:
	-- options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	AceConfigDialog:AddToBlizOptions(addonName, addonTitle)
end

function TestAddonAceConfig:OnEnable()
    -- Called when the addon is enabled
end

function TestAddonAceConfig:OnDisable()
    -- Called when the addon is disabled
end

-- There is no magic connecting the options and the db.  You need to reference the fields directly in the get and sets.
function TestAddonAceConfig:GetMyMessage(info)
    return TestAddonAceConfig.db.profile.msg
end

function TestAddonAceConfig:SetMyMessage(info, input)
    TestAddonAceConfig.db.profile.msg = input
end

function TestAddonAceConfig:GetFlag1(info)
    return TestAddonAceConfig.db.profile.flag1
end

function TestAddonAceConfig:SetFlag1(info, input)
    TestAddonAceConfig.db.profile.flag1 = input
end

function TestAddonAceConfig:GetFlag2(info)
    return TestAddonAceConfig.db.profile.flag2
end

function TestAddonAceConfig:SetFlag2(info, input)
    TestAddonAceConfig.db.profile.flag2 = input
end

-- Give your addon a method to pop open the config settings
function TestAddonAceConfig:OpenConfig()
	InterfaceOptionsFrame_OpenToCategory(addonTitle)
	-- need to call it a second time as there is a bug where the first time it won't switch !BlizzBugsSuck has a fix
	InterfaceOptionsFrame_OpenToCategory(addonTitle)
end

--TestAddonAceConfig.db.global.var1="How does this work?"
--TestAddonAceConfig.db.global.var2=99
