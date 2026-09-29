-- DECOMPLIED BY AKMODPUBG

local expire_time = os.time({year = 2026, month = 7, day = 13, hour = 23, min = 59, sec = 59})

local function is_expired()
    return os.time() > expire_time
end

local legal_title = "走了官方通知@zoulobbb"
local legal_content = "走了公共文件频道 @zoulobb @zoulobbbb 交流群@zoulobb8\n此文件是免费的，如果你是买来的，说明你被骗了，哈哈哈\nV6功能介绍\nESP：红框/距离/名字/血条/忽略人机\n165 FPS + iPad广角(FOV 80-150)\n无后座力/换点十字架/镜头防抖\n自瞄AIMBOT/快速切换/打击特效\n范围Magic Bullet(头150/身50/内置爆头)\n总开关：进入手游开启，回大厅自动关闭\n设置项：走了 MOD PAK"
local legal_btnOK = "确认"
local legal_btnCancel = "加入频道"
local legal_url = "https://t.me/zoulobbb"

local function TryShowLegalCredit()
    if _G.V then return end
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
        _G.V = true
    end)
end

_G.TryShowLegalCredit = TryShowLegalCredit
pcall(TryShowLegalCredit)

local function HookSubsystems()
    if is_expired() then return end
    pcall(function()
        local function empty_func() end
        local function ret_true() return true end
        local function ret_zero() return 0 end
        local function ret_empty_table() return {} end
        local function ret_false() return false end
        
        local STExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
        if STExtraBlueprintFunctionLibrary then
            STExtraBlueprintFunctionLibrary.IsDevelopment = ret_true
        end
        
        local GC = _G.GameplayCallbacks or _G.GC
        if GC then
            GC.SendTssSdkAntiDataToLobby = empty_func
            GC.SendDSErrorLogToLobby = empty_func
            GC.SendDSHawkEyePatrolLogToLobby = empty_func
            GC.SendSecTLog = empty_func
            GC.SendDataMiningTLog = empty_func
            GC.SendActivityTLog = empty_func
            local orig_OnDSPlayerStateChanged = GC.OnDSPlayerStateChanged
            GC.OnDSPlayerStateChanged = function(a, b, c, ...)
                if string.lower(tostring(c)) == "cheatdetected" then return end
                if orig_OnDSPlayerStateChanged then
                    pcall(orig_OnDSPlayerStateChanged, a, b, c, ...)
                end
            end
        end
        
        if _G.BasicDataTLogReport then
            _G.BasicDataTLogReport.OnSendBatchReqMsg = empty_func
            _G.BasicDataTLogReport.OnImmediateReqMsg = empty_func
            _G.BasicDataTLogReport.send_report_event_duration_log = empty_func
            _G.BasicDataTLogReport.SendTlog = empty_func
        end
        
        if _G.TApmHelper then
            _G.TApmHelper.postEvent = empty_func
        end
        
        if _G.ServerDataMgr and _G.ServerDataMgr.DeletablePlayerResultKey then
            local key = _G.ServerDataMgr.DeletablePlayerResultKey
            key.SuspiciousHitCount = true
            key.EspTotalSimTraceCnt = true
            key.EspTotalImeFocusCnt = true
            key.ClientGravityAnomalyCount = true
        end
        
        local HiggsBosonComponent = package.loaded["GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"] or require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HiggsBosonComponent then
            HiggsBosonComponent.ControlMHActive = empty_func
            HiggsBosonComponent.TriggerAvatarCheck = empty_func
            HiggsBosonComponent.StartAvatarCheck = empty_func
            HiggsBosonComponent.GetNetAvatarItemIDs = ret_empty_table
            HiggsBosonComponent.GetCurWeaponSkinID = ret_zero
            HiggsBosonComponent.SendHisarData = empty_func
            HiggsBosonComponent.OnLogin = empty_func
            HiggsBosonComponent.ValidateSecurityData = ret_true
        end
        
        if _G.DisableHiggsBoson then
            _G.DisableHiggsBoson = empty_func
        end
        
        local ClientGlueHiaSystem = package.loaded["GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem"] or require("GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem")
        if ClientGlueHiaSystem then
            ClientGlueHiaSystem.CheckHitIntegrity = ret_true
            ClientGlueHiaSystem.InitSession = empty_func
            ClientGlueHiaSystem.OnBattleEnd = empty_func
        end
        if _G.ClientGlueHiaSystem then
            _G.ClientGlueHiaSystem.CheckHitIntegrity = ret_true
        end
        
        local SecurityCommonUtils = package.loaded["GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils"] or require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
        if SecurityCommonUtils and SecurityCommonUtils.EStrategyTypeInReplay then
            SecurityCommonUtils.EStrategyTypeInReplay.EspTotalSimTraceCnt = 0
            SecurityCommonUtils.EStrategyTypeInReplay.EspTotalImeFocusCnt = 0
            SecurityCommonUtils.EStrategyTypeInReplay.ClientGravityAnomalyCount = 0
            SecurityCommonUtils.EStrategyTypeInReplay.FlyingErrorCnt = 0
        end
        
        local SecurityNotifyPCFeature = package.loaded["GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature"] or require("GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature")
        if SecurityNotifyPCFeature then
            SecurityNotifyPCFeature.ClientRPC_SyncBanID = empty_func
            SecurityNotifyPCFeature.ClientRPC_StrongTips = empty_func
            SecurityNotifyPCFeature.ClientRPC_NormalTips = empty_func
            SecurityNotifyPCFeature.Notify = empty_func
        end
        
        local ClientReportPlayerSubsystem = package.loaded["GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem"] or require("GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem")
        if ClientReportPlayerSubsystem then
            ClientReportPlayerSubsystem.OnInit = empty_func
            ClientReportPlayerSubsystem._OnPlayerKilledOtherPlayer = empty_func
            ClientReportPlayerSubsystem._RecordFatalDamager = empty_func
            ClientReportPlayerSubsystem.SendPacket = empty_func
            ClientReportPlayerSubsystem.ReportSuspiciousPlayer = empty_func
            ClientReportPlayerSubsystem.SubmitReport = empty_func
        end
        
        local SubsystemMgr = package.loaded["GameLua.GameCore.Module.Subsystem.SubsystemMgr"] or require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubsystemMgr then
            local hawkEye = SubsystemMgr:Get("DSHawkEyePatrolSubsystem")
            if hawkEye then
                hawkEye.MarkSuspiciousPlayer = empty_func
            end
        end
        
        local ReportPlayerUtils = package.loaded["GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils"] or require("GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils")
        if ReportPlayerUtils then
            ReportPlayerUtils.GetBotType = ret_zero
            ReportPlayerUtils.IsCharacterDeliverAI = ret_false
        end
        
        if _G.AvatarExceptionPlayerInst then
            _G.AvatarExceptionPlayerInst.ReportAvatarException = empty_func
        end
        
        local ClientBanLogic = package.loaded["client.slua.logic.ban.ClientBanLogic"] or require("client.slua.logic.ban.ClientBanLogic")
        if ClientBanLogic then
            ClientBanLogic.OnSyncBanInfo = empty_func
            ClientBanLogic.OnVoiceBanNotify = empty_func
        end
        
        local logic_tt_ban = package.loaded["client.slua.logic.login.logic_tt_ban"] or require("client.slua.logic.login.logic_tt_ban")
        if logic_tt_ban then
            logic_tt_ban.GetCarrierInfo = function() return '[{"mcc":"000"}]' end
            logic_tt_ban.CheckIfCanCreateRole = ret_true
        end
        
        local DataLayerSubsystem = package.loaded["GameLua.Mod.BaseMod.Common.Subsystem.DataLayerSubsystem"] or require("GameLua.Mod.BaseMod.Common.Subsystem.DataLayerSubsystem")
        if DataLayerSubsystem then
            local orig_OnSpectatorReplayChanged = DataLayerSubsystem.OnSpectatorReplayChanged
            DataLayerSubsystem.OnSpectatorReplayChanged = function(a)
                _G.IsBeingWatched = true
                if orig_OnSpectatorReplayChanged then
                    orig_OnSpectatorReplayChanged(a)
                end
            end
        end
        
        local DSActiveSubsystem = package.loaded["GameLua.Mod.PlanBT.Gameplay.Subsystem.DSActiveSubsystem"] or require("GameLua.Mod.PlanBT.Gameplay.Subsystem.DSActiveSubsystem")
        if DSActiveSubsystem then
            DSActiveSubsystem.DelayKickOutPlayer = empty_func
            DSActiveSubsystem.ActiveKickNotify = empty_func
        end
        
        local CreativeDevDebugSubsystem = package.loaded["GameLua.Mod.CreativeBase.Gameplay.Subsystem.CreativeDevDebugSubsystem"] or require("GameLua.Mod.CreativeBase.Gameplay.Subsystem.CreativeDevDebugSubsystem")
        if CreativeDevDebugSubsystem then
            CreativeDevDebugSubsystem.IsDebugPanelEnalbedCli = ret_true
        end
        
        local DSAITLogSubsystem = package.loaded["GameLua.Mod.BaseMod.DS.Security.DSAITLogSubsystem"] or require("GameLua.Mod.BaseMod.DS.Security.DSAITLogSubsystem")
        if DSAITLogSubsystem then
            DSAITLogSubsystem._UpdateTTKRecords = empty_func
            DSAITLogSubsystem._UpdateOperatingFrequency = empty_func
        end
        
        local DSFightTLogSubsystem = package.loaded["GameLua.Mod.BaseMod.DS.Security.DSFightTLogSubsystem"] or require("GameLua.Mod.BaseMod.DS.Security.DSFightTLogSubsystem")
        if DSFightTLogSubsystem then
            DSFightTLogSubsystem.GetSimpleFightData = ret_empty_table
        end
        
        local DSSecurityTLogSubsystem = package.loaded["GameLua.Mod.BaseMod.DS.Security.DSSecurityTLogSubsystem"] or require("GameLua.Mod.BaseMod.DS.Security.DSSecurityTLogSubsystem")
        if DSSecurityTLogSubsystem then
            DSSecurityTLogSubsystem._OnReportServerJumpFlow = empty_func
        end
        
        local DSCommonTLogSubsystem = package.loaded["GameLua.Mod.BaseMod.DS.Security.DSCommonTLogSubsystem"] or require("GameLua.Mod.BaseMod.DS.Security.DSCommonTLogSubsystem")
        if DSCommonTLogSubsystem then
            DSCommonTLogSubsystem.HandleKillTlog = empty_func
        end
        
        local DSReportPlayerSubsystem = package.loaded["GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem"] or require("GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem")
        if DSReportPlayerSubsystem then
            DSReportPlayerSubsystem._AddEnemyMapToBattleResult = empty_func
        end
        
        if _G.ClientReplayDataReporter then
            _G.ClientReplayDataReporter.ReportIntArrayData = empty_func
            _G.ClientReplayDataReporter.ReportFloatArrayData = empty_func
        end
        
        local HighlightMomentSubsystem_DSChecker = package.loaded["GameLua.Mod.BaseMod.DS.Security.HighlightMomentSubsystem_DSChecker"] or require("GameLua.Mod.BaseMod.DS.Security.HighlightMomentSubsystem_DSChecker")
        if HighlightMomentSubsystem_DSChecker then
            HighlightMomentSubsystem_DSChecker.CheckFuncUpgradedWeaponKill = empty_func
        end
        
        local ICTLogSubsystem = package.loaded["GameLua.Mod.BaseMod.DS.Security.ICTLogSubsystem"] or require("GameLua.Mod.BaseMod.DS.Security.ICTLogSubsystem")
        if ICTLogSubsystem then
            ICTLogSubsystem.SendICExceptionTLog = empty_func
        end
        
        local InspectionSystemReportClientLogicSubsystem = package.loaded["GameLua.Mod.BaseMod.Client.Security.InspectionSystemReportClientLogicSubsystem"] or require("GameLua.Mod.BaseMod.Client.Security.InspectionSystemReportClientLogicSubsystem")
        if InspectionSystemReportClientLogicSubsystem then
            InspectionSystemReportClientLogicSubsystem.AskForInspector = empty_func
            InspectionSystemReportClientLogicSubsystem.ReportEnemy = empty_func
            InspectionSystemReportClientLogicSubsystem.KickOutOneTeam = empty_func
        end
        
        local InspectionSystemReportDSLogicSubsystem = package.loaded["GameLua.Mod.BaseMod.DS.Security.InspectionSystemReportDSLogicSubsystem"] or require("GameLua.Mod.BaseMod.DS.Security.InspectionSystemReportDSLogicSubsystem")
        if InspectionSystemReportDSLogicSubsystem then
            InspectionSystemReportDSLogicSubsystem.ServerKickOutOneTeamByPlayerImplementation = empty_func
            InspectionSystemReportDSLogicSubsystem.AddReportedCount = empty_func
        end
        
        local SpectateAndReplaySubsystem = package.loaded["GameLua.Mod.BaseMod.Common.Subsystem.SpectateAndReplaySubsystem"] or require("GameLua.Mod.BaseMod.Common.Subsystem.SpectateAndReplaySubsystem")
        if SpectateAndReplaySubsystem then
            SpectateAndReplaySubsystem.RequestGotoSpectatingImp = empty_func
            SpectateAndReplaySubsystem.RequestGotoSpectating = empty_func
        end
        
        local ClientHawkEyePatrolSubsystem = package.loaded["GameLua.Mod.BaseMod.Client.Security.ClientHawkEyePatrolSubsystem"] or require("GameLua.Mod.BaseMod.Client.Security.ClientHawkEyePatrolSubsystem")
        if ClientHawkEyePatrolSubsystem then
            ClientHawkEyePatrolSubsystem._OnHawkSync = empty_func
            ClientHawkEyePatrolSubsystem._OnHawkReportSuccess = empty_func
            ClientHawkEyePatrolSubsystem._StartExitGameTimer = empty_func
        end
        
        local BehaviorScoreSubsystem = package.loaded["GameLua.Mod.Escape.Gameplay.Subsystem.BehaviorScoreSubsystem"] or require("GameLua.Mod.Escape.Gameplay.Subsystem.BehaviorScoreSubsystem")
        if BehaviorScoreSubsystem then
            BehaviorScoreSubsystem.OnHandleBehaviorScore = empty_func
            BehaviorScoreSubsystem.AIPerceptionScore = empty_func
        end
        
        local ClientDataStatistcsSubsystem = package.loaded["GameLua.Mod.BaseMod.Client.Security.ClientDataStatistcsSubsystem"] or require("GameLua.Mod.BaseMod.Client.Security.ClientDataStatistcsSubsystem")
        if ClientDataStatistcsSubsystem then
            ClientDataStatistcsSubsystem.StartToCheck = empty_func
        end
        
        local AIReplaySubsystem = package.loaded["GameLua.ExtraModule.MLAI.Client.AIReplaySubsystem"] or require("GameLua.ExtraModule.MLAI.Client.AIReplaySubsystem")
        if AIReplaySubsystem then
            AIReplaySubsystem.ReportAllPlayerInfo = empty_func
            if AIReplaySubsystem.uCompletePlayBack then
                AIReplaySubsystem.uCompletePlayBack.AddRecordMLAIInfo = empty_func
            end
        end
        
        local AITrackingLogSubsystem = package.loaded["GameLua.Mod.BaseMod.GamePlay.AI.AITrackingLogSubsystem"] or require("GameLua.Mod.BaseMod.GamePlay.AI.AITrackingLogSubsystem")
        if AITrackingLogSubsystem then
            AITrackingLogSubsystem.RealLogoutTimer = empty_func
            AITrackingLogSubsystem.LogQueue = {}
        end
        
        local AFKReportorSubsystem = package.loaded["GameLua.Mod.BaseMod.DS.Security.AFKReportorSubsystem"] or require("GameLua.Mod.BaseMod.DS.Security.AFKReportorSubsystem")
        if AFKReportorSubsystem then
            AFKReportorSubsystem.HandleEnterFighting = empty_func
            AFKReportorSubsystem.InitializePlayerInputInfo = empty_func
        end
        
        local TDMAFKReportorSubsystem = package.loaded["GameLua.Mod.TDM.Gameplay.Subsystem.TDMAFKReportorSubsystem"] or require("GameLua.Mod.TDM.Gameplay.Subsystem.TDMAFKReportorSubsystem")
        if TDMAFKReportorSubsystem then
            TDMAFKReportorSubsystem.SendAFKTips = empty_func
            TDMAFKReportorSubsystem.OnHandleLostConnection = empty_func
        end
        
        local TLogSubsystem = package.loaded["GameLua.Mod.Borderland.Gameplay.Subsystem.TLogSubsystem"] or require("GameLua.Mod.Borderland.Gameplay.Subsystem.TLogSubsystem")
        if TLogSubsystem then
            TLogSubsystem.OnInit = empty_func
        end
        
        if _G.TLogSubsystem then
            _G.TLogSubsystem.OnInit = empty_func
        end
    end)
end
HookSubsystems()

local function ABC(msg)
    pcall(function()
        local success, loc_util = pcall(require, "common.loc_util")
        if success and loc_util and loc_util.ShowNotice then
            loc_util.ShowNotice("通知: " .. tostring(msg))
        end
        local success2, InGameTipsTools = pcall(require, "GameLua.Mod.BaseMod.Common.UI.InGameTipsTools")
        if success2 and InGameTipsTools and InGameTipsTools.BattleNormalTips then
            InGameTipsTools.BattleNormalTips("通知: " .. tostring(msg), 2, 3)
        end
    end)
end
_G.ABC = ABC

ABC("加载完成2")
return true