-- DECOMPLIED BY @nanamod96 + @alex_vietnam

require("class")
require("GameLua.GameCore.Framework.CharacterBase")
local combine_class = require("combine_class")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")
local InGameMarkTools = require("GameLua.Mod.BaseMod.Common.InGameMarkTools")
local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local logic_common_legal_msg = require("client.slua.logic.common.logic_common_legal_msg")

local function ReturnNil()
end

local function ReturnTrue()
    return true
end

local function ReturnFalse()
    return false
end

local expireTime = os.time({year = 2026, month = 5, day = 28, hour = 19, min = 0, sec = 0})

local function IsExpired()
    return os.time() > expireTime
end

local function GetExpireTimeStr()
    local diff = expireTime - os.time()
    if diff < 0 then
        diff = 0
    end
    if diff == 0 then
        return "EXPIRED IN : 00:00:00"
    end
    local h = math.floor(diff / 3600)
    local m = math.floor((diff % 3600) / 60)
    local s = diff % 60
    return string.format("EXPIRED IN : %02d:%02d:%02d", h, m, s)
end

local function ShowExpiredDialog()
    pcall(function()
        SecurityCommonUtils.ShowOnePopUI({
            tabType = 999,
            title = "PAKS MOD LUA V2",
            content = "WARNING !!!\n\nSTATUS : EXPIRED\n\nContact @FirstMods77s",
            btnOKText = "",
            btnCancleText = ""
        })
    end)
end

local Color1 = FLinearColor(1, 0, 0, 1)
local Color2 = FLinearColor(0, 1, 0, 0.95)
local Color3 = FLinearColor(1, 1, 0, 0.95)
local Color4 = FLinearColor(1, 0, 0, 0.95)
local Color5 = FLinearColor(0, 0, 0, 0.55)

local RPCConfig = {
    ServerRPC = {
        ServerRPC_NearDeathGiveupRescue = {Reliable = true, Params = {}},
        ServerRPC_CarryDeadBox = {Reliable = true, Params = {UEnums.EPropertyClass.Object}},
        RPC_Server_GmPlayAction = {Reliable = true, Params = {UEnums.EPropertyClass.Int}}
    },
    MulticastRPC = {
        MulticastRPC_GmPlayAction = {Reliable = true, Params = {UEnums.EPropertyClass.Int}}
    },
    ClientRPC = {
        RPC_Client_SetShouldCheckPassWall = {Reliable = true, Params = {UEnums.EPropertyClass.Bool}}
    }
}

_G.ServerRPC = RPCConfig.ServerRPC
_G.ClientRPC = RPCConfig.ClientRPC
_G.MulticastRPC = RPCConfig.MulticastRPC

local function IsAlive(actor)
    if not slua.isValid(actor) then
        return false
    end
    if actor.HealthStatus then
        return InGameMarkTools.IsHealthStatusAlive(actor.HealthStatus)
    end
    if actor.IsAlive then
        return actor:IsAlive()
    end
    local hp = 0
    if actor.GetHealth then
        hp = actor:GetHealth() or 0
    end
    return hp > 0 or hp
end

_G.ESPLineMode = _G.ESPLineMode or "V1"
_G.iPadViewValue = _G.iPadViewValue or 110

local function ShowMainMenu()
    SecurityCommonUtils.ShowOnePopUI({
        tabType = 999,
        title = "PAKS MOD LUA V3 \226\128\147 FREE VERSION",
        content = "PAKS MOD LUA V3\n\nESP LINE SELECTOR\nIPAD VIEW SELECTOR\nENEMY COUNTER\n\nNOTE : USE FIREWALL\n\nDEV : @FirstMods77s\nTELEGRAM : https://t.me/FIRSTMODS",
        btnOKText = "ESP LINE V1",
        btnCancleText = "ESP LINE V2",
        okFunc = function()
            _G.ESPLineMode = "V1"
            ShowiPadViewDialog()
        end,
        refuseFunc = function()
            _G.ESPLineMode = "V2"
            ShowiPadViewDialog()
        end
    })
end

local function ShowiPadViewDialog()
    SecurityCommonUtils.ShowOnePopUI({
        tabType = 999,
        title = "IPAD VIEW SETTINGS",
        content = "CHOOSE YOUR IPAD VIEW VALUE..\n\nCurrent : " .. tostring(_G.iPadViewValue) .. "\n\n110 = Max View\n105 = Medium View",
        btnOKText = "IPAD VIEW : 110",
        btnCancleText = "IPAD VIEW : 105",
        okFunc = function()
            _G.iPadViewValue = 110
        end,
        refuseFunc = function()
            _G.iPadViewValue = 105
        end
    })
end

local function InitLegal()
    if _G.LegalShown then
        return
    end
    _G.LegalShown = true
    ShowMainMenu()
end

local function FOVTick(actor)
    if not slua.isValid(actor) then
        return
    end
    if slua.isValid(actor.ThirdPersonCameraComponent) then
        actor.ThirdPersonCameraComponent.FieldOfView = _G.iPadViewValue
    end
end

local function LoadBypassG1()
    if _G.BypassG1_Loaded then
        return
    end
    _G.BypassG1_Loaded = true
    pcall(function()
        local GC = _G.GameplayCallbacks or _G.GC
        if GC then
            GC.SendTssSdkAntiDataToLobby = ReturnNil
            GC.SendDSErrorLogToLobby = ReturnNil
            GC.SendDSHawkEyePatrolLogToLobby = ReturnNil
            GC.SendSecTLog = ReturnNil
            GC.SendDataMiningTLog = ReturnNil
            GC.SendActivityTLog = ReturnNil
            GC.OnPlayerRPCValidateFailed = ReturnNil
            GC.OnPlayerActorChannelError = ReturnNil
            GC.OnPlayerSpectateException = ReturnNil
            GC.OnShutdownAfterError = ReturnNil
            GC.OnPlayerNetConnectionClosed = ReturnNil
            GC.SendCheatDetection = ReturnNil
            GC.ReportCheat = ReturnNil
            local oldDSPlayerState = GC.OnDSPlayerStateChanged
            GC.OnDSPlayerStateChanged = function(a, b, ...)
                local filter = {cheatdetected = true, connectionlost = true, connectiontimeout = true, netdrivererror = true}
                if filter[tostring(b):lower()] then
                    return
                end
                if oldDSPlayerState then
                    return oldDSPlayerState(a, b, ...)
                end
            end
        end

        local status, HiggsBoson = pcall(function() return require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent") end)
        if status then
            HiggsBoson.ControlMHActive = ReturnNil
            HiggsBoson.Tick = ReturnNil
            HiggsBoson.OnTick = ReturnNil
            HiggsBoson.ReceiveTick = ReturnNil
            HiggsBoson.MHActiveLogic = ReturnNil
            HiggsBoson.TriggerAvatarCheck = ReturnNil
            HiggsBoson.StartAvatarCheck = ReturnNil
            HiggsBoson.ReportItemID = ReturnNil
            HiggsBoson.OnReportItemID = ReturnNil
            HiggsBoson.ReceiveAnyDamage = ReturnNil
            HiggsBoson.OnWeaponHitRecord = ReturnNil
            HiggsBoson.ShowSecurityAlert = ReturnNil
            HiggsBoson.GetNetAvatarItemIDs = function() return {} end
            HiggsBoson.GetCurWeaponSkinID = function() return 0 end
            HiggsBoson.CheckWeaponIntegrity = ReturnTrue
            HiggsBoson.CheckAvatarIntegrity = ReturnTrue
            HiggsBoson.CheckBulletIntegrity = ReturnTrue
            HiggsBoson.SendAntiDataFlow = ReturnNil
            HiggsBoson.SendHitFireBtnFlow = ReturnNil
            HiggsBoson.OnBattleResult = ReturnNil
            HiggsBoson.StaticShowSecurityAlertInDev = ReturnNil
            HiggsBoson.SendHisarData = ReturnNil
            HiggsBoson.OnGameModeType = ReturnNil
        end

        local statusSub, SubsystemMgr = pcall(function() return require("GameLua.GameCore.Module.Subsystem.SubsystemMgr") end)
        if statusSub then
            local hawkDS = SubsystemMgr:Get("DSHawkEyePatrolSubsystem")
            if hawkDS then
                hawkDS.MarkSuspiciousPlayer = ReturnNil
            end
        end

        local statusClientReport, ClientReport = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem") end)
        if statusClientReport then
            ClientReport.OnInit = ReturnNil
            ClientReport._OnPlayerKilledOtherPlayer = ReturnNil
            ClientReport._RecordFatalDamager = ReturnNil
            ClientReport._OnBattleResult = ReturnNil
            ClientReport._OnDeathReplayDataWhenFatalDamaged = ReturnNil
            ClientReport._OnSyncFatalDamage = ReturnNil
            ClientReport._SyncBattleResult = ReturnNil
            ClientReport.ReportSuspiciousPlayer = ReturnNil
            ClientReport.SubmitReport = ReturnNil
            ClientReport.ProcessReport = ReturnNil
        end

        local statusDSReport, DSReport = pcall(function() return require("GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem") end)
        if statusDSReport then
            DSReport.OnInit = ReturnNil
            DSReport._OnCharacterDied = ReturnNil
            DSReport._RecordFatalDamager = ReturnNil
        end

        if _G.AvatarCheckCallback then
            _G.AvatarCheckCallback.StartAvatarCheck = ReturnNil
            _G.AvatarCheckCallback.OnReportItemID = ReturnNil
        end

        if _G.CrashSight then
            _G.CrashSight.ReportException = ReturnNil
            _G.CrashSight.SetCustomData = ReturnNil
        end

        for _, libName in ipairs({"TDM", "TencentDataMaster", "GCloud", "APM", "INTL", "Beacon", "Safeguard"}) do
            local lib = _G[libName]
            if type(lib) == "table" then
                lib.ReportEvent = ReturnNil
                lib.ReportBinary = ReturnNil
                lib.Send = ReturnNil
            end
        end

        if statusSub then
            local hawkClient = SubsystemMgr:Get("ClientHawkEyePatrolSubsystem")
            if hawkClient then
                hawkClient.OnTick = ReturnNil
                hawkClient.ReportPatrolData = ReturnNil
            end
            local clientRepSys = SubsystemMgr:Get("ClientReportPlayerSubsystem")
            if clientRepSys then
                clientRepSys.ReportPlayer = ReturnNil
                clientRepSys.OnInit = ReturnNil
            end
        end

        local statusNotify, SecurityNotify = pcall(function() return require("GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature") end)
        if statusNotify then
            SecurityNotify.ClientRPC_SyncBanID = ReturnNil
            SecurityNotify.ClientRPC_StrongTips = ReturnNil
            SecurityNotify.ClientRPC_WeakTips = ReturnNil
            SecurityNotify.ClientRPC_NormalTips = ReturnNil
            SecurityNotify.SyncBanInfo = ReturnNil
            SecurityNotify.Notify = ReturnNil
        end

        local statusGlue, GlueHia = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem") end)
        if statusGlue then
            GlueHia.LuaFunc1 = ReturnTrue
            GlueHia.LuaFunc2 = ReturnNil
            GlueHia.LuaFunc3 = ReturnNil
            GlueHia.LuaFunc4 = ReturnFalse
            GlueHia.LuaFunc5 = ReturnFalse
            GlueHia.LuaFunc6 = ReturnFalse
            GlueHia.LuaFunc7 = ReturnFalse
            GlueHia.LuaFunc8 = ReturnFalse
            GlueHia.LuaFunc9 = ReturnNil
        end

        local statusHawkSpec, HawkSpec = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.ClientHawkEyePatrolSubsystem") end)
        if statusHawkSpec then
            HawkSpec._OnHawkSync = ReturnNil
            HawkSpec._OnHawkReportSuccess = ReturnNil
            HawkSpec._OnRecvInspectorBroadcastCount = ReturnNil
            HawkSpec.SendReportTLog = ReturnNil
            HawkSpec.ReportCheat = ReturnNil
            HawkSpec.RequestImprison = ReturnNil
            HawkSpec.IsDuringHawkEyePatrol = ReturnFalse
            HawkSpec.HasReported = ReturnTrue
        end

        local statusQuickRep, QuickRep = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.ClientQuickReportMaliciousTeammate") end)
        if statusQuickRep then
            QuickRep.MaliciousTeammateReceiveWarningTips = ReturnNil
            QuickRep.MaliciousTeammateVictimReceiveTips = ReturnNil
        end

        local statusRTBan, RTBan = pcall(function() return require("GameLua.Mod.BaseMod.Common.RealTimeBan.RealTimeBan") end)
        if statusRTBan then
            RTBan.OnPlayerWithRealTimeBan = ReturnNil
            RTBan.ShowAlias = ReturnNil
            RTBan.HandleEnterGameModeFightingState = ReturnNil
        end

        local statusReportUtils, ReportUtils = pcall(function() return require("GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils") end)
        if statusReportUtils then
            ReportUtils.BugglyPostExceptionFull = ReturnFalse
            ReportUtils.ReportException = ReturnNil
            ReportUtils.ReplayReportData = ReturnFalse
            ReportUtils.CheckCanBugglyPostException = ReturnFalse
        end

        local statusHawkUI, HawkUI = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.HawkEyeDistanceUI") end)
        if statusHawkUI then
            HawkUI._RefreshUI = ReturnNil
            HawkUI._IsShouldShow = ReturnFalse
        end

        local statusHawkWin, HawkWin = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.HawkEyeNextPatrolWindow") end)
        if statusHawkWin then
            HawkWin.OnShow = ReturnNil
        end

        local statusHawkRepWin, HawkRepWin = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.HawkEyeReportWindow") end)
        if statusHawkRepWin then
            HawkRepWin._OnClickSubmit = ReturnNil
            HawkRepWin._RefreshWindow = ReturnNil
            HawkRepWin.RegistEvents = ReturnNil
        end

        local statusClientUtils, ClientUtils = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.SecurityClientUtils") end)
        if statusClientUtils then
            ClientUtils.HasOtherTeammateOffline = ReturnFalse
        end
    end)
end

local function LoadBypassV7()
    if _G.BypassV7_Loaded then
        return
    end
    _G.BypassV7_Loaded = true
    pcall(function()
        local statusGokuba, Gokuba = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.Gokuba") end)
        if statusGokuba then
            Gokuba.ForwardFeature = ReturnNil
            if Gokuba.TimerHandle then
                pcall(function()
                    local time_ticker = require("common.time_ticker")
                    time_ticker.RemoveTimer(Gokuba.TimerHandle)
                end)
                Gokuba.TimerHandle = nil
            end
        end

        local statusTLog, TLogManager = pcall(function() return require("GameLua.Mod.BaseMod.Client.ClientTLog.ClientTLogManager") end)
        if statusTLog then
            TLogManager.OnReceiveBattleResults = ReturnNil
            TLogManager.AddValTLog = ReturnNil
            TLogManager.SetValTLog = ReturnNil
            TLogManager.SendReportLobby = ReturnNil
            if TLogManager.ClientTlogData then
                TLogManager.ClientTlogData = {}
            end
        end

        local statusSecUtils, SecUtils = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.SecurityClientUtils") end)
        if statusSecUtils then
            SecUtils.HasOtherTeammateOffline = ReturnFalse
            SecUtils.HasOtherHealthyOnlineTeammate = ReturnFalse
            SecUtils.IsMyHealthStatusHealthy = ReturnTrue
            SecUtils.IsMyHealthStatusAlive = ReturnTrue
            SecUtils.GetMyHealthStatus = function() return 1 end
        end

        local statusRacing, RacingAntiCheat = pcall(function() return require("GameLua.Mod.SocialIsland.DS.Battle.RacingAntiCheatLogic") end)
        if statusRacing then
            RacingAntiCheat.StartDetectTimer = ReturnNil
            RacingAntiCheat.StopDetectTimer = ReturnNil
            RacingAntiCheat.DetectVehicleFloating = ReturnNil
            RacingAntiCheat.HandleFloatingCheat = ReturnNil
            RacingAntiCheat.HandleSpeedCheat = ReturnNil
            RacingAntiCheat.HandlePlayerPassCheckBelt = ReturnNil
        end

        local statusCloudGM, CloudGM = pcall(function() return require("GameLua.Dev.ClientCloudGM") end)
        if not statusCloudGM then
            statusCloudGM, CloudGM = pcall(function() return require("GameLua.Mod.BaseMod.Client.Dev.ClientCloudGM") end)
        end
        if statusCloudGM then
            CloudGM.HandleCloudGMCMDStr = ReturnNil
        end

        local statusBanLogic, BanLogic = pcall(function() return require("GameLua.Mod.BaseMod.Client.Ban.ClientBanLogic") end)
        if not statusBanLogic then
            statusBanLogic, BanLogic = pcall(function() return require("GameLua.Mod.BaseMod.Client.Security.ClientBanLogic") end)
        end
        if statusBanLogic then
            BanLogic.OnVoiceBanNotify = ReturnNil
            BanLogic.OnRealTimeVoiceBanNotify = ReturnNil
            BanLogic.OnSyncBanInfo = ReturnNil
            BanLogic.OnNotifyWarningTips = ReturnNil
            BanLogic.VoiceBanEndTime = 0
            BanLogic.bEnableVoiceReport = false
        end

        if _G.Tss and _G.Tss.GetUserTag4Lua then
            _G.Tss.GetUserTag4Lua = function() return "" end
        end

        pcall(function()
            local HiggsComponentClass = import("HiggsBosonComponent")
            local playerController = slua_GameFrontendHUD:GetPlayerController()
            if slua.isValid(playerController) then
                playerController:AddGameTimer(30, true, function()
                    local comp = playerController:GetComponentByClass(HiggsComponentClass)
                    if slua.isValid(comp) then
                        if slua.isValid(comp.SecurityCoronaLabClientDataPointer) then
                            local world = slua_GameFrontendHUD:GetWorld()
                            if slua.isValid(world) then
                                local level = world.PersistentLevel
                                if slua.isValid(level) then
                                    local settings = level.WorldSettings
                                    if slua.isValid(settings) then
                                        comp.SecurityCoronaLabClientDataPointer:SetFloatValueByName("MinUndilatedFrameTime", settings.MinUndilatedFrameTime)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)

        if _G.AvatarCheckCallback then
            _G.AvatarCheckCallback.PostPlayerControllerLoginInit = function(actor)
                if slua.isValid(actor) and actor.HiggsBosonComponent then
                    pcall(function()
                        actor.HiggsBosonComponent:ControlMHActive(0)
                        actor.HiggsBosonComponent.bMHActive = false
                    end)
                end
            end
        end

        if _G.DisableHiggsBoson then
            _G.DisableHiggsBoson = function() pcall(_G.DisableHiggsBoson) end
        end
    end)
end

local function RunAllBypasses()
    _G.BypassG1_Loaded = nil
    _G.BypassV7_Loaded = nil
    LoadBypassG1()
    LoadBypassV7()
end

local EspState = {active = false, lastSwitch = 0}
local ESP_INTERVAL_1 = 0.3
local ESP_INTERVAL_2 = 0.2
local ESP_DISTANCE = 2000

local function DrawESPLineV1()
    pcall(function()
        local player = GameplayData.GetPlayerCharacter()
        if not slua.isValid(player) then
            return
        end
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then
            return
        end
        local hud = pc:GetHUD()
        if not slua.isValid(hud) then
            return
        end

        local timeNow = os.clock()
        if EspState.active then
            if timeNow - EspState.lastSwitch >= ESP_INTERVAL_1 then
                EspState.active = false
                EspState.lastSwitch = timeNow
            end
        else
            if timeNow - EspState.lastSwitch >= ESP_INTERVAL_2 then
                EspState.active = true
                EspState.lastSwitch = timeNow
            end
        end
        if not EspState.active then
            return
        end

        local myTeam = player.TeamID or 0
        local myLoc = player:K2_GetActorLocation()
        local pawns = Game:GetAllPlayerPawns() or {}
        local zOffset = ESP_DISTANCE / 2

        for _, enemy in pairs(pawns) do
            if slua.isValid(enemy) and enemy ~= player then
                local enemyTeam = enemy.TeamID or 0
                if enemyTeam ~= myTeam and IsAlive(enemy) then
                    local enemyLoc = enemy:K2_GetActorLocation()
                    if FVector.Dist2D(myLoc, enemyLoc) < 20000 then
                        hud:AddDebugText("|", enemy, 8.0, {X = 0, Y = 0, Z = 90}, {X = 0, Y = 0, Z = zOffset}, {R = 255, G = 0, B = 0, A = 255}, true, false, true, nil, ESP_INTERVAL_1, true)
                        hud:AddDebugText("|", enemy, 8.0, {X = 0, Y = 0, Z = zOffset}, {X = 0, Y = 0, Z = ESP_DISTANCE}, {R = 255, G = 60, B = 0, A = 255}, true, false, true, nil, ESP_INTERVAL_1, true)
                    end
                end
            end
        end
    end)
end

local function DrawESPLineV2()
    pcall(function()
        local player = GameplayData.GetPlayerCharacter()
        if not slua.isValid(player) then
            return
        end
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then
            return
        end
        local hud = pc:GetHUD()
        if not slua.isValid(hud) then
            return
        end

        local myTeam = player.TeamID or 0
        local myLoc = player:K2_GetActorLocation()
        local pawns = Game:GetAllPlayerPawns() or {}
        local zOffset = ESP_DISTANCE / 2

        for _, enemy in pairs(pawns) do
            if slua.isValid(enemy) and enemy ~= player then
                local enemyTeam = enemy.TeamID or 0
                if enemyTeam ~= myTeam and IsAlive(enemy) then
                    local enemyLoc = enemy:K2_GetActorLocation()
                    if FVector.Dist2D(myLoc, enemyLoc) < 20000 then
                        hud:AddDebugText("|", enemy, 22.0, {X = 0, Y = 0, Z = 90}, {X = 0, Y = 0, Z = zOffset}, {R = 255, G = 0, B = 0, A = 255}, true, false, true, nil, 1.0, true)
                        hud:AddDebugText("|", enemy, 22.0, {X = 0, Y = 0, Z = zOffset}, {X = 0, Y = 0, Z = ESP_DISTANCE}, {R = 255, G = 0, B = 0, A = 255}, true, false, true, nil, 1.0, true)
                    end
                end
            end
        end
    end)
end

local function DrawESP()
    if _G.ESPLineMode == "V2" then
        DrawESPLineV2()
    else
        DrawESPLineV1()
    end
end

local ESPTimerHandle = nil

local function UpdateESPMain()
    pcall(function()
        local player = GameplayData.GetPlayerCharacter()
        if not slua.isValid(player) then
            return
        end
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then
            return
        end
        local hud = pc:GetHUD()
        if not slua.isValid(hud) then
            return
        end

        local myTeam = player.TeamID or 0
        local myLoc = player:K2_GetActorLocation()
        local pawns = Game:GetAllPlayerPawns() or {}
        local enemyCount = 0

        for _, enemy in pairs(pawns) do
            if slua.isValid(enemy) and enemy ~= player then
                local enemyTeam = enemy.TeamID or 0
                if enemyTeam ~= myTeam and IsAlive(enemy) then
                    if FVector.Dist2D(myLoc, enemy:K2_GetActorLocation()) < 20000 then
                        enemyCount = enemyCount + 1
                    end
                end
            end
        end

        local colGreen = {R = 0, G = 255, B = 0, A = 255}
        local colYellow = {R = 255, G = 255, B = 0, A = 255}
        local colCyan = {R = 0, G = 255, B = 255, A = 255}
        local colWhite = {R = 255, G = 255, B = 255, A = 255}

        hud:AddDebugText("TELEGRAM @FirstMods77s", player, 1.2, {X = 0, Y = 0, Z = 170}, {X = 0, Y = 0, Z = 170}, colGreen, true, false, true, nil, 1.0, true)
        local infoText = "LINE : " .. tostring(_G.ESPLineMode) .. " | FOV : " .. tostring(_G.iPadViewValue)
        hud:AddDebugText(infoText, player, 1.0, {X = 0, Y = 0, Z = 160}, {X = 0, Y = 0, Z = 160}, colWhite, true, false, true, nil, 1.0, true)

        local expStr = GetExpireTimeStr()
        if enemyCount > 0 then
            hud:AddDebugText("ENEMY : " .. tostring(enemyCount), player, 1.5, {X = 0, Y = 0, Z = 150}, {X = 0, Y = 0, Z = 150}, colYellow, true, false, true, nil, 1.0, true)
        else
            hud:AddDebugText("CLEAR", player, 1.5, {X = 0, Y = 0, Z = 150}, {X = 0, Y = 0, Z = 150}, colGreen, true, false, true, nil, 1.0, true)
        end

        hud:AddDebugText(expStr, player, 1.2, {X = 0, Y = 0, Z = 135}, {X = 0, Y = 0, Z = 135}, colCyan, true, false, true, nil, 1.0, true)

        DrawESP()
    end)
end

local function StartESPTimer()
    if ESPTimerHandle then
        return
    end
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) then
        ESPTimerHandle = pc:AddGameTimer(0.05, true, function() UpdateESPMain() end)
    end
end

local function StopESPTimer()
    if ESPTimerHandle then
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if slua.isValid(pc) then
            pcall(function() pc:RemoveGameTimer(ESPTimerHandle) end)
        end
        ESPTimerHandle = nil
    end
end

local ClassDef = require("class")("GameLua.GameCore.Framework.CharacterBase", combine_class)
ClassDef.ServerRPC = RPCConfig.ServerRPC
ClassDef.ClientRPC = RPCConfig.ClientRPC
ClassDef.MulticastRPC = RPCConfig.MulticastRPC

function ClassDef:ctor()
    self._ExpiryDialogTimer = nil
    self._ESPRestartTimer = nil
    self._BypassReEnforcerTimer = nil
end

function ClassDef:_PostConstruct()
    require("GameLua.GameCore.Framework.CharacterBase")._PostConstruct(self)
    self:InitAddSpecialMoveInfo()
    self.bCanNearDeathGiveup = true
end

function ClassDef:ReceiveBeginPlay()
    require("GameLua.GameCore.Framework.CharacterBase").ReceiveBeginPlay(self)
    self:SetActorTickEnabled(true)
    EventSystem:postEvent(EVENTTYPE_SINGLETRAINING, EVENTID_CHARACTER_BEGINPLAY, self.Object)

    if Client then
        LoadBypassG1()
        LoadBypassV7()
        InitLegal()
        StartESPTimer()

        self._ESPRestartTimer = self:AddGameTimer(1.0, true, function()
            if not ESPTimerHandle then
                StartESPTimer()
            end
        end)

        self._BypassReEnforcerTimer = self:AddGameTimer(60, true, function()
            RunAllBypasses()
        end)

        self._ExpiryDialogTimer = self:AddGameTimer(1.0, true, function()
            if IsExpired() then
                ShowExpiredDialog()
            end
        end)
    end
end

function ClassDef:ReceiveEndPlay(endPlayReason)
    if self._ExpiryDialogTimer then
        self:RemoveGameTimer(self._ExpiryDialogTimer)
        self._ExpiryDialogTimer = nil
    end
    if self._ESPRestartTimer then
        self:RemoveGameTimer(self._ESPRestartTimer)
        self._ESPRestartTimer = nil
    end
    if self._BypassReEnforcerTimer then
        self:RemoveGameTimer(self._BypassReEnforcerTimer)
        self._BypassReEnforcerTimer = nil
    end

    StopESPTimer()
    require("GameLua.GameCore.Framework.CharacterBase").ReceiveEndPlay(self, endPlayReason)

    if Client then
        if require("GameLua.GameCore.Data.GameplayData").RemoveCharacter then
            require("GameLua.GameCore.Data.GameplayData").RemoveCharacter(self.Object)
        end
    end
end

function ClassDef:ReceiveTick()
    if IsExpired() then
        ShowExpiredDialog()
    end
    LoadBypassG1()
    LoadBypassV7()
    FOVTick(self.Object)
end

local FeatureList = {
    {SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature"},
    {CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature"},
    {SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature"},
    {TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature"},
    {LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature"},
    {FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature"},
    {CampFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.Camp.PlayerCharacterCampFeature"},
    {BuildSkateFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.PlayerCharacterBuildVehicleFeature"},
    {CommonBornlandTransformFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.HeroPropFeature.CommonBornlandTransformFeature"}
}

return combine_class.DeclareFeature(ClassDef, FeatureList, "BRPlayerCharacterBase")
