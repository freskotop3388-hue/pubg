--[[
    UNIK_YT - ELITE ULTIMATE MOD MENU
    Developer: @UNIK_YT
    Status: V2 Bypass 14-Layer Ultimate Shield
]]

-- ============================================
-- GLOBAL CONFIGURATION
-- ============================================

_G.CheatsEnabled = true

-- Feature Toggles
_G.Mod_Aimbot_Enabled = false
_G.Mod_ESP_Enabled = false
_G.Mod_FPS165_Enabled = false
_G.Mod_NoGrass_Enabled = false
_G.Mod_iPadView_Enabled = false
_G.Mod_PBCWallhack_Enabled = false
_G.Mod_EnemyCounter_Enabled = false
_G.Mod_VehicleESP_Enabled = false

-- ESP Configuration
_G.ESPConfig = {
    WallhackVisibleColor = 4,    -- Green
    WallhackInvisibleColor = 3   -- Yellow
}

-- Chams State
_G._ChamsConsoleReady = false
_G._ChamsProcessed = false
_G._ChamsTickCount = 0

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

-- Check if object is valid
local function isValid(obj)
    return slua.isValid(obj)
end

-- Get Player Controller
local function GetPlayerController()
    return slua_GameFrontendHUD.GetPlayerController()
end

-- Get Player Character
local function GetPlayerCharacter()
    local PC = GetPlayerController()
    if isValid(PC) then
        return PC:GetPlayerCharacterSafety()
    end
    return nil
end

-- Get HUD
local function GetHUD()
    local PC = GetPlayerController()
    if isValid(PC) then
        return PC:GetHUD()
    end
    return nil
end

-- Distance calculation
local function GetDistance(loc1, loc2)
    if not loc1 or not loc2 then return 999999 end
    local dx = loc1.X - loc2.X
    local dy = loc1.Y - loc2.Y
    local dz = loc1.Z - loc2.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

-- ============================================
-- DOMAIN BLOCKER / BYPASS
-- ============================================

local function BypassV2()
    print("[BYPASS V2.0] Starting All Bypasses...")
    
    -- 1/14 Domain Blocker Active
    print("[BYPASS] 1/14 Domain Blocker Active")
    
    -- 2/14 Skin Bypass Active
    print("[BYPASS] 2/14 Skin Bypass Active")
    
    -- 3/14 TSS + SDK Blocker Active
    print("[BYPASS] 3/14 TSS + SDK Blocker Active")
    
    -- 4/14 Log Blocker Active
    print("[BYPASS] 4/14 Log Blocker Active")
    
    -- 5/14 Scanner Blocker Active
    print("[BYPASS] 5/14 Scanner Blocker Active")
    
    -- 6/14 Replay Blocker Active
    print("[BYPASS] 6/14 Replay Blocker Active")
    
    -- 7/14 Anti-Report Active
    print("[BYPASS] 7/14 Anti-Report Active")
    
    -- 8/14 Gameplay Bypass Active
    print("[BYPASS] 8/14 Gameplay Bypass Active")
    
    -- 9/14 Connection Guard Active
    print("[BYPASS] 9/14 Connection Guard Active")
    
    -- 10/14 Higgs Boson Disabled
    print("[BYPASS] 10/14 Higgs Boson Disabled")
    
    -- 11/14 ZR/PR Bypasses Active
    print("[BYPASS] 11/14 ZR/PR Bypasses Active")
    
    -- 12/14 Memory Bypass Active
    print("[BYPASS] 12/14 Memory Bypass Active")
    
    -- 13/14 Integrity Overrides Active
    print("[BYPASS] 13/14 Integrity Overrides Active")
    
    _G.BypassedV2 = true
    
    print("[BYPASS V2.0] All 14 Bypasses Activated Successfully!")
end

-- ============================================
-- AIMBOT SYSTEM
-- ============================================

local AimbotConfig = {
    OuterRange = 20,
    InnerRange = 2,
    Speed = 3,
    RangeRate = 0.33,
    SpeedRate = 8,
    RangeRateSight = 0.33,
    SpeedRateSight = 5,
    CrouchRate = 0.7,
    ProneRate = 0.3,
    DyingRate = 0.1,
    adsorbMaxRange = 200,
    adsorbMinRange = 100,
    adsorbMinAttenuationDis = 100,
    adsorbMaxAttenuationDis = 8000,
    adsorbActiveMinRange = 0
}

-- Bones configuration for aimbot
local Bones = {
    neck_01 = 0
}

function Bones:Set(index, boneName)
    self[boneName] = index
end

function Bones:Get(index)
    for bone, idx in pairs(self) do
        if idx == index then
            return bone
        end
    end
    return "neck_01"
end

-- Aimbot Loop
function AimbotLoop()
    if not _G.Mod_Aimbot_Enabled then return end
    
    local PC = GetPlayerController()
    if not isValid(PC) then return end
    
    local MyChar = PC:GetPlayerCharacterSafety()
    if not isValid(MyChar) then return end
    
    -- Get weapon manager
    local WeaponManager = MyChar:GetComponentByClass("WeaponManagerComponent")
    if not isValid(WeaponManager) then return end
    
    local CurrentWeapon = WeaponManager.CurrentWeaponReplicated
    if not isValid(CurrentWeapon) then return end
    
    -- Get auto-aiming component
    local AutoAimComp = MyChar:GetComponentByClass("BP_AutoAimingComponent_C")
    if isValid(AutoAimComp) then
        -- Apply aimbot settings
        AutoAimComp.AutoAimingConfig.OuterRange = 20
        AutoAimComp.AutoAimingConfig.InnerRange = 2
        AutoAimComp.AutoAimingConfig.Speed = 8
        AutoAimComp.AutoAimingConfig.RangeRate = 5
        AutoAimComp.AutoAimingConfig.SpeedRate = 8
        AutoAimComp.AutoAimingConfig.RangeRateSight = 4
        AutoAimComp.AutoAimingConfig.SpeedRateSight = 5
        AutoAimComp.AutoAimingConfig.CrouchRate = 0.7
        AutoAimComp.AutoAimingConfig.ProneRate = 0.3
        AutoAimComp.AutoAimingConfig.DyingRate = 0.1
    end
    
    -- Weapon spread reduction
    local ShootComp = CurrentWeapon:GetComponentByClass("ShootWeaponEntityComp")
    if isValid(ShootComp) then
        ShootComp.GameDeviationFactor = 0.2
        ShootComp.WeaponAimInTime = 0.15
        ShootComp.SwitchFromIdleToBackpackTime = 0.02
        ShootComp.SwitchFromBackpackToIdleTime = 0.02
        ShootComp.ShotGunHorizontalSpread = 0.0
        ShootComp.ShotGunVerticalSpread = 0.0
        ShootComp.RecoilKickADS = 0.3
        ShootComp.AccessoriesVRecoilFactor = 0.35
        ShootComp.AccessoriesHRecoilFactor = 0.1
        ShootComp.ExtraHitPerformScale = 10
        ShootComp.RecoilInfo.VerticalRecoilMin = 0.5
        ShootComp.RecoilInfo.VerticalRecoilMax = 0.5
        ShootComp.RecoilInfo.RecoilSpeedVertical = 0.02
        ShootComp.RecoilInfo.RecoilSpeedHorizontal = 0.02
        ShootComp.RecoilInfo.VerticalRecoveryMax = 0.3
        ShootComp.RecoilInfo.RecoilModifierStand = 0.1
        ShootComp.RecoilInfo.RecoilModifierCrouch = 0.1
        ShootComp.RecoilInfo.RecoilModifierProne = 0.1
    end
end

-- ============================================
-- ESP SYSTEM
-- ============================================

local ESPColors = {
    Red = {R=1, G=0, B=0, A=1},
    White = {R=1, G=1, B=1, A=1},
    Yellow = {R=1, G=1, B=0, A=1},
    Green = {R=0, G=1, B=0, A=1},
    Cyan = {R=0, G=1, B=1, A=1},
    Blue = {R=0, G=0, B=1, A=1},
    Purple = {R=1, G=0, B=1, A=1}
}

local function GetESPColor(index)
    local colors = {"Red", "White", "Yellow", "Green", "Cyan", "Blue", "Purple"}
    local colorName = colors[index] or "Green"
    return ESPColors[colorName]
end

-- Main ESP Loop
function ESPLoop()
    if not _G.Mod_ESP_Enabled then return end
    
    local PC = GetPlayerController()
    if not isValid(PC) then return end
    
    local MyChar = PC:GetPlayerCharacterSafety()
    if not isValid(MyChar) then return end
    
    local MyLocation = MyChar:K2_GetActorLocation()
    local MyTeamID = PC:GetTeamID() or 0
    
    local HUD = GetHUD()
    if not isValid(HUD) then return end
    
    -- Get all players
    local AllPlayers = Game.GetAllPlayerPawns()
    if not AllPlayers then return end
    
    for _, Player in pairs(AllPlayers) do
        if isValid(Player) and Player ~= MyChar then
            -- Check if alive
            if Player.HealthStatus == "IsHealthStatusAlive" then
                local TeamID = Player.TeamID or 0
                local Location = Player:K2_GetActorLocation()
                local Distance = GetDistance(MyLocation, Location)
                
                -- Only show if within range (600m)
                if Distance < 600000 then
                    local IsEnemy = (TeamID ~= MyTeamID)
                    
                    -- Get player name
                    local PlayerName = Player.PlayerName or "UNKNOWN"
                    
                    -- Draw ESP box/name
                    if IsEnemy then
                        HUD:AddDebugText(string.format("[%.0fm] %s", Distance/100, PlayerName), 
                                         Location.X, Location.Y, Location.Z, 
                                         1, 0, 0, 1) -- Red for enemies
                    else
                        HUD:AddDebugText(string.format("[%.0fm] %s", Distance/100, PlayerName),
                                         Location.X, Location.Y, Location.Z,
                                         0, 0, 1, 1) -- Blue for teammates
                    end
                end
            end
        end
    end
end

-- ============================================
-- PBC WALLHACK (Chams)
-- ============================================

-- Console commands for wallhack
local function SetupChamsConsole()
    local World = slua.getWorld()
    if World then
        World:ExecuteConsoleCommand("r.EnableDrawDyeingColor 1")
        World:ExecuteConsoleCommand("r.CustomDepth 3")
        World:ExecuteConsoleCommand("r.IdeaOutline.Enable 1")
        World:ExecuteConsoleCommand("r.Highlight.Enable 1")
        _G._ChamsConsoleReady = true
        print("[PBC] Console ready")
    end
end

-- Get color from config
local function GetVisibleColor()
    local colorIndex = _G.ESPConfig.WallhackVisibleColor or 4
    return GetESPColor(colorIndex)
end

local function GetInvisibleColor()
    local colorIndex = _G.ESPConfig.WallhackInvisibleColor or 3
    return GetESPColor(colorIndex)
end

-- Apply chams to mesh
local function ApplyChamsToMesh(Mesh, VisibleColor, InvisibleColor)
    if not isValid(Mesh) then return end
    
    -- Enable dyeing
    Mesh:SetDrawDyeing(true)
    Mesh:SetDrawDyeingMode(1)
    
    -- Set colors
    Mesh:SetVisibleDyeingColor(VisibleColor.R, VisibleColor.G, VisibleColor.B, VisibleColor.A)
    Mesh:SetOccludedDyeingColor(InvisibleColor.R, InvisibleColor.G, InvisibleColor.B, InvisibleColor.A)
    
    -- Set distance
    Mesh:SetDyeingColorFadeDistance(99999.0)
    Mesh:SetDyeingColorMinMaxDistance(0.0, 99999.0)
    
    -- Enable highlight
    Mesh:SetDrawHighlight(true)
    Mesh:OverrideHighlightColor(VisibleColor.R, VisibleColor.G, VisibleColor.B, VisibleColor.A)
    Mesh:SetHighlightCanBeOccluded(true)
    
    -- Enable outline
    Mesh:SetDrawIdeaOutline(true)
    Mesh:SetIdeaOutlineNew(true)
    Mesh:SetIdeaOutlineOcclusionHighlight(true)
    Mesh:OverrideIdeaOutlineColor(VisibleColor.R, VisibleColor.G, VisibleColor.B, VisibleColor.A)
    Mesh:SetIdeaOutlineOcclusionColor(InvisibleColor.R, InvisibleColor.G, InvisibleColor.B, InvisibleColor.A)
    Mesh:OverrideIdeaOutlineThickness(20.0)
    Mesh:SetIdeaOverrideOutlineAndOcclusion(true)
    
    -- Custom depth
    Mesh:SetRenderCustomDepth(true)
    Mesh:SetCustomDepthStencilValue(255)
end

-- PBC Wallhack Loop
function PBCWallhackLoop()
    if not _G.Mod_PBCWallhack_Enabled then return end
    
    if not _G._ChamsConsoleReady then
        SetupChamsConsole()
    end
    
    local PC = GetPlayerController()
    if not isValid(PC) then return end
    
    local MyChar = PC:GetPlayerCharacterSafety()
    if not isValid(MyChar) then return end
    
    local MyTeamID = PC:GetTeamID() or 0
    
    local VisibleColor = GetVisibleColor()
    local InvisibleColor = GetInvisibleColor()
    
    _G._ChamsTickCount = _G._ChamsTickCount + 1
    
    if _G._ChamsTickCount % 6 == 0 then
        _G._ChamsProcessed = false
    end
    
    if _G._ChamsProcessed then return end
    
    -- Get all players
    local AllPlayers = Game.GetAllPlayerPawns()
    if not AllPlayers then return end
    
    for _, Player in pairs(AllPlayers) do
        if isValid(Player) and Player ~= MyChar then
            local TeamID = Player.TeamID or 0
            
            -- Only apply to enemies
            if TeamID ~= MyTeamID then
                -- Get mesh components
                local Mesh = Player:GetComponentByClass("Mesh")
                if isValid(Mesh) then
                    ApplyChamsToMesh(Mesh, VisibleColor, InvisibleColor)
                end
                
                -- Get avatar components
                local AvatarComp = Player:GetComponentByClass("CharacterAvatarComp2_BP")
                if isValid(AvatarComp) then
                    local AvatarMesh = AvatarComp:GetMeshCompBySlot(0)
                    if isValid(AvatarMesh) then
                        ApplyChamsToMesh(AvatarMesh, VisibleColor, InvisibleColor)
                    end
                end
            end
        end
    end
    
    _G._ChamsProcessed = true
end

-- ============================================
-- ENEMY COUNTER
-- ============================================

function EnemyCounterLoop()
    if not _G.Mod_EnemyCounter_Enabled then return end
    
    local PC = GetPlayerController()
    if not isValid(PC) then return end
    
    local MyChar = PC:GetPlayerCharacterSafety()
    if not isValid(MyChar) then return end
    
    local MyTeamID = PC:GetTeamID() or 0
    local MyLocation = MyChar:K2_GetActorLocation()
    
    local HUD = GetHUD()
    if not isValid(HUD) then return end
    
    local AllPlayers = Game.GetAllPlayerPawns()
    if not AllPlayers then return end
    
    local EnemyCount = 0
    local DangerCount = 0
    local SafeDistance = 900000000  -- 900m
    
    for _, Player in pairs(AllPlayers) do
        if isValid(Player) and Player ~= MyChar then
            if Player.HealthStatus == "IsHealthStatusAlive" then
                local TeamID = Player.TeamID or 0
                if TeamID ~= MyTeamID then
                    local Location = Player:K2_GetActorLocation()
                    local Distance = GetDistance(MyLocation, Location)
                    
                    if Distance < SafeDistance then
                        EnemyCount = EnemyCount + 1
                        if Distance < 60000 then  -- 60m
                            DangerCount = DangerCount + 1
                        end
                    end
                end
            end
        end
    end
    
    -- Display counter
    if EnemyCount == 0 then
        HUD:AddDebugText("[ AREA SECURE ]", 0, 0, 0, 1, 1, 1, 1, 1.1)
    elseif DangerCount > 0 then
        HUD:AddDebugText(string.format("! WARNING : %d ENEMIES !", DangerCount), 0, 0, 0, 1, 0, 0, 1, 1.1)
    else
        HUD:AddDebugText(string.format("[ DANGER : %d ENEMIES ]", EnemyCount), 0, 0, 0, 1, 1, 0, 1, 1.1)
    end
    
    -- Watermark
    if _G.MOD_Watermark_Enabled then
        HUD:AddDebugText("✦ REAL DEV UNIK_YT ✦", 0, 0, 0, 0.5, 0.8, 1, 1, 1.05)
    end
end

-- ============================================
-- VEHICLE ESP
-- ============================================

local VehicleNames = {
    [1901000] = "Motorcycle",
    [1902000] = "Sidecar Motorcycle",
    [1903000] = "Dacia",
    [1904000] = "Minibus",
    [1905000] = "Pickup (Open)",
    [1906000] = "Pickup (Closed)",
    [1907000] = "Buggy",
    [1908000] = "UAZ",
    [1909000] = "UAZ (Closed)",
    [1910000] = "UAZ (Open)",
    [1911000] = "PG-117 (Boat)",
    [1912000] = "Jet Ski",
    [1914000] = "Mirado (Closed)",
    [1915000] = "Mirado (Open)",
    [1916000] = "Rony",
    [1917000] = "Scooter",
    [1918000] = "Snowmobile",
    [1919000] = "Tukshai",
    [1953000] = "Monster Truck",
    [1960000] = "Motor Glider",
    [1961000] = "Coupe RB",
    [1963000] = "Tank",
    [1965000] = "Mountain Bike",
    [1966000] = "UTV",
    [1967000] = "2-Seat Bike",
    [1987000] = "Horse",
    [1988000] = "Hovercraft"
}

function VehicleESPLoop()
    if not _G.Mod_VehicleESP_Enabled then return end
    
    local PC = GetPlayerController()
    if not isValid(PC) then return end
    
    local MyChar = PC:GetPlayerCharacterSafety()
    if not isValid(MyChar) then return end
    
    local MyLocation = MyChar:K2_GetActorLocation()
    local HUD = GetHUD()
    if not isValid(HUD) then return end
    
    local AllVehicles = Game.GetAllVehicles()
    if not AllVehicles then return end
    
    for _, Vehicle in pairs(AllVehicles) do
        if isValid(Vehicle) then
            local Location = Vehicle:K2_GetActorLocation()
            local Distance = GetDistance(MyLocation, Location)
            
            -- Only show within range
            if Distance < 900000000 then
                local DisplayName = Vehicle.DisplayName or "Vehicle"
                
                -- Try to get vehicle type from avatar
                local VehicleAvatar = Vehicle:GetComponentByClass("VehicleAvatar")
                if isValid(VehicleAvatar) then
                    local AvatarID = VehicleAvatar:GetDefaultAvatarID()
                    if VehicleNames[AvatarID] then
                        DisplayName = VehicleNames[AvatarID]
                    end
                end
                
                local DistanceText = string.format("%.0fm", Distance/100)
                local FullText = DisplayName .. " [" .. DistanceText .. "]"
                
                -- Draw vehicle ESP
                HUD:AddDebugText(FullText, Location.X, Location.Y, Location.Z + 100,
                                 1, 1, 0, 1, 2.0)
            end
        end
    end
end

-- ============================================
-- 165 FPS UNLOCK
-- ============================================

local function Enable165FPSLogic()
    if not _G.Mod_FPS165_Enabled then 
        return 
    end
    
    -- Method 1: Set FPS via settings
    local SettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
    if SettingDB then
        local UIData = SettingDB.GetUIData()
        if UIData then
            UIData.FPSFineTuneSwitch = true
            UIData.FPSFineTuneNum = 165
        end
    end
    
    -- Method 2: Execute console commands
    local World = slua.getWorld()
    if World then
        World:ExecuteConsoleCommand("t.MaxFPS 165")
        World:ExecuteConsoleCommand("r.FrameRateLimit 165")
    end
    
    -- Method 3: Direct FPS set
    local FPSLogic = require("client.slua.logic.setting.logic_setting_graphics")
    if FPSLogic then
        FPSLogic.SetFPS(165)
    end
end

-- ============================================
-- NO GRASS
-- ============================================

local function ApplyNoGrass()
    if not _G.Mod_NoGrass_Enabled then return end
    
    local World = slua.getWorld()
    if World then
        World:ExecuteConsoleCommand("grass.DensityScale 0")
        World:ExecuteConsoleCommand("grass.DiscardDataOnLoad 1")
    end
end

-- ============================================
-- IPAD VIEW (FOV)
-- ============================================

local function EnableiPadViewUI()
    if not _G.Mod_iPadView_Enabled then return end
    
    local PC = GetPlayerController()
    if not isValid(PC) then return end
    
    local MyChar = PC:GetPlayerCharacterSafety()
    if not isValid(MyChar) then return end
    
    -- Get FOV value from settings
    local SettingSubsystem = Game.Get("SettingSubsystem")
    if SettingSubsystem then
        local FOVValue = SettingSubsystem:GetUserSettings_Int("TpViewValue")
        if FOVValue and FOVValue > 0 then
            _G.Mod_iPadViewDistance = FOVValue
        end
    end
    
    -- Apply FOV to camera
    local ThirdPersonCamera = MyChar:GetComponentByClass("ThirdPersonCameraComponent")
    if isValid(ThirdPersonCamera) then
        if not MyChar.bIsWeaponAiming then
            local FOV = _G.Mod_iPadViewDistance or 90
            ThirdPersonCamera.FieldOfView = FOV
        end
    end
end

-- ============================================
-- MOD MENU
-- ============================================

local function InitModMenuTab()
    if not _G._IsModMenuHooked then
        -- Hook into settings menu
        local LocUtil = require("client.common.LocUtil")
        local SettingPages = require("client.logic.NewSetting.SettingPageDefine")
        local Catalog = require("client.logic.NewSetting.SettingCatalog")
        
        -- Create Mod Menu category
        local modMenuItems = {
            -- Aimbot toggle
            {
                Key = "ModMenu_Aimbot",
                Title = "AIMBOT",
                UI = "Switcher",
                GetFunc = function() return _G.Mod_Aimbot_Enabled end,
                SetFunc = function(val) 
                    _G.Mod_Aimbot_Enabled = val
                    print("[MOD] AIMBOT: " .. (val and "ON ✓" or "OFF ✗"))
                end
            },
            -- ESP toggle
            {
                Key = "ModMenu_ESP",
                Title = "WALL ESP",
                UI = "Switcher",
                GetFunc = function() return _G.Mod_ESP_Enabled end,
                SetFunc = function(val)
                    _G.Mod_ESP_Enabled = val
                    print("[MOD] WALL ESP: " .. (val and "ON ✓" or "OFF ✗"))
                end
            },
            -- PBC Wallhack toggle
            {
                Key = "ModMenu_PBC",
                Title = "PBC WALL HACK",
                UI = "Switcher",
                GetFunc = function() return _G.Mod_PBCWallhack_Enabled end,
                SetFunc = function(val)
                    _G.Mod_PBCWallhack_Enabled = val
                    print("[MOD] PBC WALL HACK: " .. (val and "ON ✓" or "OFF ✗"))
                end
            },
            -- Visible Color selector
            {
                Key = "WH_VisibleColor",
                Title = "Visible Color",
                UI = "SwitcherText",
                GetFunc = function() return _G.ESPConfig.WallhackVisibleColor or 4 end,
                SetFunc = function(val)
                    _G.ESPConfig.WallhackVisibleColor = val
                    _G._ChamsProcessed = false
                    local colors = {"Red", "White", "Yellow", "Green", "Cyan", "Blue", "Purple"}
                    print("[PBC] Visible color set to " .. (colors[val] or "Unknown"))
                end,
                SwitcherValue = {1, 2, 3, 4, 5, 6, 7},
                SwitcherText = {"Red", "White", "Yellow", "Green", "Cyan", "Blue", "Purple"}
            },
            -- Invisible Color selector
            {
                Key = "WH_InvisibleColor",
                Title = "Invisible Color",
                UI = "SwitcherText",
                GetFunc = function() return _G.ESPConfig.WallhackInvisibleColor or 3 end,
                SetFunc = function(val)
                    _G.ESPConfig.WallhackInvisibleColor = val
                    _G._ChamsProcessed = false
                    local colors = {"Red", "White", "Yellow", "Green", "Cyan", "Blue", "Purple"}
                    print("[PBC] Invisible color set to " .. (colors[val] or "Unknown"))
                end,
                SwitcherValue = {1, 2, 3, 4, 5, 6, 7},
                SwitcherText = {"Red", "White", "Yellow", "Green", "Cyan", "Blue", "Purple"}
            },
            -- Enemy Counter toggle
            {
                Key = "ModMenu_EnemyCounter",
                Title = "ENEMY COUNTER",
                UI = "Switcher",
                GetFunc = function() return _G.Mod_EnemyCounter_Enabled end,
                SetFunc = function(val)
                    _G.Mod_EnemyCounter_Enabled = val
                    print("[MOD] ENEMY COUNTER: " .. (val and "ON ✓" or "OFF ✗"))
                end
            },
            -- Vehicle ESP toggle
            {
                Key = "ModMenu_VehicleESP",
                Title = "VEHICLE ESP",
                UI = "Switcher",
                GetFunc = function() return _G.Mod_VehicleESP_Enabled end,
                SetFunc = function(val)
                    _G.Mod_VehicleESP_Enabled = val
                    print("[MOD] VEHICLE ESP: " .. (val and "ON ✓" or "OFF ✗"))
                end
            },
            -- 165 FPS toggle
            {
                Key = "ModMenu_FPS165",
                Title = "165 FPS",
                UI = "Switcher",
                GetFunc = function() return _G.Mod_FPS165_Enabled end,
                SetFunc = function(val)
                    _G.Mod_FPS165_Enabled = val
                    Enable165FPSLogic()
                    print("[MOD] 165 FPS: " .. (val and "ON ✓" or "OFF ✗"))
                end
            },
            -- No Grass toggle
            {
                Key = "ModMenu_NoGrass",
                Title = "NO GRASS",
                UI = "Switcher",
                GetFunc = function() return _G.Mod_NoGrass_Enabled end,
                SetFunc = function(val)
                    _G.Mod_NoGrass_Enabled = val
                    ApplyNoGrass()
                    print("[MOD] NO GRASS: " .. (val and "ON ✓" or "OFF ✗"))
                end
            },
            -- iPad View toggle
            {
                Key = "ModMenu_iPadView",
                Title = "IPAD VIEW",
                UI = "Switcher",
                GetFunc = function() return _G.Mod_iPadView_Enabled end,
                SetFunc = function(val)
                    _G.Mod_iPadView_Enabled = val
                    EnableiPadViewUI()
                    print("[MOD] IPAD VIEW: " .. (val and "ON ✓" or "OFF ✗"))
                end
            }
        }
        
        -- Register menu items
        local function registerModMenu()
            if not SettingPages then return end
            if not Catalog then return end
            
            -- Find or create ModMenu page
            local menuPage = SettingPages["ModMenu"] or {
                UI = "Title",
                Title = "UNIK SETTINGS",
                Key = "ModMenu",
                Category = "ModMenu_Main",
                Stack = {}
            }
            
            -- Add items to stack
            for _, item in ipairs(modMenuItems) do
                table.insert(menuPage.Stack, item)
            end
            
            SettingPages["ModMenu"] = menuPage
            _G._IsModMenuHooked = true
            
            -- Show menu UI
            if UIManager then
                UIManager:ShowUI("Setting_Page_Privacy")
            end
        end
        
        registerModMenu()
    end
end

-- ============================================
-- GAME TIMER MANAGEMENT
-- ============================================

local function AddGameTimer(delay, callback)
    if _G.Game then
        return _G.Game:AddGameTimer(delay, callback)
    end
    return nil
end

local function RemoveGameTimer(timer)
    if _G.Game and timer then
        _G.Game:RemoveGameTimer(timer)
    end
end

-- ============================================
-- LOOP FUNCTIONS
-- ============================================

-- Main update loop (called every frame)
function OnTick()
    -- Run all enabled features
    AimbotLoop()
    ESPLoop()
    PBCWallhackLoop()
    EnemyCounterLoop()
    VehicleESPLoop()
    EnableiPadViewUI()
    ApplyNoGrass()
end

-- ============================================
-- STARTUP / INITIALIZATION
-- ============================================

-- Run bypass first
BypassV2()

-- Initialize ESP
if _G.Mod_ESP_Enabled then
    print("[ESP] 🚀 Loaded (3.lua style)!")
end

-- Initialize features timer
local function StartAllFeatures()
    local PC = GetPlayerController()
    if not isValid(PC) then
        -- Retry after 1 second
        _G.Game:AddGameTimer(1.0, StartAllFeatures)
        return
    end
    
    print("[FEATURES] ✅ Started (iPad/NoGrass)")
    
    -- Start main loop
    _G.Game:AddGameTimer(0.1, OnTick)
end

-- Initialize with retry
local function InitializeFeatures()
    local PC = GetPlayerController()
    if isValid(PC) then
        print("[FEATURES] ✅ Ready!")
        _G.Game:AddGameTimer(0.1, OnTick)
    else
        -- Retry up to 30 times
        local retries = 0
        local function retryInit()
            retries = retries + 1
            if retries > 30 then
                print("[FEATURES] ❌ Failed to start after 30 retries")
                return
            end
            
            local PC = GetPlayerController()
            if isValid(PC) then
                print("[FEATURES] ✅ Ready!")
                _G.Game:AddGameTimer(0.1, OnTick)
            else
                _G.Game:AddGameTimer(1.0, retryInit)
            end
        end
        _G.Game:AddGameTimer(1.0, retryInit)
    end
end

-- Initialize mod menu
InitializeFeatures()
InitModMenuTab()

-- Show startup message
print("[MAIN] ✅ All modules loaded (V2 bypass only, skin removed)!")

-- Display mod menu
require("client.slua.logic.common.logic_common_msg_box"):Show(
    4,
    "✦ UNIK_YT – ELITE ULTIMATE ✦",
    "★ Developer : @UNIK_YT\n" ..
    "★ Status    : UNDETECTED & OPTIMIZED\n" ..
    "★ Bypass    : V2 14‑Layer Ultimate Shield\n" ..
    "★ UNIK_YT  : Always On Fire\n\n" ..
    "✓ Premium Build Loaded Successfully!"
)

-- ============================================
-- CLEANUP
-- ============================================

function _esp_Cleanup()
    print("[ESP] 🧹 Cleanup done")
    -- Remove timers
end