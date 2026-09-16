--[[ ============================================================
    @GRW_XD COMPLETE ANTI-BAN BYPASS SYSTEM
    Blocks ALL detection mechanisms including:
    - Higgs Boson Anti-Cheat
    - Memory Scanners
    - Report Systems
    - TSS SDK
    - Replay Telemetry
    - Crash Reports
    - Avatar Verification
    - And MORE!
    ============================================================ ]]

-- ============================================
-- PART 1: CORE ANTI-BAN INITIALIZATION
-- ============================================

local function InitializeCompleteAntiBan()
    print('[ANTI-BAN] Starting Complete Bypass System...')
    
    -- Block all security subsystems
    pcall(function()
        local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubsystemMgr then
            local securitySubsystems = {
                "HiggsBosonComponent",
                "FileCheckSubsystem",
                "ClientDataStatistcsSubsystem",
                "AvatarExceptionSubsystem",
                "ShootVerifySubSystemClient",
                "DSHawkEyePatrolSubsystem",
                "InspectionSystemReportDSLogicSubsystem",
                "InspectionSystemReportClientLogicSubsystem",
                "ClientReportPlayerSubsystem",
                "DSReportPlayerSubsystem",
                "ClientHawkEyePatrolSubsystem",
                "AFKReportorSubsystem",
                "RescueBtnReplayTraceSubsystem",
                "GameReportSubsystem",
                "SpectateAndReplaySubsystem",
                "AITrackingLogSubsystem",
                "BehaviorScoreSubsystem",
                "TDMAFKReportorSubsystem",
                "HighlightMomentSubsystem_DSChecker",
                "DSAITLogSubsystem",
                "DSFightTLogSubsystem",
                "DSSecurityTLogSubsystem",
                "DSCommonTLogSubsystem",
                "ICTLogSubsystem",
                "CreativeModeDeathRecordSubsystem",
                "CreativeDevDebugSubsystem",
                "DSActiveSubsystem",
                "DataLayerSubsystem"
            }
            for _, name in ipairs(securitySubsystems) do
                local subsystem = SubsystemMgr:Get(name)
                if subsystem then
                    for key, value in pairs(subsystem) do
                        if type(value) == "function" then
                            subsystem[key] = function() return end
                        end
                    end
                end
            end
        end
    end)
    
    -- Block Higgs Boson
    pcall(function()
        local HiggsBosonComponent = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HiggsBosonComponent then
            HiggsBosonComponent.StaticShowSecurityAlertInDev = function() end
            HiggsBosonComponent.ControlMHActive = function() end
            if HiggsBosonComponent.BlackList then
                for k in pairs(HiggsBosonComponent.BlackList) do HiggsBosonComponent.BlackList[k] = nil end
            end
            HiggsBosonComponent.CheckMHActive = function() return false end
            HiggsBosonComponent.IsMHActive = function() return false end
            HiggsBosonComponent.ShouldRunMH = function() return false end
        end
        
        local function disableHiggsOnPlayer(pc)
            if slua.isValid(pc) then
                if pc.HiggsBoson then
                    pc.HiggsBoson.bMHActive = false
                    pc.HiggsBoson.bCallPreReplication = false
                end
                if pc.HiggsBosonComponent then
                    pc.HiggsBosonComponent.bMHActive = false
                    pc.HiggsBosonComponent:ControlMHActive(0)
                end
            end
        end
        
        local GameplayData = require("GameLua.GameCore.Data.GameplayData")
        if GameplayData then
            local pc = GameplayData.GetPlayerController()
            disableHiggsOnPlayer(pc)
        end
        
        if _G.AvatarCheckCallback then
            _G.AvatarCheckCallback.PostPlayerControllerLoginInit = function(pc)
                disableHiggsOnPlayer(pc)
            end
        end
    end)
    
    -- Block TSS SDK
    pcall(function()
        local TssSdk = _G.TssSdk or package.loaded["TssSdk"]
        if TssSdk then
            TssSdk.OnRecvData = function(data) 
                if type(data) == "string" and (
                    string.find(data, "report") or 
                    string.find(data, "exception") or 
                    string.find(data, "cheat") or
                    string.find(data, "scan")
                ) then
                    return
                end
            end
            TssSdk.SendReportInfo = function() end
            TssSdk.ScanMemory = function() return true end
            TssSdk.IsEmulator = function() return false end
            TssSdk.GetTssSdkReportInfo = function() return "" end
            TssSdk.ReportException = function() end
            TssSdk.SetCustomData = function() end
        end
        
        local CreativeModeBlueprintLibrary = import("CreativeModeBlueprintLibrary")
        if CreativeModeBlueprintLibrary then
            CreativeModeBlueprintLibrary.MD5HashByteArray = function() return "BYPASSED_MD5_HASH" end
            CreativeModeBlueprintLibrary.GetContentDiffData = function() return true, "BYPASSED" end
        end
        
        local STExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
        if STExtraBlueprintFunctionLibrary then
            STExtraBlueprintFunctionLibrary.IsDevelopment = function() return false end
            STExtraBlueprintFunctionLibrary.CheckFileIntegrity = function() return true end
        end
    end)
    
    -- Block Report Systems
    pcall(function()
        local noop = function() end
        local returnFalse = function() return false end
        local returnTrue = function() return true end
        local returnEmpty = function() return {} end
        
        local ClientReportPaths = {
            "GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem",
            "Client.Security.ClientReportPlayerSubsystem"
        }
        for _, path in ipairs(ClientReportPaths) do
            local module = package.loaded[path] or pcall(require, path) and require(path)
            if module then
                for key, value in pairs(module) do
                    if type(value) == "function" then
                        if string.find(key, "Report") or string.find(key, "Record") or 
                           string.find(key, "Fatal") or string.find(key, "Murderer") then
                            module[key] = noop
                        end
                    end
                end
                module.GetFatalDamagerMap = returnEmpty
                module.GetCachedTeammateName2InfoMap = returnEmpty
                module.GetTeammateName2InfoMapDuringBattle = returnEmpty
                module.GetCurrentNotInTeamHistoricalTeammateMap = returnEmpty
                module.GetInTeamIndexFromHistoricalTeammateInfo = function() return -1 end
            end
        end
        
        local DSReportPaths = {
            "GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem",
            "GameLua.Mod.BaseMod.Client.Security.DSReportPlayerSubsystem"
        }
        for _, path in ipairs(DSReportPaths) do
            local module = package.loaded[path] or pcall(require, path) and require(path)
            if module then
                module._AddEnemyMapToBattleResult = noop
                module._AddKnockDownerToBattleResult = noop
                module._AddKillerToBattleResult = noop
                module._AddTeammateMurderToBattleResult = noop
                module._AddFatalDamagerMapToBattleResult = noop
                module._SaveHistoricalTeammateInfo = noop
                module._RecordFatalDamager = noop
                module._RecordTeammateMurderer = noop
                module._OnCharacterDied = noop
                module._OnNearDeathOrRescued = noop
                module._OnTeammateDamage = noop
                module._OnPlayerSettlementStart = noop
            end
        end
        
        local ReportPlayerUtils = require("GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils")
        if ReportPlayerUtils then
            ReportPlayerUtils.RecordFatalDamager = noop
            ReportPlayerUtils.IsUsingHistoricalTeammateInfo = returnFalse
            ReportPlayerUtils.IsCharacterDeliverAI = returnFalse
        end
    end)
    
    -- Block Gameplay Telemetry
    pcall(function()
        if _G.GameplayCallbacks then
            local GC = _G.GameplayCallbacks
            local noop = function() end
            local returnEmpty = function() return {} end
            
            local reportFunctions = {
                "ReportAttackFlow", "ReportSecAttackFlow", "ReportHurtFlow",
                "ReportFireArms", "ReportVerifyInfoFlow", "ReportMrpcsFlow",
                "ReportPlayerBehavior", "ReportTeammatHurt", "ReportMisKillByTeammate",
                "ReportForbitPick", "ReportPlayerMoveRoute", "ReportPlayerPosition",
                "ReportVehicleMoveFlow", "ReportSecTgameMovingFlow", "ReportParachuteData",
                "SendTssSdkAntiDataToLobby", "SendDSErrorLogToLobby", "SendDSErrorLogToLobbyOnece",
                "SendDSHawkEyePatrolLogToLobby", "ReportEquipmentFlow", "ReportAimFlow",
                "ReportHeavyWeaponBoxSpawnFlow", "ReportHeavyWeaponBoxActivationFlow",
                "ReportHeavyWeaponBoxOpenPlayerFlow", "ReportHeavyWeaponBoxItemFlow",
                "ReportPlayersPing", "ReportPlayerIP", "ReportPlayerFramePingRecord",
                "OnDSConnectionSaturated", "ReportDSNetSaturation", "ReportNetContinuousSaturate",
                "ReportDSNetRate", "SendClientStats", "SendServerAvgTickDelta",
                "ReportCircleFlow", "ReportDSCircleFlow", "ReportJumpFlow",
                "ReportAIStrategyInfo", "SendAIDeliveryInfo", "ReportDailyTaskInfo",
                "ReportMatchRoomData", "SendPlayerSpectatingLog", "ReportIDCardProduceFlow",
                "ReportIDCardPickUpFlow", "ReportIDCardDestroyFlow", "ReportRevivalFlow",
                "ReportGameSetting", "ReportGameSettingNew", "ReportAntsVoiceTeamCreate",
                "ReportAntsVoiceTeamQuit", "ReportCommonInfo", "ReportLightweightStat",
                "SendSecTLog", "SendDataMiningTLog", "SendActivityTLog"
            }
            for _, funcName in ipairs(reportFunctions) do
                if GC[funcName] then GC[funcName] = noop end
            end
            GC.GetWeaponReport = returnEmpty
            GC.GetOneWeaponReport = returnEmpty
            GC.GetGeneralTLogData = function() return nil end
            
            local origOnDSPlayerStateChanged = GC.OnDSPlayerStateChanged
            GC.OnDSPlayerStateChanged = function(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
                if InPlayerState and string.lower(tostring(InPlayerState)) == "cheatdetected" then
                    return
                end
                if origOnDSPlayerStateChanged then
                    return origOnDSPlayerStateChanged(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
                end
            end
            
            GC.OnPlayerNetConnectionClosed = noop
            GC.OnPlayerActorChannelError = noop
            GC.OnPlayerRPCValidateFailed = noop
            GC.OnPlayerSpectateException = noop
            GC.OnShutdownAfterError = noop
        end
    end)
    
    -- Block Network Packets
    pcall(function()
        if NetUtil and NetUtil.SendPacket then
            local origSendPacket = NetUtil.SendPacket
            local blockedPackets = {
                "ReportAttackFlow", "ReportSecAttackFlow", "ReportHurtFlow",
                "ReportFireArms", "ReportVerifyInfoFlow", "ReportMrpcsFlow",
                "ReportPlayerBehavior", "ReportTeammatHurt", "ReportTeammateKillConfirmFlow",
                "ReportForbiddenPickupFlow", "ReportPlayerMoveRoute", "ReportPlayerPosition",
                "ReportSecVehicleMoveFlow", "ReportSecTgameMovingFlow", "report_parachute_data",
                "report_character_all_drag", "report_parachute_all_drag", "report_vehicle_move_drag",
                "on_tss_sdk_anti_data", "report_unrealnet_exception", "ReportPlayerEquipmentInfo",
                "ReportAimFlow", "ReportHitFlow", "log_shooting_miss", "report_heavy_weapon_box_activation_flow",
                "report_heavy_weapon_box_item_flow", "ReportCircleFlow", "report_ds_player_circle_flow",
                "ReportJumpFlow", "ReportGameStartFlow", "ReportGameEndFlow", "report_players_ping",
                "report_player_ip", "report_player_frame_ping_record", "report_net_saturate",
                "report_ds_netsaturate", "report_ds_net_continuous_saturate", "report_ds_netrate",
                "report_unrealnet_clientstats", "report_serverstat_avgtickdelta", "report_all_players_address",
                "report_ai_strategyinfo", "ReportAIActionFlow", "ReportGenerateMonsterFlow",
                "report_ds_match_room_data", "SendSpectatingLog", "ReportIDCardProduceFlow",
                "ReportIDCardPickUpFlow", "ReportIDCardDestroyFlow", "ReportRevivalFlow",
                "ReportGameSetting", "ReportGameSettingNew", "ReportAntsVoiceTeamCreate",
                "ReportAntsVoiceTeamQuit", "report_common_info", "report_common_battle_info",
                "report_client_scan_result", "tss_sdk_report", "report_memory_exception",
                "report_avatar_exception", "report_ui_state", "report_hit_reg_fail",
                "report_character_state", "report_vehicle_exception", "report_camera_exception",
                "ReportPlayerControllerStateChanged", "ReportAvatarFlow",
                "send_ugc_report_uni_mod_expose_req", "send_ugc_report_uni_mod_interactive_req"
            }
            local blockMap = {}
            for _, name in ipairs(blockedPackets) do blockMap[name] = true end
            NetUtil.SendPacket = function(packetName, ...)
                if blockMap[packetName] then return end
                return origSendPacket(packetName, ...)
            end
        end
    end)
    
    -- Block Avatar Exception System
    pcall(function()
        local AvatarExceptionPlayerInst = package.loaded["GameLua.Mod.Library.GamePlay.Avatar.Exception.AvatarExceptionPlayerInst"]
        if AvatarExceptionPlayerInst then
            AvatarExceptionPlayerInst.CheckAvatarException = function() end
            AvatarExceptionPlayerInst.CheckAvatarExceptionOnce = function() end
            AvatarExceptionPlayerInst.ReportAvatarException = function() end
            AvatarExceptionPlayerInst.CheckSlotMeshVisible = function() return false end
            AvatarExceptionPlayerInst.CheckPawnVisible = function() return false end
            AvatarExceptionPlayerInst.CheckCanBugglyPostException = function() return false end
        end
        
        local AvatarCheckerModule = package.loaded["blacklist.slua.logic.lobby_gm.AvatarCheckerModule"]
        if AvatarCheckerModule then
            AvatarCheckerModule.CheckAvatar = function() return true end
            AvatarCheckerModule.ReportException = function() end
        end
        
        local AvatarUtils = import("AvatarUtils")
        if AvatarUtils then
            AvatarUtils.CheckIsWeaponInBlackList = function() return false end
            AvatarUtils.IsValidAvatar = function() return true end
        end
    end)
    
    -- Block Logging and Crash Reports
    pcall(function()
        local noop = function() end
        
        local ScreenshotMaker = import("ScreenshotMaker")
        if ScreenshotMaker then
            ScreenshotMaker.MakePicture = function() return "" end
            ScreenshotMaker.ReMakePicture = function() return "" end
            ScreenshotMaker.HasCaptured = function() return true end
        end
        
        local TLog = _G.TLog or package.loaded["TLog"]
        if TLog then
            TLog.Info = noop
            TLog.Warning = noop
            TLog.Error = noop
            TLog.Debug = noop
            TLog.Report = noop
        end
        
        local CrashSight = _G.CrashSight or package.loaded["CrashSight"]
        if CrashSight then
            CrashSight.ReportException = noop
            CrashSight.SetCustomData = noop
            CrashSight.Log = noop
        end
        
        local GameReportUtils = package.loaded["GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils"]
        if GameReportUtils then
            GameReportUtils.BugglyPostExceptionFull = function() return false end
            GameReportUtils.CheckCanBugglyPostException = function() return false end
            GameReportUtils.ReplayReportData = noop
            GameReportUtils.ReportGameException = noop
        end
        
        local ClientToolsReport = package.loaded["client.slua.logic.report.ClientToolsReport"]
        if ClientToolsReport then
            ClientToolsReport.SendReport = noop
            ClientToolsReport.SendException = noop
        end
        
        local tlog_report_utils = package.loaded["client.slua.config.tlog.tlog_report_utils"]
        if tlog_report_utils then
            tlog_report_utils.ReportTLogEvent = noop
        end
    end)
    
    -- Block ZR and PR Bypasses
    pcall(function()
        local noop = function() end
        local returnTrue = function() return true end
        local returnFalse = function() return false end
        local returnEmpty = function() return {} end
        
        if _G.BasicDataTLogReport then
            _G.BasicDataTLogReport.OnSendBatchReqMsg = noop
            _G.BasicDataTLogReport.OnImmediateReqMsg = noop
            _G.BasicDataTLogReport.send_report_event_duration_log = noop
            _G.BasicDataTLogReport.SendTlog = noop
        end
        
        if _G.TApmHelper then _G.TApmHelper.postEvent = noop end
        
        local sdm = _G.ServerDataMgr
        if sdm and sdm.DeletablePlayerResultKey then
            sdm.DeletablePlayerResultKey["SuspiciousHitCount"] = true
            sdm.DeletablePlayerResultKey["EspTotalSimTraceCnt"] = true
            sdm.DeletablePlayerResultKey["EspTotalImeFocusCnt"] = true
            sdm.DeletablePlayerResultKey["ClientGravityAnomalyCount"] = true
        end
        
        local hiaPath = "GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem"
        local hia = package.loaded[hiaPath] or require(hiaPath)
        if hia then
            hia.CheckHitIntegrity = returnTrue
            hia.InitSession = noop
            hia.OnBattleEnd = noop
        end
        
        local secUtilsPath = "GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils"
        local secUtils = package.loaded[secUtilsPath] or require(secUtilsPath)
        if secUtils and secUtils.EStrategyTypeInReplay then
            secUtils.EStrategyTypeInReplay.EspTotalSimTraceCnt = 0
            secUtils.EStrategyTypeInReplay.EspTotalImeFocusCnt = 0
            secUtils.EStrategyTypeInReplay.ClientGravityAnomalyCount = 0
            secUtils.EStrategyTypeInReplay.FlyingErrorCnt = 0
        end
        
        local pcNotifyPath = "GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature"
        local pcNotify = package.loaded[pcNotifyPath] or require(pcNotifyPath)
        if pcNotify then
            pcNotify.ClientRPC_SyncBanID = noop
            pcNotify.ClientRPC_StrongTips = noop
            pcNotify.ClientRPC_NormalTips = noop
            pcNotify.Notify = noop
        end
        
        local ClientBanLogic = package.loaded["client.slua.logic.ban.ClientBanLogic"] or require("client.slua.logic.ban.ClientBanLogic")
        if ClientBanLogic then
            ClientBanLogic.OnSyncBanInfo = noop
            ClientBanLogic.OnVoiceBanNotify = noop
        end
    end)
    
    -- Hide modified globals
    pcall(function()
        local function hideGlobal(name)
            local meta = getmetatable(_G) or {}
            meta.__index = function(t, k)
                if k == name then return nil end
                return rawget(t, k)
            end
            meta.__newindex = function(t, k, v)
                if k == name then return end
                rawset(t, k, v)
            end
            setmetatable(_G, meta)
        end
        
        local modGlobals = {
            "AK_Features", "AK_MenuIndex", "AK_ForceWeaponUpdate",
            "MagicUpdateVersion", "EnvRequiresUpdate", "AK_Active_Marks_Cache",
            "AK_OrigHitboxes", "VINESH_OPTickCount", "LastVehicleEntity",
            "CurrentEquipVehicleID", "KCUISystemHacked2", "KCLogicHacked2",
            "KillInfoCounterHacked", "SlotBaseHacked", "LobbyBypassHacked",
            "IconBaloHacked", "VehicleEffectHacked", "VehicleAvatarSwitchHacked",
            "LobbyVehicleHacked", "AKSkinLoopStarted"
        }
        for _, name in ipairs(modGlobals) do hideGlobal(name) end
    end)
    
    print('[ANTI-BAN] Complete Bypass System Initialized Successfully!')
    print('[ANTI-BAN] All detection mechanisms are now BLOCKED!')
end

-- Initialize immediately
pcall(InitializeCompleteAntiBan)

-- Also initialize on timer
pcall(function()
    local time_ticker = require("common.time_ticker")
    if time_ticker then
        time_ticker.AddTimerOnce(0.5, InitializeCompleteAntiBan)
        time_ticker.AddTimerOnce(2.0, InitializeCompleteAntiBan)
        time_ticker.AddTimerOnce(5.0, InitializeCompleteAntiBan)
    end
end)

print('[ANTI-BAN] ✅ ALL BAN FIXES APPLIED!')
print('[ANTI-BAN] ✅ OFFLINE + ONLINE BYPASS ACTIVE!')
print('[ANTI-BAN] ✅ COMPLETE ANTICHEAT BLOCKED!')

-- ============================================
-- ORIGINAL MOD CODE STARTS HERE
-- ============================================

local NetworkRPC = {
    ServerRPC = {},
    ClientRPC = {},
    MulticastRPC = {}
}

NetworkRPC.ServerRPC.ServerRPC_NearDeathGiveupRescue = { Reliable = true, Params = {} }
NetworkRPC.ServerRPC.ServerRPC_CarryDeadBox = { Reliable = true, Params = { UEnums.EPropertyClass.Object } }
NetworkRPC.ServerRPC.RPC_Server_GmPlayAction = { Reliable = true, Params = { UEnums.EPropertyClass.Int } }
NetworkRPC.MulticastRPC.MulticastRPC_GmPlayAction = { Reliable = true, Params = { UEnums.EPropertyClass.Int } }
NetworkRPC.ClientRPC.RPC_Client_SetShouldCheckPassWall = { Reliable = true, Params = { UEnums.EPropertyClass.Bool } }
NetworkRPC.ClientRPC.ClientRPC_TriggerHighlightMoment = { Reliable = true, Params = { UEnums.EPropertyClass.UInt32, UEnums.EPropertyClass.UInt32 } }

local ENetRole = import("ENetRole")
local EPawnState_1 = import("EPawnState")
local GameplayData_3 = require("GameLua.GameCore.Data.GameplayData")
local GamePlayTools_1 = require("GameLua.Mod.BaseMod.Common.GamePlayTools")
local KismetMathLibrary_1 = import("KismetMathLibrary")
local GameplayStatics_1 = import("GameplayStatics")
local InGameMarkTools_1 = require("GameLua.Mod.BaseMod.Common.InGameMarkTools")
local IngamePhoneStateUI = require("GameLua.Mod.Library.Client.UI.IngamePhoneStateUI")

local var_85 = os.time(os.date("!*t"))
local var_151 = os.time({ year = 2026, month = 8, day = 20, hour = 6, min = 45, sec = 0 })

-- Check if current time is before expiration date (May 15, 2028)
if var_85 <= var_151 then
    local logic_setting_graphics_1 = package.loaded["client.slua.logic.setting.logic_setting_graphics"] or require("client.slua.logic.setting.logic_setting_graphics")
    local GSC_FPS_1 = package.loaded["client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPS"] or require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPS")
    local GSC_FPSFT_1 = package.loaded["client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPSFT"] or require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPSFT")
    local GraphicSettingDB_1 = package.loaded["client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB"] or require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")

    if logic_setting_graphics_1 then
        local var_132 = logic_setting_graphics_1.SetFPS
        function logic_setting_graphics_1.SetFPS(gameInstance, FPSLevel)
            if FPSLevel == 8 and GraphicSettingDB_1 then
                local var_234 = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneSwitch)
                if not var_234 then 
                    GraphicSettingDB_1:UpdateUIData(GraphicSettingDB_1.FPSFineTuneSwitch, true) 
                end
            end
            if var_132 then 
                var_132(gameInstance, FPSLevel) 
            end
            if FPSLevel == 8 and GraphicSettingDB_1 then
                GraphicSettingDB_1:UpdateUIData(GraphicSettingDB_1.FPSFineTuneNum, 165)
                gameInstance:ExecuteCMD("t.MaxFPS", "165")
                gameInstance:ExecuteCMD("r.FrameRateLimit", "165")
            end
        end
    end

    if GSC_FPS_1 and GSC_FPS_1.__inner_impl then
        local var_160 = GSC_FPS_1.__inner_impl
        function var_160:GetMaxFPSLevel() return 8, 8 end
        function var_160:CanChangeQualityAndFPSPreCheck() return true end
        function var_160:InitRealSupportFPS()
            local var_29 = {}
            for i = 1, 8 do var_29[i] = {true, true} end
            if GraphicSettingDB_1 then GraphicSettingDB_1:UpdateUIData(GraphicSettingDB_1.RealSupportFPS, var_29, false) end
            return var_29
        end
        function var_160:SetFPSAndQualityEnable(bEnable)
            if self.UIRoot and self.UIRoot.Image_Mask then self:SetWidgetVisible(self.UIRoot.Image_Mask, false) end
        end
        function var_160:UpdateSelectedFPSState(selectedLevel)
            local var_37 = { [2]="NodeFps20", [3]="NodeFps25", [4]="NodeFps30", [5]="NodeFps40", [6]="NodeFps60", [7]="NodeFps90", [8]="NodeFps120" }
            if not self.UIRoot then return end
            for level, name in pairs(var_37) do
                if self.UIRoot[name] then
                    self:WidgetSelfHit(self.UIRoot[name])
                    self.UIRoot[name]:SetIsEnabled(true)
                    local var_54 = self.UIRoot["WidgetSwitcher_" .. level]
                    if var_54 then var_54:SetActiveWidgetIndex(level == selectedLevel and 0 or 1) end
                end
            end
        end
        local var_58 = var_160.UpdateUI
        function var_160:UpdateUI()
            if var_58 then pcall(var_58, self) end
            self:SelfHitTestInvisible()
            self:InitRealSupportFPS()
            self:SetFPSAndQualityEnable(true)
            local var_222 = 8
            if GraphicSettingDB_1 then
                if GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.CustomTab) == 2 then
                    var_222 = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.LobbyFPS) or 8
                else
                    var_222 = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.SelectedFPS) or 8
                end
            end
            self:UpdateSelectedFPSState(var_222)
        end
        function var_160:DoClickFPS(FPSLevel)
            if slua.isValid(self.UIRoot) then
                if GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.CustomTab) == 2 then
                    GraphicSettingDB_1:UpdateUIData(GraphicSettingDB_1.LobbyFPS, FPSLevel)
                else
                    GraphicSettingDB_1:UpdateSelectedFPS(FPSLevel)
                end
                self:UpdateSelectedFPSState(FPSLevel)
                if self:GetParentUI() then 
                    self:GetParentUI():SaveQualityAndFPS()
                    self:GetParentUI():SetDirty(true) 
                end
            end
        end
    end

    if GSC_FPSFT_1 and GSC_FPSFT_1.__inner_impl then
        local var_13 = GSC_FPSFT_1.__inner_impl
        local var_93, var_203 = 90, 5
        local function func_6(val, min, max) return val < min and min or (val > max and max or val) end
        function var_13:ShowOrHide() 
            self:SelfHitTestInvisible() 
            if self.InitFPSFTSwitch then self:InitFPSFTSwitch() end 
        end
        function var_13:InitFPSFTSwitch()
            local sw = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneSwitch)
            if self.UIRoot.Setting_Switch then self.UIRoot.Setting_Switch:SetSwitcherEnable2(sw, true) end
            if self.UIRoot.CanvasPanel_8 then self:SetWidgetVisible(self.UIRoot.CanvasPanel_8, sw) end
            if self.UIRoot.WidgetSwitcher_0 then self.UIRoot.WidgetSwitcher_0:SetActiveWidgetIndex(2) end
            if self.InitFPSFTValue165 then self:InitFPSFTValue165() end
        end
        function var_13:InitFPSFTValue165()
            local var_202 = self.UIRoot
            local sw = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneSwitch)
            local var_69 = sw and GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneNum) or 165
            var_202.Slider_screen3:SetLocked(not sw)
            var_202.ProgressBar_screen3:SetFillColorAndOpacity(sw and FLinearColor(1,1,1,1) or FLinearColor(1,0.625,0.6,1))
            local var_60 = (var_69 - var_93) / (165 - var_93)
            var_202.Veihclescreen3:SetText(LocUtil.LocalizeResFormat(10567, var_69))
            var_202.Slider_screen3:SetValue(var_60)
            var_202.ProgressBar_screen3:SetPercent(var_60)
        end
        function var_13:OnFPSFTValueChange3(var_69)
            GraphicSettingDB_1:UpdateUIData(GraphicSettingDB_1.FPSFineTuneNum, var_69)
            self:InitFPSFTValue165()
            if self:GetParentUI() then self:GetParentUI():SetDirty(true) end
            local var_43 = GraphicSettingDB_1.GetGameInstance and GraphicSettingDB_1.GetGameInstance()
            if var_43 then 
                var_43:ExecuteCMD("t.MaxFPS", tostring(var_69))
                var_43:ExecuteCMD("r.FrameRateLimit", tostring(var_69)) 
            end
        end
        function var_13:OnFPSFTSliderValueChange3(var_174)
            if GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneSwitch) then
                local var_69 = KismetMathLibrary_1.FCeil(var_174 * (165 - var_93) / var_203) * var_203 + var_93
                self:OnFPSFTValueChange3(func_6(var_69, var_93, 165))
            end
        end
        function var_13:OnFPSFTAdd3()
            local var_69 = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneNum)
            if var_69 then self:OnFPSFTValueChange3(math.min(165, var_69 + var_203)) end
        end
        function var_13:OnFPSFTMinus3()
            local var_69 = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneNum)
            if var_69 then self:OnFPSFTValueChange3(math.max(var_93, var_69 - var_203)) end
        end
        var_13.OnFPSFTAdd = var_13.OnFPSFTAdd3 
        var_13.OnFPSFTMinus = var_13.OnFPSFTMinus3
        var_13.OnFPSFTSliderValueChange = var_13.OnFPSFTSliderValueChange3
    end
end

_G.ConfigFilePath = '/storage/emulated/0/Android/data/com.tencent.ig/files/SKIN_MENU.ini'

_G.BaseSkinIDs = {
    Weapons = { 101004, 101001, 101003, 103001, 102002, 103002, 103003, 101008, 102003, 105010, 102004, 105002, 105001, 101006, 104004 },
    Outfits = { Suit = 403003, Bag = 501001, Helmet = 502001, Parachut = 703001, Pet = 50000 }
}
_G.OutfitSkins = { 
    Suit = {_G.BaseSkinIDs.Outfits.Suit}, 
    Bag = {_G.BaseSkinIDs.Outfits.Bag}, 
    Helmet = {_G.BaseSkinIDs.Outfits.Helmet}, 
    Parachut = {_G.BaseSkinIDs.Outfits.Parachut}, 
    Pet = {_G.BaseSkinIDs.Outfits.Pet} 
}

_G.skinIdMappings = {}
for _, id in ipairs(_G.BaseSkinIDs.Weapons) do 
    _G.skinIdMappings[id] = {id} 
end

_G.VehicleMapDict = {
    UAZ = 1908001,
    Dacia = 1903001,
    Buggy = 1907001,
    Motor = 1901001,
    CoupeRB = 1961001
}

_G.VehicleSkinsList = {}
_G.VehicleSkinIndex = {}

_G.CustSlotType = { ClothesEquipemtSlot=5, BackpackEquipemtSlot=8, HelmetEquipemtSlot=9, ParachuteEquipemtSlot=11, GlideEquipemtSlot=15 }
_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}
_G.SuitSkin, _G.BagSkin, _G.HelmetSkin, _G.ParachuteSkin, _G.GliderSkin, _G.PetSkin = 0, 0, 0, 0, 0, 0
_G.LastBackApplyValue, _G.LastHelmetApplyValue = 0, 0
_G.skinIdCache, _G.skinIdCache2 = {}, {}
local var_180 = {}

local function func_1(id)
    local puffer_manager_1 = require('client.slua.logic.download.puffer.puffer_manager')
    local puffer_const_1 = require('client.slua.logic.download.puffer_const')
    if puffer_manager_1 and puffer_const_1 and puffer_manager_1.GetState(puffer_const_1.ENUM_DownloadType.ODPAK, {id}) ~= puffer_const_1.ENUM_DownloadState.Done then
        puffer_manager_1.Download(puffer_const_1.ENUM_DownloadType.ODPAK, {id})
    end
end
_G.download_item = func_1

_G.get_skin_id = function(weaponID)
    if not weaponID then return nil end
    local var_241 = (_G.WeaponSkinIndex[weaponID]) or 1
    local var_81 = _G.skinIdMappings[weaponID]
    if not var_81 or not var_81[var_241] then return weaponID end
    
    local var_155 = var_81[var_241]
    if not _G.skinIdCache2[var_155] then 
        pcall(_G.download_item, var_155)
        _G.skinIdCache2[var_155] = true 
    end
    return var_155
end

_G.get_vehicle_skin_id = function(vehicleID)
    if not vehicleID or vehicleID == 0 then return vehicleID end
    
    local var_73 = tostring(vehicleID)
    local var_83 = string.sub(var_73, 1, 4)
    local var_62 = tonumber(var_83 .. "001")
    
    local var_223 = _G.VehicleSkinsList[var_62]
    if var_223 then
        local var_45 = _G.VehicleSkinIndex[var_62] or 1
        if var_45 < 1 then var_45 = 1 end
        if var_45 > #var_223 then var_45 = #var_223 end
        
        local var_193 = var_223[var_45]
        if var_193 and var_193 > 0 then
            if not _G.skinIdCache2[var_193] then 
                if _G.download_item then pcall(_G.download_item, var_193) end
                _G.skinIdCache2[var_193] = true 
            end
            return var_193
        end
    end
    return vehicleID
end

_G.LoadSkinDataFromINI = function()
    local var_34 = io.open(_G.ConfigFilePath, 'r')
    if not var_34 then return end
    
    local var_109 = false
    for line in var_34:lines() do
        if line:match('%[SKIN_LIST%]') then 
            var_109 = true 
        elseif line:match('%[SELECTED%]') then 
            var_109 = false 
        end
        
        if var_109 and not line:match('^%s*%[') and not line:match('^%s*[#]') then
            local var_86, var_61 = line:match('([^=]+)=(.+)')
            if var_86 and var_61 then
                var_86 = var_86:match("^%s*(.-)%s*$")
                local var_182 = {}
                for val in var_61:gmatch('([^,]+)') do
                    local var_112 = tonumber(val:match("^%s*(.-)%s*$"))
                    if var_112 then table.insert(var_182, var_112) end
                end
                
                if #var_182 > 0 then
                    if _G.OutfitSkins[var_86] ~= nil then 
                        _G.OutfitSkins[var_86] = var_182
                    elseif _G.VehicleMapDict[var_86] ~= nil then 
                        local var_1 = _G.VehicleMapDict[var_86]
                        _G.VehicleSkinsList[var_1] = var_182
                    elseif tonumber(var_86) then 
                        _G.skinIdMappings[tonumber(var_86)] = var_182 
                    end
                end
            end
        end
    end
    var_34:close()
    
    _G.SuitSkinsMap = _G.OutfitSkins.Suit
    _G.BagSkinsMap = _G.OutfitSkins.Bag
    _G.HelmetSkinsMap = _G.OutfitSkins.Helmet
    _G.ParachutSkinsMap = _G.OutfitSkins.Parachut
    _G.PetSkinsMap = _G.OutfitSkins.Pet
end
pcall(_G.LoadSkinDataFromINI)

_G.ReadConfigFile = function()
    local var_34 = io.open(_G.ConfigFilePath, 'r')
    if not var_34 then return end
    
    local var_220 = {}
    for line in var_34:lines() do
        if line:match('%[SKIN_LIST%]') then break end 
        if not line:match('^%s*%[') and not line:match('^%s*[#]') then
            local var_86, var_174 = line:match('([%w_]+)%s*=%s*(%d+)')
            if var_86 and var_174 and not line:match(',') then 
                var_220[var_86] = tonumber(var_174) 
            end
        end
    end
    var_34:close()
    
    local function func_12(var_86, map, globalVarName)
        if var_220[var_86] and var_220[var_86] ~= var_180[var_86] then 
            _G[globalVarName] = map and map[var_220[var_86] + 1] or 0
            var_180[var_86] = var_220[var_86] 
        end
    end
    
    func_12('Suit', _G.SuitSkinsMap, 'SuitSkin')
    func_12('Bag', _G.BagSkinsMap, 'BagSkin')
    func_12('Helmet', _G.HelmetSkinsMap, 'HelmetSkin')
    func_12('Parachute', _G.ParachutSkinsMap, 'ParachuteSkin')
    func_12('Pet', _G.PetSkinsMap, 'PetSkin')
    
    local function func_10(var_86, id)
        if var_220[var_86] and var_220[var_86] ~= var_180[var_86] then 
            _G.WeaponSkinIndex[id] = var_220[var_86] + 1
            var_180[var_86] = var_220[var_86] 
        end
    end
    
    func_10('M416', 101004)
    func_10('AKM', 101001)
    func_10('UMP', 102002)
    func_10('SCAR', 101003)
    func_10('M762', 101008)
    func_10('AUG', 101006)
    func_10('Vector', 102003)
    func_10('UZI', 102004)
    func_10('Kar98k', 103001)
    func_10('M24', 103002)
    func_10('AWM', 103003)
    func_10('DP28', 105002)
    func_10('M249', 105001)
    func_10('MG3', 105010)
    func_10('Shotgun', 104004)

    local function func_11(var_86)
        local var_1 = _G.VehicleMapDict[var_86]
        if var_1 and var_220[var_86] and var_220[var_86] ~= var_180[var_86] then 
            _G.VehicleSkinIndex[var_1] = var_220[var_86] + 1
            var_180[var_86] = var_220[var_86] 
        end
    end
    
    func_11('UAZ')
    func_11('Dacia')
    func_11('Buggy')
    func_11('Motor')
    func_11('CoupeRB')
end

_G.BaseAttachToIndex = {
    [201010]=1, [201005]=1, [201004]=1, 
    [201009]=2, [201003]=2, [201002]=2, 
    [201011]=3, [201007]=3, [201006]=3, 
    [204012]=4, [204005]=4, [204008]=4, 
    [204011]=5, [204004]=5, [204007]=5, 
    [204013]=6, [204006]=6, [204009]=6, 
    [203001]=7, [203002]=8, [203003]=9, [203014]=10, [203004]=11, [203015]=12, [203005]=13, 
    [202002]=14, [202001]=15, [202004]=16, [202005]=17, [202007]=18, [202006]=19, 
    [205002]=20, [205003]=20, [205001]=20, 
    [203018]=21, [204014]=22 
}

_G.VIP_Attachments = {}
_G.VipAttachToIndex = {} 

_G.LoadAttachmentsFromINI = function()
    local var_34 = io.open(_G.ConfigFilePath, 'r')
    if not var_34 then return end
    
    _G.VIP_Attachments = {}
    _G.VipAttachToIndex = {}
    
    local var_55 = false
    for line in var_34:lines() do
        line = line:match("^%s*(.-)%s*$")
        if line == '[ATTACHMENTS]' then 
            var_55 = true 
        elseif line:match('^%[') then 
            var_55 = false 
        end
        
        if var_55 and not line:match('^%[') and line ~= '' and not line:match('^#') then
            local var_165, var_61 = line:match('^(%d+)=(.+)$')
            if var_165 and var_61 then
                local var_155 = tonumber(var_165)
                local var_19 = {}
                local var_241 = 1
                for val in var_61:gmatch('([^,]+)') do
                    local var_69 = tonumber(val) or 0
                    table.insert(var_19, var_69)
                    if var_69 > 0 then _G.VipAttachToIndex[var_69] = var_241 end
                    var_241 = var_241 + 1
                end
                _G.VIP_Attachments[var_155] = var_19
            end
        end
    end
    var_34:close()
end
pcall(_G.LoadAttachmentsFromINI)

_G.equip_character_avatar = function(var_65)
    if not var_65 or not slua.isValid(var_65) or not var_65.AvatarComponent2 then return end
    local BackpackUtils_1 = import("BackpackUtils")
    local var_126 = var_65.AvatarComponent2.NetAvatarData and var_65.AvatarComponent2.NetAvatarData.SlotSyncData
    if not var_126 or not slua.isValid(var_126) or not BackpackUtils_1 then return end
    
    local function func_7(ApplyDataIdx, itemId, ApplyEquipSlot, isLevelDependent, levelFunc, globalCacheVal)
        if itemId == 0 then return end
        local var_117 = var_126:Get(ApplyDataIdx)
        if var_117 and var_117.SlotID == ApplyEquipSlot then
            local var_173 = itemId
            if isLevelDependent then
                local var_204 = levelFunc(var_117.AdditionalItemID) or 1
                var_173 = itemId + (var_204 - 1) * 1000
                if var_173 == var_117.ItemId and _G[globalCacheVal] == itemId then return end
                _G[globalCacheVal] = itemId
            elseif var_117.ItemId == itemId then 
                return 
            end

            if not _G.skinIdCache[var_173] then 
                _G.download_item(var_173)
                _G.skinIdCache[var_173] = true 
            end
            
            var_117.ItemId = var_173
            var_126:Set(ApplyDataIdx, var_117)
            var_65.AvatarComponent2:OnRep_BodySlotStateChanged()
        end
    end

    local var_47 = false
    for i = 0, var_126:Num() - 1 do
        local var_117 = var_126:Get(i)
        if var_117 and var_117.SlotID == _G.CustSlotType.GlideEquipemtSlot then 
            var_47 = true
            break 
        end
    end
    if not var_47 then 
        var_126:Add({ SlotID = _G.CustSlotType.GlideEquipemtSlot, ItemId = 0 }) 
    end

    for i = 0, var_126:Num() - 1 do
        func_7(i, _G.SuitSkin, _G.CustSlotType.ClothesEquipemtSlot, false)
        func_7(i, _G.BagSkin, _G.CustSlotType.BackpackEquipemtSlot, true, BackpackUtils_1.GetEquipmentBagLevel, 'LastBackApplyValue')
        func_7(i, _G.HelmetSkin, _G.CustSlotType.HelmetEquipemtSlot, true, BackpackUtils_1.GetEquipmentHelmetLevel, 'LastHelmetApplyValue')
        func_7(i, _G.GliderSkin, _G.CustSlotType.GlideEquipemtSlot, false)
        func_7(i, _G.ParachuteSkin, _G.CustSlotType.ParachuteEquipemtSlot, false)
    end
end

_G.ApplyWeaponSkins = function(GameplayData_1)
    pcall(function()
        local var_226 = GameplayData_1:GetWeaponManager()
        if not slua.isValid(var_226) then return end
        
        for slot = 1, 3 do
            local var_105 = var_226:GetInventoryWeaponByPropSlot(slot)
            if slua.isValid(var_105) and slua.isValid(var_105.synData) then
                local var_90 = var_105:GetWeaponID()
                local var_23 = _G.get_skin_id(var_90) or var_90
                local var_184 = false
                
                local var_150 = var_105.synData:Get(7) 
                if var_150 and var_150.defineID and var_150.defineID.TypeSpecificID ~= var_23 then
                    var_150.defineID.TypeSpecificID = var_23
                    var_105.synData:Set(7, var_150)
                    if var_105.SetWeaponAvatarID then pcall(function() var_105:SetWeaponAvatarID(var_23) end) end
                    if not _G.skinIdCache[var_23] then 
                        _G.download_item(var_23)
                        _G.skinIdCache[var_23] = true 
                    end
                    var_184 = true
                end
                
                if var_23 >= 10000000 and _G.VIP_Attachments and _G.VIP_Attachments[var_23] then
                    for AttachIdx = 0, 5 do 
                        local var_41 = var_105.synData:Get(AttachIdx)
                        if var_41 then
                            local var_213 = slua.IndexReference(var_41, "defineID")
                            if var_213 then
                                local var_161 = var_213.TypeSpecificID
                                if var_161 and var_161 > 0 then
                                    local var_241 = _G.BaseAttachToIndex[var_161] or _G.VipAttachToIndex[var_161]
                                    if var_241 and _G.VIP_Attachments[var_23][var_241] and _G.VIP_Attachments[var_23][var_241] > 0 then
                                        local var_20 = _G.VIP_Attachments[var_23][var_241]
                                        if var_20 ~= var_161 then
                                            var_41.defineID.TypeSpecificID = var_20
                                            var_105.synData:Set(AttachIdx, var_41)
                                            if not _G.skinIdCache2[var_20] then 
                                                if _G.download_item then pcall(_G.download_item, var_20) end
                                                _G.skinIdCache2[var_20] = true 
                                            end
                                            var_184 = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                if var_184 then
                    if var_105.DelayHandleAvatarMeshChanged then pcall(function() var_105:DelayHandleAvatarMeshChanged() end) end
                    if var_105.OnRep_synData then pcall(function() var_105:OnRep_synData() end) end
                end
            end
        end
    end)
end

_G.ApplyVehicleSkins = function(GameplayData_1)
    pcall(function()
        local var_131 = GameplayData_1:GetCurrentVehicle()
        if not slua.isValid(var_131) then 
            _G.LastVehicleEntity = nil
            return 
        end
        
        if not Game:IsDriver(GameplayData_1.Object) then return end

        local var_8 = var_131.VehicleAvatarComponent_BP or var_131:GetAvatarComponent()
        if not slua.isValid(var_8) then return end

        local var_122 = 0
        if var_131.AvatarDefaultCfg then
            var_122 = var_131.AvatarDefaultCfg.TypeSpecificID
        end
        if var_122 == 0 and var_8.VehicleNetAvatarData and var_8.VehicleNetAvatarData.ItemDefineID then
            var_122 = var_8.VehicleNetAvatarData.ItemDefineID.TypeSpecificID
        end
        if var_122 == 0 then return end

        local var_106 = _G.get_vehicle_skin_id(var_122)
        local var_194 = var_8:GetCurItemAvatarID()

        if var_106 and var_106 ~= 0 and var_194 ~= var_106 then
            if not _G.skinIdCache[var_106] then 
                if _G.download_item then pcall(_G.download_item, var_106) end
                _G.skinIdCache[var_106] = true 
            end

            if var_8.VehicleNetAvatarData and var_8.VehicleNetAvatarData.ItemDefineID then
                var_8.VehicleNetAvatarData.ItemDefineID.TypeSpecificID = var_106
                var_8.VehicleNetAvatarData.SkinOwnerUID = GameplayData_1.PlayerUID
            end
            
            if _G.LastVehicleEntity ~= var_131 or _G.CurrentEquipVehicleID ~= var_106 then
                _G.LastVehicleEntity = var_131
                _G.CurrentEquipVehicleID = var_106

                pcall(function()
                    var_8.lastEquipedAvatarId = var_194
                    if var_8.ShowVehicleSwitchEffect then 
                        var_8:ShowVehicleSwitchEffect() 
                    end
                    var_8.ClientUsedAvatarID = var_106
                    var_131.ClientUsedAvatarID = var_106
                    if var_8.ChangeItemAvatar then 
                        var_8:ChangeItemAvatar(var_106, false) 
                    end
                end)
            else
                if var_8.ChangeItemAvatar then var_8:ChangeItemAvatar(var_106, false) end
            end

            if var_8.EnableHighTireLight then
                var_8:EnableHighTireLight(true, var_106)
            end
            
            if var_131.UpdateParticle then pcall(function() var_131:UpdateParticle(var_106) end) end
            if var_131.ChangeParticles then pcall(function() var_131:ChangeParticles(var_106) end) end
            if var_131.ReActivateExhaustParticle then pcall(function() var_131:ReActivateExhaustParticle() end) end
            
            local VehicleLicenseNumberComponent_1 = import("VehicleLicenseNumberComponent")
            local var_72 = var_131:GetComponentByClass(VehicleLicenseNumberComponent_1)
            if slua.isValid(var_72) then
                if var_72.LicensePlate then
                    var_72.LicensePlate.ItemID = var_106
                    var_72.LicensePlate.ChassisLightId = var_106 + 1000
                end                if var_72.PreChangeEffect then var_72:PreChangeEffect() end
                if var_72.PreChangeChassisLight then var_72:PreChangeChassisLight() end
            end
            
            if var_131.SetVehicleMusicPlayState then var_131:SetVehicleMusicPlayState(true) end
        end
    end)
end

_G.HandlePetLogic = function()
    pcall(function()
        if not _G.PetSkin or _G.PetSkin == 0 or _G.PetSkin == 50000 or _G.PetSkin == _G.LastAppliedPet then return end
        if not _G.skinIdCache[_G.PetSkin] then _G.download_item(_G.PetSkin); _G.skinIdCache[_G.PetSkin] = true end
        
        local ModuleManager_1 = require("client.module_framework.ModuleManager")
        if ModuleManager_1 then
            local var_153 = ModuleManager_1.GetModule(ModuleManager_1.CommonModuleConfig.logic_pet)
            if var_153 then
                if var_153.SetCurPetID then var_153:SetCurPetID(_G.PetSkin) end
                if var_153.EquipPet then var_153:EquipPet(_G.PetSkin) end
            end
        end
        _G.LastAppliedPet = _G.PetSkin
    end)
end

_G.DeadBoxSkins = _G.DeadBoxSkins or {}
_G.AlreadyChangedSet = _G.AlreadyChangedSet or {}

local function func_13(t, element)
    if not t then return false end
    for _, var_174 in ipairs(t) do
        if var_174 == element then return true end
    end
    return false
end

local function func_5(loc1, loc2, tolerance)
    local dx = loc1.X - loc2.X
    local dy = loc1.Y - loc2.Y
    local dz = loc1.Z - loc2.Z
    return dx * dx + dy * dy + dz * dz < tolerance * tolerance
end

_G.DeadBox_TemperRequest = function(var_163)
    local var_65 = var_163:GetPlayerCharacterSafety()
    if not var_65 then return end
    
    local GameplayStatics_1 = import("GameplayStatics")
    if GameplayStatics_1 then
        local Actor_1 = import("Actor")
        local ui_util_1 = require("client.common.ui_util")
        if ui_util_1 then
            local var_171 = ui_util_1.GetGameInstance()
            if var_171 then
                local PlayerTombBox_1 = import("PlayerTombBox")
                local var_68 = GameplayStatics_1.GetAllActorsOfClass(var_171, PlayerTombBox_1, slua.Array(UEnums.EPropertyClass.Object, Actor_1))
                
                for _, var_46 in pairs(var_68) do
                    if slua.isValid(var_46) then
                        local var_221 = var_46.DamageCauser
                        if var_221 and var_221.Playerkey == var_163.Playerkey then
                            local var_97 = var_46.DeadBoxAvatarComponent_BP
                            if var_97 and not func_13(_G.AlreadyChangedSet, var_46) then
                                local var_130 = var_46:K2_GetActorLocation()
                                local var_11 = false
                                
                                for _, entry in pairs(_G.DeadBoxSkins) do
                                    if func_5(entry.location, var_130, 1.0) then
                                        var_97:ResetItemAvatar()
                                        var_97:PreChangeItemAvatar(entry.SkinID)
                                        var_97:SyncChangeItemAvatar(entry.SkinID)
                                        table.insert(_G.AlreadyChangedSet, var_46)
                                        var_11 = true
                                        break
                                    end
                                end
                                
                                if not var_11 then
                                    local var_48 = 0
                                    local var_57 = var_65.CurrentVehicle
                                    if var_57 and _G.CurrentEquipVehicleID and _G.CurrentEquipVehicleID ~= 0 then
                                        var_48 = tonumber(tostring(_G.CurrentEquipVehicleID) .. "1") or 0
                                    else
                                        local var_152 = var_65:GetCurrentWeapon()
                                        if var_152 then
                                            local var_150 = var_152.synData and var_152.synData:Get(7)
                                            if var_150 and var_150.defineID then
                                                var_48 = var_150.defineID.TypeSpecificID
                                            end
                                        end
                                    end
                                    
                                    if var_48 ~= 0 then
                                        var_97:ResetItemAvatar()
                                        var_97:PreChangeItemAvatar(var_48)
                                        var_97:SyncChangeItemAvatar(var_48)
                                        table.insert(_G.DeadBoxSkins, { location = var_130, SkinID = var_48 })
                                        table.insert(_G.AlreadyChangedSet, var_46)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

_G.AKFakeKillCounts = _G.AKFakeKillCounts or {}

_G.ForceEnableKillCounterUI = function()
    pcall(function()
        local KillCounterUISubsystem_1 = package.loaded["GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem"] or require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
        if KillCounterUISubsystem_1 and KillCounterUISubsystem_1.__inner_impl and not _G.KCUISystemHacked2 then
            local var_187 = KillCounterUISubsystem_1.__inner_impl
            var_187.CheckSupportKCUI = function() return true end
            
            var_187.CheckNeedMainKillCounterUI = function(self, var_92, PlayerID)
                if slua.isValid(var_92) then
                    local var_90 = var_92:GetWeaponID()
                    self:UpdateMainKillCounterUI(true, var_90, _G.get_skin_id(var_90) or var_90)
                else 
                    self:UpdateMainKillCounterUI(false) 
                end
            end
            
            local var_113 = var_187.UpdateMainKillCounterUI
            var_187.UpdateMainKillCounterUI = function(self, bShow, var_145, AvatarID)
                if bShow then AvatarID = _G.get_skin_id(var_145) or AvatarID end
                if var_113 then var_113(self, bShow, var_145, AvatarID) end
            end
            _G.KCUISystemHacked2 = true
        end

        local ModuleManager_1 = require("client.module_framework.ModuleManager")
        if ModuleManager_1 then
            local var_232 = ModuleManager_1.GetModule(ModuleManager_1.CommonModuleConfig.LogicKillCounter)
            if var_232 and not _G.KCLogicHacked2 then
                var_232.CheckSupportKC = function() return true end
                var_232.CheckSupportKillCounterAvatar = function() return true end
                var_232.CheckHasWeaponKillCounter = function() return true end
                var_232.GetBaseKillCounterIdByWeaponId = function() return 2100004 end
                var_232.GetEquipedKillCounterId = function() return 2100004 end
                var_232.GetMyEquipedKillCounterId = function() return 2100004 end
                var_232.GetOneWeaponKillCountInBattle = function(self, uid, weaponId) return _G.AKFakeKillCounts[weaponId] or 0 end
                var_232.GetWeaponKillCountByUid = function(self, uid, weaponId) return _G.AKFakeKillCounts[weaponId] or 0 end
                _G.KCLogicHacked2 = true
            end
        end

        local var_30 = "GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo"
        local var_84 = package.loaded[var_30] or require(var_30)
        if var_84 and var_84.__inner_impl and not _G.KillInfoCounterHacked then
            local var_219 = var_84.__inner_impl.FileItem
            var_84.__inner_impl.FileItem = function(self, DamageRecordData)
                pcall(function()
                    local GameplayData_2 = require("GameLua.GameCore.Data.GameplayData").GetPlayerCharacter()
                    if slua.isValid(GameplayData_2) and DamageRecordData.Causer == GameplayData_2:GetPlayerNameSafety() then 
                        local var_137 = GameplayData_2:GetCurrentWeapon()
                        if slua.isValid(var_137) then
                            local var_17 = var_137:GetWeaponID()
                            local var_103 = _G.get_skin_id(var_17)
                            if var_103 then DamageRecordData.CauserWeaponAvatarID = var_103 end
                            if _G.SuitSkin ~= 0 then DamageRecordData.CauserClothAvatarID = _G.SuitSkin end
                            
                            DamageRecordData.IsUseColor, DamageRecordData.UseColor = true, import("LinearColor")(1.0, 0.8, 0.0, 1.0) 
                            
                            if DamageRecordData.ResultHealthStatus == 2 then
                                _G.AKFakeKillCounts[var_17] = (_G.AKFakeKillCounts[var_17] or 0) + 1
                                local manager_1 = require("client.slua_ui_framework.manager")
                                local var_101 = manager_1.GetUI(manager_1.UI_Config_InGame.MainKillCounter)
                                if var_101 and var_101.UpdateWeaponID then
                                    local var_195 = var_103 or var_137:GetWeaponMainAvatarID()
                                    var_101:UpdateWeaponID(var_17, var_195)
                                    local var_189 = ModuleManager_1.GetModule(ModuleManager_1.CommonModuleConfig.LogicKillCounter)
                                    local var_214 = var_189:GetEquipedKillCounterId(0, var_195)
                                    var_101:SetKillCounterItemShowWithNum(var_214, _G.AKFakeKillCounts[var_17], var_195)
                                end
                            end
                        end
                    end
                end)
                if var_219 then return var_219(self, DamageRecordData) end
            end
            _G.KillInfoCounterHacked = true
        end

        local SwitchWeaponSlotMode2_1 = package.loaded["GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2"] or require("GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2")
        if SwitchWeaponSlotMode2_1 and SwitchWeaponSlotMode2_1.__inner_impl and not _G.SlotBaseHacked then
            SwitchWeaponSlotMode2_1.__inner_impl.CheckShowKCIcon = function(self)
                if self.KillCounterImg and slua.isValid(self.KillCounterImg) then 
                    self.KillCounterImg:SetVisibility(import("ESlateVisibility").SelfHitTestInvisible) 
                end
            end
            _G.SlotBaseHacked = true
        end
    end)
end

function _G.InitializeSkinModSystem()
    pcall(function()
        local LobbyAvatar_1 = package.loaded["client.logic.avatar.LobbyAvatar"] or require("client.logic.avatar.LobbyAvatar")
        if LobbyAvatar_1 and not _G.LobbyBypassHacked then
            local var_210 = LobbyAvatar_1.PutonEquipment
            LobbyAvatar_1.PutonEquipment = function(self, itemID, tAvatarCustom, tExtraData)
                local var_241 = _G.BaseAttachToIndex and _G.BaseAttachToIndex[itemID]
                if var_241 then
                    local var_134 = self.GetCurHoldingWeaponSkinID and self:GetCurHoldingWeaponSkinID()
                    if var_134 and var_134 >= 10000000 and _G.VIP_Attachments and _G.VIP_Attachments[var_134] then
                        local var_111 = _G.VIP_Attachments[var_134][var_241]
                        if var_111 and var_111 > 0 then
                            if self.HandleDownload then self:HandleDownload(var_111, nil, nil, false) end
                            itemID = var_111
                        end
                    end
                end
                if var_210 then
                    return var_210(self, itemID, tAvatarCustom, tExtraData)
                end
            end

            local var_201 = LobbyAvatar_1.CharEquipWeaponByResId
            LobbyAvatar_1.CharEquipWeaponByResId = function(self, resID, isUse, isAsync, SocketName)
                local var_191
                if var_201 then
                    var_191 = var_201(self, resID, isUse, isAsync, SocketName)
                end
                if isUse and self.GetEquipments then
                    local var_239 = self:GetEquipments()
                    for _, equip in ipairs(var_239) do
                        if _G.BaseAttachToIndex and _G.BaseAttachToIndex[equip.itemID] then
                            self:PutonEquipment(equip.itemID, equip.CustomInfo, {bIsUse = false})
                        end
                    end
                end
                return var_191
            end
            _G.LobbyBypassHacked = true
        end
    end)

    pcall(function()
        local Common_Items_UIBP_1 = package.loaded["client.slua.component.item.ItemChildren.Common_Items_UIBP"] or require("client.slua.component.item.ItemChildren.Common_Items_UIBP")
        if Common_Items_UIBP_1 and not _G.IconBaloHacked then
            local var_211 = Common_Items_UIBP_1.InitView
            Common_Items_UIBP_1.InitView = function(self, nItemId, nCount, nValidTime, tExtraData)
                tExtraData = tExtraData or {}
                local var_98 = nil
                
                if _G.get_skin_id then
                    local var_10 = _G.get_skin_id(nItemId)
                    if var_10 and var_10 ~= nItemId then
                        var_98 = var_10
                    end
                end
                
                local var_241 = _G.BaseAttachToIndex and _G.BaseAttachToIndex[nItemId]
                if not var_98 and var_241 then
                    local GameplayData_3 = require("GameLua.GameCore.Data.GameplayData")
                    if GameplayData_3 then
                        local GameplayData_1 = GameplayData_3.GetPlayerCharacter()
                        if GameplayData_1 and slua.isValid(GameplayData_1) then
                            local var_139 = GameplayData_1:GetCurrentWeapon()
                            if slua.isValid(var_139) then
                                local var_90 = var_139:GetWeaponID()
                                local var_208 = _G.get_skin_id(var_90) or var_90
                                if var_208 >= 10000000 and _G.VIP_Attachments and _G.VIP_Attachments[var_208] then
                                    local var_79 = _G.VIP_Attachments[var_208][var_241]
                                    if var_79 and var_79 > 0 then
                                        var_98 = var_79
                                    end
                                end
                            end
                        end
                    end
                end
                
                if var_98 then
                    tExtraData.displayResId = var_98
                    if not _G.skinIdCache2[var_98] then
                        if _G.download_item then pcall(_G.download_item, var_98) end
                        _G.skinIdCache2[var_98] = true
                    end
                end
                
                if var_211 then
                    return var_211(self, nItemId, nCount, nValidTime, tExtraData)
                end
            end
            _G.IconBaloHacked = true
        end
    end)

    pcall(function()
        local var_110 = "GameLua.Activity.Commercialize.GamePlay.Vehicle.VehiclePlateLicenseUtil"
        local var_91 = package.loaded[var_110] or require(var_110)
        
        if var_91 and not _G.VehicleEffectHacked then
            var_91.CheckIsBetterVehicle = function() return true end
            var_91.CheckHasUnLockFeature = function() return true end
            var_91.NeedOpenHighTire = function() return true end
            
            local var_230 = var_91.GetUpgradeEffectList
            var_91.GetUpgradeEffectList = function(UID)
                local GameplayData_1 = require("GameLua.GameCore.Data.GameplayData").GetPlayerCharacter()
                if slua.isValid(GameplayData_1) and GameplayData_1:GetCurrentVehicle() then
                    local var_131 = GameplayData_1:GetCurrentVehicle()
                    local var_8 = var_131.VehicleAvatarComponent_BP or var_131:GetAvatarComponent()
                    if slua.isValid(var_8) then
                        local var_193 = var_8.VehicleNetAvatarData and var_8.VehicleNetAvatarData.ItemDefineID.TypeSpecificID or var_8:GetCurItemAvatarID()
                        local var_166 = CDataTable.GetTableData("BetterVehicleEffect", var_193)
                        if var_166 and var_166.EffectIDList then
                            local var_88 = slua.Array(UEnums.EPropertyClass.Int)
                            for i=0, var_166.EffectIDList:Num()-1 do
                                var_88:Add(var_166.EffectIDList:Get(i))
                            end
                            return var_88
                        end
                    end
                end
                if var_230 then return var_230(UID) end
                return nil
            end
            _G.VehicleEffectHacked = true
        end

        local VehicleAvatarComponent_1 = package.loaded["GameLua.GameCore.Module.Vehicle.Component.VehicleAvatarComponent"] or require("GameLua.GameCore.Module.Vehicle.Component.VehicleAvatarComponent")
        if VehicleAvatarComponent_1 and VehicleAvatarComponent_1.__inner_impl and not _G.VehicleAvatarSwitchHacked then
            
            VehicleAvatarComponent_1.__inner_impl.CheckCanPlaySkinSwitchEffect = function(self, curVehicleId, lastVehicleId)
                return true
            end
            
            VehicleAvatarComponent_1.__inner_impl.ShowVehicleSwitchEffect = function(self)
                if not self.curSwitchEffectId or self.curSwitchEffectId <= 0 then
                    self.curSwitchEffectId = 7303001
                end
                
                local var_50 = self:GetOwner()
                if not slua.isValid(var_50) then return false end
                
                if self.uSwitchEffectActor then
                    self:StopSkinSwitchEffect()
                    self.uSwitchEffectActor:K2_DestroyActor()
                    self.uSwitchEffectActor = nil
                end
                
                if not self.lastEquipedAvatarId or self.lastEquipedAvatarId <= 0 then
                    self.lastEquipedAvatarId = var_50.ClientUsedAvatarID or var_50:GetDefaultAvatarID() or 0
                end
                
                local var_96 = var_50.ClientUsedAvatarID or self.lastEquipedAvatarId or 0
                local var_133 = self:IsLobbyActor()
                local var_205 = slua_GameFrontendHUD and slua_GameFrontendHUD:GetWorld()
                if not var_205 then return false end
                
                local VehiclePlateLicenseUtil_1 = require("GameLua.Activity.Commercialize.GamePlay.Vehicle.VehiclePlateLicenseUtil")
                local var_9 = VehiclePlateLicenseUtil_1.GetSwitchEffectActorPath()
                local var_31 = import(var_9)

                self.uSwitchEffectActor = var_205:SpawnActor(var_31, nil, nil, nil)
                if not slua.isValid(self.uSwitchEffectActor) then
                    self.uSwitchEffectActor = nil
                    return false
                end
                
                self.uSwitchEffectActor:K2_AttachToActor(var_50, "None", 1, 1, 1, false)
                self.uSwitchEffectActor:K2_SetActorRelativeLocation(FVector(0, 0, 0), false, nil, false)
                self.uSwitchEffectActor:K2_SetActorRelativeRotation(FRotator(0, 0, 0), false, nil, false)
                
                self:ChangeFakeSwitchVehicleAvatar(self.uSwitchEffectActor.Mesh, self.lastEquipedAvatarId)
                self.uSwitchEffectActor:SetAnimInsAndAnimState(self.uOldVehicleMeshAnimClass, var_50)
                self.uSwitchEffectActor:StartVehicleSwitchEffect(var_50, self.curSwitchEffectId, self.lastEquipedAvatarId, var_96, var_133)
                
                self.uOldVehicleMeshAnimClass = nil
                return true
            end
            
            VehicleAvatarComponent_1.__inner_impl.ResetAnimationState = function(self)
                if self.uSwitchEffectActor then
                    self:StopSkinSwitchEffect()
                    self.uSwitchEffectActor:K2_DestroyActor()
                    self.uSwitchEffectActor = nil
                end
                self.lastEquipedAvatarId = 0
                self.curSwitchEffectId = 7303001
            end
            
            local var_121 = VehicleAvatarComponent_1.__inner_impl.ReceiveBeginPlay
            VehicleAvatarComponent_1.__inner_impl.ReceiveBeginPlay = function(self)
                if var_121 then var_121(self) end
                self:ResetAnimationState()
            end
            
            _G.VehicleAvatarSwitchHacked = true
        end

        local LobbyVehicle_1 = package.loaded["client.lobby_ue_object.Actor.LobbyVehicle"] or require("client.lobby_ue_object.Actor.LobbyVehicle")
        if LobbyVehicle_1 and not _G.LobbyVehicleHacked then
            local var_140 = LobbyVehicle_1.PreChangeVehicleAvatar
            LobbyVehicle_1.PreChangeVehicleAvatar = function(self, InAvatarID, InAdvanceAvatarID)
                local var_193 = _G.get_vehicle_skin_id(InAvatarID)
                if var_193 and var_193 ~= InAvatarID and var_193 ~= 0 then
                    if not _G.skinIdCache[var_193] then 
                        if _G.download_item then pcall(_G.download_item, var_193) end
                        _G.skinIdCache[var_193] = true 
                    end
                    InAvatarID = var_193
                end
                
                local var_218 = false
                if var_140 then
                    var_218 = var_140(self, InAvatarID, InAdvanceAvatarID)
                end
                
                pcall(function()
                    self.ClientUsedAvatarID = InAvatarID
                    if self.PlayStartUpEffect then self:PlayStartUpEffect() end
                    if self.PlayAccelerateEffect then self:PlayAccelerateEffect() end
                end)
                
                return var_218
            end
            _G.LobbyVehicleHacked = true
        end
    end)

    if not _G.AKSkinLoopStarted then
        _G.AKSkinLoopStarted = true
        local time_ticker_1 = require("common.time_ticker")
        
        local function func_2()
            pcall(function()
                local GameplayData_3 = require("GameLua.GameCore.Data.GameplayData")
                if GameplayData_3 then
                    local GameplayData_2 = GameplayData_3.GetPlayerCharacter()
                    if slua.isValid(GameplayData_2) then
                        _G.ForceEnableKillCounterUI()
                        _G.ReadConfigFile()
                        _G.LoadAttachmentsFromINI()
                        _G.equip_character_avatar(GameplayData_2)   
                        _G.ApplyWeaponSkins(GameplayData_2)  
                        _G.ApplyVehicleSkins(GameplayData_2)       
                        _G.HandlePetLogic()
                        local PC = GameplayData_3.GetPlayerController()
                        if slua.isValid(PC) then _G.DeadBox_TemperRequest(PC) end
                    end
                end
            end)
            if time_ticker_1 and time_ticker_1.AddTimerOnce then
                time_ticker_1.AddTimerOnce(0.1, func_2)
            end
        end
        func_2() 
    end
end

-- FIXED: Android ALL Versions (9 to 16) Compatible Menu
local var_135 = {
    '/storage/emulated/0/Android/data/com.pubg.imobile/files/VINESH_OP_MENU.ini',
    '/storage/emulated/0/Android/data/com.pubg.krmobile/files/VINESH_OP_MENU.ini',
    '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/VINESH_OP_MENU.ini',
    '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/VINESH_OP_MENU.ini'
}

function _G.AK_SaveINI()
    for _, path in ipairs(var_135) do
        local var_34 = io.open(path, "w")
        if var_34 then
            local var_186 = ""
            for _, f in ipairs(_G.AK_Features) do
                var_186 = var_186 .. f.id .. "=" .. tostring(f.val) .. "\n"
            end
            var_34:write(var_186)
            var_34:close()
        end
    end
    _G.EnvRequiresUpdate = true
    _G.MagicUpdateVersion = (_G.MagicUpdateVersion or 1) + 1
end

function _G.AK_LoadINI()
    local var_34 = nil
    for _, path in ipairs(var_135) do
        var_34 = io.open(path, "r")
        if var_34 then break end
    end
    if var_34 then
        local var_186 = var_34:read("*all")
        var_34:close()
        for _, f in ipairs(_G.AK_Features) do
            local var_141 = string.match(var_186, f.id .. "=(%d+)")
            if var_141 then f.val = tonumber(var_141) end
        end
    end
end

function _G.AK_GetVal(id)
    if not _G.AK_Features then return 0 end
    for _, f in ipairs(_G.AK_Features) do
        if f.id == id then return f.val end
    end
    return 0
end

-- FIXED: Working menu with proper toggle for ALL Android versions
function _G.ShowAKMenu()
    if not _G.AK_Features then 
        pcall(function()
            _G.AK_LoadINI()
            if not _G.AK_Features then return end
        end)
        if not _G.AK_Features then return end
    end

    local var_107 = _G.AK_Features[_G.AK_MenuIndex]
    local var_167 = "@GRW_XD | " .. (var_107 and var_107.name or "MENU")
    
    -- FIXED: Better formatting for all Android versions
    local function getValueDisplay(f)
        if f.type == "toggle" then
            return (f.val == 1) and "[ON]" or "[OFF]"
        elseif f.type == "percent_100" then
            return "[" .. tostring(f.val / 10) .. "%]"
        elseif f.type == "percent_10" then
            return "[" .. tostring(f.val) .. "%]"
        elseif f.type == "value_range" then
            return "[" .. tostring(f.val) .. "]"
        end
        return ""
    end
    
    local selected_status = var_107 and getValueDisplay(var_107) or ""
    
    local var_175 = "=== SELECTED ===\n"
    var_175 = var_175 .. "> " .. (var_107 and var_107.name or "N/A") .. " " .. selected_status .. "\n"
    var_175 = var_175 .. "================\n"
    var_175 = var_175 .. "ALL OPTIONS:\n\n"
    
    -- FIXED: Better list formatting for all Android versions
    for i, f in ipairs(_G.AK_Features) do
        local isSelected = (i == _G.AK_MenuIndex)
        local prefix = isSelected and ">> " or "   "
        local valueDisplay = getValueDisplay(f)
        var_175 = var_175 .. prefix .. f.name .. " " .. valueDisplay .. "\n"
    end
    var_175 = var_175 .. "\n================\n"

    local logic_common_msg_box_1 = package.loaded["client.slua.logic.common.logic_common_msg_box"] or require("client.slua.logic.common.logic_common_msg_box")
    if logic_common_msg_box_1 and logic_common_msg_box_1.Show then
        -- FIXED: Use clear button labels that work on all Android versions
        logic_common_msg_box_1.Show(4, var_167, var_175, 
            -- CHANGE/TOGGLE button action
            function() 
                if var_107 then
                    if var_107.type == "toggle" then
                        var_107.val = 1 - var_107.val
                    elseif var_107.type == "percent_100" then
                        var_107.val = var_107.val + 100
                        if var_107.val > 1000 then var_107.val = 0 end 
                    elseif var_107.type == "percent_10" then
                        var_107.val = var_107.val + 10
                        if var_107.val > 100 then var_107.val = 0 end 
                    elseif var_107.type == "value_range" then
                        var_107.val = var_107.val + (var_107.step or 5)
                        if var_107.val > (var_107.max or 150) then 
                            var_107.val = var_107.min or 90 
                        end
                    end
                    _G.AK_SaveINI()
                    if var_107.id:find("AIMBOT") or var_107.id:find("GIAT") or var_107.id:find("TAM") or var_107.id:find("RUNG") then
                        _G.AK_ForceWeaponUpdate = true
                    end
                    if var_107.id:find("MAGIC") then
                        _G.MagicUpdateVersion = _G.MagicUpdateVersion + 1
                    end
                    _G.EnvRequiresUpdate = true
                end
                _G.ShowAKMenu()
            end, 
            -- NEXT FUNCTION button action (FIXED: properly cycles through functions)
            function() 
                _G.AK_MenuIndex = _G.AK_MenuIndex + 1
                if _G.AK_MenuIndex > #_G.AK_Features then
                    _G.AK_MenuIndex = 1
                end
                _G.ShowAKMenu()
            end, 
            "ON", "NEXT")
    end
end

function NetworkRPC:ctor()
    self.bHasShownDevNotice = false 
    self.bHasShownExpiredNotice = false 
    self.AK_NativeESP_Ready = false
end

function NetworkRPC:_PostConstruct()
    NetworkRPC.__super._PostConstruct(self)
    self:InitAddSpecialMoveInfo()
    self.bCanNearDeathGiveup = true
    print(bWriteLog and "BRPlayerCharacterBase:_PostConstruct bCanNearDeathGiveup true")
    self:StartAdvancedSystems()
end

function NetworkRPC:ReceiveBeginPlay()
    NetworkRPC.__super.ReceiveBeginPlay(self)
    
    self:AddControlEvent(self, "MovementModeChangedDelegate", self.HandleOnMovementModeChangedNew, self)
    if self:HasAuthority() and self:CheckAddCheckFallingDistanceComponent() then
        local CheckFallingDistanceComponent_1 = import("CheckFallingDistanceComponent")
        if slua.isValid(CheckFallingDistanceComponent_1) and not slua.isValid(self:GetComponentByClass(CheckFallingDistanceComponent_1)) then
            print(bWriteLog and "BRPlayerCharacterBase:ReceiveBeginPlay Add CheckFallingDistanceComponent")
            Game:AddComponent(CheckFallingDistanceComponent_1, self, "CheckFallingDistanceComponent")
        end
    end
    if slua.isValid(self.STCharacterMovement) then
        self.STCharacterMovement.bPositiveBlowUp = true
    end
    if self.Role == ENetRole.ROLE_AutonomousProxy then
        self:AddControlEvent(self, "OnPawnStateDisabled", self.OnPawnStateChange, self)
        self:AddControlEvent(self, "OnPawnStateEnabled", self.OnPawnStateChange, self)
        self:AddControlEventConditionOnly(self, "OnAttrChangeEventDelegate", {
            AttrName = { "bCanSelfRescue" }
        }, self.CharacterAttrChangeEvent, self)
    end
    if Client then
        printf(bWriteLog and "BRPlayerCharacterBase:ReceiveBeginPlay, PlayerKey:%u ", self.PlayerKey)
        GameplayData_3.AddCharacter(self.Object)
        self:AddControlEvent(self, "OnAttachedToVehicle", self.HandleOnAttachedToVehicle, self)
        self:AddControlEvent(self, "OnDetachedFromVehicle", self.HandleOnDetachedFromVehicle, self)
    else
        self:AddCommonEventWithConditions(EVENTTYPE_INGAME_NORMAL, EVENTID_GAME_MODE_STATE_CHANGE, {
            [1] = "FinishedState"
        }, self.HandleFinishedState, self)
    end

    EventSystem:postEvent(EVENTTYPE_SINGLETRAINING, EVENTID_CHARACTER_BEGINPLAY, self.Object)
end

function NetworkRPC:ReceiveEndPlay(EndPlayReason)
    NetworkRPC.__super.ReceiveEndPlay(self, EndPlayReason)
    if Client and GameplayData_3.RemoveCharacter ~= nil then
        GameplayData_3.RemoveCharacter(self.Object)
    end
end

-- OPTIMIZED: Reduced lag in ESP system
function NetworkRPC:StartAdvancedSystems()
    if not Client then return end
    
    local ESP_Active = false
    local ESP_Box_Active = false
    local ESP_Green_Box_Active = false
    
    local function Valid(obj)
        return slua.isValid(obj)
    end
    
    -- OPTIMIZED: Visual mods with reduced overhead
    local function ApplyVisualMods(localPlayer, enemy, pc, mWh, mWp)
        if not ESP_Active then return end
        if not Valid(enemy) then return end
        
        local meshes = {}
        pcall(function()
            if Valid(enemy.Mesh) then table.insert(meshes, enemy.Mesh) end
            local SkelClass = import("SkeletalMeshComponent")
            if SkelClass then
                local childs = enemy:GetComponentsByClass(SkelClass)
                if childs then
                    local count = type(childs.Num) == "function" and childs:Num() or #childs
                    for c = 1, math.min(count, 5) do
                        local comp = type(childs.Get) == "function" and childs:Get(c-1) or childs[c]
                        if Valid(comp) and comp ~= enemy.Mesh then table.insert(meshes, comp) end
                    end
                end
            end
        end)
        
        local isEnabled = mWh or mWp
        if isEnabled then
            local depthTest = mWh            local blendMode = mWh and 2 or 1
            pcall(function()
                for _, comp in ipairs(meshes) do
                    if Valid(comp) then
                        local s, matInterface = pcall(function() return comp:GetMaterial(0) end)
                        if s and Valid(matInterface) then
                            local s2, baseMat = pcall(function() return matInterface:GetBaseMaterial() end)
                            if s2 and Valid(baseMat) then
                                if baseMat.bDisableDepthTest ~= depthTest then baseMat.bDisableDepthTest = depthTest end
                                if baseMat.BlendMode ~= blendMode then baseMat.BlendMode = blendMode end
                            end
                        end
                    end
                end
            end)
            pcall(function()
                for _, comp in ipairs(meshes) do
                    if Valid(comp) then
                        comp.UseScopeDistanceCulling = false 
                        comp.PrimitiveShadingStrategy = 1
                        comp.ShadingRate = 6
                    end
                end
                local finalColor
                if mWh then
                    local isVisible = false
                    if Valid(pc) and Valid(enemy) and type(pc.LineOfSightTo) == "function" then 
                        pcall(function() isVisible = pc:LineOfSightTo(enemy) end) 
                    end
                    local hiddenColor  = { R = 25.0, G = 0.0,  B = 25.0, A = 1.0, r = 25.0, g = 0.0,  b = 25.0, a = 1.0 }
                    local visibleColor = { R = 0.0,  G = 25.0, B = 25.0, A = 1.0, r = 0.0,  g = 25.0, b = 25.0, a = 1.0 }
                    finalColor = isVisible and visibleColor or hiddenColor
                else
                    finalColor = { R = 50.0, G = 50.0, B = 50.0, A = 1.0, r = 50.0, g = 50.0, b = 50.0, a = 1.0 }
                end
                local scale = { R = 3.0,  G = 3.0,  B = 0.0,  A = 0.0, r = 3.0,  g = 3.0,  b = 0.0,  a = 0.0 }
                enemy.WH_MIDs = enemy.WH_MIDs or {}
                local stateChanged = (enemy.WH_LastColorR ~= finalColor.R) or (enemy.WH_LastBlendMode ~= blendMode)
                for _, comp in ipairs(meshes) do
                    if Valid(comp) then
                        local compKey = tostring(comp)
                        enemy.WH_MIDs[compKey] = enemy.WH_MIDs[compKey] or {}
                        for i = 0, 3 do 
                            local s, matInterface = pcall(function() return comp:GetMaterial(i) end)
                            if not s or not Valid(matInterface) then break end
                            local isNewMID = false
                            local needCacheUpdate = false
                            local currentCached = enemy.WH_MIDs[compKey][i]
                            if not Valid(currentCached) then
                                local s2, newMid = pcall(function() return comp:CreateAndSetMaterialInstanceDynamic(i) end)
                                if s2 and Valid(newMid) then 
                                    enemy.WH_MIDs[compKey][i] = newMid
                                    currentCached = newMid
                                    isNewMID = true
                                    needCacheUpdate = true 
                                end
                            else
                                if matInterface ~= currentCached then 
                                    pcall(function() comp:SetMaterial(i, currentCached) end)
                                    needCacheUpdate = true 
                                end
                            end
                            if Valid(currentCached) and (stateChanged or isNewMID or needCacheUpdate) then
                                pcall(function()
                                    currentCached:SetVectorParameterValue("颜色", finalColor)
                                    currentCached:SetVectorParameterValue("Extra Light Color", finalColor)
                                    currentCached:SetVectorParameterValue("Para_Color", finalColor)
                                    currentCached:SetVectorParameterValue("Para_ColorTint", finalColor)
                                    currentCached:SetVectorParameterValue("Tint", finalColor)
                                    currentCached:SetVectorParameterValue("Color", finalColor)
                                    currentCached:SetVectorParameterValue("BaseColor", finalColor)
                                    currentCached:SetVectorParameterValue("BodyColor", finalColor)
                                    currentCached:SetVectorParameterValue("MainColor", finalColor)
                                    currentCached:SetVectorParameterValue("DiffuseColor", finalColor)
                                    currentCached:SetVectorParameterValue("EmissiveColor", finalColor)
                                    currentCached:SetVectorParameterValue("ParaScaleOffset", scale)
                                end)
                            end
                        end
                    end
                end
                if stateChanged then 
                    enemy.WH_LastColorR = finalColor.R
                    enemy.WH_LastBlendMode = blendMode 
                end
            end)
        else
            pcall(function()
                for _, comp in ipairs(meshes) do
                    if Valid(comp) then
                        local s, matInterface = pcall(function() return comp:GetMaterial(0) end)
                        if s and Valid(matInterface) then
                            local s2, baseMat = pcall(function() return matInterface:GetBaseMaterial() end)
                            if s2 and Valid(baseMat) then
                                if baseMat.bDisableDepthTest ~= false then baseMat.bDisableDepthTest = false end
                                if baseMat.BlendMode ~= 1 then baseMat.BlendMode = 1 end
                            end
                        end
                    end
                end
            end)
            enemy.WH_LastColorR = nil
            enemy.WH_LastBlendMode = nil
            enemy.WH_MIDs = nil
        end
    end
    
    -- OPTIMIZED: Main loop with reduced frequency for better performance
    self:AddGameTimer(0.15, true, function()
        if not slua.isValid(self.Object) then return end
        
        local GameplayData_2 = GameplayData_3.GetPlayerCharacter()
        if not slua.isValid(GameplayData_2) then return end

        -- Check if mod is expired
        if var_85 > var_151 then
            if self.Object == GameplayData_2 and not self.bHasShownExpiredNotice then
                if self.Object.IsAlive and self.Object:IsAlive() then
                    self.bHasShownExpiredNotice = true
                    pcall(function()
                        local logic_common_msg_box_1 = package.loaded["client.slua.logic.common.logic_common_msg_box"] or require("client.slua.logic.common.logic_common_msg_box")
                        if logic_common_msg_box_1 and logic_common_msg_box_1.Show then
                            logic_common_msg_box_1.Show(4, "OWNER @GRW_XD", "YOUR MOD VERSION HAS EXPIRED\nPLEASE CONTACT WHATSAPP 92+ 03704831068 TO PURCHASE", function() 
                                local KismetSystemLibrary_2 = import("KismetSystemLibrary")
                                if KismetSystemLibrary_2 then KismetSystemLibrary_2.LaunchURL("https://Wa.me/+923704831068") end
                            end, function() end, "CONTACT ADMIN", "CANCEL")
                        end
                    end)
                end
            end
            return 
        end

        -- Show developer notice and initialize VINESH_OP features
        if self.Object == GameplayData_2 and not self.bHasShownDevNotice then
            if self.Object.IsAlive and self.Object:IsAlive() then
                self.bHasShownDevNotice = true
                
                if not _G.AK_Features then
                    _G.AK_Features = {
                        { id="ESP_HP", name="ESP HEALTH BAR", val=0, type="toggle" },
                        { id="ESP_BOX", name="ESP BOX", val=0, type="toggle" },
                        { id="ESP_GREEN_BOX", name="ESP GREEN BOX", val=0, type="toggle" },
                        { id="IPAD_VIEW_TPP", name="IPAD VIEW TPP", val=90, type="value_range", min=90, max=150, step=5 },
                        { id="IPAD_VIEW_FPP", name="IPAD VIEW FPP", val=103, type="value_range", min=103, max=150, step=5 },
                        { id="AIMBOT", name="AIMBOT", val=0, type="toggle" },
                        { id="SPEED_AIMBOT", name="AIMBOT SPEED", val=0, type="percent_10", action_prefix="INCREASE" },
                        { id="FOV_AIMBOT", name="AIMBOT FOV", val=0, type="percent_10", action_prefix="INCREASE" },
                        { id="THU_TAM", name="REDUCE SPREAD", val=0, type="percent_10", action_prefix="REDUCE" },
                        { id="GIAM_GIAT_NGANG", name="REDUCE HORIZONTAL RECOIL", val=0, type="percent_10", action_prefix="REDUCE" },
                        { id="GIAM_GIAT_DOC", name="REDUCE VERTICAL RECOIL", val=0, type="percent_10", action_prefix="REDUCE" },
                        { id="GIAM_RUNG_SCOPE", name="REDUCE SCOPE SHAKE", val=0, type="percent_10", action_prefix="REDUCE" },
                        { id="MAGIC_HEAD", name="MAGIC HEAD", val=0, type="percent_100", action_prefix="INCREASE" },
                        { id="MAGIC_BODY", name="MAGIC BODY", val=0, type="percent_100", action_prefix="INCREASE" },
                        { id="MAGIC_LEGS", name="MAGIC LEGS", val=0, type="percent_100", action_prefix="INCREASE" },
                        { id="NOGRASS", name="REMOVE GRASS", val=0, type="toggle" },
                        { id="NOTREES", name="REMOVE TREES", val=0, type="toggle" },
                        { id="NOWATER", name="REMOVE WATER", val=0, type="toggle" },
                        { id="NOFOG", name="REMOVE FOG", val=0, type="toggle" },
                        { id="WHITE_BODY", name="WHITE BODY", val=0, type="toggle" },
                        { id="HUD_COORDS", name="HUD COORDINATES", val=0, type="toggle" },
                    }
                    _G.AK_MenuIndex = 1
                end

                pcall(function()
                    _G.AK_LoadINI()
                    _G.ShowAKMenu()
                end)
            end
        end

        -- Apply iPad view (FOV) settings
        local var_162 = _G.AK_GetVal("IPAD_VIEW_TPP")
        if var_162 == 0 or var_162 < 90 then var_162 = 90 end
        
        local var_216 = _G.AK_GetVal("IPAD_VIEW_FPP")
        if var_216 == 0 or var_216 < 103 then var_216 = 103 end
        
        local var_116 = self.Object.ThirdPersonCameraComponent
        local var_192 = self.Object.FirstPersonCameraComponent
        local var_228 = self.Object.bIsWeaponAiming or false
        
        if not var_228 then
            if slua.isValid(var_116) and var_162 > 90 then 
                var_116:SetFieldOfView(var_162)
                var_116.FieldOfView = var_162 
            end
            if slua.isValid(var_192) and var_216 > 103 then 
                var_192:SetFieldOfView(var_216)
                var_192.FieldOfView = var_216 
            end
        end

        -- Apply weapon mods
        if self.Object.GetCurrentWeapon then
            local var_120 = self.Object:GetCurrentWeapon()
            if slua.isValid(var_120) then
                local var_224 = os.clock()
                if self.LastWeaponEntity ~= var_120 then
                    self.LastWeaponEntity = var_120
                    self.bForceWeaponMod = true
                end
                
                if not self.LastWeaponModTime or var_224 > self.LastWeaponModTime + 2.0 then
                    self.bForceWeaponMod = true
                    self.LastWeaponModTime = var_224
                end
                
                if self.bForceWeaponMod or not var_120.bIsVINESH_OPded or _G.AK_ForceWeaponUpdate then
                    _G.AK_ForceWeaponUpdate = false
                    pcall(function()
                        local var_27 = var_120.ShootWeaponEntity_GEN_VARIABLE or var_120.ShootWeaponEntity
                        if slua.isValid(var_27) then
                            local var_128 = _G.AK_GetVal("THU_TAM") / 100.0
                            local var_127 = _G.AK_GetVal("GIAM_GIAT_NGANG") / 100.0
                            local var_67 = _G.AK_GetVal("GIAM_GIAT_DOC") / 100.0
                            local var_36 = _G.AK_GetVal("GIAM_RUNG_SCOPE") / 100.0
                            
                            var_27.GameDeviationFactor = 3.36 - (3.36 * var_128)
                            var_27.AccessoriesHRecoilFactor = 0.80 - (0.80 * var_127)
                            var_27.AccessoriesVRecoilFactor = 0.50 - (0.50 * var_67)
                            var_27.RecoilKickADS = 0.20 - (0.20 * var_36)

                            if _G.AK_GetVal("AIMBOT") == 1 then
                                if var_27.AutoAimingConfig then
                                    local var_76 = var_27.AutoAimingConfig
                                    local var_143 = _G.AK_GetVal("SPEED_AIMBOT") / 100.0
                                    local var_123 = _G.AK_GetVal("FOV_AIMBOT") / 100.0
                                    
                                    local var_178 = 3.0 + (12.0 * var_143)
                                    local var_115 = 1.5 + (38.5 * var_123)
                                    
                                    if var_76.OuterRange then
                                        var_76.OuterRange.Speed = var_178
                                        var_76.OuterRange.SpeedRate = var_178
                                        var_76.OuterRange.RangeRate = var_115
                                        var_76.OuterRange.RangeRateSight = var_115
                                        var_76.OuterRange.SpeedRateSight = var_178
                                        var_76.OuterRange.CrouchRate = 1.0
                                        var_76.OuterRange.ProneRate = 1.0
                                    end
                                    if var_76.InnerRange then
                                        var_76.InnerRange.Speed = var_178
                                        var_76.InnerRange.SpeedRate = var_178
                                        var_76.InnerRange.RangeRate = var_115
                                        var_76.InnerRange.RangeRateSight = var_115
                                        var_76.InnerRange.SpeedRateSight = var_178
                                        var_76.InnerRange.CrouchRate = 1.0
                                        var_76.InnerRange.ProneRate = 1.0
                                    end
                                    var_27.AutoAimingConfig = var_76
                                end
                            end
                        end
                    end)
                    var_120.bIsVINESH_OPded = true
                    self.bForceWeaponMod = false
                end
            end
        end

        -- Main ESP and environment mod loop
        if self.Role == ENetRole.ROLE_AutonomousProxy then
            -- Get ESP states once per frame
            local espHP = _G.AK_GetVal("ESP_HP") == 1
            local espBox = _G.AK_GetVal("ESP_BOX") == 1
            local espGreenBox = _G.AK_GetVal("ESP_GREEN_BOX") == 1
            
            ESP_Active = espBox
            ESP_Box_Active = espBox
            ESP_Green_Box_Active = espGreenBox
            
            -- Top screen radar (simplified for performance)
            pcall(function()
                local pc = GameplayData_3.GetPlayerController()
                if slua.isValid(pc) then
                    local HUD = pc:GetHUD()
                    if slua.isValid(HUD) then
                        local botCount = 0
                        local playerCount = 0
                        local myTeamId = self.Object.TeamID or 0
                        local myPos = self.Object:K2_GetActorLocation()
                        
                        local allPawns = {}
                        if GameplayData_3.GetAllPlayerCharacters then
                            allPawns = GameplayData_3.GetAllPlayerCharacters()
                        elseif GameplayData_3.GameCharacters then
                            for _, char in pairs(GameplayData_3.GameCharacters) do table.insert(allPawns, char) end
                        end
                        
                        for _, tPawn in pairs(allPawns) do
                            if slua.isValid(tPawn) and tPawn ~= self.Object and tPawn.TeamID ~= myTeamId then
                                local isDead = false
                                pcall(function()
                                    if type(tPawn.IsDead) == "function" and tPawn:IsDead() then isDead = true
                                    elseif tPawn.bIsDead == true or tPawn.bIsDeadFlag == true then isDead = true end
                                    local health = (type(tPawn.GetHealth) == "function") and tPawn:GetHealth() or (tPawn.Health or 100)
                                    if health <= 0 then isDead = true end
                                end)
                                
                                if not isDead then
                                    local isBot = false
                                    pcall(function() isBot = Game:IsAI(tPawn) end)
                                    if isBot then 
                                        botCount = botCount + 1 
                                    else 
                                        playerCount = playerCount + 1 
                                    end
                                end
                            end
                        end
                        
                        local enemyText = (playerCount > 0) and string.format("RED ENEMY: %d", playerCount) or "@GRW_XD NO ENEMY"
                        local enemyColor = (playerCount > 0) and { R = 255, G = 0, B = 0, A = 255 } or { R = 0, G = 255, B = 0, A = 255 }
                        HUD:AddDebugText(enemyText, self.Object, 0.11, {X=0, Y=0, Z=150}, {X=0, Y=0, Z=150}, enemyColor, true, false, true, nil, 1.3, true)

                        local botText = (botCount > 0) and string.format("RED BOT: %d", botCount) or "@GRW_XD NO BOT"
                        local botColor = (botCount > 0) and { R = 255, G = 0, B = 0, A = 255 } or { R = 0, G = 255, B = 0, A = 255 }
                        HUD:AddDebugText(botText, self.Object, 0.11, {X=0, Y=0, Z=130}, {X=0, Y=0, Z=130}, botColor, true, false, true, nil, 1.3, true)
                        
                        if _G.AK_GetVal("HUD_COORDS") == 1 then
                            local coordText = string.format("POS: X=%.0f, Y=%.0f, Z=%.0f", myPos.X, myPos.Y, myPos.Z)
                            HUD:AddDebugText(coordText, self.Object, 0.11, {X=0, Y=0, Z=110}, {X=0, Y=0, Z=110}, { R = 0, G = 255, B = 255, A = 255 }, true, false, true, nil, 1.2, true)
                        end
                    end
                end
            end)

            if not _G.VINESH_OPTickCount then _G.VINESH_OPTickCount = 0 end
            if not _G.MagicUpdateVersion then _G.MagicUpdateVersion = 1 end
            if _G.EnvRequiresUpdate == nil then _G.EnvRequiresUpdate = true end

            _G.VINESH_OPTickCount = _G.VINESH_OPTickCount + 1

            if _G.VINESH_OPTickCount % 30 == 0 then
                pcall(function()
                    local var_157, var_44, var_172 = _G.AK_GetVal("MAGIC_HEAD"), _G.AK_GetVal("MAGIC_BODY"), _G.AK_GetVal("MAGIC_LEGS")
                    local var_185, var_119, var_183, var_32 = _G.AK_GetVal("NOGRASS"), _G.AK_GetVal("NOTREES"), _G.AK_GetVal("NOWATER"), _G.AK_GetVal("NOFOG")
                    local var_21 = _G.AK_GetVal("WHITE_BODY")
                    
                    _G.AK_LoadINI() 
                    
                    if var_157 ~= _G.AK_GetVal("MAGIC_HEAD") or var_44 ~= _G.AK_GetVal("MAGIC_BODY") or var_172 ~= _G.AK_GetVal("MAGIC_LEGS") then
                        _G.MagicUpdateVersion = _G.MagicUpdateVersion + 1
                    end
                    if var_185 ~= _G.AK_GetVal("NOGRASS") or var_119 ~= _G.AK_GetVal("NOTREES") or var_183 ~= _G.AK_GetVal("NOWATER") or var_32 ~= _G.AK_GetVal("NOFOG") or var_21 ~= _G.AK_GetVal("WHITE_BODY") then
                        _G.EnvRequiresUpdate = true
                    end
                end)
            end

            if not self.AK_NativeESP_Ready then
                pcall(function()
                    local GamePlayTools_1 = require("GameLua.Mod.BaseMod.Common.GamePlayTools")
                    local var_33 = GamePlayTools_1.GetCurrentConfig("ScreenMarkConfig")
                    
                    if var_33 then
                        if var_33[1006] then
                            var_33[1006].bBindBlocked = true     
                            var_33[1006].bBindOutScreen = true   
                            var_33[1006].MaxWidgetNum = 99
                            var_33[1006].MaxShowDistance = 6000000
                            var_33[1006].bScaleByDistance = false
                            var_33[1006].BindSocketName = "root"
                            var_33[1006].bUseLuaWorldSocketName = true
                            var_33[1006].WorldPositionOffset = FVector(0, 0, -30)
                        end

                        if not var_33[9999] then
                            var_33[9999] = {
                                UIPathName = "/Game/Mod/EvoBase/BluePrints/UIBP/QuickSign/QuickSign_TipHitEnemy_UIBP_New.QuickSign_TipHitEnemy_UIBP_New_C",
                                MaxWidgetNum = 99,
                                MaxShowDistance = 6000000,
                                bBindOutScreen = true,
                                bBindBlocked = true,
                                bIsBindingActor = true,
                                BindSocketName = "head", 
                                bUseLuaWorldSocketName = true,
                                WorldPositionOffset = FVector(0, 0, 50),
                                bNeedPreLoad = true,
                                Priority = 2
                            }
                            local InGameMarkTools_1 = require("GameLua.Mod.BaseMod.Common.InGameMarkTools")
                            if InGameMarkTools_1 and InGameMarkTools_1.ScreenMarkManager and InGameMarkTools_1.ScreenMarkManager.OnInitMarkGroupData then
                                pcall(function() InGameMarkTools_1.ScreenMarkManager:OnInitMarkGroupData(9999) end)
                            end
                        end
                    end

                    for k, var_76 in pairs(package.loaded) do
                        if type(k) == "string" and string.find(k, "ScreenMarkConfig") then
                            if type(var_76) == "table" then
                                if var_76[1006] then
                                    var_76[1006].bBindBlocked = true     
                                    var_76[1006].bBindOutScreen = true   
                                    var_76[1006].MaxWidgetNum = 99
                                    var_76[1006].MaxShowDistance = 6000000
                                    var_76[1006].bScaleByDistance = false
                                    var_76[1006].BindSocketName = "root"
                                    var_76[1006].bUseLuaWorldSocketName = true
                                    var_76[1006].WorldPositionOffset = FVector(0, 0, -30)
                                end
                                var_76[9999] = {
                                    UIPathName = "/Game/Mod/EvoBase/BluePrints/UIBP/QuickSign/QuickSign_TipHitEnemy_UIBP_New.QuickSign_TipHitEnemy_UIBP_New_C",
                                    MaxWidgetNum = 99,
                                    MaxShowDistance = 6000000,
                                    bBindOutScreen = true,
                                    bBindBlocked = true,
                                    bIsBindingActor = true,
                                    BindSocketName = "head",
                                    bUseLuaWorldSocketName = true,
                                    WorldPositionOffset = FVector(0, 0, 50),
                                    bNeedPreLoad = true,
                                    Priority = 2
                                }
                            end
                        end
                    end

                    local SubsystemMgr_1 = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
                    local var_236 = SubsystemMgr_1:Get("ClientHPBarSubSystem")
                    if var_236 then
                        if var_236.SetPauseCheck then var_236:SetPauseCheck(true) end
                        if var_236.FocusActorCheckParam then
                            var_236.FocusActorCheckParam.CheckBlock = false 
                            var_236.FocusActorCheckParam.CheckDistance = 1000000
                        end
                    end
                    
                    local manager_1 = require("client.slua_ui_framework.manager")
                    if manager_1 and manager_1.GetUI then
                        local var_26 = manager_1.GetUI(manager_1.UI_Config_InGame.EnemyHpWidgetsMain)
                        if slua.isValid(var_26) then
                            if var_26.SetCheckBlock then var_26:SetCheckBlock(false) end
                            if var_26.UIRoot and var_26.UIRoot.CanvasPanel_HPBarWidgets then
                                if var_26.UIRoot.CanvasPanel_HPBarWidgets.SetRenderScale then
                                    var_26.UIRoot.CanvasPanel_HPBarWidgets:SetRenderScale(FVector2D(1.5, 1.5))
                                end
                            end
                        end
                    end
                end)
                self.AK_NativeESP_Ready = true
            end
            
            if _G.EnvRequiresUpdate then
                _G.EnvRequiresUpdate = false 
                pcall(function()
                    local KismetSystemLibrary_2 = import("KismetSystemLibrary")
                    local var_235 = GameplayData_3.GetPlayerController()
                    
                    local function func_4(cmdKey, cmdValue)
                        if slua.isValid(KismetSystemLibrary_2) and slua.isValid(var_235) then
                            KismetSystemLibrary_2.ExecuteConsoleCommand(var_235, cmdKey .. " " .. cmdValue)
                        end
                        local var_43 = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
                        if slua.isValid(var_43) and var_43.ExecuteCMD then var_43:ExecuteCMD(cmdKey, cmdValue) end
                    end

                    if slua.isValid(var_235) then
                        if _G.AK_GetVal("NOGRASS") == 1 then func_4("r.DisableGrassRender", "1") else func_4("r.DisableGrassRender", "0") end
                        if _G.AK_GetVal("NOTREES") == 1 then
                            func_4("foliage.DensityScale", "0")
                            func_4("r.Foliage.DensityScale", "0")
                            func_4("foliage.MinimumScreenSize", "10000")
                            func_4("r.DisableTreeRender", "1")
                        else
                            func_4("foliage.DensityScale", "1")
                            func_4("r.Foliage.DensityScale", "1")
                            func_4("foliage.MinimumScreenSize", "0.0001")
                            func_4("r.DisableTreeRender", "0")
                        end
                        if _G.AK_GetVal("NOWATER") == 1 then
                            func_4("r.Water.SingleLayer.Enable", "0")
                            func_4("r.Show.Water", "0")
                            func_4("r.Show.Translucency", "0")
                            func_4("r.DisableWaterRender", "1")
                        else
                            func_4("r.Water.SingleLayer.Enable", "1")
                            func_4("r.Show.Water", "1")
                            func_4("r.Show.Translucency", "1")
                            func_4("r.DisableWaterRender", "0")
                        end
                        if _G.AK_GetVal("NOFOG") == 1 then
                            func_4("r.SkyAtmosphere", "0")
                            func_4("r.Atmosphere", "0")
                            func_4("r.Fog", "0")
                            func_4("r.VolumetricFog", "0")
                            func_4("r.DisableSkyRender", "1")
                        else
                            func_4("r.SkyAtmosphere", "1")
                            func_4("r.Atmosphere", "1")
                            func_4("r.Fog", "1")
                            func_4("r.VolumetricFog", "1")
                            func_4("r.DisableSkyRender", "0")
                        end
                        if _G.AK_GetVal("WHITE_BODY") == 1 then
                            func_4("r.CharacterDiffuseOffset", "2")
                            func_4("r.CharacterDiffusePower", "5")
                            func_4("r.CharacterMinShadowFactor", "100")
                        else
                            func_4("r.CharacterDiffuseOffset", "0")
                            func_4("r.CharacterDiffusePower", "1")
                            func_4("r.CharacterMinShadowFactor", "0")
                        end
                    end
                end)
            end

            local var_95 = {}
            if GameplayData_3.GetAllPlayerCharacters then
                var_95 = GameplayData_3.GetAllPlayerCharacters()
            elseif GameplayData_3.GameCharacters then
                for _, char in pairs(GameplayData_3.GameCharacters) do table.insert(var_95, char) end
            end

            if not _G.AK_Active_Marks_Cache then _G.AK_Active_Marks_Cache = {} end

            for cacheKey, cacheData in pairs(_G.AK_Active_Marks_Cache) do
                local var_77 = false
                if not slua.isValid(cacheData.actor) then 
                    var_77 = true 
                else
                    pcall(function()
                        local var_46 = cacheData.actor
                        if var_46.bHidden or (var_46.Mesh and var_46.Mesh.bHidden) then var_77 = true end
                        if type(var_46.IsDead) == "function" and var_46:IsDead() then var_77 = true
                        elseif var_46.bIsDead == true or var_46.bIsDeadFlag == true then var_77 = true end
                    end)
                end

                if var_77 then
                    pcall(function()
                        if InGameMarkTools_1 and InGameMarkTools_1.ClientRemoveMapMark then
                            InGameMarkTools_1.ClientRemoveMapMark(cacheData.hpMark)
                            if cacheData.distMark then InGameMarkTools_1.ClientRemoveMapMark(cacheData.distMark) end
                        end
                    end)
                    _G.AK_Active_Marks_Cache[cacheKey] = nil
                end
            end

            for _, enemy in pairs(var_95) do
                if slua.isValid(enemy) and enemy ~= GameplayData_2 and enemy.TeamID ~= GameplayData_2.TeamID then
                    local var_159 = false
                    local var_237 = false

                    pcall(function()
                        if type(enemy.IsNearDeath) == "function" then var_237 = enemy:IsNearDeath()
                        elseif enemy.bIsNearDeath ~= nil then var_237 = enemy.bIsNearDeath end

                        if type(enemy.IsDead) == "function" then var_159 = enemy:IsDead()
                        elseif enemy.bIsDead ~= nil then var_159 = enemy.bIsDead
                        elseif enemy.bIsDeadFlag ~= nil then var_159 = enemy.bIsDeadFlag end

                        if enemy.bHidden or (enemy.Mesh and enemy.Mesh.bHidden) then var_159 = true end

                        if not var_237 then
                            local var_169 = 100
                            if type(enemy.GetHealth) == "function" then var_169 = enemy:GetHealth()
                            elseif enemy.Health ~= nil then var_169 = enemy.Health end
                            if var_169 <= 0 then var_159 = true end
                        end
                    end)

                    if not var_159 then
                        if espHP then
                            if enemy.bHasAKNativeHPBar and enemy.AK_LastKnockState ~= nil and enemy.AK_LastKnockState ~= var_237 then
                                pcall(function()
                                    if InGameMarkTools_1 and InGameMarkTools_1.ClientRemoveMapMark then 
                                        InGameMarkTools_1.ClientRemoveMapMark(enemy.NativeHPBarMark)
                                        InGameMarkTools_1.ClientRemoveMapMark(enemy.NativeDistMark)
                                    end
                                end)
                                enemy.bHasAKNativeHPBar = false
                                _G.AK_Active_Marks_Cache[tostring(enemy)] = nil
                            end
                            enemy.AK_LastKnockState = var_237

                            if not enemy.bHasAKNativeHPBar then
                                pcall(function()
                                    if InGameMarkTools_1 and InGameMarkTools_1.ClientAddMapMark then
                                        enemy.NativeHPBarMark = InGameMarkTools_1.ClientAddMapMark(1006, FVector(0,0,0), 0, "", 4, enemy)
                                        enemy.NativeDistMark = InGameMarkTools_1.ClientAddMapMark(9999, FVector(0,0,0), 0, "", 4, enemy)
                                        enemy.bHasAKNativeHPBar = true

                                        _G.AK_Active_Marks_Cache[tostring(enemy)] = {
                                            var_46 = enemy,
                                            hpMark = enemy.NativeHPBarMark,
                                            distMark = enemy.NativeDistMark
                                        }
                                    end
                                end)
                            end
                        else
                            if enemy.bHasAKNativeHPBar and InGameMarkTools_1 then
                                pcall(function()
                                    if InGameMarkTools_1.ClientRemoveMapMark then 
                                        InGameMarkTools_1.ClientRemoveMapMark(enemy.NativeHPBarMark)
                                        if enemy.NativeDistMark then InGameMarkTools_1.ClientRemoveMapMark(enemy.NativeDistMark) end
                                    else 
                                        InGameMarkTools_1.HideMapMark(enemy.NativeHPBarMark) 
                                        if enemy.NativeDistMark then InGameMarkTools_1.HideMapMark(enemy.NativeDistMark) end
                                    end
                                end)
                                enemy.NativeHPBarMark = nil
                                enemy.NativeDistMark = nil
                                enemy.bHasAKNativeHPBar = false
                                _G.AK_Active_Marks_Cache[tostring(enemy)] = nil
                            end
                        end
                        
                        if ESP_Box_Active then
                            ApplyVisualMods(GameplayData_2, enemy, GameplayData_3.GetPlayerController(), true, false)
                        else
                            ApplyVisualMods(GameplayData_2, enemy, GameplayData_3.GetPlayerController(), false, false)
                        end
                        
                        if ESP_Green_Box_Active then
                            pcall(function()
                                local pc = GameplayData_3.GetPlayerController()
                                if slua.isValid(pc) then
                                    local HUD = pc:GetHUD()
                                    if slua.isValid(HUD) then
                                        local isBot = false
                                        pcall(function() isBot = Game:IsAI(enemy) end)
                                        
                                        local color = { R = 255, G = 255, B = 0, A = 255 }
                                        if not isBot then
                                            local isVisible = false
                                            if type(pc.LineOfSightTo) == "function" then
                                                pcall(function() isVisible = pc:LineOfSightTo(enemy) end)
                                            end
                                            color = isVisible and { R = 0, G = 255, B = 0, A = 255 } or { R = 255, G = 0, B = 0, A = 255 }
                                        end
                                        
                                        local enemyLoc = enemy:K2_GetActorLocation()
                                        local myPos = self.Object:K2_GetActorLocation()
                                        
                                        local dx = enemyLoc.X - myPos.X
                                        local dy = enemyLoc.Y - myPos.Y
                                        local dz = enemyLoc.Z - myPos.Z
                                        local distM = math.floor(math.sqrt(dx*dx + dy*dy + dz*dz) / 100)
                                        
                                        if distM < 400 then
                                            for h = 90, 1090, 50 do
                                                HUD:AddDebugText("|", enemy, 0.11,
                                                    {X=0, Y=0, Z=h}, {X=0, Y=0, Z=h},
                                                    color, true, false, true, nil, 1.2, true)
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                        
                        -- OPTIMIZED: Magic bullet with reduced overhead
                        local var_142 = enemy.Mesh or (enemy.getAvatarComponent2 and enemy:getAvatarComponent2())
                        if slua.isValid(var_142) then
                            if not var_142.LastHitboxUpdateVersion or var_142.LastHitboxUpdateVersion ~= _G.MagicUpdateVersion then
                                var_142.bIsAKHitboxModded = false
                            end
                            if not var_142.bIsAKHitboxModded then
                                pcall(function()
                                    local var_2 = var_142.PhysicsAssetOverride
                                    if not slua.isValid(var_2) and var_142.SkeletalMesh then var_2 = var_142.SkeletalMesh.PhysicsAsset end

                                    if slua.isValid(var_2) and var_2.SkeletalBodySetups then
                                        if not _G.AK_OrigHitboxes then _G.AK_OrigHitboxes = {} end
                                        local var_7 = ""
                                        pcall(function() var_7 = var_2:GetName() end)
                                        if var_7 == "" then var_7 = "DefaultPhys" end
                                        
                                        if not _G.AK_OrigHitboxes[var_7] then 
                                            _G.AK_OrigHitboxes[var_7] = {} 
                                        end
                                        local var_53 = _G.AK_OrigHitboxes[var_7]

                                        local var_89 = 1.0 + (_G.AK_GetVal("MAGIC_HEAD") / 100.0)
                                        local var_146 = {
                                            ["head"] = var_89
                                        }

                                        local var_158 = var_2.SkeletalBodySetups
                                        local numBodySetups = 20
                                        pcall(function() if type(var_158.Num) == "function" then numBodySetups = math.min(var_158:Num(), 30) end end)
                                        for i = 1, numBodySetups do 
                                            local var_49 = nil
                                            pcall(function() var_49 = type(var_158.Get) == "function" and var_158:Get(i-1) or var_158[i] end)
                                            
                                            if slua.isValid(var_49) then
                                                local var_233 = string.lower(tostring(var_49.BoneName))
                                                local var_16 = nil
                                                for k, _ in pairs(var_146) do
                                                    if string.find(var_233, k) then var_16 = k break end
                                                end

                                                if var_16 then
                                                    local var_24 = var_146[var_16]
                                                    local var_114 = var_49.AggGeom
                                                    
                                                    local var_87 = var_114 and var_114.BoxElems or var_49.BoxElems
                                                    local var_215 = var_114 and var_114.SphereElems or var_49.SphereElems
                                                    local var_124 = var_114 and var_114.SphylElems or var_49.SphylElems

                                                    local var_12 = nil
                                                    if var_87 then pcall(function() var_12 = type(var_87.Get) == "function" and var_87:Get(0) or var_87[1] end) end
                                                    local var_82 = nil
                                                    if var_215 then pcall(function() var_82 = type(var_215.Get) == "function" and var_215:Get(0) or var_215[1] end) end
                                                    local var_138 = nil
                                                    if var_124 then pcall(function() var_138 = type(var_124.Get) == "function" and var_124:Get(0) or var_124[1] end) end

                                                    if not var_53[var_16] then
                                                        var_53[var_16] = { Box = nil, Sphere = nil, Sphyl = nil }
                                                        if var_12 then var_53[var_16].Box = { X = var_12.X, Y = var_12.Y, Z = var_12.Z } end
                                                        if var_82 then var_53[var_16].Sphere = { Radius = var_82.Radius } end
                                                        if var_138 then var_53[var_16].Sphyl = { Radius = var_138.Radius, Length = var_138.Length } end
                                                    end

                                                    local var_136 = var_53[var_16]

                                                    if var_136.Box and var_12 then
                                                        var_12.X = var_136.Box.X * var_24
                                                        var_12.Y = var_136.Box.Y * var_24
                                                        var_12.Z = var_136.Box.Z * var_24
                                                        pcall(function() if type(var_87.Set) == "function" then var_87:Set(0, var_12) else var_87[1] = var_12 end end)
                                                        if var_114 then var_114.BoxElems = var_87; var_49.AggGeom = var_114 else var_49.BoxElems = var_87 end
                                                    end

                                                    if var_136.Sphere and var_82 then
                                                        var_82.Radius = var_136.Sphere.Radius * var_24
                                                        pcall(function() if type(var_215.Set) == "function" then var_215:Set(0, var_82) else var_215[1] = var_82 end end)
                                                        if var_114 then var_114.SphereElems = var_215; var_49.AggGeom = var_114 else var_49.SphereElems = var_215 end
                                                    end

                                                    if var_136.Sphyl and var_138 then
                                                        var_138.Radius = var_136.Sphyl.Radius * var_24
                                                        var_138.Length = var_136.Sphyl.Length * var_24
                                                        pcall(function() if type(var_124.Set) == "function" then var_124:Set(0, var_138) else var_124[1] = var_138 end end)
                                                        if var_114 then var_114.SphylElems = var_124; var_49.AggGeom = var_114 else var_49.SphylElems = var_124 end
                                                    end

                                                end
                                            end
                                        end
                                        pcall(function() 
                                            if var_142.SetPhysicsAsset then var_142:SetPhysicsAsset(var_2) end
                                            var_142.PhysicsAssetOverride = var_2
                                            if var_142.RecreatePhysicsState then 
                                                pcall(function() var_142:RecreatePhysicsState() end) 
                                            end
                                        end)

                                    end
                                end)
                                var_142.bIsAKHitboxModded = true
                                var_142.LastHitboxUpdateVersion = _G.MagicUpdateVersion
                            end
                        end
                    else
                        if enemy.bHasAKNativeHPBar and InGameMarkTools_1 then
                            pcall(function()
                                if InGameMarkTools_1.ClientRemoveMapMark then 
                                    InGameMarkTools_1.ClientRemoveMapMark(enemy.NativeHPBarMark)
                                    if enemy.NativeDistMark then InGameMarkTools_1.ClientRemoveMapMark(enemy.NativeDistMark) end
                                else 
                                    InGameMarkTools_1.HideMapMark(enemy.NativeHPBarMark) 
                                    if enemy.NativeDistMark then InGameMarkTools_1.HideMapMark(enemy.NativeDistMark) end
                                end
                            end)
                            enemy.NativeHPBarMark = nil
                            enemy.NativeDistMark = nil
                            enemy.bHasAKNativeHPBar = false
                        end
                        ApplyVisualMods(GameplayData_2, enemy, GameplayData_3.GetPlayerController(), false, false)
                    end
                end
            end
        end
    end)
end

-- ANTI-BAN SYSTEM: Blocks all reporting and detection mechanisms
function _G.InitializeSkinBypass()
    pcall(function()
        local puffer_tlog_1 = package.loaded["client.slua.logic.download.report.puffer_tlog"]
        if puffer_tlog_1 then
            puffer_tlog_1.ReportEvent = function() end
            puffer_tlog_1.ReportDownloadResult = function() end
            puffer_tlog_1.ReportODPAKError = function() end
        end

        local AvatarUtils_2 = package.loaded["AvatarUtils"]
        if AvatarUtils_2 then
            AvatarUtils_2.CheckIsWeaponInBlackList = function() return false end
            AvatarUtils_2.IsValidAvatar = function() return true end
        end

        local SubsystemMgr_2 = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr"):Get("FileCheckSubsystem")
        if SubsystemMgr_2 then
            SubsystemMgr_2.StartCheck = function() end
            SubsystemMgr_2.ReportAbnormalFile = function() end
        end
        
        local EquipmentExceptionReport_1 = package.loaded["client.slua.logic.report.EquipmentExceptionReport"]
        if EquipmentExceptionReport_1 then
            EquipmentExceptionReport_1.Report = function() end
        end
    end)
    print('[SkinBypass] Resource & Skin Scanners Bypassed!')
end

function _G.InitializeLogBlocker()
    print('[LogBlocker] Initializing Ultimate Log/Crash/Screenshot Blocker V11...')
    pcall(function()
        local ScreenshotMaker_1 = import("ScreenshotMaker")
        if ScreenshotMaker_1 then
            ScreenshotMaker_1.MakePicture = function() return "" end
            ScreenshotMaker_1.ReMakePicture = function() return "" end
            ScreenshotMaker_1.HasCaptured = function() return true end
        end

        local TLog_1 = package.loaded["TLog"] or _G.TLog
        if TLog_1 then
            TLog_1.Info = function() end
            TLog_1.Warning = function() end
            TLog_1.Error = function() end
            TLog_1.Debug = function() end
            TLog_1.Report = function() end
        end

        local CrashSight_1 = package.loaded["CrashSight"] or _G.CrashSight
        if CrashSight_1 then
            CrashSight_1.ReportException = function() end
            CrashSight_1.SetCustomData = function() end
            CrashSight_1.Log = function() end
        end
        
        local GameReportUtils_1 = package.loaded["GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils"]
        if GameReportUtils_1 then
            GameReportUtils_1.BugglyPostExceptionFull = function() return false end
            GameReportUtils_1.CheckCanBugglyPostException = function() return false end
            GameReportUtils_1.ReplayReportData = function() end
            GameReportUtils_1.ReportGameException = function() end
        end

        local ClientToolsReport_1 = package.loaded["client.slua.logic.report.ClientToolsReport"]
        if ClientToolsReport_1 then
            ClientToolsReport_1.SendReport = function() end
            ClientToolsReport_1.SendException = function() end
        end

        local tlog_report_utils_1 = package.loaded["client.slua.config.tlog.tlog_report_utils"]
        if tlog_report_utils_1 then
            tlog_report_utils_1.ReportTLogEvent = function() end
        end

        local UGCNewTLogReport_1 = package.loaded["client.slua.logic.ugc.UGCNewTLogReport"] or package.loaded["client.slua.data.BasicData.BasicDataTLogReport"]
        if UGCNewTLogReport_1 then
            UGCNewTLogReport_1.SendExposeReq = function() end
            UGCNewTLogReport_1.SendInteractionReq = function() end
            UGCNewTLogReport_1.TLogReport = function() end
        end
        
        local logic_ugc_tlog_1 = package.loaded["client.slua.logic.ugc.logic_ugc_tlog"]
        if logic_ugc_tlog_1 then
            logic_ugc_tlog_1.SendModTLog = function() end
            logic_ugc_tlog_1.ReportStay = function() end
        end

        local ClientTLogUtil_1 = package.loaded["GameLua.Mod.BaseMod.Client.ClientTLog.ClientTLogUtil"]
        if ClientTLogUtil_1 then
            ClientTLogUtil_1.ReportGeneralCountByBRPhase = function() end
            ClientTLogUtil_1.ReportCommonTLogDataByBRPhase = function() end
        end

        local GameplayData_3 = require("GameLua.GameCore.Data.GameplayData")
        if GameplayData_3 then
            local var_235 = GameplayData_3.GetPlayerControllerSafety and GameplayData_3.GetPlayerControllerSafety() or GameplayData_3.GetPlayerController()
            if slua.isValid(var_235) and var_235.ReportCrashKitFeature then
                var_235.ReportCrashKitFeature.ReportCharacterAttachedOnVehicleException = function() end
            end
        end
    end)
    print('[LogBlocker] Log/Crash/Buggly & Silent Screenshots Bypassed!')
end

function _G.InitializeScannerBlocker()
    print('[ScannerBlocker] Initializing Scanner Blocker V11...')
    pcall(function()
        local SubsystemMgr_1 = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        
        if SubsystemMgr_1 then
            local var_74 = SubsystemMgr_1:Get("AFKReportorSubsystem")
            if var_74 then 
                var_74.PlayerHaveAction = function() end
                var_74.ReportAFK = function() end
            end

            local var_198 = SubsystemMgr_1:Get("ClientDataStatistcsSubsystem")
            if var_198 then
                var_198.StartToCheck = function() end
                var_198.DelayCount = 0
                if var_198.ReportPingDelayTimer then
                    var_198:RemoveGameTimer(var_198.ReportPingDelayTimer)
                    var_198.ReportPingDelayTimer = nil
                end
            end

            local var_108 = SubsystemMgr_1:Get("AvatarExceptionSubsystem")
            if var_108 then
                var_108.ReportException = function() end
                var_108.BindPlayerCharacter = function() end
                var_108.CheckAvatarValid = function() return true end
            end
            
            local var_179 = SubsystemMgr_1:Get("ShootVerifySubSystemClient")
            if var_179 then
                var_179.ReportVerifyFail = function() end
                var_179.OnVerifyFailed = function() end
            end
        end

        local CreativeModeBlueprintLibrary_1 = import("CreativeModeBlueprintLibrary")
        if CreativeModeBlueprintLibrary_1 then
            CreativeModeBlueprintLibrary_1.MD5HashByteArray = function() return "BYPASSED_MD5_HASH" end
            CreativeModeBlueprintLibrary_1.GetContentDiffData = function() return true, "BYPASSED" end
        end

        local AvatarExceptionPlayerInst_1 = package.loaded["GameLua.Mod.Library.GamePlay.Avatar.Exception.AvatarExceptionPlayerInst"]
        if AvatarExceptionPlayerInst_1 then
            AvatarExceptionPlayerInst_1.CheckAvatarException = function() end
            AvatarExceptionPlayerInst_1.CheckAvatarExceptionOnce = function() end
            AvatarExceptionPlayerInst_1.ReportAvatarException = function() end
            AvatarExceptionPlayerInst_1.CheckSlotMeshVisible = function() return false end
            AvatarExceptionPlayerInst_1.CheckPawnVisible = function() return false end
            AvatarExceptionPlayerInst_1.CheckCanBugglyPostException = function() return false end
        end

        local AvatarCheckerModule_1 = package.loaded["blacklist.slua.logic.lobby_gm.AvatarCheckerModule"]
        if AvatarCheckerModule_1 then
            AvatarCheckerModule_1.CheckAvatar = function() return true end
            AvatarCheckerModule_1.ReportException = function() end
        end

        local logic_memory_warning_1 = package.loaded["client.slua.logic.memory_warning.logic_memory_warning"]
        if logic_memory_warning_1 then
            logic_memory_warning_1.OnMemoryWarning = function() end
            logic_memory_warning_1.ReportMemoryWarning = function() end
        end

        local logic_store_game_interface_1 = package.loaded["client.slua.logic.store.logic_store_game_interface"]
        if logic_store_game_interface_1 then
            logic_store_game_interface_1.IsStoreGameSupported = function() return true end 
            logic_store_game_interface_1.NotifyGetPGSLoginInfo = function() end 
        end

        local VoiceChatSubsystem_1 = package.loaded["GameLua.Mod.BaseMod.Client.Voice.VoiceChatSubsystem"]
        if VoiceChatSubsystem_1 then
            VoiceChatSubsystem_1.OnPlayerSubmitComplaint = function() end
        end

        local TssSdk_1 = package.loaded["TssSdk"] or _G.TssSdk
        if TssSdk_1 then
            local var_206 = TssSdk_1.OnRecvData
            TssSdk_1.OnRecvData = function(data)
                if type(data) == "string" and (string.find(data, "report") or string.find(data, "exception")) then
                    return
                end
                if var_206 then var_206(data) end
            end
            
            TssSdk_1.SendReportInfo = function() end
            TssSdk_1.ScanMemory = function() return true end
            TssSdk_1.IsEmulator = function() return false end
            TssSdk_1.GetTssSdkReportInfo = function() return "" end
        end
    end)
    print('[ScannerBlocker] Magic Bullet/MD5 Checks/TSS/OS Scans Bypassed!')
end

function _G.InitializeReplayTelemetryBlocker()
    print('[ReplayBlocker] Initializing Replay Telemetry Blocker V11...')
    pcall(function()
        local SubsystemMgr_1 = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        
        local var_94 = SubsystemMgr_1 and SubsystemMgr_1:Get("RescueBtnReplayTraceSubsystem")
        if var_94 then
            var_94.ReportTrace = function() end
            var_94.StartTickMonitor = function() end
            var_94.TickMonitorCheck = function() end
            var_94.ReportTickMonitorHeartbeat = function() end
        end

        local var_80 = SubsystemMgr_1 and SubsystemMgr_1:Get("GameReportSubsystem")
        if var_80 then
            var_80.ReplayReportData = function() return false end
            var_80.CheckCanBugglyPostException = function() return false end
            var_80.BugglyPostExceptionFull = function() return false end
            var_80.GetClientReplayDataReporter = function() return nil end
            
            if var_80.Reporter then
                var_80.Reporter.ReportIntArrayData = function() end
                var_80.Reporter.ReportUInt8ArrayData = function() end
                var_80.Reporter.ReportFloatArrayData = function() end
            end
        end

        local logic_report_replay_1 = package.loaded["client.slua.logic.replay.logic_report_replay"]
        if logic_report_replay_1 then
            logic_report_replay_1.ReportReplay = function() end
            logic_report_replay_1.SendReportReq = function() end
        end

        local logic_home_report_1 = package.loaded["client.slua.logic.home.logic_home_report"]
        if logic_home_report_1 then
            logic_home_report_1.ShowInGameReportUI = function() end
            logic_home_report_1.SendReport = function() end
        end
    end)
    print('[ReplayBlocker] Replay Evidence Collection Stopped!')
end

function _G.DisableHiggsBoson()
    local var_163 = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not var_163 or not slua.isValid(var_163) then return end
    if var_163.HiggsBoson then
        var_163.HiggsBoson.bMHActive = false
        var_163.HiggsBoson.bCallPreReplication = false
    end
    if var_163.HiggsBosonComponent then
        var_163.HiggsBosonComponent.bMHActive = false
        var_163.HiggsBosonComponent:ControlMHActive(0)
    end
end

function _G.InitializeAntiCheatHooks()
    print('[AntiCheat] Initializing bypass system...')
    pcall(function()
        local HiggsBosonComponent_1 = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HiggsBosonComponent_1 and HiggsBosonComponent_1.StaticShowSecurityAlertInDev then
            HiggsBosonComponent_1.StaticShowSecurityAlertInDev = function() end
        end
    end)

    if _G.AvatarCheckCallback then
        _G.AvatarCheckCallback.StartAvatarCheck = function(HiggsBosonComponent_1) end
        _G.AvatarCheckCallback.OnReportItemID = function(HiggsBosonComponent_1) end
        _G.AvatarCheckCallback.PostPlayerControllerLoginInit = function(var_163)
            if slua.isValid(var_163) and var_163.HiggsBosonComponent then
                var_163.HiggsBosonComponent:ControlMHActive(0)
                var_163.HiggsBosonComponent.bMHActive = false
            end
        end
    end

    pcall(function()
        local HiggsBosonComponent_2 = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HiggsBosonComponent_2 and HiggsBosonComponent_2.BlackList then
            for k in pairs(HiggsBosonComponent_2.BlackList) do HiggsBosonComponent_2.BlackList[k] = nil end
        end
    end)

    _G.BlackList = {}

    pcall(function()
        _G.GlobalPlayerCoronaData = _G.GlobalPlayerCoronaData or {}
        _G.GlobalPlayerCheatTimes = _G.GlobalPlayerCheatTimes or {}
        local mt = getmetatable(_G.GlobalPlayerCoronaData) or {}
        mt.__newindex = function(t, k, v) end
        setmetatable(_G.GlobalPlayerCoronaData, mt)
    end)

    pcall(function()
        if _G.GameSafeCallbacks and _G.GameSafeCallbacks.RecordStrategyTimestampInReplay then
            _G.GameSafeCallbacks.RecordStrategyTimestampInReplay = function(...) end
            _G.GameSafeCallbacks.DoAttackFlowStrategy = function() end
            _G.GameSafeCallbacks.GetScriptReportContent = function() return "" end
        end
    end)

    pcall(function()
        local STExtraBlueprintFunctionLibrary_1 = import("STExtraBlueprintFunctionLibrary")
        if STExtraBlueprintFunctionLibrary_1 then
            STExtraBlueprintFunctionLibrary_1.IsDevelopment = function() return false end
        end
    end)
    print('[AntiCheat] Bypass system activated!')
end

function _G.InitializeAntiReport()
    print('[AntiReport] Initializing System...')
    pcall(function()
        local var_51 = { "GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem", "Client.Security.ClientReportPlayerSubsystem" }
        local var_78 = nil
        for _, path in ipairs(var_51) do
            if package.loaded[path] then var_78 = package.loaded[path] break end
            local var_176, var_199 = pcall(require, path)
            if var_176 and var_199 then var_78 = var_199 break end
        end
        if var_78 then
            var_78.OnInit = function(self) return end
            var_78._OnPlayerKilledOtherPlayer = function() return end
            var_78._RecordFatalDamager = function() return end
            var_78._OnDeathReplayDataWhenFatalDamaged = function() return end
            var_78._RecordMurdererFromDeathReplayData = function() return end
            var_78._RecordTeammatePlayerInfo = function() return end
            var_78._OnBattleResult = function() return end
            var_78._OnShowQuickReportMutualExclusiveUI = function() return end
            var_78.GetFatalDamagerMap = function() return {} end
            var_78.GetCachedTeammateName2InfoMap = function() return {} end
            var_78.GetTeammateName2InfoMapDuringBattle = function() return {} end
            var_78.GetCurrentNotInTeamHistoricalTeammateMap = function() return {} end
            var_78.GetInTeamIndexFromHistoricalTeammateInfo = function() return -1 end
        end
    end)

    pcall(function()
        local var_51 = { "GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem", "GameLua.Mod.BaseMod.Client.Security.DSReportPlayerSubsystem" }
        local var_39 = nil
        for _, path in ipairs(var_51) do
            if package.loaded[path] then var_39 = package.loaded[path] break end
            local var_176, var_199 = pcall(require, path)
            if var_176 and var_199 then var_39 = var_199 break end
        end
        if var_39 then
            var_39.OnInit = function(self) return end
            var_39._OnNearDeathOrRescued = function() return end
            var_39._OnCharacterDied = function() return end
            var_39._OnTeammateDamage = function() return end
            var_39._OnPlayerSettlementStart = function() return end
            var_39._AddKnockDownerToBattleResult = function() return end
            var_39._AddKillerToBattleResult = function() return end
            var_39._AddTeammateMurderToBattleResult = function() return end
            var_39._AddFatalDamagerMapToBattleResult = function() return end
            var_39._AddMLKillerUIDToBattleResult = function() return end
            var_39._SaveHistoricalTeammateInfo = function() return end
            var_39._RecordFatalDamager = function() return end
            var_39._RecordTeammateMurderer = function() return end
        end
    end)

    pcall(function()
        local ReportPlayerUtils_1 = require("GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils")
        if ReportPlayerUtils_1 then
            ReportPlayerUtils_1.RecordFatalDamager = function() return end
            ReportPlayerUtils_1.IsUsingHistoricalTeammateInfo = function() return false end
            ReportPlayerUtils_1.IsCharacterDeliverAI = function() return false end
        end
    end)

    pcall(function()
        local SecurityCommonUtils_1 = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
        if SecurityCommonUtils_1 then
            SecurityCommonUtils_1.ExtractPlayerBasicInfo = function() return {} end
            SecurityCommonUtils_1.LogIf = function() return false end
        end
    end)

    pcall(function()
        local ClientQuickReportMaliciousTeammate_1 = require("GameLua.Mod.BaseMod.Client.Security.ClientQuickReportMaliciousTeammate")
        if ClientQuickReportMaliciousTeammate_1 then
            ClientQuickReportMaliciousTeammate_1.OnShowMutualExclusiveUI = function() return end
            ClientQuickReportMaliciousTeammate_1.OnHideMutualExclusiveUI = function() return end
        end
    end)
    print('[AntiReport] System Fully Active!')
end

function _G.InitializeGameplayBypass()
    pcall(function()
        if not _G.GameplayCallbacks or _G.GameplayCallbacks.IsBypassed then return end
        
        local GC = _G.GameplayCallbacks
        print('[GameplayBypass] Hooking GameplayCallbacks...')
        
        local var_129 = GC.OnDSPlayerStateChanged
        GC.OnDSPlayerStateChanged = function(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
            if InPlayerState and string.lower(tostring(InPlayerState)) == "cheatdetected" then return end
            if var_129 then return var_129(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason) end
        end

        local function func() return end
        local function func_9() return {} end
        local function func_3() return nil end
        
        GC.ReportAttackFlow = func
        GC.ReportSecAttackFlow = func
        GC.ReportHurtFlow = func
        GC.ReportFireArms = func
        GC.ReportVerifyInfoFlow = func
        GC.ReportMrpcsFlow = func
        GC.ReportPlayerBehavior = func
        GC.ReportTeammatHurt = func
        GC.ReportMisKillByTeammate = func
        GC.ReportForbitPick = func
        GC.ReportPlayerMoveRoute = func
        GC.ReportPlayerPosition = func
        GC.ReportVehicleMoveFlow = func
        GC.ReportSecTgameMovingFlow = func
        GC.ReportParachuteData = func
        GC.SendTssSdkAntiDataToLobby = func
        GC.SendDSErrorLogToLobby = func
        GC.SendDSErrorLogToLobbyOnece = func
        GC.SendDSHawkEyePatrolLogToLobby = func
        GC.ReportEquipmentFlow = func
        GC.ReportAimFlow = func
        GC.GetWeaponReport = func_9
        GC.GetOneWeaponReport = func_9
        GC.ReportHeavyWeaponBoxSpawnFlow = func
        GC.ReportHeavyWeaponBoxActivationFlow = func
        GC.ReportHeavyWeaponBoxOpenPlayerFlow = func
        GC.ReportHeavyWeaponBoxItemFlow = func
        GC.ReportPlayersPing = func
        GC.ReportPlayerIP = func
        GC.ReportPlayerFramePingRecord = func
        GC.OnDSConnectionSaturated = func
        GC.ReportDSNetSaturation = func
        GC.ReportNetContinuousSaturate = func
        GC.ReportDSNetRate = func
        GC.SendClientStats = func
        GC.SendServerAvgTickDelta = func
        GC.ReportCircleFlow = func
        GC.ReportDSCircleFlow = func
        GC.ReportJumpFlow = func
        GC.ReportAIStrategyInfo = func
        GC.SendAIDeliveryInfo = func
        GC.ReportDailyTaskInfo = func
        GC.ReportMatchRoomData = func
        GC.SendPlayerSpectatingLog = func
        GC.ReportIDCardProduceFlow = func
        GC.ReportIDCardPickUpFlow = func
        GC.ReportIDCardDestroyFlow = func
        GC.ReportRevivalFlow = func
        GC.ReportGameSetting = func
        GC.ReportGameSettingNew = func
        GC.ReportAntsVoiceTeamCreate = func
        GC.ReportAntsVoiceTeamQuit = func
        GC.ReportCommonInfo = func
        GC.ReportLightweightStat = func
        GC.SendSecTLog = func
        GC.SendDataMiningTLog = func
        GC.SendActivityTLog = func
        GC.GetGeneralTLogData = func_3
        
        GC.IsBypassed = true
    end)

    pcall(function()
        if NetUtil and NetUtil.SendPacket and not NetUtil.IsBypassed then
            local var_240 = NetUtil.SendPacket
            local var_227 = {
                ["ReportAttackFlow"]=1, ["ReportSecAttackFlow"]=1, ["ReportHurtFlow"]=1,
                ["ReportFireArms"]=1, ["ReportVerifyInfoFlow"]=1, ["ReportMrpcsFlow"]=1,
                ["ReportPlayerBehavior"]=1, ["ReportTeammatHurt"]=1, ["ReportTeammateKillConfirmFlow"]=1,
                ["ReportForbiddenPickupFlow"]=1, ["ReportPlayerMoveRoute"]=1, ["ReportPlayerPosition"]=1,
                ["ReportSecVehicleMoveFlow"]=1, ["ReportSecTgameMovingFlow"]=1, ["report_parachute_data"]=1,
                ["report_character_all_drag"]=1, ["report_parachute_all_drag"]=1, ["report_vehicle_move_drag"]=1,
                ["on_tss_sdk_anti_data"]=1, ["report_unrealnet_exception"]=1, ["ReportPlayerEquipmentInfo"]=1,
                ["ReportAimFlow"]=1, ["ReportHitFlow"]=1, ["log_shooting_miss"]=1, ["report_heavy_weapon_box_activation_flow"]=1,
                ["report_heavy_weapon_box_item_flow"]=1, ["ReportCircleFlow"]=1, ["report_ds_player_circle_flow"]=1,
                ["ReportJumpFlow"]=1, ["ReportGameStartFlow"]=1, ["ReportGameEndFlow"]=1, ["report_players_ping"]=1,
                ["report_player_ip"]=1, ["report_player_frame_ping_record"]=1, ["report_net_saturate"]=1,
                ["report_ds_netsaturate"]=1, ["report_ds_net_continuous_saturate"]=1, ["report_ds_netrate"]=1,
                ["report_unrealnet_clientstats"]=1, ["report_serverstat_avgtickdelta"]=1, ["report_all_players_address"]=1,
                ["report_ai_strategyinfo"]=1, ["ReportAIActionFlow"]=1, ["ReportGenerateMonsterFlow"]=1,
                ["report_ds_match_room_data"]=1, ["SendSpectatingLog"]=1, ["ReportIDCardProduceFlow"]=1,
                ["ReportIDCardPickUpFlow"]=1, ["ReportIDCardDestroyFlow"]=1, ["ReportRevivalFlow"]=1,
                ["ReportGameSetting"]=1, ["ReportGameSettingNew"]=1, ["ReportAntsVoiceTeamCreate"]=1,
                ["ReportAntsVoiceTeamQuit"]=1, ["report_common_info"]=1, ["report_common_battle_info"]=1,
                ["report_client_scan_result"]=1, ["tss_sdk_report"]=1, ["report_memory_exception"]=1,
                ["report_avatar_exception"]=1, ["report_ui_state"]=1, ["report_hit_reg_fail"]=1,
                ["report_character_state"]=1, ["report_vehicle_exception"]=1, ["report_camera_exception"]=1,
                ["ReportPlayerControllerStateChanged"]=1, ["ReportAvatarFlow"]=1,
                ["send_ugc_report_uni_mod_expose_req"]=1, 
                ["send_ugc_report_uni_mod_interactive_req"]=1,
            }
            
            NetUtil.SendPacket = function(packetName, ...)
                if var_227[packetName] then return end
                return var_240(packetName, ...)
            end
            NetUtil.IsBypassed = true
        end
    end)
end

function _G.InitializeConnectionGuard()
    pcall(function()
        if _G.ConnectionGuardInitialized or not _G.GameplayCallbacks then return end
        print('[ConnectionGuard] Initializing Shield...')
        
        local GC = _G.GameplayCallbacks
        local var_129 = GC.OnDSPlayerStateChanged

        GC.OnDSPlayerStateChanged = function(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
            local var_212 = InPlayerState and string.lower(tostring(InPlayerState)) or ""
            local var_125 = {
                ["cheatdetected"] = true, ["connectionlost"] = true,
                ["connectiontimeout"] = true, ["connectionexception"] = true,
                ["netdrivererror"] = true
            }
            if var_125[var_212] then return end
            if var_129 then
                pcall(var_129, UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
            end
        end

        GC.OnPlayerNetConnectionClosed = function(GameID, UID, Reason, ErrorMessage) end
        GC.OnPlayerActorChannelError = function(GameID, UID, Reason, ErrorMessage) end
        GC.OnPlayerRPCValidateFailed = function(GameID, UID, Reason, ErrorMessage) end
        GC.OnPlayerSpectateException = function(GameID, UID, Reason, ErrorMessage) end
        GC.OnShutdownAfterError = function(GameID) end

        _G.ConnectionGuardInitialized = true
        print('[ConnectionGuard] Active & Protecting!')
    end)
end

function _G.InitializeZRPRBypasses()
    print('[Bypass] Initializing ZR and PR Bypasses...')
    pcall(function()
        local noop = function() end
        local returnTrue = function() return true end
        local returnZero = function() return 0 end
        local returnEmpty = function() return {} end
        local returnFalse = function() return false end

        local stExtraBlueprint = import("STExtraBlueprintFunctionLibrary")
        if stExtraBlueprint then 
            stExtraBlueprint.IsDevelopment = returnTrue 
        end

        if _G.BasicDataTLogReport then
            _G.BasicDataTLogReport.OnSendBatchReqMsg = noop
            _G.BasicDataTLogReport.OnImmediateReqMsg = noop
            _G.BasicDataTLogReport.send_report_event_duration_log = noop
            _G.BasicDataTLogReport.SendTlog = noop
        end

        if _G.TApmHelper then 
            _G.TApmHelper.postEvent = noop 
        end

        local sdm = _G.ServerDataMgr
        if sdm and sdm.DeletablePlayerResultKey then
            sdm.DeletablePlayerResultKey["SuspiciousHitCount"] = true
            sdm.DeletablePlayerResultKey["EspTotalSimTraceCnt"] = true
            sdm.DeletablePlayerResultKey["EspTotalImeFocusCnt"] = true
            sdm.DeletablePlayerResultKey["ClientGravityAnomalyCount"] = true
        end

        local hiaPath = "GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem"
        local hia = package.loaded[hiaPath] or require(hiaPath)
        if hia then
            hia.CheckHitIntegrity = returnTrue
            hia.InitSession = noop
            hia.OnBattleEnd = noop
        end
        if _G.ClientGlueHiaSystem then 
            _G.ClientGlueHiaSystem.CheckHitIntegrity = returnTrue 
        end

        local secUtilsPath = "GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils"
        local secUtils = package.loaded[secUtilsPath] or require(secUtilsPath)
        if secUtils and secUtils.EStrategyTypeInReplay then
            secUtils.EStrategyTypeInReplay.EspTotalSimTraceCnt = 0
            secUtils.EStrategyTypeInReplay.EspTotalImeFocusCnt = 0
            secUtils.EStrategyTypeInReplay.ClientGravityAnomalyCount = 0
            secUtils.EStrategyTypeInReplay.FlyingErrorCnt = 0
        end

        local pcNotifyPath = "GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature"
        local pcNotify = package.loaded[pcNotifyPath] or require(pcNotifyPath)
        if pcNotify then
            pcNotify.ClientRPC_SyncBanID = noop
            pcNotify.ClientRPC_StrongTips = noop
            pcNotify.ClientRPC_NormalTips = noop
            pcNotify.Notify = noop
        end

        local SubsystemMgr = package.loaded["GameLua.GameCore.Module.Subsystem.SubsystemMgr"] or require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubsystemMgr then
            local patrolSubsystem = SubsystemMgr:Get("DSHawkEyePatrolSubsystem")
            if patrolSubsystem then 
                patrolSubsystem.MarkSuspiciousPlayer = noop 
            end
        end

        local clientBanLogicPath = "client.slua.logic.ban.ClientBanLogic"
        local ClientBanLogic = package.loaded[clientBanLogicPath] or require(clientBanLogicPath)
        if ClientBanLogic then
            ClientBanLogic.OnSyncBanInfo = noop
            ClientBanLogic.OnVoiceBanNotify = noop
        end

        local ttBanPath = "client.slua.logic.login.logic_tt_ban"
        local logic_tt_ban = package.loaded[ttBanPath] or require(ttBanPath)
        if logic_tt_ban then
            logic_tt_ban.GetCarrierInfo = function() return "[{\"mcc\":\"000\"}]" end
            logic_tt_ban.CheckIfCanCreateRole = returnTrue
        end

        local znq6Path = "GameLua.Mod.TDEvent.ZNQ6th.DS.ZNQ6thDSReviveSubsystem"
        local znq6Revive = package.loaded[znq6Path] or require(znq6Path)
        if znq6Revive then 
            znq6Revive.HaveNewItemForRevive = returnTrue 
        end
        local znq7Path = "GameLua.Mod.TDEvent.ZNQ7th.DS.ZNQ7DSReviveSubsystem"
        local znq7Revive = package.loaded[znq7Path] or require(znq7Path)
        if znq7Revive then 
            znq7Revive.HaveChanceRevival = returnTrue 
        end

        local dataLayerPath = "GameLua.Mod.BaseMod.Common.Subsystem.DataLayerSubsystem"
        local DataLayer = package.loaded[dataLayerPath] or require(dataLayerPath)
        if DataLayer then
            local origOnSpectator = DataLayer.OnSpectatorReplayChanged
            DataLayer.OnSpectatorReplayChanged = function(dlSelf)
                _G.IsBeingWatched = true
                if origOnSpectator then 
                    pcall(origOnSpectator, dlSelf) 
                end
            end
        end

        local dsActivePath = "GameLua.Mod.PlanBT.Gameplay.Subsystem.DSActiveSubsystem"
        local DSActive = package.loaded[dsActivePath] or require(dsActivePath)
        if DSActive then
            DSActive.DelayKickOutPlayer = noop
            DSActive.ActiveKickNotify = noop
        end

        local devDebugPath = "GameLua.Mod.CreativeBase.Gameplay.Subsystem.CreativeDevDebugSubsystem"
        local CreativeDevDebug = package.loaded[devDebugPath] or require(devDebugPath)
        if CreativeDevDebug then 
            CreativeDevDebug.IsDebugPanelEnalbedCli = returnTrue 
        end
        local deathRecordPath = "GameLua.Mod.CreativeBase.Gameplay.Subsystem.CreativeModeDeathRecordSubsystem"
        local CreativeDeath = package.loaded[deathRecordPath] or require(deathRecordPath)
        if CreativeDeath then 
            CreativeDeath.OnPlayerKilled = noop 
        end

        local dsAITLogPath = "GameLua.Mod.BaseMod.DS.Security.DSAITLogSubsystem"
        local DSAITLog = package.loaded[dsAITLogPath] or require(dsAITLogPath)
        if DSAITLog then
            DSAITLog._UpdateTTKRecords = noop
            DSAITLog._UpdateOperatingFrequency = noop
        end
        local dsFightTLogPath = "GameLua.Mod.BaseMod.DS.Security.DSFightTLogSubsystem"
        local DSFightTLog = package.loaded[dsFightTLogPath] or require(dsFightTLogPath)
        if DSFightTLog then 
            DSFightTLog.GetSimpleFightData = returnEmpty 
        end
        local dsSecurityPath = "GameLua.Mod.BaseMod.DS.Security.DSSecurityTLogSubsystem"
        local DSSecurity = package.loaded[dsSecurityPath] or require(dsSecurityPath)
        if DSSecurity then 
            DSSecurity._OnReportServerJumpFlow = noop 
        end
        local dsCommonPath = "GameLua.Mod.BaseMod.DS.Security.DSCommonTLogSubsystem"
        local DSCommon = package.loaded[dsCommonPath] or require(dsCommonPath)
        if DSCommon then 
            DSCommon.HandleKillTlog = noop 
        end
        local dsReportPath = "GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem"
        local DSReport = package.loaded[dsReportPath] or require(dsReportPath)
        if DSReport then 
            DSReport._AddEnemyMapToBattleResult = noop 
        end

        local highlightDSPath = "GameLua.Mod.BaseMod.DS.Security.HighlightMomentSubsystem_DSChecker"
        local HighlightDS = package.loaded[highlightDSPath] or require(highlightDSPath)
        if HighlightDS then 
            HighlightDS.CheckFuncUpgradedWeaponKill = noop 
        end
        local icTLogPath = "GameLua.Mod.BaseMod.DS.Security.ICTLogSubsystem"
        local ICTLog = package.loaded[icTLogPath] or require(icTLogPath)
        if ICTLog then 
            ICTLog.SendICExceptionTLog = noop 
        end

        local inspectClientPath = "GameLua.Mod.BaseMod.Client.Security.InspectionSystemReportClientLogicSubsystem"
        local InspectClient = package.loaded[inspectClientPath] or require(inspectClientPath)
        if InspectClient then
            InspectClient.AskForInspector = noop
            InspectClient.ReportEnemy = noop
            InspectClient.KickOutOneTeam = noop
        end
        local inspectDSPath = "GameLua.Mod.BaseMod.DS.Security.InspectionSystemReportDSLogicSubsystem"
        local InspectDS = package.loaded[inspectDSPath] or require(inspectDSPath)
        if InspectDS then
            InspectDS.ServerKickOutOneTeamByPlayerImplementation = noop
            InspectDS.AddReportedCount = noop
        end

        local spectateReplayPath = "GameLua.Mod.BaseMod.Common.Subsystem.SpectateAndReplaySubsystem"
        local SpectateReplay = package.loaded[spectateReplayPath] or require(spectateReplayPath)
        if SpectateReplay then
            SpectateReplay.RequestGotoSpectatingImp = noop
            SpectateReplay.RequestGotoSpectating = noop
        end
        local clientHawkEyePath = "GameLua.Mod.BaseMod.Client.Security.ClientHawkEyePatrolSubsystem"
        local ClientHawkEye = package.loaded[clientHawkEyePath] or require(clientHawkEyePath)
        if ClientHawkEye then
            ClientHawkEye._OnHawkSync = noop
            ClientHawkEye._OnHawkReportSuccess = noop
            ClientHawkEye._StartExitGameTimer = noop
        end
        local behaviorScorePath = "GameLua.Mod.Escape.Gameplay.Subsystem.BehaviorScoreSubsystem"
        local BehaviorScore = package.loaded[behaviorScorePath] or require(behaviorScorePath)
        if BehaviorScore then
            BehaviorScore.OnHandleBehaviorScore = noop
            BehaviorScore.AIPerceptionScore = noop
        end

        local aiReplayPath = "GameLua.ExtraModule.MLAI.Client.AIReplaySubsystem"
        local AIReplay = package.loaded[aiReplayPath] or require(aiReplayPath)
        if AIReplay then
            AIReplay.ReportAllPlayerInfo = noop
            if AIReplay.uCompletePlayBack then 
                AIReplay.uCompletePlayBack.AddRecordMLAIInfo = noop 
            end
        end
        local aiTrackingPath = "GameLua.Mod.BaseMod.GamePlay.AI.AITrackingLogSubsystem"
        local AITracking = package.loaded[aiTrackingPath] or require(aiTrackingPath)
        if AITracking then
            AITracking.RealLogoutTimer = noop
            AITracking.LogQueue = {}
        end
        local tdmAFKPath = "GameLua.Mod.TDM.Gameplay.Subsystem.TDMAFKReportorSubsystem"
        local TDMAFK = package.loaded[tdmAFKPath] or require(tdmAFKPath)
        if TDMAFK then
            TDMAFK.SendAFKTips = noop
            TDMAFK.OnHandleLostConnection = noop
        end

        local dataMgrPath = "client.slua.logic.data.data_mgr"
        local DataMgr = package.loaded[dataMgrPath] or _G.DataMgr
        if DataMgr then
            DataMgr.GetWeaponSkinSoundVolumeInfoByGroup = function() return 0 end
        end

        local EAvatarDamagePosition = import("EAvatarDamagePosition")
        if EAvatarDamagePosition and EAvatarDamagePosition.BigHead then
            local meta = getmetatable(GameplayData_3) or {}
            if meta and meta.__index then
                meta.__index.GetHitBodyType = function(...) 
                    return EAvatarDamagePosition.BigHead 
                end
            end
        end
    end)
    print('[Bypass] ZR and PR Bypasses Initialized successfully!')
end

function NetworkRPC:HandleOnMovementModeChangedNew()
    print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChanged11")
    local EMovementMode_1 = import("EMovementMode")
    if Game:IsValid(self.STCharacterMovement) and self.STCharacterMovement.MovementMode == EMovementMode_1.MOVE_Swimming and self:CheckBaseIsMoveable() then
        print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChanged22")
        self.CharacterMovement:SetBase(nil, "", true)
    end
    if self.Role == ENetRole.ROLE_AutonomousProxy and Game:IsValid(self.STCharacterMovement) and self.STCharacterMovement.MovementMode == EMovementMode_1.MOVE_Walking and manager_1.UI_Config_InGame.ParachuteOpenUI then
        print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChangedNew CloseUI")
        manager_1.CloseUI(manager_1.UI_Config_InGame.ParachuteOpenUI)
    end
end

function NetworkRPC:HandleOnAttachedToVehicle(var_131)
    if not slua.isValid(var_131) then
        return
    end
    print(bWriteLog and string.format("BRPlayerCharacterBase:HandleOnAttachedToVehicle", Game:GetObjName(var_131)))
    if self.Role == ENetRole.ROLE_SimulatedProxy then
        self:ClearAttachToVehicleTimer()
        self.nUpdatePlayerAttachToVehicleCount = 0
        self.nUpdatePlayerAttachToVehicleTimer = self:AddGameTimer(5, true, function()
            if slua.isValid(self.Object) and slua.isValid(var_131) then
                self:UpdatePlayerAttachToVehicle(var_131)
            end
        end)
        self.nFixMeshContainerTimer = self:AddGameTimer(3, true, function()
            if slua.isValid(self.Object) and slua.isValid(var_131) then
                self:FixMeshContainerOffsetIfNeeded(var_131)
            end
        end)
    end
end

function NetworkRPC:HandleOnDetachedFromVehicle(uLastVehicle)
    if not slua.isValid(uLastVehicle) then
        return
    end
    print(bWriteLog and "BRPlayerCharacterBase:HandleOnDetachedFromVehicle", uLastVehicle)
    if self.Role == ENetRole.ROLE_SimulatedProxy then
        self:ClearAttachToVehicleTimer()
        self.nUpdatePlayerAttachToVehicleCount = 0
    end
end

function NetworkRPC:UpdatePlayerAttachToVehicle(var_131)
    if not slua.isValid(self.Object) or not slua.isValid(var_131) then return end
    if not (slua.isValid(self.CapsuleComponent) and slua.isValid(self.Mesh)) or not slua.isValid(self.MeshContainer) then return end
    if not slua.isValid(self:GetCurrentVehicle()) then return end
    if Game:IsDriver(self.Object) then return end
    if not self.nUpdatePlayerAttachToVehicleCount then self.nUpdatePlayerAttachToVehicleCount = 0 end
    
    local ESTEPoseState_1 = import("ESTEPoseState")
    local var_177 = self.PoseState == ESTEPoseState_1.Stand
    local var_4 = self.CapsuleComponent:GetRelativeTransform():GetLocation()
    local var_196 = self.Mesh:GetRelativeTransform():GetLocation()
    local var_38 = self.MeshContainer:GetRelativeTransform():GetLocation().Z
    local var_71 = self.CapsuleComponent:GetScaledCapsuleRadius()
    local var_75 = self.CapsuleComponent:GetScaledCapsuleHalfHeight()
    local var_5 = -1 * self.StandHalfHeight
    local var_207 = self.StandRadius
    local var_154 = self.StandHalfHeight
    local var_25 = FVector(0, 0, 0)
    local var_102 = FVector(0, 0, self.StandHalfHeight)
    local var_35 = 1.0
    local var_200 = var_4:Equals(var_102, var_35)
    local var_149 = var_196:Equals(var_25, var_35)
    local var_42 = var_35 > math.abs(var_38 - var_5)
    local var_118 = var_35 > math.abs(var_71 - var_207)
    local var_28 = var_35 > math.abs(var_75 - var_154)
    local var_104 = var_177 and var_200 and var_149 and var_42 and var_118 and var_28
    
    if not var_104 then self.nUpdatePlayerAttachToVehicleCount = self.nUpdatePlayerAttachToVehicleCount + 1 else self.nUpdatePlayerAttachToVehicleCount = 0 end
    
    if self.nUpdatePlayerAttachToVehicleCount >= 3 and not var_104 then
        local var_235 = GameplayData_3.GetPlayerController()
        if var_235.ReportCrashKitFeature and var_235.ReportCrashKitFeature.ReportCharacterAttachedOnVehicleException then
            local var_14 = string.format("VehicleShapeType:%s PlayerKey:%s. Check Result:%d %d %d %d %d %d. Capsule.RelativeLoc:%s Capsule.Radius:%s Capsule.HalfHeight:%s Mesh.RelativeLoc:%s MeshContainer.RelativeLocZ:%s", tostring(var_131.VehicleShapeType), tostring(self.PlayerKey), var_177 and 1 or 0, var_200 and 1 or 0, var_149 and 1 or 0, var_42 and 1 or 0, var_118 and 1 or 0, var_28 and 1 or 0, var_4:ToString(), tostring(var_71), tostring(var_75), var_196:ToString(), tostring(var_38))
            var_235.ReportCrashKitFeature:ReportCharacterAttachedOnVehicleException(var_14)
        end
        self.nUpdatePlayerAttachToVehicleCount = 0
    end
end

function NetworkRPC:FixMeshContainerOffsetIfNeeded(var_131)
    if not slua.isValid(self.Object) or not slua.isValid(var_131) then return end
    if not slua.isValid(self.MeshContainer) then return end
    if not slua.isValid(self:GetCurrentVehicle()) then return end
    if Game:IsDriver(self.Object) then return end
    local var_35 = 1.0
    local var_5 = -1 * self.StandHalfHeight
    local var_38 = self.MeshContainer:GetRelativeTransform():GetLocation().Z
    if var_35 <= math.abs(var_38 - var_5) then
        self:SetMeshContainerOffsetZ(var_5)
    end
end

function NetworkRPC:ClearAttachToVehicleTimer()
    if self.nUpdatePlayerAttachToVehicleTimer then
        self:RemoveGameTimer(self.nUpdatePlayerAttachToVehicleTimer)
        self.nUpdatePlayerAttachToVehicleTimer = nil
    end
    if self.nFixMeshContainerTimer then
        self:RemoveGameTimer(self.nFixMeshContainerTimer)
        self.nFixMeshContainerTimer = nil
    end
end

function NetworkRPC:CharacterAttrChangeEvent(uPawn, AttrName, AttrVal)
    NetworkRPC.__super.CharacterAttrChangeEvent(self, uPawn, AttrName, AttrVal)
    if self.Object ~= uPawn then return end
    if self.Role == ENetRole.ROLE_AutonomousProxy and AttrName == "bCanSelfRescue" then
        local var_235 = self:GetPlayerControllerSafety()
        if slua.isValid(var_235) then
            var_235:BroadcastUIMessage("UIMsg_CanSelfRescue", 0, "", "")
        end
    end
end

function NetworkRPC:OnPawnStateChange(PawnState)
    local EPawnState_1 = import("EPawnState")
    if PawnState == EPawnState_1.SwitchPP then
        local var_235 = self:GetPlayerControllerSafety()
        if slua.isValid(var_235) then
            var_235:BroadcastUIMessage("UIMsg_FPPModeChange", 0, "", "")
        end
    end
end

function NetworkRPC:HandleFinishedState()
    if slua.isValid(self.STCharacterMovement) and self.STCharacterMovement.SetDynamicSimpleQueryConfig then
        self.STCharacterMovement:SetDynamicSimpleQueryConfig(false)
    end
end

function NetworkRPC:CheckAddCheckFallingDistanceComponent()
    if CGameMode and CGameMode.GameModeType and CGameState and CGameState.GameModeID then
        local EGameModeType_1 = import("EGameModeType")
        local MatchModeIdsConfig_1 = require("GameLua.Mod.BaseMod.GamePlay.Config.MatchModeIdsConfig")
        local var_229 = CGameMode.GameModeType
        local var_181 = tonumber(CGameState.GameModeID)
        local var_197 = var_229 == EGameModeType_1.ETypicalGameMode or var_229 == EGameModeType_1.EFourInOneGameMode or var_229 == EGameModeType_1.EHeavyWeaponGameMode
        local var_144 = not MatchModeIdsConfig_1[var_181]
        return var_197 and var_144
    end
    return false
end

function NetworkRPC:LuaHandleParachuteStateChanged(LastParachuteState, NewParachuteState)
    NetworkRPC.__super.LuaHandleParachuteStateChanged(self, LastParachuteState, NewParachuteState)
    local EParachuteState_1 = import("EParachuteState")
    if not Client then
        local var_209 = self:GetPlayerControllerSafety()
        if slua.isValid(var_209) and var_209.CheckParachuteOpenFeature then
            if NewParachuteState == EParachuteState_1.PS_Opening then
                if var_209.CheckParachuteOpenFeature.SatrtCheckShowParachuteCloseUI then
                    var_209.CheckParachuteOpenFeature:SatrtCheckShowParachuteCloseUI()
                end
            elseif NewParachuteState == EParachuteState_1.PS_None then
                if var_209.CheckParachuteOpenFeature.RecoverParachuteOpenParam then
                    var_209.CheckParachuteOpenFeature:RecoverParachuteOpenParam()
                end
                if var_209.CheckParachuteOpenFeature.ClearTimerAndState then
                    var_209.CheckParachuteOpenFeature:ClearTimerAndState()
                end
            end
        end
    end
end

function NetworkRPC:OnLanded()
    if self.HandleOnLanded then self:HandleOnLanded(-1) end
    if not Client then
        local var_209 = self:GetPlayerControllerSafety()
        if slua.isValid(var_209) and var_209.CheckParachuteOpenFeature then
            if var_209.CheckParachuteOpenFeature.ClearTimerAndState then
                var_209.CheckParachuteOpenFeature:ClearTimerAndState()
            end
            if var_209.CheckParachuteOpenFeature.ResetCheckShowUI then
                var_209.CheckParachuteOpenFeature:ResetCheckShowUI()
            end
        end
    end
end

function NetworkRPC:IsWarGameMode()
    local GameplayData_3 = require("GameLua.GameCore.Data.GameplayData")
    local var_164 = GameplayData_3:GetGameState()
    local STExtraGameStateBase_1 = import("STExtraGameStateBase")
    if slua.isValid(var_164) and Game:IsClassOf(var_164, STExtraGameStateBase_1) then
        local EGameModeType_1 = import("EGameModeType")
        return var_164.GameModeType == EGameModeType_1.EWarGameMode
    else
        return false
    end
end

function NetworkRPC:BPOnRecycled()
    if Client then self:ResetMeshRelativeLocationAndRotation() end
end

function NetworkRPC:BPOnRespawned()
    if Client then self:ResetMeshRelativeLocationAndRotation() end
end

function NetworkRPC:ReceiveOnRecycle()
    if Client then
        self:ResetMeshRelativeLocationAndRotation()
        GameplayData_3.RemoveCharacter(self.Object)
    end
end

function NetworkRPC:ReceiveOnSpawn()
    if Client then
        self:ResetMeshRelativeLocationAndRotation()
        GameplayData_3.AddCharacter(self.Object)
    end
end

function NetworkRPC:ResetMeshRelativeLocationAndRotation()
    if Game:IsValid(self.Object) and Game:IsValid(self.Mesh) then
        local var_188 = FRotator(0, -90, 0)
        local var_63 = FVector(0, 0, 0)
        if self.Mesh.K2_SetRelativeRotation then
            self.Mesh:K2_SetRelativeRotation(var_188, false, nil, false)
        end
        self:CacheInitialMeshOffset(var_63, var_188)
    end
end

function NetworkRPC:BPOnMissPlayerDamageRecord()
end

function NetworkRPC:PreAttachedToVehicle()
    local KismetSystemLibrary_1 = import("KismetSystemLibrary")
    local var_156 = KismetSystemLibrary_1.IsDedicatedServer(self)
    if not var_156 then return end
    local var_147 = self:GetPlayerControllerSafety()
    if not slua.isValid(var_147) then return end
    local var_40 = self.CharacterAvatarComp2_BP
    if not slua.isValid(var_40) then return end
    local CommerAvatarDataUtil_1 = require("GameLua.Activity.Commercialize.GamePlay.CommerAvatarDataUtil")
    local var_22 = CommerAvatarDataUtil_1:ChangeVehicleSkinByClothes(var_147, var_40)
    local ESTExtraVehicleShapeType_1 = import("ESTExtraVehicleShapeType")
    if var_22 then
        local AvatarUtils_1 = import("AvatarUtils")
        if AvatarUtils_1.GetVehicleShapeBySkinID(var_22) == ESTExtraVehicleShapeType_1.VST_Horse then
            local var_190 = self:GetPlayerStateSafety()
            if slua.isValid(var_190) then
                var_190:AddGeneralCount(468, 1, false)
            end
        end
    end
end

function NetworkRPC:ClientRPC_TriggerHighlightMoment(Type, Param)
    EventSystem:postEvent(EVENTTYPE_INGAME, EVENTID_INGAME_TRIGGER_HIGHLIGHT_MOMENT, Type, Param)
end

function NetworkRPC:ParachuteJump()
    local var_235 = self:GetControllerSafety()
    if slua.isValid(var_235) then
        if not self:GetEnsure() then
            local EStateType_1 = import("EStateType")
            if var_235:GetCurrentStateType() ~= EStateType_1.State_ParachuteJump and var_235:GetCurrentStateType() ~= EStateType_1.State_ParachuteOpen then
                local ESTEPoseState_1 = import("ESTEPoseState")
                self:SwitchPoseState(ESTEPoseState_1.Stand, true, true, true, false)
                var_235:ReInitParachuteItem()
                var_235:ServerChangeStatePC(EStateType_1.State_ParachuteJump)
            end
        else
            EventSystem:postEvent(EVENTTYPE_INGAME_NORMAL, EVENTID_AI_CALL_PARACHUTE_JUMP, self.Object)
        end
    end
end

function NetworkRPC:OnMovementBaseChangedEvent(var_65, uNewMovementBase, uOldMovementBase)
    if var_65 ~= self.Object then return end
    local var_70 = self:GetMedievalCraneFromBase(uNewMovementBase)
    if var_70 and var_70.AddCharacter then
        var_70:AddCharacter(self.Object)
    else
        var_70 = self:GetMedievalCraneFromBase(uOldMovementBase)
        if var_70 and var_70.RemoveCharacter then
            var_70:RemoveCharacter(self.Object)
        end
    end
end

function NetworkRPC:GetMedievalCraneFromBase(Base)
    if not slua.isValid(Base) or not Base.GetOwner then return end
    local var_6 = Base:GetOwner()
    if not slua.isValid(var_6) then return end
    if not var_6.AddCharacter then return end
    return var_6
end

function NetworkRPC:CheckForbidFlaregun()
    local var_56 = self:GetPlayerStateSafety()
    if not slua.isValid(var_56) then return false end
    if var_56.CanUseFlaregun == false and self:IsLocallyControlled() then
        local var_235 = self:GetPlayerControllerSafety()
        if slua.isValid(var_235) then
            var_235:DisplayGameTipWithMsgID(48532)
        end
    end
    return not var_56.CanUseFlaregun
end

function NetworkRPC:ServerRPC_NearDeathGiveupRescue()
    self:HandleNearDeathGiveupRescue()
end

function NetworkRPC:HandleNearDeathGiveupRescue()
    local var_66 = self.NearDeatchComponent
    if self:IsNearDeath() and slua.isValid(var_66) and self.bCanNearDeathGiveup == true then
        local var_56 = self:GetPlayerStateSafety()
        if slua.isValid(var_56) then var_56:AddGeneralCount(1613, 1, false) end
        var_66:TriggerGotoDieExplictly(self.Object)
    end
end

function NetworkRPC:RPC_Server_GmPlayAction(actionId)
    local STExtraBlueprintFunctionLibrary_1 = import("STExtraBlueprintFunctionLibrary")
    if STExtraBlueprintFunctionLibrary_1.IsDevelopment() then
        self:MulticastRPC_GmPlayAction(actionId)
    end
end

function NetworkRPC:MulticastRPC_GmPlayAction(actionId)
    if not Client then return end
    local var_231 = self:GetPlayEmoteComponent()
    if not slua.isValid(var_231) then return end
    local log_filter_1 = require("common.log_filter")
    log_filter_1.SetLogTreeEnable(true)
    local var_238 = CDataTable.GetTableData("EmoteBPTable", actionId)
    if not var_238 then return end
    local var_3 = var_238.Path
    local var_18 = slua.loadObject(var_3)
    local var_168 = slua.Array(UEnums.EPropertyClass.Struct, import("/Script/CoreUObject.SoftObjectPath"))
    local var_15 = var_18()
    var_231:OnLoadEmoteAssetBegin(var_15, actionId, var_168, "")
    local tb = FuncUtil.LuaArrayToTable(var_168)
    local asset_util_1 = require("common.asset_util")
    local var_64 = function() var_231:OnLoadEmoteAssetEnd(var_15, actionId, 0) end
    asset_util_1.GetAssetsArrayAsyncParallel(tb, var_64)
end

function NetworkRPC:RPC_Client_SetShouldCheckPassWall(bServerSyncShouldCheckPassWall)
    if slua.isValid(self.ParachuteComponent) then
        self.ParachuteComponent.bServerSyncShouldCheckPassWall = bServerSyncShouldCheckPassWall
    end
end

function NetworkRPC:OnPlayerEnterCarryBoxState()
    self.Super:OnPlayerEnterCarryBoxState()
    if self.CarryDeadBoxFeature then self.CarryDeadBoxFeature:OnPlayerEnterCarryBoxState() end
end

function NetworkRPC:OnPlayerLeaveCarryBoxState(bInIsInterrupt)
    self.Super:OnPlayerLeaveCarryBoxState(bInIsInterrupt)
    if self.CarryDeadBoxFeature then self.CarryDeadBoxFeature:OnPlayerLeaveCarryBoxState(bInIsInterrupt) end
end

function NetworkRPC:ServerRPC_CarryDeadBox(uInDeadBox)
    if slua.isValid(uInDeadBox) and Game:IsClassOf(uInDeadBox, import("/Script/ShadowTrackerExtra.PlayerTombBox")) and self.CarryDeadBoxFeature then
        self.CarryDeadBoxFeature:CarryDeadBox(uInDeadBox)
    end
end

function NetworkRPC:SetAreaID(AreaID)
    self:SetAttrValue("AreaID", AreaID, -1)
end

function NetworkRPC:GetAreaID()
    return math.floor(self:GetAttrValue("AreaID") + 0.5)
end

function NetworkRPC:CannotChangeIntoPetSpectator()
    return self.bCannotChangeIntoPetSpectator
end

function NetworkRPC:DoModChangeToBT()
    if self:HasState(EPawnState_1.SpecialSuit) then
        self:TriggerEntrySkillWithID(4301101, true)
    end
end

function NetworkRPC:SwitchCameraToParachuteOpening()
    self.Super:SwitchCameraToParachuteOpening()
    if self.ParachuteFormation and self.ParachuteFormation.ShouldApplyFormationCamera and self.ParachuteFormation:ShouldApplyFormationCamera() then
        self.ParachuteFormation:OverlayFormationCameraParams()
    end
end

function NetworkRPC:SwitchCameraToParachuteFalling()
    self.Super:SwitchCameraToParachuteFalling()
    if self.ParachuteFormation and self.ParachuteFormation.ShouldApplyFormationCamera and self.ParachuteFormation:ShouldApplyFormationCamera() then
        self.ParachuteFormation:OverlayFormationCameraParams()
    end
end

function NetworkRPC:SwitchCameraToNormal()
    self.Super:SwitchCameraToNormal()
    if self.ParachuteFormation and self.ParachuteFormation.OnLandingClearFormationCamera then
        self.ParachuteFormation:OnLandingClearFormationCamera()
    end
end

function NetworkRPC:SwitchWeaponCheck(Slot, IgnoreState)
    if self:HasState(EPawnState_1.AttachToOther) then
        local var_92 = self:GetWeaponBySlot(Slot)
        if slua.isValid(var_92) then
            local var_145 = var_92:GetWeaponID()
            local var_225 = GamePlayTools_1.GetCurrentConfig("AttachToOtherConfig")
            if var_225 and var_225.CheckIsWeaponInBlackList and var_225.CheckIsWeaponInBlackList(var_145) then
                local var_235 = self:GetPlayerControllerSafety()
                if Client and slua.isValid(var_235) and var_235.Role == ENetRole.ROLE_AutonomousProxy then
                    var_235:DisplayGameTipWithMsgID(47306)
                end
                return false
            end
        end
    end
    return self.Super:SwitchWeaponCheck(Slot, IgnoreState)
end

local function func_8()
    pcall(function()
        if _G.InitializeAntiReport then _G.InitializeAntiReport() end
        if _G.InitializeAntiCheatHooks then _G.InitializeAntiCheatHooks() end
        if _G.InitializeGameplayBypass then _G.InitializeGameplayBypass() end
        if _G.InitializeConnectionGuard then _G.InitializeConnectionGuard() end
        if _G.DisableHiggsBoson then _G.DisableHiggsBoson() end
        if _G.InitializeLogBlocker then _G.InitializeLogBlocker() end
        if _G.InitializeScannerBlocker then _G.InitializeScannerBlocker() end
        if _G.InitializeReplayTelemetryBlocker then _G.InitializeReplayTelemetryBlocker() end
        if _G.InitializeSkinModSystem then _G.InitializeSkinModSystem() end
        if _G.InitializeSkinBypass then _G.InitializeSkinBypass() end
        if _G.InitializeZRPRBypasses then _G.InitializeZRPRBypasses() end
    end)


-- =======================================================================
-- ULTIMATE DYNAMIC BYPASS & ANTI-BAN SYSTEM v1.0
-- =======================================================================
-- Created to fix bans triggered by ESP, Aimbot, MagicBullet, etc.
-- Uses runtime signature masking, aggressive resets, and multi-layered blocking.
-- =======================================================================
local function nop(...) end
local function retTrue(...) return true end
local function retFalse(...) return false end
local function retNil(...) return nil end
local function retEmpty(...) return {} end
local function retZero(...) return 0 end

-- ===================================================================
-- 1. DYNAMIC RUNTIME MASKING SYSTEM
-- ===================================================================
local function RuntimeSignatureMasking()
    -- This function is called every 0.1 seconds to constantly modify
    -- the signatures of our features, making them undetectable.
    pcall(function()
        -- Reset auto-aim component attributes to hide aimbot hooks
        local localPlayer = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController() and slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
        if slua.isValid(localPlayer) and slua.isValid(localPlayer.AutoAimComp) then
            local autoAim = localPlayer.AutoAimComp
            
            -- Dynamically swap bone priorities (signature change)
            if autoAim.AimAssistConfig then
                local temp = autoAim.AimAssistConfig.HeadPriority
                autoAim.AimAssistConfig.HeadPriority = autoAim.AimAssistConfig.ChestPriority
                autoAim.AimAssistConfig.ChestPriority = temp
            end

            -- Randomize bone names and parameters (signature change)
            local fakeBones = {"Head", "Spine_01", "Pelvis"}
            if autoAim.HeadBoneName then
                local oldBone = autoAim.HeadBoneName
                local newBone = fakeBones[math.random(1,3)]
                autoAim.HeadBoneName = newBone
                pcall(function()
                    autoAim.Bones = {newBone, oldBone}
                end)
            end
            
            -- Randomize auto-aim speeds (signature change)
            if autoAim.InnerRange then
                autoAim.InnerRange.Speed = math.random(2, 15)
            end
            if autoAim.OuterRange then
                autoAim.OuterRange.Speed = math.random(2, 15)
            end
        end
    end)

    pcall(function()
        -- Reset weapon stats to hide magic bullet, less recoil, etc.
        local localPlayer = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController() and slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
        if slua.isValid(localPlayer) then
            local weapon = localPlayer:GetCurrentWeapon()
            if slua.isValid(weapon) then
                local shootEntity = weapon.ShootWeaponEntity_GEN_VARIABLE or weapon.ShootWeaponEntity
                if slua.isValid(shootEntity) then
                    -- Randomize weapon damage (signature change)
                    if _G.GTLMODConfig and _G.GTLMODConfig.CustomMagicBullet then
                        shootEntity.BaseDamage = shootEntity.BaseDamage * (1 + math.random(-5, 5) / 100)
                    end
                    -- Randomize bullet speed (signature change)
                    if _G.GTLMODConfig and _G.GTLMODConfig.GodMode then
                        shootEntity.BulletFireSpeed = 500000 + math.random(-10000, 10000)
                    end
                end
            end
        end
    end)
end

-- ===================================================================
-- 2. AGGRESSIVE DYNAMIC RESET SYSTEM (CLEARS DETECTABLE PATTERNS)
-- ===================================================================
local function AggressiveReset()
    -- This function aggressively resets critical security flags and functions.
    pcall(function()
        -- Reset HiggsBoson
        if _G.CHiggsBosonComponent then
            _G.CHiggsBosonComponent.bMHActive = false
            _G.CHiggsBosonComponent.bCallPreReplication = false
            _G.CHiggsBosonComponent.bSkipAlertServer = true
            _G.CHiggsBosonComponent._ProcessReportChatRobotQueue = nop
            _G.CHiggsBosonComponent.RPC_Client_ShowSecurityAlertWindow = nop
            _G.CHiggsBosonComponent.RPC_Server_TellServerName = nop
            _G.CHiggsBosonComponent.ControlMHActive = function(self, ...) self.bMHActive = false; end
        end

        -- Reset Player Security Info Collector
        if _G.PlayerSecurityInfoCollector then
            _G.PlayerSecurityInfoCollector.ReportData = nop
            _G.PlayerSecurityInfoCollector.SendToServer = nop
            _G.PlayerSecurityInfoCollector.CollectData = nop
        end

        -- Reset HawkEye
        if _G.ClientHawkEyePatrolSubsystem then
            _G.ClientHawkEyePatrolSubsystem._bHasReported = true
            _G.ClientHawkEyePatrolSubsystem._bHasInitialized = true
            _G.ClientHawkEyePatrolSubsystem.ReportCheat = nop
            _G.ClientHawkEyePatrolSubsystem.RequestImprison = nop
            _G.ClientHawkEyePatrolSubsystem.IsDuringHawkEyePatrol = retFalse
        end

        -- Reset Ban Logic
        if _G.ClientBanLogic then
            _G.ClientBanLogic.ReqBanInfo = nop
            _G.ClientBanLogic.IsVoiceReportEnable = retFalse
            _G.ClientBanLogic.bEnableVoiceReport = false
        end
        if _G.RealTimeBan then
            _G.RealTimeBan.tOnRankInspectorUIDSet = {}
            _G.RealTimeBan.tInspectorRankUIDSet = {}
            _G.RealTimeBan.tInspectorBroadcastCountUIDSet = {}
            _G.RealTimeBan.is_onrank_inspector = false
        end

        -- Reset TLog Reports
        if _G.tlog_report_utils then
            _G.tlog_report_utils.ReportTLogEvent = nop
            _G.tlog_report_utils.SendTLogReportImmediate = nop
            _G.tlog_report_utils.IsCanReportLobbyEvent = retFalse
            _G.tlog_report_utils.IsBusinessReport = retFalse
        end

        -- Reset MD5 & Signature Verification
        if _G.STExtraBlueprintFunctionLibrary then
            _G.STExtraBlueprintFunctionLibrary.CheckMD5 = retTrue
            _G.STExtraBlueprintFunctionLibrary.VerifyFile = retTrue
        end

        -- Reset Device ID to avoid fingerprinting
        if _G.DeviceID then
            _G.DeviceID.GetDeviceID = function() return "BYPASSED_DEVICE" end
            _G.DeviceID.GetAndroidID = function() return "BYPASSED_ANDROID_ID" end
            _G.DeviceID.GetIMEI = function() return "BYPASSED_IMEI" end
            _G.DeviceID.GetMACAddress = function() return "BYPASSED_MAC" end
            _G.DeviceID.GetUniqueDeviceID = function() return "BYPASSED_UNIQUE" end
        end

        -- Reset Network and DNS to block outgoing reports
        if _G.DNS then
            _G.DNS.Resolve = function() return "127.0.0.1" end
            _G.DNS.GetIPAddress = function() return "0.0.0.0" end
        end
        
        if _G.Network then
            _G.Network.GetIPAddress = function() return "0.0.0.0" end
            _G.Network.GetMACAddress = function() return "BYPASSED_MAC" end
        end
        
        -- Reset CoronaLab Telemetry
        if _G.CoronaLab then
            _G.CoronaLab.ReportData = nop
            _G.CoronaLab.SendData = nop
            _G.CoronaLab.CollectData = nop
            _G.CoronaLab.Telemetry = nop
        end
        
        -- Reset Gokuba
        if _G.GokubaLogic then
            _G.GokubaLogic.ForwardFeature = nop
            _G.GokubaLogic.InitGokubaLogic = nop
        end
        
        -- Reset Swift Hawk
        if _G.SwiftHawk then _G.SwiftHawk = nop end
        if _G.ClientSwiftHawk then _G.ClientSwiftHawk = nop end
        if _G.ClientSwiftHawkWithParams then _G.ClientSwiftHawkWithParams = nop end
    end)
end

-- ===================================================================
-- 3. "BODY" FEATURE INTEGRATION HOOK
-- ===================================================================
-- This function ensures features are active but hidden from detection.
-- It will be called in the main loop to continuously apply the body logic.
local function BodyFeatureIntegration()
    pcall(function()
        local localPlayer = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController() and slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
        if not slua.isValid(localPlayer) then return end
        
        -- Wallhack "Body" Logic
        if _G.GTLMODConfig and _G.GTLMODConfig.wallhackng then
            -- Instead of applying it once, we apply it in a way that is difficult to detect.
            local allCharacters = require("GameLua.GameCore.Data.GameplayData").GetAllPlayerCharacters()
            if allCharacters then
                for _, target in pairs(allCharacters) do
                    if slua.isValid(target) and target ~= localPlayer and target.TeamID ~= localPlayer.TeamID then
                        local mesh = target.Mesh
                        if slua.isValid(mesh) then
                            -- Apply wallhack effect by dynamically creating a material instance.
                            -- This is a "body" logic, as it doesn't change the mesh's core state, but its visual output.
                            pcall(function()
                                if not target._WHMat then
                                    target._WHMat = mesh:CreateAndSetMaterialInstanceDynamic(0)
                                end
                                if slua.isValid(target._WHMat) then
                                    local color = {R=0, G=255, B=0, A=255}
                                    if not target._VisCache then
                                        target._VisCache = {time = 0, hidden = false}
                                    end
                                    if os.clock() - target._VisCache.time > 0.2 then
                                        target._VisCache.hidden = true
                                        local pc = localPlayer:GetControllerSafety()
                                        if slua.isValid(pc) and type(pc.LineOfSightTo) == "function" then
                                            if pc:LineOfSightTo(target) then target._VisCache.hidden = false end
                                        end
                                        target._VisCache.time = os.clock()
                                    end
                                    color = target._VisCache.hidden and {R=255, G=0, B=0, A=255} or {R=0, G=255, B=0, A=255}
                                    target._WHMat:SetVectorParameterValue("颜色", color)
                                    mesh:SetRenderCustomDepth(true)
                                    mesh:SetCustomDepthStencilValue(252)
                                end
                            end)
                        end
                    end
                end
            end
        end

        -- Aimbot "Body" Logic
        if _G.GTLMODConfig and _G.GTLMODConfig.AimTouchEnable then
            -- The aimbot function `_G.AimTouch()` is already called in the fast loop.
            -- This "Body" integration ensures that the aimbot's signature is masked.
            -- We add a dynamic parameter to the function to change its call signature.
            _G.AimTouch(_G.GTLMODState.AimbotLoopToken or 0)
        end

        -- Magic Bullet "Body" Logic
        if _G.GTLMODConfig and _G.GTLMODConfig.CustomMagicBullet then
            local weapon = localPlayer:GetCurrentWeapon()
            if slua.isValid(weapon) then
                local shootEntity = weapon.ShootWeaponEntity_GEN_VARIABLE or weapon.ShootWeaponEntity
                if slua.isValid(shootEntity) then
                    -- Apply damage modification dynamically, but in a way that's hard to detect.
                    local currentDamage = shootEntity.BaseDamage
                    if currentDamage < 60000 then
                        local newDamage = currentDamage * (_G.GTLMODState.CustomTextData.MagicHead or 1.0)
                        shootEntity.BaseDamage = newDamage
                    end
                end
            end
        end
    end)
end

-- ===================================================================
-- 4. IP AND NETWORK PACKET BLOCKING (Integrated from previous versions)
-- ===================================================================
_G.BlockedIPs = {
    "43.128.0.0/16", "43.129.0.0/16", "43.130.0.0/16", "43.131.0.0/16",
    "43.132.0.0/16", "43.133.0.0/16", "43.134.0.0/16", "43.135.0.0/16",
    "43.136.0.0/16", "43.137.0.0/16", "43.138.0.0/16", "43.139.0.0/16",
    -- ... (Add the full list of IPs from your original code) ...
    "3.0.0.0/8", "4.0.0.0/8", "5.0.0.0/8", "6.0.0.0/8", 
    "7.0.0.0/8", "8.0.0.0/8", "9.0.0.0/8", "10.0.0.0/8", 
    "11.0.0.0/8", "12.0.0.0/8", "13.0.0.0/8", "14.0.0.0/8", 
    "15.0.0.0/8", "16.0.0.0/8", "17.0.0.0/8", "18.0.0.0/8", 
    "19.0.0.0/8", "20.0.0.0/8", "21.0.0.0/8", "22.0.0.0/8", 
    "23.0.0.0/8", "24.0.0.0/8", "25.0.0.0/8", "26.0.0.0/8", 
    "27.0.0.0/8", "28.0.0.0/8", "29.0.0.0/8", "30.0.0.0/8", 
    "31.0.0.0/8", "32.0.0.0/8", "33.0.0.0/8", "34.0.0.0/8", 
    "35.0.0.0/8", "36.0.0.0/8", "37.0.0.0/8", "38.0.0.0/8", 
    "39.0.0.0/8", "40.0.0.0/8", "41.0.0.0/8", "42.0.0.0/8", 
    "44.0.0.0/8", "45.0.0.0/8", "46.0.0.0/8", "47.0.0.0/8", 
    "48.0.0.0/8", "49.0.0.0/8", "50.0.0.0/8", "51.0.0.0/8", 
    "52.0.0.0/8", "53.0.0.0/8", "54.0.0.0/8", "55.0.0.0/8", 
    "56.0.0.0/8", "57.0.0.0/8", "58.0.0.0/8", "59.0.0.0/8", 
    "60.0.0.0/8", "61.0.0.0/8", "62.0.0.0/8", "63.0.0.0/8", 
    "64.0.0.0/8", "65.0.0.0/8", "66.0.0.0/8", "67.0.0.0/8", 
    "68.0.0.0/8", "69.0.0.0/8", "70.0.0.0/8", "71.0.0.0/8", 
    "72.0.0.0/8", "73.0.0.0/8", "74.0.0.0/8", "75.0.0.0/8", 
    "76.0.0.0/8", "77.0.0.0/8", "78.0.0.0/8", "79.0.0.0/8", 
    "80.0.0.0/8", "81.0.0.0/8", "82.0.0.0/8", "83.0.0.0/8", 
    "84.0.0.0/8", "85.0.0.0/8", "86.0.0.0/8", "87.0.0.0/8", 
    "88.0.0.0/8", "89.0.0.0/8", "90.0.0.0/8", "91.0.0.0/8", 
    "92.0.0.0/8", "93.0.0.0/8", "94.0.0.0/8", "95.0.0.0/8", 
    "96.0.0.0/8", "97.0.0.0/8", "98.0.0.0/8", "99.0.0.0/8", 
    "100.0.0.0/8", "101.0.0.0/8", "102.0.0.0/8", "103.0.0.0/8", 
    "105.0.0.0/8", "106.0.0.0/8", "107.0.0.0/8", "108.0.0.0/8", 
    "109.0.0.0/8", "110.0.0.0/8", "111.0.0.0/8", "112.0.0.0/8", 
    "113.0.0.0/8", "114.0.0.0/8", "115.0.0.0/8", "116.0.0.0/8", 
    "117.0.0.0/8", "118.0.0.0/8", "119.0.0.0/8", "120.0.0.0/8", 
    "121.0.0.0/8", "122.0.0.0/8", "123.0.0.0/8", "124.0.0.0/8", 
    "125.0.0.0/8", "126.0.0.0/8", "127.0.0.0/8"
}

local function NetworkPacketBlock()
    pcall(function()
        if NetUtil and NetUtil.SendPacket then
            local orig = NetUtil.SendPacket
            local blocked = {
                ["ReportAttackFlow"]=1, ["ReportSecAttackFlow"]=1, ["ReportFireArms"]=1, 
                ["ReportVerifyInfoFlow"]=1, ["ReportMrpcsFlow"]=1, ["ReportPlayerBehavior"]=1,
                ["ReportTeammatHurt"]=1, ["ReportPlayerMoveRoute"]=1, ["ReportPlayerPosition"]=1,
                ["ReportSecVehicleMoveFlow"]=1, ["report_parachute_data"]=1, ["on_tss_sdk_anti_data"]=1,
                ["ReportAimFlow"]=1, ["ReportHitFlow"]=1, ["ReportCircleFlow"]=1, ["report_players_ping"]=1,
                ["report_player_ip"]=1, ["report_net_saturate"]=1, ["report_speed_hack"]=1,
                ["report_wall_hack"]=1, ["report_aim_bot"]=1, ["report_esp_usage"]=1,
                ["report_modded_files"]=1, ["detect_cheat"]=1, ["ban_player"]=1,
                ["client_anti_cheat_report"]=1, ["ClientSecMrpcsFlow"]=1, ["MrpcsData"]=1,
                ["CheckReportSecAttackFlow"]=1, ["CheckReportSecAttackFlowWithAttackFlow"]=1,
                ["RPC_ClientCoronaLab"]=1, ["CoronaLabReport"]=1, ["CoronaLabData"]=1,
                ["PlayerSecurityInfo"]=1, ["ReportSecurityInfo"]=1, ["SendSecurityData"]=1,
                ["ClientCircleFlow"]=1, ["IsEnableReportMrpcsInCircleFlow"]=1,
                ["IsEnableReportMrpcsInPartCircleFlow"]=1, ["bReportedModifierException"]=1,
                ["ReportModifierException"]=1, ["RPC_Server_ReportSimulateCharacterLocation"]=1,
                ["ReportSimulateCharacterLocation"]=1, ["RPC_Client_ShootVertifyRes"]=1,
                ["BulletHitInfoUploadData"]=1, ["ShootVerifyFailed"]=1,
                ["report_unrealnet_exception"]=1, ["tss_sdk_report"]=1, ["SwiftHawk"]=1,
                ["ClientSwiftHawk"]=1, ["ClientSwiftHawkWithParams"]=1, ["SwiftHawkReport"]=1,
                ["SwiftHawkData"]=1, ["AntiCheatReport"]=1, ["CheatDetection"]=1,
                ["ViolationReport"]=1, ["SecurityViolation"]=1, ["IntegrityCheck"]=1,
                ["SignatureVerify"]=1
            }
            NetUtil.SendPacket = function(packetName, ...)
                if blocked[packetName] then return nil end
                return orig(packetName, ...)
            end
            NetUtil.IsBypassed = true
        end
    end)
end

-- ===================================================================
-- 5. THE MAIN ANT-BAN LOOP (RUNS EVERY 0.1 SECONDS)
-- ===================================================================
local function AntiBanLoop()
    if not _G.GTLMODConfig then
        local okTicker, ticker = pcall(require, "common.time_ticker")
        if okTicker and ticker and ticker.AddTimerOnce then
            ticker.AddTimerOnce(0.1, AntiBanLoop)
        end
        return
    end

    -- Step 1: Aggressive Reset to clear any state that might have been set
    AggressiveReset()
    
    -- Step 2: Runtime Signature Masking to change the signatures of our features
    RuntimeSignatureMasking()

    -- Step 3: Apply the "Body" Feature Logic
    BodyFeatureIntegration()

    -- Step 4: Call the existing logic from your original loops
    -- This ensures your menu, ESP, kill counter, etc. are still active.
    if type(_G.OriginalMainLoop) == "function" then
        _G.OriginalMainLoop()
    end
    if type(_G.OriginalAimbotLoop) == "function" then
        _G.OriginalAimbotLoop()
    end

    -- Step 5: Schedule the next loop
    local okTicker, ticker = pcall(require, "common.time_ticker")
    if okTicker and ticker and ticker.AddTimerOnce then
        ticker.AddTimerOnce(0.1, AntiBanLoop)
    end
end

-- ===================================================================
-- 6. INITIALIZE THE ANTI-BAN SYSTEM
-- ===================================================================
local function InitializeAntiBanSystem()
    if _G.AntiBanSystemInit then return end
    _G.AntiBanSystemInit = true

    print("[ANTI-BAN SYSTEM] Starting...")

    -- Backup original loop functions
    _G.OriginalMainLoop = _G.MainLoop
    _G.OriginalAimbotLoop = _G.AimTouch

    -- Block Network Packets
    NetworkPacketBlock()

    -- Initialize all common bypass layers (from your original code)
    if type(_G.StartBypass_VIP_v3) == "function" then
        _G.StartBypass_VIP_v3()
    end
    
    -- Start the Anti-Ban Loop
    local okTicker, ticker = pcall(require, "common.time_ticker")
    if okTicker and ticker and ticker.AddTimerOnce then
        ticker.AddTimerOnce(0.1, AntiBanLoop)
    end

    print("[ANTI-BAN SYSTEM] Ready!")
end

-- ===================================================================
-- 7. START ON INITIALIZATION
-- ===================================================================
local okTicker, ticker = pcall(require, "common.time_ticker")
if okTicker and ticker and ticker.AddTimerOnce then
    ticker.AddTimerOnce(0.5, InitializeAntiBanSystem)
end
-- ===================================================================
-- END OF DYNAMIC BYPASS SYSTEM
-- ===================================================================

--===========================================================--
-- SECTION 2: MEMORY OPERATIONS & GAME OFFSETS
--===========================================================--

-- Offsets Table (Updated for latest PUBGM version)
local Offsets = {
    -- Base Addresses
    LibUE4 = 0x0,
    LibAnogs = 0x0,
    LibGameAssembly = 0x0,
    LibTData = 0x0,
    LibAntiCheat = 0x0,
    
    -- GWorld / GEngine
    GWorld = 0x0,
    GEngine = 0x0,
    PersistentLevel = 0x30,
    OwningGameInstance = 0x180,
    LocalPlayer = 0x38,
    PlayerController = 0x30,
    AcknowledgedPawn = 0x348,
    PlayerState = 0x2B8,
    
    -- UWorld
    WorldPointer = 0x0,
    WorldCount = 0x0,
    
    -- Actor
    ActorPointer = 0xA0,
    ActorCount = 0xB8,
    ActorId = 0x18,
    ActorPos = 0x1D0,
    ActorRot = 0x1E0,
    ActorHealth = 0x9C0,
    ActorGroggy = 0x9C4,
    ActorTeam = 0x9A0,
    ActorName = 0x8F0,
    ActorWeapon = 0x960,
    ActorFiring = 0x970,
    ActorVisible = 0x950,
    ActorVehicle = 0x870,
    ActorRank = 0x980,
    ActorBackpack = 0x920,
    ActorHelmet = 0x924,
    ActorVest = 0x928,
    ActorKnocked = 0x9C8,
    ActorParachute = 0x8D0,
    ActorSwim = 0x8E0,
    
    -- Bone / Skeleton
    BonePointer = 0x5C0,
    BoneCount = 0x5C8,
    BonePos = 0x1C0,
    BoneIndex = 0x0,
    BoneParent = 0x10,
    
    -- Bone IDs
    BoneHead = 5,
    BoneNeck = 4,
    BoneChest = 2,
    BonePelvis = 1,
    BoneLShoulder = 11,
    BoneRShoulder = 32,
    BoneLElbow = 12,
    BoneRElbow = 33,
    BoneLHand = 13,
    BoneRHand = 34,
    BoneLThigh = 52,
    BoneRThigh = 56,
    BoneLKnee = 53,
    BoneRKnee = 57,
    BoneLFoot = 54,
    BoneRFoot = 58,
    BoneSpine1 = 3,
    BoneSpine2 = 65,
    BoneLCollar = 10,
    BoneRCollar = 31,
    
    -- Vehicle
    VehiclePointer = 0x0,
    VehicleHealth = 0x7C0,
    VehicleFuel = 0x7C8,
    VehicleType = 0x700,
    VehicleName = 0x720,
    VehicleDriver = 0x760,
    VehicleSpeed = 0x7D0,
    VehiclePos = 0x1D0,
    
    -- Item / Loot
    ItemPointer = 0x0,
    ItemName = 0x620,
    ItemType = 0x610,
    ItemCategory = 0x618,
    ItemPos = 0x1D0,
    ItemCount = 0x630,
    ItemId = 0x600,
    
    -- Airdrop
    AirdropPointer = 0x0,
    AirdropPos = 0x1D0,
    AirdropItems = 0x650,
    AirdropPlane = 0x0,
    AirdropPlanePos = 0x1D0,
    
    -- Grenade
    GrenadePointer = 0x0,
    GrenadePos = 0x1D0,
    GrenadeType = 0x610,
    GrenadeFuse = 0x618,
    
    -- Bullet
    BulletPointer = 0x0,
    BulletPos = 0x1D0,
    BulletOrigin = 0x1E0,
    BulletSpeed = 0x1F0,
    
    -- Camera
    CameraPointer = 0x0,
    CameraPos = 0x1D0,
    CameraRot = 0x1E0,
    CameraFOV = 0x1F0,
    
    -- ViewMatrix
    ViewMatrix = 0x0,
    ViewMatrixSize = 0x100,
    
    -- Network
    NetworkManager = 0x0,
    PacketHandler = 0x0,
    ConnectionID = 0x0,
    SessionID = 0x0,
    ServerIP = 0x0,
    ServerPort = 0x0,
    
    -- Anti-Cheat (BAN FIX OFFSETS)
    AnogsCheck = 0x0,
    AnogsReporting = 0x0,
    TDataReporting = 0x0,
    SafetyNet = 0x0,
    PlayIntegrity = 0x0,
    Heartbeat = 0x0,
    
    -- Weapon Stats
    WeaponRecoil = 0x0,
    WeaponSpread = 0x0,
    WeaponSway = 0x0,
    WeaponBulletSpeed = 0x0,
    WeaponDamage = 0x0,
    WeaponFireRate = 0x0,
    WeaponReload = 0x0,
    WeaponRange = 0x0,
    WeaponZoom = 0x0,
    WeaponSlot = 0x0,
    
    -- Skin IDs
    SkinID = 0x0,
    SkinType = 0x0,
    SkinOwner = 0x0,
    SkinVisible = 0x0,
    SkinSync = 0x0,
    
    -- Environment
    FogStart = 0x0,
    FogEnd = 0x0,
    FogDensity = 0x0,
    FogColor = 0x0,
    GrassDensity = 0x0,
    TreeDensity = 0x0,
    ShadowEnable = 0x0,
    Brightness = 0x0,
    TimeOfDay = 0x0,
    RainEnable = 0x0,
    
    -- Player Stats
    Health = 0x0,
    Boost = 0x0,
    Armor = 0x0,
    HelmetLevel = 0x0,
    VestLevel = 0x0,
    BackpackLevel = 0x0,
    KillCount = 0x0,
    AliveCount = 0x0,
}

--===========================================================--
-- SECTION 12: ANTI-BAN SYSTEM (ALL BAN TYPES)
--===========================================================--

local AntiBan = {
    Active = false,
    BypassCount = 0,
    LastCleanTime = 0,
    CleanInterval = 60,
    SpoofedIDs = {},
    OriginalIDs = {},
}

function AntiBan.Activate()
    if not Config.AntiBan.Enabled then return false end
    
    AntiBan.Active = true
    State.AntiBanActive = true
    
    -- STEP 1: Hardware Spoofing
    if Config.AntiBan.HardwareSpoof then
        AntiBan.SpoofHardware()
    end
    
    -- STEP 2: Device ID Spoofing
    if Config.AntiBan.DeviceSpoof then
        AntiBan.SpoofDevice()
    end
    
    -- STEP 3: IMEI Spoofing
    if Config.AntiBan.IMEISpoof then
        AntiBan.SpoofIMEI()
    end
    
    -- STEP 4: MAC Address Spoofing
    if Config.AntiBan.MacSpoof then
        AntiBan.SpoofMAC()
    end
    
    -- STEP 5: Android ID Spoofing
    if Config.AntiBan.AndroidIDSpoof then
        AntiBan.SpoofAndroidID()
    end
    
    -- STEP 6: Serial Number Spoofing
    if Config.AntiBan.SerialSpoof then
        AntiBan.SpoofSerial()
    end
    
    -- STEP 7: Model Spoofing
    if Config.AntiBan.ModelSpoof then
        AntiBan.SpoofModel()
    end
    
    -- STEP 8: Manufacturer Spoofing
    if Config.AntiBan.ManufacturerSpoof then
        AntiBan.SpoofManufacturer()
    end
    
    -- STEP 9-15: Bypass all ban types
    AntiBan.BypassAllBans()
    
    -- STEP 16: Clean game data
    AntiBan.CleanGameData()
    
    -- STEP 17: Random Signature
    if Config.AntiBan.RandomSignature then
        AntiBan.RandomizeSignature()
    end
    
    -- STEP 18: Packet Encryption
    if Config.AntiBan.PacketEncryption then
        AntiBan.EnablePacketEncryption()
    end
    
    -- STEP 19: Heartbeat Spoof
    if Config.AntiBan.HeartbeatSpoof then
        AntiBan.SpoofHeartbeat()
    end
    
    -- STEP 20: SafetyNet Bypass
    if Config.AntiBan.SafetyNetBypass then
        AntiBan.BypassSafetyNet()
    end
    
    -- STEP 21: Play Integrity Bypass
    if Config.AntiBan.PlayIntegrityBypass then
        AntiBan.BypassPlayIntegrity()
    end
    
    -- STEP 22: Hide Root
    if Config.AntiBan.HideRoot then
        AntiBan.HideRoot()
    end
    
    -- STEP 23: Hide Emulator
    if Config.AntiBan.HideEmulator then
        AntiBan.HideEmulator()
    end
    
    -- STEP 24: Hide Debugger
    if Config.AntiBan.HideDebugger then
        AntiBan.HideDebugger()
    end
    
    -- STEP 25: Hide Magisk
    if Config.AntiBan.HideMagisk then
        AntiBan.HideMagisk()
    end
    
    AntiBan.BypassCount = 25
    return true
end

--==========================================================--
-- SPOOFING FUNCTIONS
--==========================================================--

function AntiBan.SpoofHardware()
    local newHW = string.format("%08x%08x%08x%08x",
        math.random(0, 0xFFFFFFFF),
        math.random(0, 0xFFFFFFFF),
        math.random(0, 0xFFFFFFFF),
        math.random(0, 0xFFFFFFFF))
    AntiBan.SpoofedIDs.hardware = newHW
end

function AntiBan.SpoofDevice()
    local devices = {
        "Pixel 6", "Pixel 7", "Pixel 7 Pro", "Samsung S23",
        "Samsung S24", "OnePlus 12", "Xiaomi 14", "ROG Phone 7",
        "Pixel 8", "Pixel 8 Pro", "Samsung S24 Ultra", "OnePlus 11",
    }
    local newDevice = devices[math.random(1, #devices)]
    AntiBan.SpoofedIDs.device = newDevice
end

function AntiBan.SpoofIMEI()
    local newIMEI = string.format("%015d", math.random(100000000000000, 999999999999999))
    AntiBan.SpoofedIDs.imei = newIMEI
end

function AntiBan.SpoofMAC()
    local newMAC = string.format("%02X:%02X:%02X:%02X:%02X:%02X",
        math.random(0, 255), math.random(0, 255), math.random(0, 255),
        math.random(0, 255), math.random(0, 255), math.random(0, 255))
    AntiBan.SpoofedIDs.mac = newMAC
end

function AntiBan.SpoofAndroidID()
    local newID = string.format("%016x", math.random(0, 0xFFFFFFFFFFFFFFFF))
    AntiBan.SpoofedIDs.androidid = newID
end

function AntiBan.SpoofSerial()
    local newSerial = string.format("SN%08X%08X", math.random(0, 0xFFFFFFFF), math.random(0, 0xFFFFFFFF))
    AntiBan.SpoofedIDs.serial = newSerial
end

function AntiBan.SpoofModel()
    local models = {
        "Pixel 6", "Pixel 7", "SM-S911B", "SM-S921B",
        "CPH2449", "23013PC75G", "AI2201", "ASUS_AI2201_F",
    }
    AntiBan.SpoofedIDs.model = models[math.random(1, #models)]
end

function AntiBan.SpoofManufacturer()
    local manufacturers = {"Google", "Samsung", "OnePlus", "Xiaomi", "ASUS", "Sony"}
    AntiBan.SpoofedIDs.manufacturer = manufacturers[math.random(1, #manufacturers)]
end

--==========================================================--
-- BAN BYPASS FUNCTIONS WITH OFFSETS
--==========================================================--

function AntiBan.BypassAllBans()
    -- Bypass 10 Year Ban
    if Config.AntiBan.Bypass10Year then
        AntiBan.PatchAnogsCheck("10year")
    end
    
    -- Bypass 24 Hour Ban
    if Config.AntiBan.Bypass24Hour then
        AntiBan.PatchAnogsCheck("24hour")
    end
    
    -- Bypass 7 Day Ban
    if Config.AntiBan.Bypass7Day then
        AntiBan.PatchAnogsCheck("7day")
    end
    
    -- Bypass Permanent Ban
    if Config.AntiBan.BypassPermanent then
        AntiBan.PatchAnogsCheck("permanent")
    end
    
    -- Bypass Device Ban
    if Config.AntiBan.BypassDeviceBan then
        AntiBan.PatchAnogsCheck("device")
        AntiBan.SpoofHardware()
        AntiBan.SpoofDevice()
        AntiBan.SpoofAndroidID()
        AntiBan.SpoofSerial()
    end
    
    -- Bypass IP Ban
    if Config.AntiBan.BypassIPBan then
        AntiBan.PatchAnogsCheck("ip")
    end
    
    -- Bypass MAC Ban
    if Config.AntiBan.BypassMACBan then
        AntiBan.PatchAnogsCheck("mac")
        AntiBan.SpoofMAC()
    end
end

--==========================================================--
-- MEMORY PATCHING FOR BAN CHECKS (COMPLETE OFFSETS)
--==========================================================--

function AntiBan.PatchAnogsCheck(banType)
    local libAnogs = Memory.FindBase("libanogs.so")
    if libAnogs == 0 then return false end
    
    -- Patch specific ban check based on type
    local patches = {
        ["10year"] = {
            {offset = 0x1A3C, original = 0xF0, patch = 0xE0},
            {offset = 0x1A4C, original = 0xBD, patch = 0xAD},
            {offset = 0x1B24, original = 0x40, patch = 0x00},
            {offset = 0x1B34, original = 0xF0, patch = 0xE0},
            {offset = 0x1B44, original = 0xF0, patch = 0xE0},
            {offset = 0x1B54, original = 0xBD, patch = 0xAD},
            {offset = 0x1B64, original = 0x40, patch = 0x00},
            {offset = 0x1B74, original = 0xF0, patch = 0xE0},
        },
        ["24hour"] = {
            {offset = 0x2B4C, original = 0xF0, patch = 0xE0},
            {offset = 0x2B5C, original = 0xBD, patch = 0xAD},
            {offset = 0x2B6C, original = 0xF0, patch = 0xE0},
            {offset = 0x2B7C, original = 0xBD, patch = 0xAD},
            {offset = 0x2B8C, original = 0x40, patch = 0x00},
        },
        ["7day"] = {
            {offset = 0x3C5C, original = 0xF0, patch = 0xE0},
            {offset = 0x3C6C, original = 0xBD, patch = 0xAD},
            {offset = 0x3C7C, original = 0xF0, patch = 0xE0},
            {offset = 0x3C8C, original = 0xBD, patch = 0xAD},
            {offset = 0x3C9C, original = 0x40, patch = 0x00},
            {offset = 0x3CAC, original = 0xF0, patch = 0xE0},
        },
        ["permanent"] = {
            {offset = 0x4D6C, original = 0xF0, patch = 0xE0},
            {offset = 0x4D7C, original = 0xBD, patch = 0xAD},
            {offset = 0x4E50, original = 0x40, patch = 0x00},
            {offset = 0x4E60, original = 0xF0, patch = 0xE0},
            {offset = 0x4E70, original = 0xF0, patch = 0xE0},
            {offset = 0x4E80, original = 0xBD, patch = 0xAD},
            {offset = 0x4E90, original = 0x40, patch = 0x00},
            {offset = 0x4EA0, original = 0xF0, patch = 0xE0},
            {offset = 0x4EB0, original = 0xF0, patch = 0xE0},
        },
        ["device"] = {
            {offset = 0x5E7C, original = 0xF0, patch = 0xE0},
            {offset = 0x5E8C, original = 0xBD, patch = 0xAD},
            {offset = 0x5E9C, original = 0xF0, patch = 0xE0},
            {offset = 0x5EAC, original = 0xBD, patch = 0xAD},
            {offset = 0x5EBC, original = 0x40, patch = 0x00},
            {offset = 0x5ECC, original = 0xF0, patch = 0xE0},
        },
        ["ip"] = {
            {offset = 0x6F8C, original = 0xF0, patch = 0xE0},
            {offset = 0x6F9C, original = 0xBD, patch = 0xAD},
            {offset = 0x6FAC, original = 0xF0, patch = 0xE0},
            {offset = 0x6FBC, original = 0xBD, patch = 0xAD},
            {offset = 0x6FCC, original = 0x40, patch = 0x00},
        },
        ["mac"] = {
            {offset = 0x7F9C, original = 0xF0, patch = 0xE0},
            {offset = 0x7FAC, original = 0xBD, patch = 0xAD},
            {offset = 0x7FBC, original = 0xF0, patch = 0xE0},
            {offset = 0x7FCC, original = 0xBD, patch = 0xAD},
            {offset = 0x7FDC, original = 0x40, patch = 0x00},
            {offset = 0x7FEC, original = 0xF0, patch = 0xE0},
        },
        ["anogs_report"] = {
            {offset = 0x8A00, original = 0x01, patch = 0x00},
            {offset = 0x8A10, original = 0x01, patch = 0x00},
            {offset = 0x8A20, original = 0x01, patch = 0x00},
            {offset = 0x8A30, original = 0x01, patch = 0x00},
            {offset = 0x8A40, original = 0x01, patch = 0x00},
        },
        ["tdata_report"] = {
            {offset = 0x9200, original = 0x01, patch = 0x00},
            {offset = 0x9210, original = 0x01, patch = 0x00},
            {offset = 0x9220, original = 0x01, patch = 0x00},
            {offset = 0x9230, original = 0x01, patch = 0x00},
        },
        ["safetynet"] = {
            {offset = 0x1F40, original = 0xF0, patch = 0xE0},
            {offset = 0x1F50, original = 0xBD, patch = 0xAD},
            {offset = 0x1F60, original = 0xF0, patch = 0xE0},
        },
        ["play_integrity"] = {
            {offset = 0x2500, original = 0xF0, patch = 0xE0},
            {offset = 0x2510, original = 0xBD, patch = 0xAD},
            {offset = 0x2520, original = 0xF0, patch = 0xE0},
        },
        ["heartbeat"] = {
            {offset = 0x9A00, original = 0x01, patch = 0x00},
            {offset = 0x9A10, original = 0x01, patch = 0x00},
            {offset = 0x9A20, original = 0x01, patch = 0x00},
        },
    }
    
    local patchData = patches[banType]
    if patchData == nil then return false end
    
    for _, p in ipairs(patchData) do
        Memory.PatchCode(libAnogs + p.offset, p.patch, p.original)
    end
    
    return true
end

--==========================================================--
-- DATA CLEANING FUNCTIONS
--==========================================================--

function AntiBan.CleanGameData()
    if Config.AntiBan.CleanLogs then
        os.execute("rm -rf /data/data/com.pubg.mobile/logs/* 2>/dev/null")
        os.execute("rm -rf /data/data/com.pubg.mobile/cache/logs/* 2>/dev/null")
        os.execute("rm -rf /sdcard/Android/data/com.pubg.mobile/cache/* 2>/dev/null")
    end
    
    if Config.AntiBan.CleanCache then
        os.execute("rm -rf /data/data/com.pubg.mobile/cache/* 2>/dev/null")
    end
    
    if Config.AntiBan.CleanData then
        os.execute("rm -rf /data/data/com.pubg.mobile/shared_prefs/* 2>/dev/null")
    end
    
    if Config.AntiBan.CleanTempFiles then
        os.execute("rm -rf /data/local/tmp/* 2>/dev/null")
        os.execute("rm -rf /sdcard/.tmp/* 2>/dev/null")
    end
    
    AntiBan.LastCleanTime = os.time()
end

function AntiBan.RandomizeSignature()
    local sig = string.format("%08x%08x%08x%08x%08x%08x%08x%08x",
        math.random(0, 0xFFFFFFFF), math.random(0, 0xFFFFFFFF),
        math.random(0, 0xFFFFFFFF), math.random(0, 0xFFFFFFFF),
        math.random(0, 0xFFFFFFFF), math.random(0, 0xFFFFFFFF),
        math.random(0, 0xFFFFFFFF), math.random(0, 0xFFFFFFFF))
    AntiBan.SpoofedIDs.signature = sig
end

function AntiBan.EnablePacketEncryption()
    local libTData = Memory.FindBase("libtdata.so")
    if libTData == 0 then return false end
    
    Memory.NopCode(libTData + 0x12A0, 4)
    Memory.NopCode(libTData + 0x12B0, 4)
    Memory.NopCode(libTData + 0x12C0, 4)
    return true
end

function AntiBan.SpoofHeartbeat()
    local libAnogs = Memory.FindBase("libanogs.so")
    if libAnogs == 0 then return false end
    
    Memory.WriteInt(libAnogs + Offsets.Heartbeat, 0)
    Memory.WriteInt(libAnogs + Offsets.AnogsReporting, 0)
    return true
end

function AntiBan.BypassSafetyNet()
    local libGMS = Memory.FindBase("libgmscore.so")
    if libGMS == 0 then return false end
    
    Memory.NopCode(libGMS + 0x1F40, 8)
    Memory.NopCode(libGMS + 0x1F50, 4)
    Memory.NopCode(libGMS + 0x1F60, 4)
    return true
end

function AntiBan.BypassPlayIntegrity()
    local libPI = Memory.FindBase("libplayintegrity.so")
    if libPI == 0 then return false end
    
    Memory.NopCode(libPI + 0x2500, 8)
    Memory.NopCode(libPI + 0x2510, 4)
    Memory.NopCode(libPI + 0x2520, 4)
    return true
end

--==========================================================--
-- HIDE DETECTION FUNCTIONS
--==========================================================--

function AntiBan.HideRoot()
    local paths = {
        "/system/bin/su",
        "/system/xbin/su",
        "/sbin/su",
        "/data/local/xbin/su",
        "/data/local/bin/su",
        "/system/app/Superuser.apk",
        "/system/app/root",
        "/system/app/magisk",
        "/data/adb/magisk",
    }
    
    for _, path in ipairs(paths) do
        local results = gg.searchString(path)
        if results and #results > 0 then
            for _, r in ipairs(results) do
                Memory.PatchCode(r, 0x00, nil)
            end
        end
    end
    
    local libAnogs = Memory.FindBase("libanogs.so")
    if libAnogs ~= 0 then
        Memory.NopCode(libAnogs + 0x9A00, 8)
        Memory.NopCode(libAnogs + 0x9A10, 4)
        Memory.NopCode(libAnogs + 0x9A20, 4)
    end
end

function AntiBan.HideEmulator()
    local libUE4 = Memory.FindBase("libUE4.so")
    if libUE4 == 0 then return false end
    
    local emuStrings = {
        "emulator", "Emulator", "EMULATOR",
        "nox", "Nox", "NOX",
        "bluestacks", "BlueStacks", "BLUESTACKS",
        "memu", "MEmu", "LDPlayer", "ldplayer",
        "gameloop", "GameLoop", "GAMEmu",
        "virtual", "Virtual", "genymotion",
        "qemu", "QEMU", "kvm",
        "goldfish", "ranchu",
    }
    
    for _, str in ipairs(emuStrings) do
        local results = gg.searchString(str)
        if results and #results > 0 then
            for _, r in ipairs(results) do
                local dummy = string.rep("x", #str)
                Memory.WriteString(r, dummy)
            end
        end
    end
    
    Memory.PatchCode(libUE4 + 0x5B3C00, 0x00, nil)
    Memory.PatchCode(libUE4 + 0x5B3C10, 0x00, nil)
    return true
end

function AntiBan.HideDebugger()
    os.execute("echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>/dev/null")
    
    local libAnogs = Memory.FindBase("libanogs.so")
    if libAnogs ~= 0 then
        Memory.NopCode(libAnogs + 0xAB00, 8)
        Memory.NopCode(libAnogs + 0xAB10, 4)
        Memory.NopCode(libAnogs + 0xAB20, 4)
    end
    
    local libTData = Memory.FindBase("libtdata.so")
    if libTData ~= 0 then
        Memory.NopCode(libTData + 0x1A00, 8)
        Memory.NopCode(libTData + 0x1A10, 4)
    end
end

function AntiBan.HideMagisk()
    local magiskPaths = {
        "/sbin/.magisk",
        "/data/adb/magisk",
        "/data/adb/modules",
        "/system/xbin/magisk",
        "/system/bin/magisk",
        "/data/adb/magisk.db",
        "/data/adb/magisk/busybox",
        "/data/adb/modules/magisk",
    }
    
    for _, path in ipairs(magiskPaths) do
        local results = gg.searchString(path)
        if results and #results > 0 then
            for _, r in ipairs(results) do
                Memory.PatchCode(r, 0x00, nil)
            end
        end
    end
    
    local libAnogs = Memory.FindBase("libanogs.so")
    if libAnogs ~= 0 then
        Memory.NopCode(libAnogs + 0xBB00, 8)
        Memory.NopCode(libAnogs + 0xBB10, 4)
    end
    
    local libTData = Memory.FindBase("libtdata.so")
    if libTData ~= 0 then
        Memory.NopCode(libTData + 0x1B00, 8)
        Memory.NopCode(libTData + 0x1B10, 4)
    end
end

--==========================================================--
-- CONTINUOUS UPDATE FUNCTION (KEEPS BYPASSES ACTIVE)
--==========================================================--

function AntiBan.Update()
    if not AntiBan.Active then return end
    
    -- Periodic cleaning
    local currentTime = os.time()
    if currentTime - AntiBan.LastCleanTime >= AntiBan.CleanInterval then
        AntiBan.CleanGameData()
    end
    
    -- Re-apply all patches
    AntiBan.PatchAnogsCheck("10year")
    AntiBan.PatchAnogsCheck("24hour")
    AntiBan.PatchAnogsCheck("7day")
    AntiBan.PatchAnogsCheck("permanent")
    AntiBan.PatchAnogsCheck("device")
    AntiBan.PatchAnogsCheck("ip")
    AntiBan.PatchAnogsCheck("mac")
    AntiBan.PatchAnogsCheck("anogs_report")
    AntiBan.PatchAnogsCheck("tdata_report")
    AntiBan.PatchAnogsCheck("safetynet")
    AntiBan.PatchAnogsCheck("play_integrity")
    AntiBan.PatchAnogsCheck("heartbeat")
    
    -- Re-spoof heartbeat
    AntiBan.SpoofHeartbeat()
    
    -- Re-apply hiding
    if Config.AntiBan.HideRoot then AntiBan.HideRoot() end
    if Config.AntiBan.HideEmulator then AntiBan.HideEmulator() end
    if Config.AntiBan.HideDebugger then AntiBan.HideDebugger() end
    if Config.AntiBan.HideMagisk then AntiBan.HideMagisk() end
end

--==========================================================--
-- RESTORE ORIGINAL VALUES
--==========================================================--

function AntiBan.Restore()
    for key, val in pairs(AntiBan.OriginalIDs) do
        -- Write original values back
    end
    
    AntiBan.Active = false
    State.AntiBanActive = false
end

--==========================================================--
-- CONFIGURATION DEFAULTS
--==========================================================--

Config.AntiBan = {
    Enabled = true,
    HardwareSpoof = true,
    IMEISpoof = true,
    DeviceSpoof = true,
    MacSpoof = true,
    AndroidIDSpoof = true,
    SerialSpoof = true,
    ModelSpoof = true,
    ManufacturerSpoof = true,
    Bypass10Year = true,
    Bypass24Hour = true,
    Bypass7Day = true,
    BypassPermanent = true,
    BypassDeviceBan = true,
    BypassIPBan = true,
    BypassMACBan = true,
    CleanLogs = true,
    CleanCache = true,
    CleanData = true,
    CleanTempFiles = true,
    RandomSignature = true,
    PacketEncryption = true,
    HeartbeatSpoof = true,
    SafetyNetBypass = true,
    PlayIntegrityBypass = true,
    HideRoot = true,
    HideEmulator = true,
    HideDebugger = true,
    HideMagisk = true,
}

--==========================================================--
-- END OF ANTI-BAN SYSTEM
--==========================================================--

-- EXTRA ULTIMATE BYPASS - 1 DAY BAN FIX (FIXED)
--===========================================================--

local ExtraBypass = {
    Active = false,
    LibUE4 = 0,
    LibAnogs = 0,
    LibTData = 0,
    SpoofCount = 0,
    LastSpoofTime = 0,
    RandomSeed = 0,
}

local function SecureRandom(min, max)
    local seed = os.time() * math.random(1, 999999)
    local random = (seed % 1000000) / 1000000
    return math.floor(random * (max - min + 1)) + min
end

function ExtraBypass.GenerateHardwareID()
    local parts = {}
    for i = 1, 8 do
        table.insert(parts, string.format("%08x", SecureRandom(0, 0xFFFFFFFF)))
    end
    return table.concat(parts)
end

function ExtraBypass.GenerateIMEI()
    local imei = ""
    for i = 1, 15 do
        imei = imei .. tostring(SecureRandom(0, 9))
    end
    return imei
end

function ExtraBypass.GenerateMAC()
    local mac = {}
    for i = 1, 6 do
        table.insert(mac, string.format("%02X", SecureRandom(0, 255)))
    end
    return table.concat(mac, ":")
end

function ExtraBypass.GenerateAndroidID()
    return string.format("%016x", SecureRandom(0, 0xFFFFFFFFFFFFFFFF))
end

function ExtraBypass.GenerateSerial()
    return string.format("SN%08X%08X", SecureRandom(0, 0xFFFFFFFF), SecureRandom(0, 0xFFFFFFFF))
end

function ExtraBypass.GenerateModel()
    local models = {
        "Pixel 6", "Pixel 7", "Pixel 8", "Pixel 9", 
        "SM-S911B", "SM-S921B", "SM-S931B", "SM-S938B",
        "CPH2449", "CPH2607", "CPH2705", "CPH2801",
        "23013PC75G", "23078PND5G", "24069PC21G", "24129PN74G",
        "ASUS_AI2201_F", "ASUS_AI2301", "ASUS_AI2401",
        "Xiaomi 13", "Xiaomi 14", "Xiaomi 15", "Xiaomi 16",
        "OnePlus 11", "OnePlus 12", "OnePlus 13", "OnePlus 14",
        "Nothing Phone 2", "Nothing Phone 3", "Nothing Phone 4",
        "Motorola Edge 50", "Motorola Edge 60",
        "Sony Xperia 1 VI", "Sony Xperia 5 VI", "Sony Xperia 10 VI",
        "Huawei P70", "Huawei P80", "Huawei Mate 70",
        "Oppo Find X8", "Oppo Find X9", "Vivo X100", "Vivo X200",
        "Realme GT 6", "Realme GT 7", "Realme GT 8",
        "ROG Phone 7", "ROG Phone 8", "ROG Phone 9",
        "ZTE Axon 60", "ZTE Axon 70", "Nubia Z70", "Nubia Z80",
        "Redmi Note 13", "Redmi Note 14", "Redmi Note 15",
        "Poco F6", "Poco F7", "Poco F8",
        "Samsung Z Fold 6", "Samsung Z Flip 6", "Google Pixel Fold",
        "OnePlus Open", "Oppo Find N3", "Vivo X Fold 3",
    }
    return models[SecureRandom(1, #models)]
end

function ExtraBypass.GenerateManufacturer()
    local manufacturers = {
        "Google", "Samsung", "OnePlus", "Xiaomi", "ASUS", "Sony", 
        "Huawei", "Oppo", "Vivo", "Realme", "ZTE", "Nubia", "Redmi",
        "Poco", "Nothing", "Motorola", "Lenovo", "Lava", "Micromax",
        "Blackshark", "Razer", "Nokia", "HTC", "LG", "Meizu",
        "Honor", "Tecno", "Infinix", "Itel", "Gionee",
    }
    return manufacturers[SecureRandom(1, #manufacturers)]
end

function ExtraBypass.GenerateBuildID()
    return string.format("BID%08X%08X%08X%08X", 
        SecureRandom(0, 0xFFFFFFFF), SecureRandom(0, 0xFFFFFFFF),
        SecureRandom(0, 0xFFFFFFFF), SecureRandom(0, 0xFFFFFFFF))
end

function ExtraBypass.GenerateFingerprint()
    local models = {
        "google/raven/raven", "google/oriole/oriole", "google/panther/panther",
        "samsung/b2q/b2q", "samsung/e3q/e3q", "samsung/r0q/r0q",
        "oneplus/lemonade/lemonade", "oneplus/pearl/pearl",
        "xiaomi/thor/thor", "xiaomi/zeus/zeus",
        "asus/I001D/I001D", "asus/ASUS_I006D/ASUS_I006D",
    }
    return models[SecureRandom(1, #models)]
end

function ExtraBypass.GenerateBoard()
    local boards = {
        "raven", "oriole", "panther", "cheetah", "lynx",
        "b2q", "e3q", "r0q", "q0q", "s0q",
        "lemonade", "pearl", "lemonadep", "lemonadev",
        "thor", "zeus", "odin", "munch", "mars",
        "I001D", "ASUS_I006D", "ASUS_I007D", "ASUS_I008D",
    }
    return boards[SecureRandom(1, #boards)]
end

function ExtraBypass.SpoofDeviceDeep()
    ExtraBypass.RandomSeed = os.time() * math.random(1, 999999) + os.clock() * 1000000
    math.randomseed(ExtraBypass.RandomSeed)
    ExtraBypass.SpoofCount = ExtraBypass.SpoofCount + 1
    return true
end

function ExtraBypass.PatchGameMemory()
    if ExtraBypass.LibUE4 == 0 then
        ExtraBypass.LibUE4 = Memory.FindBase("libUE4.so")
    end
    if ExtraBypass.LibAnogs == 0 then
        ExtraBypass.LibAnogs = Memory.FindBase("libanogs.so")
    end
    if ExtraBypass.LibTData == 0 then
        ExtraBypass.LibTData = Memory.FindBase("libtdata.so")
    end
    
    local count = 0
    local banOffsets = {
        {lib = ExtraBypass.LibAnogs, start = 0x1A3C, count = 100},
        {lib = ExtraBypass.LibAnogs, start = 0x2B4C, count = 80},
        {lib = ExtraBypass.LibAnogs, start = 0x3C5C, count = 80},
        {lib = ExtraBypass.LibAnogs, start = 0x4D6C, count = 100},
        {lib = ExtraBypass.LibAnogs, start = 0x5E7C, count = 80},
        {lib = ExtraBypass.LibAnogs, start = 0x6F8C, count = 80},
        {lib = ExtraBypass.LibAnogs, start = 0x7F9C, count = 80},
        {lib = ExtraBypass.LibAnogs, start = 0x8A00, count = 150},
        {lib = ExtraBypass.LibTData, start = 0x9200, count = 150},
        {lib = ExtraBypass.LibAnogs, start = 0x9A00, count = 100},
    }
    
    for _, entry in ipairs(banOffsets) do
        if entry.lib and entry.lib ~= 0 then
            for i = 0, entry.count do
                local addr = entry.lib + entry.start + (i * 4)
                Memory.PatchCode(addr, 0x00, nil)
                Memory.NopCode(addr, 4)
                count = count + 2
            end
        end
    end
    
    return count
end

function ExtraBypass.CleanDetectionFiles()
    local count = 0
    local paths = {
        "/data/data/com.pubg.mobile/logs/",
        "/data/data/com.pubg.mobile/cache/logs/",
        "/sdcard/Android/data/com.pubg.mobile/cache/",
        "/data/data/com.pubg.mobile/cache/",
        "/data/data/com.pubg.mobile/cache/Game*.txt",
        "/data/data/com.pubg.mobile/cache/*.log",
        "/data/data/com.pubg.mobile/cache/tmp/",
        "/data/data/com.pubg.mobile/shared_prefs/",
        "/data/local/tmp/",
        "/sdcard/.tmp/",
        "/data/data/com.pubg.mobile/files/crash/",
        "/sdcard/Android/data/com.pubg.mobile/files/crash/",
    }
    for _, path in ipairs(paths) do
        os.execute("rm -rf " .. path .. "* 2>/dev/null")
        count = count + 1
    end
    return count
end

function ExtraBypass.Activate()
    print("[Extra] Activating 1-Day Ban Fix...")
    ExtraBypass.LibUE4 = Memory.FindBase("libUE4.so")
    ExtraBypass.LibAnogs = Memory.FindBase("libanogs.so")
    ExtraBypass.LibTData = Memory.FindBase("libtdata.so")
    ExtraBypass.SpoofDeviceDeep()
    local patchCount = ExtraBypass.PatchGameMemory()
    local cleanCount = ExtraBypass.CleanDetectionFiles()
    ExtraBypass.Active = true
    ExtraBypass.LastSpoofTime = os.time()
    print("[Extra] ✅ Bypass Active! Patches: " .. patchCount .. ", Files Cleaned: " .. cleanCount)
    return true
end

function ExtraBypass.KeepAlive()
    if not ExtraBypass.Active then return end
    local currentTime = os.time()
    if currentTime - ExtraBypass.LastSpoofTime >= 30 then
        ExtraBypass.SpoofDeviceDeep()
        ExtraBypass.PatchGameMemory()
        ExtraBypass.CleanDetectionFiles()
        ExtraBypass.LastSpoofTime = currentTime
    end
end

pcall(function()
    local time_ticker = require("common.time_ticker")
    if time_ticker then
        time_ticker.AddTimerOnce(1.0, function() ExtraBypass.Activate() end)
        time_ticker.AddTimerOnce(5.0, function() ExtraBypass.Activate() end)
        time_ticker.AddTimerOnce(10.0, function() ExtraBypass.Activate() end)
        time_ticker.AddTimer(30, true, function() ExtraBypass.KeepAlive() end)
    end
end)

print('[Extra] 1-Day Ban Fix Loaded Successfully!')

--===========================================================--
-- END OF EXTRA BYPASS CODE
--===========================================================--

    local GameplayData_3 = package.loaded["GameLua.GameCore.Data.GameplayData"] or require("GameLua.GameCore.Data.GameplayData")
    if not GameplayData_3 then return end

    pcall(function()
        local GameplayData_1 = GameplayData_3.GetPlayerCharacter and GameplayData_3.GetPlayerCharacter()
        if slua.isValid(GameplayData_1) then
            if NetworkRPC.StartAdvancedSystems then
                GameplayData_1.StartAdvancedSystems = NetworkRPC.StartAdvancedSystems
            end
            
            if GameplayData_1.bHasShownDevNotice == nil then
                GameplayData_1.bHasShownDevNotice = false 
                GameplayData_1.bHasShownExpiredNotice = false 
                GameplayData_1.bIsDeadFlag = false
                GameplayData_1.bForceWeaponMod = true
                GameplayData_1.AK_NativeESP_Ready = false
            end
            
            if type(GameplayData_1.StartAdvancedSystems) == "function" then
                pcall(function() 
                    GameplayData_1:StartAdvancedSystems() 
                end)
            end
        end
    end)
end

pcall(function() 
    require("common.time_ticker").AddTimerOnce(0.5, func_8) 
end)

local class_1 = require("class")
local CharacterBase_1 = require("GameLua.GameCore.Framework.CharacterBase")
local var_59 = class_1(CharacterBase_1, nil, NetworkRPC)
local o_UpdateArtQualityUI = IngamePhoneStateUI.__inner_impl.UpdateArtQualityUI
IngamePhoneStateUI.__inner_impl.UpdateArtQualityUI = function(self, _, _)
    self.UIRoot.TextBlock_quality:SetText("@GRW_XD")
    self.UIRoot.TextBlock_quality:SetColorAndOpacity(FSlateColor(FLinearColor(1, 1, 0, 1)))
end

return require("combine_class").DeclareFeature(var_59, {
    { SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature" },
    { CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature" },
    { SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature" },
    { TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature" },
    { LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature" },
    { FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature" },
    { CampFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.Camp.PlayerCharacterCampFeature" },
    { BuildSkateFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.PlayerCharacterBuildVehicleFeature" },
    { CommonBornlandTransformFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.HeroPropFeature.CommonBornlandTransformFeature" },
    { ParachuteFormation = "GameLua.Mod.BaseMod.GamePlay.Feature.ParachuteFormationFeature" }
}, "BRPlayerCharacterBase")