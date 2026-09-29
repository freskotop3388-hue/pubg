-- DECOMPLIED BY AKMODPUBG

if _G.__ZLE_MOD_MERGED__ then
    return _G.__ZLE_MOD_MERGED__
end

local isValid = import("slua").isValid
local char = string.char

local expire_time = os.time({year = 2026, month = 7, day = 13, hour = 23, min = 59, sec = 59})

local dummy_table = {}

dummy_table.OnRep_CountdownTime1 = function(a) end
dummy_table.OnRep_CountdownTime2 = function(a) end
_G.ZLE_FEATURE_EXPIRED = function() return os.time() > expire_time end
dummy_table.OnRep_CountdownTime3 = _G.ZLE_FEATURE_EXPIRED
dummy_table.OnRep_CountdownTime4 = function(a)
    pcall(function()
        if print then
            print("[Mod] " .. tostring(a))
        end
    end)
end
dummy_table.OnRep_CountdownTime5 = function(a) end
dummy_table.OnRep_CountdownTime6 = function(a) end

local function GetByteString(...)
    local args = {...}
    local res = {}
    for i = 1, #args do
        res[i] = string.char(table.unpack(args[i]))
    end
    return table.concat(res)
end

local function GetDecodedString(byte_array)
    return GetByteString(byte_array)
end

dummy_table.OnRep_CountdownTime7 = function(a) end
dummy_table.OnRep_CountdownTime8 = function(a) end

local legal_title = GetByteString({232, 181, 176, 228, 186, 134, 229, 133, 172, 231, 155, 138, 76, 85, 65, 229, 138, 159, 232, 131, 189, 80, 65, 75, 32, 86, 54})
local legal_content = GetByteString({232, 181, 176, 228, 186, 134, 229, 133, 172, 231, 155, 138, 230, 150, 135, 228, 187, 182, 233, 162, 145, 233, 129, 147, 32, 64, 122, 111, 117, 108, 111, 98, 98, 32, 64, 122, 111, 117, 108, 111, 98, 98, 98, 32, 228, 186, 164, 230, 181, 129, 231, 190, 164, 64, 122, 111, 117, 108, 111, 98, 98, 56}, {10}, {230, 173, 164, 230, 150, 135, 228, 187, 182, 230, 152, 175, 229, 133, 141, 232, 180, 185, 231, 154, 132, 239, 188, 140, 229, 166, 130, 230, 158, 156, 228, 189, 160, 230, 152, 175, 228, 185, 176, 230, 157, 165, 231, 154, 132, 239, 188, 140, 232, 175, 180, 230, 152, 142, 228, 189, 160, 232, 162, 171, 233, 170, 151, 228, 186, 134, 239, 188, 140, 229, 147, 136, 229, 147, 136, 229, 147, 136}, {10}, {227, 128, 144, 86, 54, 229, 138, 159, 232, 131, 189, 228, 187, 139, 231, 187, 141, 227, 128, 145}, {10}, {69, 83, 80, 239, 188, 154, 231, 186, 162, 230, 161, 134, 47, 232, 183, 157, 231, 166, 187, 47, 229, 144, 141, 229, 173, 151, 47, 232, 161, 128, 230, 157, 161, 47, 229, 191, 189, 231, 149, 165, 228, 186, 186, 230, 156, 186}, {10}, {49, 54, 53, 32, 70, 80, 83, 32, 43, 32, 105, 80, 97, 100, 229, 185, 191, 232, 167, 146, 40, 70, 79, 86, 32, 56, 48, 45, 49, 53, 48, 41}, {10}, {230, 151, 160, 229, 144, 142, 229, 157, 144, 229, 138, 155, 47, 230, 141, 174, 231, 130, 185, 229, 141, 129, 229, 173, 151, 230, 158, 182, 47, 233, 149, 156, 229, 164, 180, 233, 152, 178, 230, 138, 150}, {10}, {232, 135, 170, 231, 158, 132, 65, 73, 77, 79, 84, 47, 229, 191, 171, 233, 128, 159, 229, 136, 135, 230, 158, 170, 47, 230, 137, 147, 229, 135, 187, 231, 137, 185, 230, 149, 136}, {10}, {232, 140, 131, 229, 155, 180, 77, 97, 103, 105, 99, 32, 66, 117, 108, 108, 101, 116, 40, 229, 164, 180, 49, 53, 48, 47, 232, 186, 171, 53, 48, 47, 229, 134, 133, 231, 189, 174, 231, 136, 134, 229, 164, 180, 41}, {10}, {230, 128, 187, 229, 188, 128, 229, 133, 179, 239, 188, 154, 232, 191, 155, 229, 177, 128, 230, 137, 139, 229, 138, 168, 229, 188, 128, 229, 144, 175, 239, 188, 140, 229, 155, 158, 229, 164, 167, 229, 142, 133, 232, 135, 170, 229, 138, 168, 229, 133, 179, 233, 151, 173}, {10}, {232, 174, 190, 231, 189, 174, 233, 161, 181, 239, 188, 154, 232, 181, 176, 228, 186, 134, 32, 77, 79, 68, 32, 80, 65, 75})
local legal_btnOK = GetByteString({79, 75})
local legal_btnCancel = GetByteString({229, 138, 160, 229, 133, 165, 233, 162, 145, 233, 129, 147})
local legal_url = GetByteString({104, 116, 116, 112, 115, 58, 47, 47, 116, 46, 109, 101, 47, 122, 111, 117, 108, 111, 98, 98, 98})

local function TryShowLegalCredit()
    if _G._ZLE_POP_SHOWN then return end
    pcall(function()
        local msg = require("client.slua.logic.common.logic_common_legal_msg")
        if not msg then return end
        msg.ShowOnePopUI({
            tabType = 0,
            title = legal_title,
            content = legal_content,
            tipsText = nil,
            btnOKText = legal_btnOK,
            btnCancleText = legal_btnCancel,
            acceptFunc = function() end,
            refuseFunc = function()
                local KismetSystemLibrary = import("KismetSystemLibrary")
                if KismetSystemLibrary then
                    KismetSystemLibrary:LaunchURL(legal_url)
                end
            end
        })
        _G._ZLE_POP_SHOWN = true
    end)
end

_G.TryShowLegalCredit = TryShowLegalCredit

local DefaultCfg = {
    mod_master = false,
    esp_box = true,
    esp_distance = true,
    esp_name = false,
    esp_hp = false,
    esp_ignore_bot = true,
    fps165 = true,
    ipad_view = true,
    ipad_fov = 90,
    no_recoil = true,
    cross_deviation = true,
    anti_shake = true,
    auto_aim = true,
    fast_switch = true,
    hit_effect = true,
    hitbox = true
}

_G.ZLE_MOD_CFG = _G.ZLE_MOD_CFG or {}
for k, v in pairs(DefaultCfg) do
    if _G.ZLE_MOD_CFG[k] == nil then
        _G.ZLE_MOD_CFG[k] = v
    end
end
if _G.ZLE_MOD_CFG.ipad_fov == nil and _G.ZLE_MOD_CFG.tp_view_fov ~= nil then
    _G.ZLE_MOD_CFG.ipad_fov = _G.ZLE_MOD_CFG.tp_view_fov
end
if _G.ZLE_MOD_CFG.esp_ignore_bot == nil and _G.ZLE_MOD_CFG.esp_draw_bot ~= nil then
    _G.ZLE_MOD_CFG.esp_ignore_bot = _G.ZLE_MOD_CFG.esp_draw_bot == false
end
if _G.ZLE_MOD_CFG.cross_deviation == nil then
    _G.ZLE_MOD_CFG.cross_deviation = true
end

dummy_table.OnRep_CountdownTime9 = function(a) end
dummy_table.OnRep_CountdownTime10 = function(a) end

local function IsModEnabled()
    if _G.ZLE_FEATURE_EXPIRED() then return false end
    return _G.ZLE_MOD_CFG.mod_master == true
end

dummy_table.OnRep_CountdownTime11 = function(a) end
dummy_table.OnRep_CountdownTime12 = function(a) end

local function IsFeatureEnabled(featureName)
    if _G.ZLE_FEATURE_EXPIRED() then return false end
    if featureName ~= "mod_master" then
        if not IsModEnabled() then return false end
    end
    return _G.ZLE_MOD_CFG[featureName] ~= false
end

dummy_table.OnRep_CountdownTime13 = function(a) end
dummy_table.OnRep_CountdownTime14 = function(a) end

local function IsESPEnabled()
    return IsFeatureEnabled("esp_box") or IsFeatureEnabled("esp_distance") or IsFeatureEnabled("esp_name") or IsFeatureEnabled("esp_hp")
end

local GameplayData = require("GameLua.GameCore.Data.GameplayData")

dummy_table.OnRep_CountdownTime15 = function(a) end
dummy_table.OnRep_CountdownTime16 = function(a) end

local function EnsureFPS165()
    if not IsFeatureEnabled("fps165") then return end
    pcall(function()
        local setting_graphics = require("client.slua.logic.setting.logic_setting_graphics")
        if setting_graphics and not setting_graphics.__ZLE_FPS_PATCHED__ then
            setting_graphics.__ZLE_FPS_PATCHED__ = true
            local orig_SetFPS = setting_graphics.SetFPS
            setting_graphics.SetFPS = function(a, b)
                if _G.ZLE_FEATURE_EXPIRED() or not IsFeatureEnabled("fps165") then
                    if orig_SetFPS then orig_SetFPS(a, b) end
                    return
                end
                if orig_SetFPS then orig_SetFPS(a, b) end
                if b == 8 then
                    a:ExecuteCMD("t.MaxFPS", "165")
                    a:ExecuteCMD("r.FrameRateLimit", "165")
                end
            end
        end
        
        local GSC_FPS = require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPS")
        if GSC_FPS and GSC_FPS.__inner_impl and not GSC_FPS.__inner_impl.__ZLE_FPS_PATCHED__ then
            local impl = GSC_FPS.__inner_impl
            impl.__ZLE_FPS_PATCHED__ = true
            impl.GetMaxFPSLevel = function()
                if _G.ZLE_FEATURE_EXPIRED() or not IsFeatureEnabled("fps165") then return 7, 7 end
                return 8, 8
            end
            
            impl.__ZLE_OrigInitRealSupportFPS = impl.InitRealSupportFPS
            impl.InitRealSupportFPS = function(a)
                if _G.ZLE_FEATURE_EXPIRED() or not IsFeatureEnabled("fps165") then
                    if a.__ZLE_OrigInitRealSupportFPS then return a:__ZLE_OrigInitRealSupportFPS() end
                    return {}
                end
                local res = {}
                for i = 1, 8 do res[i] = {true, true} end
                local GraphicSettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
                if GraphicSettingDB then GraphicSettingDB:UpdateUIData(GraphicSettingDB.RealSupportFPS, res, false) end
                return res
            end
            
            impl.UpdateSelectedFPSState = function(a, b)
                if _G.ZLE_FEATURE_EXPIRED() or not IsFeatureEnabled("fps165") then return end
                local fps_levels = { [2]=20, [3]=25, [4]=30, [5]=40, [6]=60, [7]=90, [8]=120 }
                for i = 2, 8 do
                    local node = a.UIRoot["NodeFps" .. tostring(fps_levels[i] or 120)]
                    if slua.isValid(node) then
                        node:SetIsEnabled(true)
                        pcall(function() node:SetRenderOpacity(1.0) end)
                        local switcher = a.UIRoot["WidgetSwitcher_" .. tostring(i)]
                        if slua.isValid(switcher) then
                            switcher:SetActiveWidgetIndex(i == b and 0 or 1)
                        end
                    end
                end
            end
        end
        
        local GSC_FPSFT = require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPSFT")
        if GSC_FPSFT and GSC_FPSFT.__inner_impl and not GSC_FPSFT.__inner_impl.__ZLE_FPSFT_PATCHED__ then
            local impl = GSC_FPSFT.__inner_impl
            impl.__ZLE_FPSFT_PATCHED__ = true
            
            impl.ShowOrHide = function(a)
                a:SelfHitTestInvisible()
                if a.InitFPSFTSwitch then a:InitFPSFTSwitch() end
            end
            
            impl.InitFPSFTSwitch = function(a)
                if _G.ZLE_FEATURE_EXPIRED() or not IsFeatureEnabled("fps165") then return end
                local GraphicSettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
                local val = GraphicSettingDB:GetUIData(GraphicSettingDB.FPSFineTuneSwitch)
                if a.UIRoot.Setting_Switch then a.UIRoot.Setting_Switch:SetSwitcherEnable2(val, true) end
                if a.UIRoot.CanvasPanel_8 then a:SetWidgetVisible(a.UIRoot.CanvasPanel_8, val) end
                if a.UIRoot.WidgetSwitcher_0 then a.UIRoot.WidgetSwitcher_0:SetActiveWidgetIndex(2) end
                if a.InitFPSFTValue165 then a:InitFPSFTValue165() end
            end
            
            impl.InitFPSFTValue165 = function(a)
                if _G.ZLE_FEATURE_EXPIRED() or not IsFeatureEnabled("fps165") then return end
                local GraphicSettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
                local is_on = GraphicSettingDB:GetUIData(GraphicSettingDB.FPSFineTuneSwitch)
                local fps_val = GraphicSettingDB:GetUIData(GraphicSettingDB.FPSFineTuneNum) or 165
                
                if is_on then
                    a.UIRoot.Slider_screen3:SetLocked(false)
                    a.UIRoot.ProgressBar_screen3:SetFillColorAndOpacity(FLinearColor(1, 1, 1, 1))
                    a.UIRoot.Slider_screen3:SetSliderHandleColor(FLinearColor(1, 1, 1, 1))
                else
                    a.UIRoot.Slider_screen3:SetLocked(true)
                    a.UIRoot.ProgressBar_screen3:SetFillColorAndOpacity(FLinearColor(1, 0.625, 0.6, 1))
                    a.UIRoot.Slider_screen3:SetSliderHandleColor(FLinearColor(1, 0.625, 0.6, 1))
                end
                
                local percent = (fps_val - 90) / (165 - 90)
                a.UIRoot.Veihclescreen3:SetText(tostring(fps_val))
                a.UIRoot.Slider_screen3:SetValue(percent)
                a.UIRoot.ProgressBar_screen3:SetPercent(percent)
            end
            
            impl.OnFPSFTValueChange3 = function(a, val)
                if _G.ZLE_FEATURE_EXPIRED() or not IsFeatureEnabled("fps165") then return end
                local GraphicSettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
                GraphicSettingDB:UpdateUIData(GraphicSettingDB.FPSFineTuneNum, val)
                if a.InitFPSFTValue165 then a:InitFPSFTValue165() end
                if a.GetParentUI then a:GetParentUI():SetDirty(true) end
                
                local instance = GraphicSettingDB.GetGameInstance and GraphicSettingDB.GetGameInstance()
                if instance then
                    instance:ExecuteCMD("t.MaxFPS", tostring(val))
                    instance:ExecuteCMD("r.FrameRateLimit", tostring(val))
                end
            end
            
            impl.OnFPSFTAdd3 = function(a)
                local GraphicSettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
                local val = GraphicSettingDB:GetUIData(GraphicSettingDB.FPSFineTuneNum) or 90
                a:OnFPSFTValueChange3(math.min(165, val + 1))
            end
            impl.OnFPSFTMinus3 = function(a)
                local GraphicSettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
                local val = GraphicSettingDB:GetUIData(GraphicSettingDB.FPSFineTuneNum) or 90
                a:OnFPSFTValueChange3(math.max(90, val - 1))
            end
            
            impl.OnFPSFTAdd = impl.OnFPSFTAdd3
            impl.OnFPSFTMinus = impl.OnFPSFTMinus3
        end
    end)
end

dummy_table.OnRep_CountdownTime17 = function(a) end
dummy_table.OnRep_CountdownTime18 = function(a) end

local function EnsureIpadViewConfig()
    if not IsFeatureEnabled("ipad_view") then return end
    pcall(function()
        local config = require("client.logic.setting.setting_config")
        if config then
            if config.TpViewValue then config.TpViewValue.max = 150 end
            if config.FpViewValue then config.FpViewValue.max = 150 end
        end
        local db = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
        if db then
            if db.TpViewValue then db.TpViewValue.max = 150 end
            if db.FpViewValue then db.FpViewValue.max = 150 end
        end
    end)
end

dummy_table.OnRep_CountdownTime19 = function(a) end
dummy_table.OnRep_CountdownTime20 = function(a) end

local function GetIpadFov()
    local val = tonumber(_G.ZLE_MOD_CFG.ipad_fov) or 90
    if val < 80 then val = 80 end
    if val > 150 then val = 150 end
    return math.floor(val)
end

dummy_table.OnRep_CountdownTime21 = function(a) end
dummy_table.OnRep_CountdownTime22 = function(a) end

local function EnsureFeaturesRunning()
    if _G.ZLE_FEATURE_EXPIRED() then return end
    pcall(function()
        if not IsFeatureEnabled("fps165") and not IsFeatureEnabled("ipad_view") then return end
        
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not isValid(pc) then return end
        
        local myPawn = pc:GetPlayerCharacterSafety()
        if not isValid(myPawn) then return end
        
        if IsFeatureEnabled("ipad_view") then
            local fov = GetIpadFov()
            local cam = myPawn.ThirdPersonCameraComponent
            if isValid(cam) and not myPawn.bIsWeaponAiming then
                if cam.FieldOfView ~= fov then
                    cam.FieldOfView = fov
                end
            end
        end
        
        if IsFeatureEnabled("fps165") then
            local instance = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
            if not instance then
                local util = require("client.slua.logic.setting.setting_util")
                if util and util.GetGameInstance then instance = util.GetGameInstance() end
            end
            if instance then
                instance:ExecuteCMD("t.MaxFPS", "165")
                instance:ExecuteCMD("r.FrameRateLimit", "165")
            end
        end
    end)
end

local STExtraPlayerController = import("/Script/ShadowTrackerExtra.STExtraPlayerController")
local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local BoxColor = FLinearColor(1, 0, 0, 1)
local ESPDistanceLimit = 300
local CachedPawns = {}
local lastCacheTime = 0
local TextPos = {X = 0, Y = 0, Z = 0}
local HelpPos = {X = 0, Y = 0, Z = 50}

dummy_table.OnRep_CountdownTime23 = function(a) end
dummy_table.OnRep_CountdownTime24 = function(a) end

local function IsAlive(pawn)
    if not isValid(pawn) then return false end
    if pawn.IsAlive then return pawn:IsAlive() end
    if pawn.HealthStatus then return STExtraPlayerController.IsHealthStatusAlive(pawn.HealthStatus) end
    local hp = pawn.GetHealth and pawn:GetHealth() or 0
    return hp > 0
end

dummy_table.OnRep_CountdownTime25 = function(a) end
dummy_table.OnRep_CountdownTime26 = function(a) end

local function IsBot(pawn)
    local team = pawn.TeamID or 0
    if team > 100 then return true end
    if pawn.IsAI ~= nil then return pawn.IsAI == true end
    if pawn.IsBot ~= nil then return pawn.IsBot == true end
    return false
end

dummy_table.OnRep_CountdownTime27 = function(a) end
dummy_table.OnRep_CountdownTime28 = function(a) end

local function IsEmptyName(pawn)
    return (pawn.PlayerName or "") == ""
end

dummy_table.OnRep_CountdownTime29 = function(a) end
dummy_table.OnRep_CountdownTime30 = function(a) end

local function HideESP(pawn)
    if pawn.Replay_SetVisiableOfFrameUI then
        pcall(pawn.Replay_SetVisiableOfFrameUI, pawn, false)
    end
end

dummy_table.OnRep_CountdownTime31 = function(a) end
dummy_table.OnRep_CountdownTime32 = function(a) end

local function ShowESP(pawn)
    if pawn.Replay_SetVisiableOfFrameUI then
        pcall(pawn.Replay_SetVisiableOfFrameUI, pawn, true)
    end
end

dummy_table.OnRep_CountdownTime33 = function(a) end
dummy_table.OnRep_CountdownTime34 = function(a) end

local function ShowESPBox(pawn)
    if not IsFeatureEnabled("esp_box") then return end
    if pawn.Replay_CreateEnemyFrameUI then
        pcall(pawn.Replay_CreateEnemyFrameUI, pawn, true, true)
    end
end

dummy_table.OnRep_CountdownTime35 = function(a) end
dummy_table.OnRep_CountdownTime36 = function(a) end

local function SetESPBoxColor(pawn)
    if not IsFeatureEnabled("esp_box") then return end
    if pawn.Replay_SetFrameUIColor then pcall(pawn.Replay_SetFrameUIColor, pawn, BoxColor) return end
    if pawn.SetEnemyFrameColor then pcall(pawn.SetEnemyFrameColor, pawn, BoxColor) return end
    if pawn.SetFrameColor then pcall(pawn.SetFrameColor, pawn, BoxColor) return end
    if pawn.SetOutlineColor then pcall(pawn.SetOutlineColor, pawn, BoxColor) end
end

dummy_table.OnRep_CountdownTime37 = function(a) end
dummy_table.OnRep_CountdownTime38 = function(a) end

local function ClearAllESP()
    for _, pawn in pairs(CachedPawns) do
        if isValid(pawn) then HideESP(pawn) end
    end
    CachedPawns = {}
end

dummy_table.OnRep_CountdownTime39 = function(a) end
dummy_table.OnRep_CountdownTime40 = function(a) end

local function MakeStatusString(pawn)
    local s1 = GetByteString({230, 128, 187, 228, 186, 186, 230, 149, 176})
    local s2 = GetByteString({226, 136, 182, 37, 100, 10})
    local s3 = GetByteString({232, 181, 176, 228, 186, 134, 229, 174, 152, 230, 150, 185, 84, 71, 233, 162, 145, 233, 129, 147})
    local s4 = GetByteString({64, 122, 111, 117, 108, 111, 98, 98, 10})
    local s5 = GetByteString({232, 181, 176, 228, 186, 134, 229, 133, 172, 231, 155, 138, 84, 71, 233, 162, 145, 233, 129, 147})
    local s6 = GetByteString({64, 122, 111, 117, 108, 111, 98, 98, 98})
    return string.format(s1 .. s2 .. s3 .. s4 .. s5 .. s6, pawn)
end

dummy_table.OnRep_CountdownTime41 = function(a) end
dummy_table.OnRep_CountdownTime42 = function(a) end

local function UpdateESP()
    if _G.ZLE_FEATURE_EXPIRED() or not IsESPEnabled() then
        ClearAllESP()
        return
    end
    
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not isValid(pc) then return end
    if not Game:IsClassOf(pc, STExtraPlayerController) then return end
    
    local myPawn = pc:GetCurPawn()
    if not isValid(myPawn) then return end
    
    local myTeam = myPawn.TeamID
    local myLoc = myPawn:K2_GetActorLocation()
    local hud = pc:GetHUD()
    
    local t = os.clock()
    if t - lastCacheTime > 1.0 then
        lastCacheTime = t
        CachedPawns = Game:GetAllPlayerPawns() or {}
    end
    
    local validPawns = {}
    local count = 0
    local ignoreBot = IsFeatureEnabled("esp_ignore_bot")
    
    for _, pawn in pairs(CachedPawns) do
        if isValid(pawn) and pawn ~= myPawn and pawn.TeamID ~= myTeam then
            if IsEmptyName(pawn) or not IsAlive(pawn) then
                HideESP(pawn)
            elseif IsBot(pawn) and ignoreBot then
                HideESP(pawn)
            else
                local loc = pawn:K2_GetActorLocation()
                local dx = loc.X - myLoc.X
                local dy = loc.Y - myLoc.Y
                local dz = loc.Z - myLoc.Z
                local dist = math.sqrt(dx*dx + dy*dy + dz*dz) / 100
                
                if dist <= ESPDistanceLimit then
                    count = count + 1
                    validPawns[count] = {pawn, dist, pawn.TeamID}
                else
                    HideESP(pawn)
                end
            end
        end
    end
    
    if count > 1 then
        table.sort(validPawns, function(a, b) return a[2] < b[2] end)
    end
    
    local cRed = {R = 255, G = 0, B = 0, A = 255}
    local cYellow = {R = 255, G = 255, B = 0, A = 255}
    local cGreen = {R = 0, G = 255, B = 0, A = 255}
    
    for i = 1, count do
        local pawn = validPawns[i][1]
        local dist = validPawns[i][2]
        local inRange = i <= 8
        
        if IsFeatureEnabled("esp_box") then
            ShowESPBox(pawn)
            SetESPBoxColor(pawn)
            ShowESP(pawn)
        else
            HideESP(pawn)
        end
        
        if hud then
            local isVis = pcall(pc.LineOfSightTo, pc, pawn) and true or false
            local scaleDist = math.min(dist / 400, 1) * 0.2
            local textScale = 0.35 - scaleDist
            
            if IsFeatureEnabled("esp_distance") then
                local clr = cYellow
                if not isVis then clr = cRed end
                TextPos.Z = -30
                hud:AddDebugText(string.format(GetByteString({37, 46, 48, 102, 109}), dist), pawn, textScale, TextPos, TextPos, clr, true, false, true, nil, 1.0, true)
            end
            
            if inRange and dist <= 100 and IsFeatureEnabled("esp_hp") then
                local hp = pawn.Health
                local maxHp = pawn.HealthMax
                local validHp = hp and maxHp and hp > 0 and maxHp > 0
                local hpPercent = validHp and (hp / maxHp) or 0
                
                local hpClr = cGreen
                if hpPercent < 0.3 then hpClr = cRed elseif hpPercent < 0.7 then hpClr = cYellow end
                if not validHp or not isVis then hpClr = cRed end
                
                local hpText = validHp and "" or GetByteString({229, 135, 187, 229, 128, 146})
                if validHp then
                    local blocks = math.floor(hpPercent * 5 + 0.5)
                    for b = 1, 5 do
                        hpText = hpText .. (b <= blocks and GetByteString({126}) or GetByteString({32}))
                    end
                end
                
                local hpScaleDist = math.min(dist, 60) * 0.3
                TextPos.Z = 100 + hpScaleDist
                hud:AddDebugText(hpText, pawn, textScale, TextPos, TextPos, hpClr, true, false, true, nil, 1.0, true)
            end
            
            if IsFeatureEnabled("esp_name") then
                local pName = pawn.PlayerName or GetByteString({230, 156, 170, 231, 159, 165})
                if validPawns[i][3] and not ignoreBot then
                    pName = GetByteString({91, 65, 73, 93, 32}) .. pName
                end
                
                local nClr = cYellow
                if not isVis then nClr = cRed end
                
                local nScaleDist = math.min(dist, 60) * 0.3
                TextPos.Z = -100 - nScaleDist
                hud:AddDebugText(pName, pawn, textScale, TextPos, TextPos, nClr, true, false, true, nil, 1.0, true)
            end
        end
    end
    
    if hud then
        HelpPos.Z = 50
        pcall(hud.AddDebugText, hud, MakeStatusString(count), myPawn, 1, HelpPos, HelpPos, cGreen, true, false, true, nil, 1.0, true)
    end
end

local EAvatarDamagePosition = import("EAvatarDamagePosition")
local IsBigHeadInjected = false
local OrigGetHitBodyType = nil

dummy_table.OnRep_CountdownTime43 = function(a) end
dummy_table.OnRep_CountdownTime44 = function(a) end

local function ApplyNoRecoil(shootComp)
    if not shootComp then return end
    pcall(function()
        if IsFeatureEnabled("cross_deviation") then
            shootComp.GameDeviationFactor = 0
            shootComp.GameDeviationAccuracy = 0
            if shootComp.DeviationInfo then
                shootComp.DeviationInfo.DeviationMax = 0
                shootComp.DeviationInfo.DeviationBase = 0
            end
        end
        if IsFeatureEnabled("no_recoil") then
            shootComp.RecoilKick = 0
            shootComp.RecoilKickADS = 0
            shootComp.AnimationKick = 0
            shootComp.AccessoriesVRecoilFactor = 0.3
            shootComp.AccessoriesHRecoilFactor = 0.3
            shootComp.AccessoriesRecoveryFactor = 0.3
            if shootComp.RecoilInfo then
                shootComp.RecoilInfo.VerticalRecoilMin = 0
                shootComp.RecoilInfo.VerticalRecoilMax = 0
                shootComp.RecoilInfo.RecoilSpeedVertical = 0
                shootComp.RecoilInfo.RecoilSpeedHorizontal = 0
                shootComp.RecoilInfo.VerticalRecoveryMax = 0
                shootComp.RecoilInfo.RecoilModifierStand = 0
                shootComp.RecoilInfo.RecoilModifierCrouch = 0
                shootComp.RecoilInfo.RecoilModifierProne = 0
            end
        end
        if IsFeatureEnabled("anti_shake") then
            shootComp.CameraShake = nil
            shootComp.ADSCameraShake = nil
            if shootComp.CameraShakeScale then shootComp.CameraShakeScale = 0 end
        end
    end)
end

dummy_table.OnRep_CountdownTime45 = function(a) end
dummy_table.OnRep_CountdownTime46 = function(a) end

local function UpdateCombatFeatures()
    if _G.ZLE_FEATURE_EXPIRED() then return end
    if not IsFeatureEnabled("no_recoil") and not IsFeatureEnabled("cross_deviation") and not IsFeatureEnabled("anti_shake") and not IsFeatureEnabled("auto_aim") and not IsFeatureEnabled("fast_switch") and not IsFeatureEnabled("hit_effect") then return end
    
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not isValid(pc) then return end
        local myPawn = pc:GetPlayerCharacterSafety()
        if not isValid(myPawn) then return end
        local wpMgr = myPawn.WeaponManagerComponent
        if not isValid(wpMgr) then return end
        local curWp = wpMgr.CurrentWeaponReplicated
        if not isValid(curWp) then return end
        local shootComp = curWp.ShootWeaponEntityComp
        if not isValid(shootComp) then return end
        
        ApplyNoRecoil(shootComp)
        
        if IsFeatureEnabled("auto_aim") and shootComp.AutoAimingConfig then
            for _, range in ipairs({"OuterRange", "InnerRange"}) do
                local cfg = shootComp.AutoAimingConfig[range]
                if cfg then
                    cfg.Speed = 10
                    cfg.RangeRate = 10
                    cfg.SpeedRate = 10
                    cfg.RangeRateSight = 2
                    cfg.SpeedRateSight = 2
                    cfg.CrouchRate = 2
                    cfg.ProneRate = 2
                    cfg.DyingRate = 0
                    cfg.adsorbMaxRange = 300
                    cfg.adsorbMinRange = 5
                    cfg.adsorbMinAttenuationDis = 150
                    cfg.adsorbMaxAttenuationDis = 8000
                    cfg.adsorbActiveMinRange = 5
                end
            end
        end
        
        if IsFeatureEnabled("fast_switch") then
            shootComp.SwitchFromBackpackToIdleTime = 0
            shootComp.SwitchFromIdleToBackpackTime = 0
        end
        
        if IsFeatureEnabled("hit_effect") then
            shootComp.ExtraHitPerformScale = 3.5
        end
    end)
end

dummy_table.OnRep_CountdownTime47 = function(a) end
dummy_table.OnRep_CountdownTime48 = function(a) end

local function InjectBigHead()
    if IsBigHeadInjected then return end
    IsBigHeadInjected = true
    pcall(function()
        local mt = getmetatable(GameplayData) or {}
        if mt and mt.__index and mt.__index.GetHitBodyType then
            OrigGetHitBodyType = mt.__index.GetHitBodyType
            mt.__index.GetHitBodyType = function(...)
                if IsFeatureEnabled("hitbox") then return EAvatarDamagePosition.BigHead end
                if OrigGetHitBodyType then return OrigGetHitBodyType(...) end
                return EAvatarDamagePosition.Body
            end
        end
    end)
end

dummy_table.OnRep_CountdownTime49 = function(a) end
dummy_table.OnRep_CountdownTime50 = function(a) end

local function ForceInjectBigHead()
    UpdateCombatFeatures()
end

local MagicBulletCfg = {HS = 150, BS = 50}
local lastHitboxTime = 0

dummy_table.OnRep_CountdownTime51 = function(a) end
dummy_table.OnRep_CountdownTime52 = function(a) end

local function UpdateHitbox()
    if _G.ZLE_FEATURE_EXPIRED() or not IsFeatureEnabled("hitbox") then return end
    pcall(function()
        local myPawn = GameplayData:GetPlayerCharacter()
        if not isValid(myPawn) then return end
        
        local hsScale = MagicBulletCfg.HS
        local bsScale = MagicBulletCfg.BS
        local pawns = Game:GetAllPlayerPawns() or {}
        
        for _, pawn in pairs(pawns) do
            if isValid(pawn) and pawn ~= myPawn and pawn.TeamID ~= myPawn.TeamID then
                local mesh = pawn.Mesh
                if isValid(mesh) then
                    local physAsset = mesh.PhysicsAssetOverride
                    if not isValid(physAsset) then
                        physAsset = mesh.SkeletalMesh and mesh.SkeletalMesh.PhysicsAsset
                    end
                    if isValid(physAsset) and physAsset.SkeletalBodySetups then
                        _G._ZLE_MB = _G._ZLE_MB or {}
                        local name = physAsset:GetName() or tostring(physAsset)
                        if not _G._ZLE_MB[name] then
                            for i = 1, 80 do
                                local setup = nil
                                pcall(function()
                                    if type(physAsset.SkeletalBodySetups.Get) == "function" then
                                        setup = physAsset.SkeletalBodySetups:Get(i - 1)
                                    else
                                        setup = physAsset.SkeletalBodySetups[i]
                                    end
                                end)
                                if not setup or not isValid(setup) then break end
                                
                                local boneName = string.lower(tostring(setup.BoneName))
                                local scale = nil
                                if boneName:find("head") then
                                    scale = hsScale
                                elseif boneName:find("neck") or boneName:find("pelvis") or boneName:find("spine") or boneName:find("upperarm") or boneName:find("lowerarm") or boneName:find("hand") or boneName:find("thigh") or boneName:find("calf") or boneName:find("foot") then
                                    scale = bsScale
                                end
                                
                                if scale and scale > 0 then
                                    local factor = 1.0 + (scale / 100.0)
                                    pcall(function()
                                        local elems = setup.AggGeom and setup.AggGeom.BoxElems or setup.BoxElems
                                        if elems then
                                            local elem = type(elems.Get) == "function" and elems:Get(0) or elems[1]
                                            if elem then
                                                elem.X = (elem.X or 30) * factor
                                                elem.Y = (elem.Y or 30) * factor
                                                elem.Z = (elem.Z or 60) * factor
                                                if type(elems.Set) == "function" then elems:Set(0, elem) else elems[1] = elem end
                                                if setup.AggGeom then setup.AggGeom = setup.AggGeom else setup.BoxElems = elems end
                                            end
                                        end
                                    end)
                                    pcall(function()
                                        local elems = setup.AggGeom and setup.AggGeom.SphylElems or setup.SphylElems
                                        if elems then
                                            local elem = type(elems.Get) == "function" and elems:Get(0) or elems[1]
                                            if elem then
                                                if elem.Radius then elem.Radius = elem.Radius * factor end
                                                if elem.Length then elem.Length = elem.Length * factor end
                                                if type(elems.Set) == "function" then elems:Set(0, elem) else elems[1] = elem end
                                                if setup.AggGeom then setup.AggGeom = setup.AggGeom else setup.SphylElems = elems end
                                            end
                                        end
                                    end)
                                    pcall(function()
                                        local elems = setup.AggGeom and setup.AggGeom.SphereElems or setup.SphereElems
                                        if elems then
                                            local elem = type(elems.Get) == "function" and elems:Get(0) or elems[1]
                                            if elem then
                                                if elem.Radius then elem.Radius = elem.Radius * factor end
                                                if type(elems.Set) == "function" then elems:Set(0, elem) else elems[1] = elem end
                                                if setup.AggGeom then setup.AggGeom = setup.AggGeom else setup.SphereElems = elems end
                                            end
                                        end
                                    end)
                                end
                            end
                            _G._ZLE_MB[name] = true
                            if mesh.RecreatePhysicsState then mesh:RecreatePhysicsState() end
                        end
                    end
                end
            end
        end
    end)
end

dummy_table.OnRep_CountdownTime53 = function(a) end
dummy_table.OnRep_CountdownTime54 = function(a) end

local function LoopHitbox()
    local t = os.clock()
    if t - lastHitboxTime < 2 then return end
    lastHitboxTime = t
    UpdateHitbox()
end

local tm_esp, tm_fps, tm_combat, tm_hitbox, curPC, curWorld

dummy_table.OnRep_CountdownTime55 = function(a) end
dummy_table.OnRep_CountdownTime56 = function(a) end

local function GetPC()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if isValid(pc) then return pc end
    pcall(function()
        local GameplayStatics = import("GameplayStatics")
        pc = GameplayStatics:GetPlayerController(slua_GameFrontendHUD:GetWorld(), 0)
    end)
    return pc
end

-- Generate padding functions for obfuscator
for i = 200, 299 do dummy_table["OnRep_CountdownTime" .. i] = function(a) end end
for i = 216, 299 do dummy_table["OnRep_CountdownTime" .. i] = function(a) end end
for i = 57, 58 do dummy_table["OnRep_CountdownTime" .. i] = function(a) end end

local function CleanUpGameTimers()
    pcall(function()
        if curWorld and isValid(curWorld) and curPC then
            curWorld:RemoveGameTimer(curPC)
        end
    end)
    curPC = nil
    curWorld = nil
end

dummy_table.OnRep_CountdownTime59 = function(a) end
dummy_table.OnRep_CountdownTime60 = function(a) end

local function CleanUpAllTimers()
    pcall(function()
        if tm_esp and isValid(tm_esp) then
            if tm_fps then tm_esp:RemoveGameTimer(tm_fps) end
            if tm_combat then tm_esp:RemoveGameTimer(tm_combat) end
            if tm_hitbox then tm_esp:RemoveGameTimer(tm_hitbox) end
            if curPC then tm_esp:RemoveGameTimer(curPC) end
        end
    end)
    tm_fps = nil
    tm_combat = nil
    tm_hitbox = nil
    curPC = nil
    tm_esp = nil
    ESPDistanceLimit = nil
end

dummy_table.OnRep_CountdownTime61 = function(a) end
dummy_table.OnRep_CountdownTime62 = function(a) end

local function StopAll()
    CleanUpAllTimers()
    CleanUpGameTimers()
end

dummy_table.OnRep_CountdownTime63 = function(a) end
dummy_table.OnRep_CountdownTime64 = function(a) end

local function StartAll()
    if _G.ZLE_FEATURE_EXPIRED() then return end
    local pc = GetPC()
    if isValid(pc) and pc.AddGameTimer then
        if tm_esp == pc and tm_fps and tm_combat and tm_hitbox and curPC then return end
        CleanUpAllTimers()
        tm_esp = pc
        ESPDistanceLimit = pc
        
        tm_fps = pc:AddGameTimer(0.1, true, function() pcall(function() if _G.ZLE_FEATURE_EXPIRED() then ClearAllESP() return end UpdateESP() end) end)
        tm_combat = pc:AddGameTimer(0.3, true, function() pcall(UpdateCombatFeatures) end)
        tm_hitbox = pc:AddGameTimer(0.3, true, function() pcall(ForceInjectBigHead) end)
        curPC = pc:AddGameTimer(2.0, true, function() pcall(LoopHitbox) end)
        
        local msg = GetByteString({116, 105, 109, 101, 114, 115, 32, 115, 116, 97, 114, 116, 101, 100, 32, 112, 99, 61}) .. tostring(pc)
    end
end

dummy_table.OnRep_CountdownTime65 = function(a) end
dummy_table.OnRep_CountdownTime66 = function(a) end

local function InitializeHooks()
    pcall(function()
        local pc = GetPC()
        if isValid(pc) and pc.AddGameTimer then
            if curWorld == pc and curPC then return end
            CleanUpGameTimers()
            curWorld = pc
            curPC = pc:AddGameTimer(1.0, true, function()
                pcall(function()
                    -- Hooks defined elsewhere would be called here.
                    local pc2 = GetPC()
                    if isValid(pc2) and tm_esp ~= pc2 then StartAll() end
                    EnsureFeaturesRunning()
                end)
            end)
            _G.__ZLE_WATCHDOG_ARMED__ = true
        end
    end)
end

dummy_table.OnRep_CountdownTime67 = function(a) end
dummy_table.OnRep_CountdownTime68 = function(a) end

local function MainLoopCheck()
    if _G.ZLE_FEATURE_EXPIRED() or not IsModEnabled() then
        StopAll()
        ClearAllESP()
        return
    end
    if IsFeatureEnabled("fps165") then EnsureFPS165() end
    if IsFeatureEnabled("ipad_view") then EnsureIpadViewConfig() end
    InjectBigHead()
    StartAll()
    InitializeHooks()
end

dummy_table.OnRep_CountdownTime69 = function(a) end
dummy_table.OnRep_CountdownTime70 = function(a) end

local function HookMatch()
    if _G.__ZLE_MATCH_HOOK__ then return end
    pcall(function()
        GameplayData:AddSelfPlayerControllerEvent("OnPlayerEnterFighting", function(...)
            local msg = GetByteString({101, 110, 116, 101, 114, 32, 109, 97, 116, 99, 104, 44, 32, 109, 111, 100, 95, 109, 97, 115, 116, 101, 114, 32, 109, 117, 115, 116, 32, 98, 101, 32, 101, 110, 97, 98, 108, 101, 100, 32, 109, 97, 110, 117, 97, 108, 108, 121})
            if _G.__ZLE_DISABLE_MASTER__ then _G.__ZLE_DISABLE_MASTER__(GetByteString({101, 110, 116, 101, 114, 32, 109, 97, 116, 99, 104})) else _G.ZLE_MOD_CFG.mod_master = false StopAll() ClearAllESP() MainLoopCheck() end
        end)
        _G.__ZLE_MATCH_HOOK__ = true
    end)
end

dummy_table.OnRep_CountdownTime71 = function(a) end
dummy_table.OnRep_CountdownTime72 = function(a) end

local function HookLobby()
    if _G.__ZLE_LOBBY_HOOK__ then return end
    pcall(function()
        EventSystem:registEvent(EVENTTYPE_SETTING, EVENTID_SETTING_RETURN_TO_LOBBY, function() end)
        EventSystem:registEvent(EVENTTYPE_STATE, EVENTID_GAMESTATE_ON_BATTLE_RESULT, function() end)
        _G.__ZLE_LOBBY_HOOK__ = true
    end)
end

dummy_table.OnRep_CountdownTime73 = function(a) end
dummy_table.OnRep_CountdownTime74 = function(a) end

local function Bootstrap()
    if _G.ZLE_FEATURE_EXPIRED() then return end
    _G.ZLE_MOD_CFG.mod_master = false
    MainLoopCheck()
    HookMatch()
    HookLobby()
end

local ZLE_MOD_NAME = GetByteString({232, 181, 176, 228, 186, 134, 32, 77, 79, 68, 32, 80, 65, 75, 10, 84, 71, 64, 122, 111, 117, 108, 111, 98, 98})
local ZLeModTab = "ZLeMod"
local Setting_Page_ZLeMod = "Setting_Page_ZLeMod"
local Path_ZLeMod = "client.slua.umg.NewSetting.Page.Setting_Page_ZLeMod"
local Path_Game = "/Game/UMG/UI_BP/Setting25/Page/WBP_Setting_Page_Game.WBP_Setting_Page_Game"

dummy_table.OnRep_CountdownTime75 = function(a) end
dummy_table.OnRep_CountdownTime76 = function(a) end

local function CreateSliderItem(key, min, max, default, showFunc, onChange)
    if _G.ZLE_MOD_CFG[key] == nil then _G.ZLE_MOD_CFG[key] = default end
    local AliasMap = require("client.slua.umg.NewSetting.Item.AliasMap")
    local item = { Key = key, UI = AliasMap.Slider, Text = 39268, Min = min, Max = max, IsPercent = false }
    item.GetFunc = function()
        if _G.ZLE_FEATURE_EXPIRED() then return min end
        local v = math.floor(tonumber(_G.ZLE_MOD_CFG[key]) or default)
        if v < min then v = min end
        if v > max then v = max end
        return v
    end
    item.SetFunc = function(a, v)
        if _G.ZLE_FEATURE_EXPIRED() then return end
        local val = math.floor(tonumber(v) or default)
        if val < min then val = min end
        if val > max then val = max end
        _G.ZLE_MOD_CFG[key] = val
        if onChange then pcall(onChange) end
        MainLoopCheck()
    end
    if showFunc then item.BShowFunc = showFunc end
    return item
end

dummy_table.OnRep_CountdownTime79 = function(a) end
dummy_table.OnRep_CountdownTime80 = function(a) end

local function CreateSwitchItem(key, default, onChange)
    if _G.ZLE_MOD_CFG[key] == nil then _G.ZLE_MOD_CFG[key] = default ~= false end
    local AliasMap = require("client.slua.umg.NewSetting.Item.AliasMap")
    local item = { Key = key, UI = AliasMap.Switcher, Text = 39268 }
    item.GetFunc = function()
        if _G.ZLE_FEATURE_EXPIRED() then return false end
        return _G.ZLE_MOD_CFG[key] ~= false
    end
    item.SetFunc = function(a, v)
        if _G.ZLE_FEATURE_EXPIRED() then return end
        _G.ZLE_MOD_CFG[key] = v == true
        if onChange then pcall(onChange) end
        MainLoopCheck()
    end
    return item
end

dummy_table.OnRep_CountdownTime81 = function(a) end
dummy_table.OnRep_CountdownTime82 = function(a) end

local function UpdateUISelection(a)
    if a and a.Data and a.Data.GetFunc then
        a._bIntType = false
        if a.RefreshSelection then pcall(function() a:RefreshSelection() end) end
        if a.UIRoot and a.UIRoot.Switcher then
            pcall(function()
                local val = a.Data.GetFunc(a.Data.Key)
                local idx = val and 0 or 1
                a.UIRoot.Switcher.bUpdateInstantly = true
                a.UIRoot.Switcher:RefreshSelection(idx)
            end)
        end
    end
end

dummy_table.OnRep_CountdownTime83 = function(a) end
dummy_table.OnRep_CountdownTime84 = function(a) end

local function HookOptionSwitcher()
    if _G.__ZLE_OPTION_SWITCHER_HOOK__ then return end
    pcall(function()
        local Switcher = require("client.slua.umg.NewSetting.Item.Setting_Option_Switcher")
        local impl = Switcher and Switcher.__inner_impl or Switcher
        if not impl or impl.__ZLE_PATCHED__ then return end
        
        local orig = impl.OnSelected
        impl.OnSelected = function(a, b, c)
            orig(a, b, c)
            UpdateUISelection(a)
            pcall(function()
                local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
                if isValid(pc) and pc.AddGameTimer then
                    pc:AddGameTimer(0, false, function() UpdateUISelection(a) end)
                end
            end)
        end
        impl.__ZLE_PATCHED__ = true
        _G.__ZLE_OPTION_SWITCHER_HOOK__ = true
    end)
end

dummy_table.OnRep_CountdownTime85 = function(a) end
dummy_table.OnRep_CountdownTime86 = function(a) end

local function CreateTitleItem(key)
    local AliasMap = require("client.slua.umg.NewSetting.Item.AliasMap")
    return { Key = key, UI = AliasMap.Title, Text = 1 }
end

dummy_table.OnRep_CountdownTime87 = function(a) end
dummy_table.OnRep_CountdownTime88 = function(a) end

local function ReloadModPageStack()
    if _G.__ZLE_MOD_SETTING_PAGE__ then
        local page = _G.__ZLE_MOD_SETTING_PAGE__
        if page.ReloadStack and page.StackContainerWidget and page.OptionUIList then
            for i = 1, #page.OptionUIList do
                if page.OptionUIList[i] then page.OptionUIList[i]._ZLE_HELP_BOUND = nil end
            end
            page:ReloadStack(buildModStack(), page.StackContainerWidget)
        end
    end
end

dummy_table.OnRep_CountdownTime89 = function(a) end
dummy_table.OnRep_CountdownTime90 = function(a) end

local function UpdateModMasterUI()
    if _G.__ZLE_MOD_SETTING_PAGE__ then
        local page = _G.__ZLE_MOD_SETTING_PAGE__
        if page.GetItemUI then
            local ui = page:GetItemUI("mod_master")
            if ui then UpdateUISelection(ui) end
        end
    end
end

dummy_table.OnRep_CountdownTime91 = function(a) end
dummy_table.OnRep_CountdownTime92 = function(a) end

local function DisableMaster(msg)
    if _G.ZLE_MOD_CFG.mod_master == false then
        StopAll()
        ClearAllESP()
        UpdateModMasterUI()
        HookMatch()
        return
    end
    _G.ZLE_MOD_CFG.mod_master = false
    StopAll()
    ClearAllESP()
    UpdateModMasterUI()
    MainLoopCheck()
end

_G.__ZLE_DISABLE_MASTER__ = DisableMaster

dummy_table.OnRep_CountdownTime93 = function(a) end
dummy_table.OnRep_CountdownTime94 = function(a) end

local function ShowHelp(a, text)
    if not text or text == "" then return end
    pcall(function()
        UIManager:ShowUI(UIManager.UI_Config.common_questionmark_style_three, text, a)
    end)
end

dummy_table.OnRep_CountdownTime95 = function(a) end
dummy_table.OnRep_CountdownTime96 = function(a) end

local function BindHelp(a, text)
    if not a or not a.UIRoot or not text then return end
    if a._ZLE_HELP_BOUND then return end
    local base = a.UIRoot.Setting_Option_Base
    if not base or not base.Button_Help then return end
    local btn = base.Button_Help
    a._ZLE_HELP_BOUND = true
    pcall(function() a:SetWidgetVisible(btn, true, true) end)
    pcall(function() a:AddOnClickedEventByControl(btn, ShowHelp, btn, text) end)
end

dummy_table.OnRep_CountdownTime97 = function(a) end
dummy_table.OnRep_CountdownTime98 = function(a) end

local function CreateModMasterItem()
    if _G.ZLE_MOD_CFG.mod_master == nil then _G.ZLE_MOD_CFG.mod_master = false end
    local AliasMap = require("client.slua.umg.NewSetting.Item.AliasMap")
    local item = { Key = "mod_master", UI = AliasMap.Switcher, Text = 39268, HelpText = GetByteString({232, 191, 155, 229, 133, 165, 229, 175, 185, 229, 177, 128, 229, 144, 142, 239, 188, 140, 232, 175, 183, 230, 137, 139, 229, 138, 168, 229, 188, 128, 229, 144, 175, 230, 173, 164, 230, 128, 187, 229, 188, 128, 229, 133, 179, 239, 188, 140, 230, 137, 128, 230, 156, 137, 229, 138, 159, 232, 131, 189, 230, 137, 141, 228, 188, 154, 231, 148, 159, 230, 149, 136, 227, 128, 130, 10, 230, 175, 143, 229, 177, 128, 231, 187, 147, 230, 157, 159, 232, 191, 148, 229, 155, 158, 229, 164, 167, 229, 142, 133, 229, 144, 142, 228, 188, 154, 232, 135, 170, 229, 138, 168, 229, 133, 179, 233, 151, 173, 227, 128, 130, 10, 10, 65, 102, 116, 101, 114, 32, 101, 110, 116, 101, 114, 105, 110, 103, 32, 97, 32, 109, 97, 116, 99, 104, 44, 32, 109, 97, 110, 117, 97, 108, 108, 121, 32, 101, 110, 97, 98, 108, 101, 32, 116, 104, 105, 115, 32, 109, 97, 115, 116, 101, 114, 32, 115, 119, 105, 116, 99, 104, 32, 116, 111, 32, 97, 99, 116, 105, 118, 97, 116, 101, 32, 97, 108, 108, 32, 102, 101, 97, 116, 117, 114, 101, 115, 46, 10, 73, 116, 32, 97, 117, 116, 111, 32, 116, 117, 114, 110, 115, 32, 79, 70, 70, 32, 119, 104, 101, 110, 32, 121, 111, 117, 32, 114, 101, 116, 117, 114, 110, 32, 116, 111, 32, 116, 104, 101, 32, 108, 111, 98, 98, 121, 32, 97, 102, 116, 101, 114, 32, 101, 97, 99, 104, 32, 109, 97, 116, 99, 104, 46}) }
    item.GetFunc = function()
        if _G.ZLE_FEATURE_EXPIRED() then return false end
        return _G.ZLE_MOD_CFG.mod_master == true
    end
    item.SetFunc = function(a, v)
        if _G.ZLE_FEATURE_EXPIRED() then return end
        _G.ZLE_MOD_CFG.mod_master = v == true
        MainLoopCheck()
    end
    return item
end

dummy_table.OnRep_CountdownTime99 = function(a) end
dummy_table.OnRep_CountdownTime100 = function(a) end

local function BuildModStack()
    local AliasMap = require("client.slua.umg.NewSetting.Item.AliasMap")
    local stack = {
        CreateModMasterItem(),
        { UI = AliasMap.Spacer },
        CreateTitleItem("Title_ESP"),
        CreateSwitchItem("esp_box", true),
        CreateSwitchItem("esp_distance", true),
        CreateSwitchItem("esp_name", false),
        CreateSwitchItem("esp_hp", false),
        CreateSwitchItem("esp_ignore_bot", true),
        { UI = AliasMap.Spacer },
        CreateTitleItem("Title_Graphics"),
        CreateSwitchItem("fps165", true),
        CreateSwitchItem("ipad_view", true, ReloadModPageStack),
        CreateSliderItem("ipad_fov", 80, 150, 90, function() return IsFeatureEnabled("ipad_view") end),
        { UI = AliasMap.Spacer },
        CreateTitleItem("Title_Combat"),
        CreateSwitchItem("no_recoil", true),
        CreateSwitchItem("cross_deviation", true),
        CreateSwitchItem("anti_shake", true),
        CreateSwitchItem("auto_aim", true),
        CreateSwitchItem("fast_switch", true),
        CreateSwitchItem("hit_effect", true),
        CreateSwitchItem("hitbox", true)
    }
    return stack
end

dummy_table.OnRep_CountdownTime101 = function(a) end
dummy_table.OnRep_CountdownTime102 = function(a) end

local function GetModPageConfig()
    return {
        Key = ZLeModTab,
        text = ZLE_MOD_NAME,
        UIKey = Setting_Page_ZLeMod,
        Stack = BuildModStack()
    }
end

dummy_table.OnRep_CountdownTime103 = function(a) end
dummy_table.OnRep_CountdownTime104 = function(a) end

local function CreateSettingPageZLeMod()
    local page = {}
    page.OnInitialize = function(a)
        if page.__super and page.__super.OnInitialize then page.__super.OnInitialize(a) end
        a:SetWidgetVisible(a.UIRoot.Button_BackLobby, false)
        a:SetWidgetVisible(a.UIRoot.Button_CustomerService, false)
        a:SetWidgetVisible(a.UIRoot.Button_CloudManager, false)
    end
    page.RegistEvents = function(a)
        if page.__super and page.__super.RegistEvents then page.__super.RegistEvents(a) end
        a:AddTimerLoop(0.5, function() a:RefreshExpiredUI() end, TIMER_INFINITE, 0.5)
    end
    page.RefreshExpiredUI = function(a)
        local exp = _G.ZLE_FEATURE_EXPIRED()
        local list = a.OptionUIList or {}
        for i = 1, #list do
            local item = list[i]
            if item and item.UIRoot then
                local root = item.UIRoot
                if root.Setting_Option_Base then pcall(function() root.Setting_Option_Base:SetIsEnabled(not exp) end) end
                if root.Switcher then pcall(function() root.Switcher:SetIsEnabled(not exp) end) end
                pcall(function() root:SetRenderOpacity(exp and 0.4 or 1.0) end)
                if exp and item.OnRefreshOption then item:OnRefreshOption() end
            end
        end
    end
    page.OnStackLoaded = function(a)
        _G.__ZLE_MOD_SETTING_PAGE__ = a
        HookOptionSwitcher()
        for k, v in pairs(DefaultCfg) do
            local ui = a:GetItemUI(k)
            if ui and ui.UIRoot then
                if ui.UIRoot.Setting_Option_Base and ui.UIRoot.Setting_Option_Base.Text then
                    ui.UIRoot.Setting_Option_Base.Text:SetText(v)
                elseif ui.UIRoot.Text then
                    ui.UIRoot.Text:SetText(v)
                end
            end
        end
        local list = a.OptionUIList or {}
        for i = 1, #list do
            local item = list[i]
            if item and item.Data then
                if item.Data.HelpText then BindHelp(item, item.Data.HelpText) end
                if item.Data.GetFunc then
                    if item.UIRoot and item.UIRoot.Switcher then UpdateUISelection(item) end
                elseif item.Data.Min and item.OnRefreshOption then
                    item:OnRefreshOption()
                end
            end
        end
        local uiMod = a:GetItemUI("mod_master")
        if uiMod and uiMod.Data then BindHelp(uiMod, uiMod.Data.HelpText or GetByteString({})) end
        a:RefreshExpiredUI()
    end
    
    local class = require("class")
    local Setting_StackContainer = require("client.slua.umg.NewSetting.Page.Setting_StackContainer")
    return class(Setting_StackContainer, nil, page)
end

dummy_table.OnRep_CountdownTime105 = function(a) end
dummy_table.OnRep_CountdownTime106 = function(a) end

local function InjectSettingCatalog(catalog)
    if type(catalog) ~= "table" then return false end
    for i, v in ipairs(catalog) do
        if v.Key == ZLeModTab then return true end
    end
    local pos = 1
    for i, v in ipairs(catalog) do
        if v.Key == "Account" then pos = i + 1 break end
    end
    table.insert(catalog, pos, GetModPageConfig())
    return true
end

dummy_table.OnRep_CountdownTime107 = function(a) end
dummy_table.OnRep_CountdownTime108 = function(a) end

local function HookSettingCatalog()
    local catalog = package.loaded["client.logic.NewSetting.SettingCatalog"]
    if not catalog then
        pcall(function() catalog = require("client.logic.NewSetting.SettingCatalog") end)
    end
    return InjectSettingCatalog(catalog)
end

dummy_table.OnRep_CountdownTime109 = function(a) end
dummy_table.OnRep_CountdownTime110 = function(a) end

local function HookInGameCatalog()
    if _G.__ZLE_INGAME_CATALOG_HOOK__ then return end
    local hooked = false
    pcall(function()
        local main = require("GameLua.GameCore.Main.ClientGameMain")
        if main and main.GetCurrentConfig then
            local orig = main.GetCurrentConfig
            main.GetCurrentConfig = function(cfgName)
                local cfg = orig(cfgName)
                if cfgName == "SettingCatalog" then InjectSettingCatalog(cfg) end
                return cfg
            end
            hooked = true
        end
    end)
    pcall(function()
        local tools = require("GameLua.Mod.BaseMod.Common.GamePlayTools")
        if tools and tools.GetCurrentConfig then
            local orig = tools.GetCurrentConfig
            tools.GetCurrentConfig = function(cfgName)
                local cfg = orig(cfgName)
                if cfgName == "SettingCatalog" then InjectSettingCatalog(cfg) end
                return cfg
            end
            hooked = true
        end
    end)
    if hooked then _G.__ZLE_INGAME_CATALOG_HOOK__ = true end
end

dummy_table.OnRep_CountdownTime111 = function(a) end
dummy_table.OnRep_CountdownTime112 = function(a) end

local function HookLobbyEnter()
    if _G.__ZLE_LOBBY_ENTER_HOOK__ then return end
    pcall(function()
        local util = require("client.slua.logic.setting.setting_util")
        if util and util.Enter then
            local orig = util.Enter
            util.Enter = function(a, b)
                HookSettingCatalog()
                return orig(a, b)
            end
            _G.__ZLE_LOBBY_ENTER_HOOK__ = true
        end
    end)
end

dummy_table.OnRep_CountdownTime113 = function(a) end
dummy_table.OnRep_CountdownTime114 = function(a) end

local function EnsureUIFramework()
    local mgr = require("client.slua_ui_framework.manager")
    if not mgr or not mgr.UI_Config then return false end
    if mgr.UI_Config[Setting_Page_ZLeMod] then return true end
    mgr.UI_Config[Setting_Page_ZLeMod] = { keyName = Setting_Page_ZLeMod, moduleName = Path_ZLeMod, path = Path_Game, asy = false, isMainUI = false }
    if mgr.ProcessOneConfig then mgr:ProcessOneConfig(Setting_Page_ZLeMod, mgr.UI_Config[Setting_Page_ZLeMod]) end
    return true
end

dummy_table.OnRep_CountdownTime115 = function(a) end
dummy_table.OnRep_CountdownTime116 = function(a) end

local function InitializeSettings()
    if _G.__ZLE_SETTING_TAB_HOOKED__ then return end
    _G.__ZLE_SETTING_TAB_HOOKED__ = true
    pcall(function()
        HookOptionSwitcher()
        package.preload[Path_ZLeMod] = function() return CreateSettingPageZLeMod() end
        package.loaded[Path_ZLeMod] = nil
        EnsureUIFramework()
        HookSettingCatalog()
        HookInGameCatalog()
        HookLobbyEnter()
        pcall(function()
            local defs = require("client.logic.NewSetting.SettingPageDefine")
            if type(defs) == "table" then defs.ZLeMod = GetModPageConfig() end
        end)
    end)
end

TryShowLegalCredit()
InitializeSettings()
Bootstrap()

_G.__ZLE_MOD_MERGED__ = {
    FeatureExpired = _G.ZLE_FEATURE_EXPIRED,
    CFG = _G.ZLE_MOD_CFG,
    Bootstrap = Bootstrap,
    Ensure = HookMatch,
    ShowPopup = TryShowLegalCredit
}

return _G.__ZLE_MOD_MERGED__