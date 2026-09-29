--[[
    MOD MENU - NADEEM V9 ENGINE
    Protected by: OFFICIAL_NADEEM896211
    ENCRYPTED_BY_OFFICIAL_NADEEM896211
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

-- ============================================
-- PROTECTION AND ENCRYPTION
-- ============================================

local function DecryptString(encrypted)
    -- XOR decryption with key
    local key = "OFFICIAL_NADEEM896211"
    local result = ""
    for i = 1, #encrypted do
        local byte = string.byte(encrypted, i)
        local keyByte = string.byte(key, ((i-1) % #key) + 1)
        result = result .. string.char(bit.bxor(byte, keyByte))
    end
    return result
end

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
-- SECURITY BYPASS
-- ============================================

local function BypassSecurity()
    print("[NADEEM V9] Starting Security Bypass...")
    
    -- Disable security checks
    local SecurityUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
    if SecurityUtils then
        SecurityUtils.EnableSecurityChecks = false
        SecurityUtils.ReportException = function() end
        SecurityUtils.BugglyPostException = function() end
    end
    
    -- Disable TSS
    local TssSdk = require("TssSdk")
    if TssSdk then
        TssSdk.ReportData = function() end
        TssSdk.ScanMemory = function() return false end
    end
    
    -- Disable Beacon
    local BeaconSDK = require("BeaconSDK")
    if BeaconSDK then
        BeaconSDK.Report = function() end
        BeaconSDK.ReportEvent = function() end
    end
    
    print("[NADEEM V9] Security Bypass Complete!")
end

-- ============================================
-- AIMBOT SYSTEM
-- ============================================

local AimbotConfig = {
    OuterRange = 20,
    InnerRange = 2,
    Speed = 8,
    RangeRate = 5,
    SpeedRate = 8,
    RangeRateSight = 4,
    SpeedRateSight = 5,
    CrouchRate = 0.7,
    ProneRate = 0.3,
    DyingRate = 0.1,
    adsorbMaxRange = 200,
    adsorbMinRange = 100,
    adsorbActiveMinRange = 0
}

-- Bones configuration
local Bones = { neck_01 = 0 }

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
    
    local AllPlayers = Game.GetAllPlayerPawns()
    if not AllPlayers then return end
    
    for _, Player in pairs(AllPlayers) do
        if isValid(Player) and Player ~= MyChar then
            if Player.HealthStatus == "IsHealthStatusAlive" then
                local TeamID = Player.TeamID or 0
                local Location = Player:K2_GetActorLocation()
                local Distance = GetDistance(MyLocation, Location)
                
                if Distance < 600000 then
                    local IsEnemy = (TeamID ~= MyTeamID)
                    local PlayerName = Player.PlayerName or "UNKNOWN"
                    
                    if IsEnemy then
                        HUD:AddDebugText(string.format("[%.0fm] %s", Distance/100, PlayerName),
                                         Location.X, Location.Y, Location.Z,
                                         1, 0, 0, 1)
                    else
                        HUD:AddDebugText(string.format("[%.0fm] %s", Distance/100, PlayerName),
                                         Location.X, Location.Y, Location.Z,
                                         0, 0, 1, 1)
                    end
                end
            end
        end
    end
end

-- ============================================
-- PBC WALLHACK (Chams)
-- ============================================

local function SetupChamsConsole()
    local World = slua.getWorld()
    if World then
        World:ExecuteConsoleCommand("r.EnableDrawDyeingColor 1")
        World:ExecuteConsoleCommand("r.CustomDepth 3")
        World:ExecuteConsoleCommand("r.IdeaOutline.Enable 1")
        World:ExecuteConsoleCommand("r.Highlight.Enable 1")
        print("[PBC] Console ready")
    end
end

local function ApplyChamsToMesh(Mesh, VisibleColor, InvisibleColor)
    if not isValid(Mesh) then return end
    
    Mesh:SetDrawDyeing(true)
    Mesh:SetDrawDyeingMode(1)
    Mesh:SetVisibleDyeingColor(VisibleColor.R, VisibleColor.G, VisibleColor.B, VisibleColor.A)
    Mesh:SetOccludedDyeingColor(InvisibleColor.R, InvisibleColor.G, InvisibleColor.B, InvisibleColor.A)
    Mesh:SetDyeingColorFadeDistance(99999.0)
    Mesh:SetDyeingColorMinMaxDistance(0.0, 99999.0)
    Mesh:SetDrawHighlight(true)
    Mesh:OverrideHighlightColor(VisibleColor.R, VisibleColor.G, VisibleColor.B, VisibleColor.A)
    Mesh:SetHighlightCanBeOccluded(true)
    Mesh:SetDrawIdeaOutline(true)
    Mesh:SetIdeaOutlineNew(true)
    Mesh:SetIdeaOutlineOcclusionHighlight(true)
    Mesh:OverrideIdeaOutlineColor(VisibleColor.R, VisibleColor.G, VisibleColor.B, VisibleColor.A)
    Mesh:SetIdeaOutlineOcclusionColor(InvisibleColor.R, InvisibleColor.G, InvisibleColor.B, InvisibleColor.A)
    Mesh:OverrideIdeaOutlineThickness(20.0)
    Mesh:SetIdeaOverrideOutlineAndOcclusion(true)
    Mesh:SetRenderCustomDepth(true)
    Mesh:SetCustomDepthStencilValue(255)
end

function PBCWallhackLoop()
    if not _G.Mod_PBCWallhack_Enabled then return end
    
    if not _G._ChamsConsoleReady then
        SetupChamsConsole()
        _G._ChamsConsoleReady = true
    end
    
    local PC = GetPlayerController()
    if not isValid(PC) then return end
    
    local MyChar = PC:GetPlayerCharacterSafety()
    if not isValid(MyChar) then return end
    
    local MyTeamID = PC:GetTeamID() or 0
    local VisibleColor = GetESPColor(_G.ESPConfig.WallhackVisibleColor or 4)
    local InvisibleColor = GetESPColor(_G.ESPConfig.WallhackInvisibleColor or 3)
    
    local AllPlayers = Game.GetAllPlayerPawns()
    if not AllPlayers then return end
    
    for _, Player in pairs(AllPlayers) do
        if isValid(Player) and Player ~= MyChar then
            local TeamID = Player.TeamID or 0
            
            if TeamID ~= MyTeamID then
                local Mesh = Player:GetComponentByClass("Mesh")
                if isValid(Mesh) then
                    ApplyChamsToMesh(Mesh, VisibleColor, InvisibleColor)
                end
                
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
    local SafeDistance = 900000000
    
    for _, Player in pairs(AllPlayers) do
        if isValid(Player) and Player ~= MyChar then
            if Player.HealthStatus == "IsHealthStatusAlive" then
                local TeamID = Player.TeamID or 0
                if TeamID ~= MyTeamID then
                    local Location = Player:K2_GetActorLocation()
                    local Distance = GetDistance(MyLocation, Location)
                    
                    if Distance < SafeDistance then
                        EnemyCount = EnemyCount + 1
                        if Distance < 60000 then
                            DangerCount = DangerCount + 1
                        end
                    end
                end
            end
        end
    end
    
    if EnemyCount == 0 then
        HUD:AddDebugText("[ AREA SECURE ]", 0, 0, 0, 1, 1, 1, 1, 1.1)
    elseif DangerCount > 0 then
        HUD:AddDebugText(string.format("! WARNING : %d ENEMIES !", DangerCount), 0, 0, 0, 1, 0, 0, 1, 1.1)
    else
        HUD:AddDebugText(string.format("[ DANGER : %d ENEMIES ]", EnemyCount), 0, 0, 0, 1, 1, 0, 1, 1.1)
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
            
            if Distance < 900000000 then
                local DisplayName = Vehicle.DisplayName or "Vehicle"
                local VehicleAvatar = Vehicle:GetComponentByClass("VehicleAvatar")
                if isValid(VehicleAvatar) then
                    local AvatarID = VehicleAvatar:GetDefaultAvatarID()
                    if VehicleNames[AvatarID] then
                        DisplayName = VehicleNames[AvatarID]
                    end
                end
                
                HUD:AddDebugText(string.format("%s [%.0fm]", DisplayName, Distance/100),
                                 Location.X, Location.Y, Location.Z + 100,
                                 1, 1, 0, 1, 2.0)
            end
        end
    end
end

-- ============================================
-- 165 FPS UNLOCK
-- ============================================

local function Enable165FPSLogic()
    if not _G.Mod_FPS165_Enabled then return end
    
    local World = slua.getWorld()
    if World then
        World:ExecuteConsoleCommand("t.MaxFPS 165")
        World:ExecuteConsoleCommand("r.FrameRateLimit 165")
    end
    
    local SettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
    if SettingDB then
        local UIData = SettingDB.GetUIData()
        if UIData then
            UIData.FPSFineTuneSwitch = true
            UIData.FPSFineTuneNum = 165
        end
    end
    
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
    
    local ThirdPersonCamera = MyChar:GetComponentByClass("ThirdPersonCameraComponent")
    if isValid(ThirdPersonCamera) then
        if not MyChar.bIsWeaponAiming then
            local FOV = _G.Mod_iPadViewDistance or 90
            ThirdPersonCamera.FieldOfView = FOV
        end
    end
end

-- ============================================
-- MAIN UPDATE LOOP
-- ============================================

function OnTick()
    AimbotLoop()
    ESPLoop()
    PBCWallhackLoop()
    EnemyCounterLoop()
    VehicleESPLoop()
    EnableiPadViewUI()
    ApplyNoGrass()
end

-- ============================================
-- INITIALIZATION
-- ============================================

-- Run security bypass
BypassSecurity()

-- Initialize features
local function InitializeFeatures()
    local PC = GetPlayerController()
    if isValid(PC) then
        print("[NADEEM V9] ✅ Features Ready!")
        _G.Game:AddGameTimer(0.1, OnTick)
    else
        local retries = 0
        local function retryInit()
            retries = retries + 1
            if retries > 30 then
                print("[NADEEM V9] ❌ Failed to start features")
                return
            end
            
            local PC = GetPlayerController()
            if isValid(PC) then
                print("[NADEEM V9] ✅ Features Ready!")
                _G.Game:AddGameTimer(0.1, OnTick)
            else
                _G.Game:AddGameTimer(1.0, retryInit)
            end
        end
        _G.Game:AddGameTimer(1.0, retryInit)
    end
end

InitializeFeatures()

print("[NADEEM V9] ✅ All modules loaded successfully!")