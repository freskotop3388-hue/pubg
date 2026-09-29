-- DECOMPLIED BY AKMODPUBG

local require = require
local class = require("class")
local CharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local combine_class = require("combine_class")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")
local GameplayStatics = import("GameplayStatics")
local KismetMathLibrary = import("KismetMathLibrary")

local RPCs = {
    ServerRPC = {
        ServerRPC_NearDeathGiveupRescue = { Reliable = true, Params = {} },
        ServerRPC_CarryDeadBox = { Reliable = true, Params = { UEnums.EPropertyClass.Object } },
        RPC_Server_GmPlayAction = { Reliable = true, Params = { UEnums.EPropertyClass.Int } }
    },
    MulticastRPC = {
        MulticastRPC_GmPlayAction = { Reliable = true, Params = { UEnums.EPropertyClass.Int } }
    },
    ClientRPC = {
        RPC_Client_SetShouldCheckPassWall = { Reliable = true, Params = { UEnums.EPropertyClass.Bool } }
    }
}

-- Thời gian hết hạn của Script: 27/06/2026
local ExpireTime = os.time({year = 2026, month = 6, day = 27, hour = 0, min = 0, sec = 0})

local function IsExpired()
    return os.time() > ExpireTime
end

local isWelcomed = false

local function ShowWelcomeMessage()
    if isWelcomed then return end
    isWelcomed = true
    pcall(function()
        local MsgBox = require("client.slua.logic.common.logic_common_msg_box")
        if IsExpired() then
            MsgBox.Show(4, "تنبيه: انتهت الصلاحية", "لقد انتهت صلاحية هذا السكربت.\nالرجاء التواصل مع المطور\nhttps://t.me/ArabHacker67.", function() end)
            return
        end
        
        local WebviewSDK = require("client.slua.logic.url.logic_webview_sdk")
        local UIUtils = require("GameLua.Util.UIUtils")
        
        local function OpenTelegram()
            if WebviewSDK then
                WebviewSDK.OpenURL("https://t.me/ArabHacker67")
            end
            if UIUtils and UIUtils.ShowNotice then
                UIUtils.ShowNotice("Official Channel: TG@ArabHacker67")
            end
        end
        
        MsgBox.Show(4, "Welcome", "THIS FILE WAS CREATED BY TG@ArabHacker67\nTHIS FILE IS FREE.", OpenTelegram)
    end)
end

local ESPConfig = {
    Colors = {
        RED = {R = 255, G = 40, B = 40, A = 255},
        YELLOW = {R = 0, G = 255, B = 120, A = 255},
        GREEN = {R = 255, G = 220, B = 0, A = 255}
    },
    ESP = {
        MaxDist = 300,
        TextScale = 1.0,
        UpdateRate = 0.1
    }
}

local HUDInstance = nil

local function DrawESP()
    if IsExpired() then return end
    pcall(function()
        local localPlayer = GameplayData.GetPlayerCharacter()
        if not slua.isValid(localPlayer) then return end

        if not slua.isValid(HUDInstance) then
            local pc = slua_GameFrontendHUD:GetPlayerController()
            if not pc then
                pc = GameplayStatics.GetPlayerController(slua_GameFrontendHUD:GetWorld(), 0)
            end
            if slua.isValid(pc) then
                HUDInstance = pc:GetHUD()
            end
        end

        if not slua.isValid(HUDInstance) then return end
        
        local myLocation = localPlayer:K2_GetActorLocation()
        local allPawns = Game:GetAllPlayerPawns() or {}

        for _, enemy in pairs(allPawns) do
            if slua.isValid(enemy) and enemy ~= localPlayer then
                local enemyTeam = enemy.TeamID or 0
                local myTeam = localPlayer.TeamID or 0
                
                if enemyTeam ~= myTeam then
                    local health = enemy.Health or 0
                    if health > 0 then
                        local enemyLocation = enemy:K2_GetActorLocation()
                        local distance = math.floor(FVector.Dist(myLocation, enemyLocation) / 100)
                        
                        if distance < ESPConfig.ESP.MaxDist then
                            health = math.floor(health)
                            local colorConfig = ESPConfig.Colors.GREEN
                            
                            if health <= 30 then
                                colorConfig = ESPConfig.Colors.RED
                            elseif health <= 70 then
                                colorConfig = ESPConfig.Colors.YELLOW
                            end
                            
                            local textFormat = string.format("✯ %s ✯\n ● %d%% | ➼ %dm", enemy.PlayerName or "Enemy", health, distance)
                            HUDInstance:AddDebugText(
                                textFormat, enemy, ESPConfig.ESP.UpdateRate, 
                                {X = 0, Y = 0, Z = 200}, {X = 0, Y = 0, Z = 200}, 
                                colorConfig, true, false, true, nil, ESPConfig.ESP.TextScale, true
                            )
                        end
                    end
                end
            end
        end
    end)
end

local function InitESPTimer()
    if _G._STICKMAN_TMR or IsExpired() then return end
    _G._STICKMAN_TMR = true
    
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not pc then
        pc = GameplayStatics.GetPlayerController(slua_GameFrontendHUD:GetWorld(), 0)
    end
    
    if slua.isValid(pc) then
        pc:AddGameTimer(0.1, true, DrawESP)
    end
end

_G._AimbotCurrentPC = nil

local function ModifyWeaponStats()
    if IsExpired() then return end
    pcall(function()
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        
        local safetyPlayer = pc:GetPlayerCharacterSafety()
        if not slua.isValid(safetyPlayer) then return end
        
        local weaponMgr = safetyPlayer.WeaponManagerComponent
        if not slua.isValid(weaponMgr) then return end
        
        local currentWeapon = weaponMgr.CurrentWeaponReplicated
        if not slua.isValid(currentWeapon) then return end
        
        local shootEntity = currentWeapon.ShootWeaponEntityComp
        if slua.isValid(shootEntity) and shootEntity == _G._AimbotCurrentPC then return end
        
        _G._AimbotCurrentPC = shootEntity
        
        shootEntity.GameDeviationFactor = 0.5
        shootEntity.WeaponAimInTime = 20
        shootEntity.SwitchFromIdleToBackpackTime = 0.15
        shootEntity.SwitchFromBackpackToIdleTime = 0.15
        shootEntity.ShotGunHorizontalSpread = 0.0
        shootEntity.ShotGunVerticalSpread = 0.0
        shootEntity.RecoilKick = 0.2
        shootEntity.RecoilKickADS = 0.2
        shootEntity.AnimationKick = 0.2
        shootEntity.AccessoriesVRecoilFactor = 0.6
        shootEntity.AccessoriesHRecoilFactor = 0.6
        shootEntity.GameDeviationFactor = 0.3
        
        if shootEntity.RecoilInfo then
            shootEntity.RecoilInfo.VerticalRecoilMin = 0.2
            shootEntity.RecoilInfo.VerticalRecoilMax = 0.2
            shootEntity.RecoilInfo.RecoilSpeedVertical = 0.2
            shootEntity.RecoilInfo.RecoilSpeedHorizontal = 0.15
            shootEntity.RecoilInfo.VerticalRecoveryMax = 0.2
        end
        
        shootEntity.RecoilModifierStand = 0.2
        shootEntity.RecoilModifierCrouch = 0.2
        shootEntity.RecoilModifierProne = 0.2
        
        if shootEntity.AutoAimingConfig then
            for _, rangeType in ipairs({"OuterRange", "InnerRange"}) do
                local config = shootEntity.AutoAimingConfig[rangeType]
                if config then
                    config.Speed = 8
                    config.RangeRate = 2
                    config.SpeedRate = 6
                    config.RangeRateSight = 4
                    config.SpeedRateSight = 4
                    config.CrouchRate = 4
                    config.ProneRate = 4
                    config.DyingRate = 0
                    config.adsorbMaxRange = 200
                    config.adsorbMinRange = 20
                    config.adsorbMinAttenuationDis = 100
                    config.adsorbMaxAttenuationDis = 8000
                    config.adsorbActiveMinRange = 20
                end
            end
        end
        
        pcall(function()
            local autoAimComp = pc.BP_AutoAimingComponent_C or pc.BP_AutoAimingComponent or pc.AutoAimingComponent
            if slua.isValid(autoAimComp) and autoAimComp.Bones then
                pcall(function() autoAimComp.Bones[0] = "head" end)
                pcall(function() autoAimComp.Bones[1] = "head" end)
                pcall(function() autoAimComp.Bones[2] = "head" end)
                pcall(function() autoAimComp.Bones:Set(0, "head") end)
                pcall(function() autoAimComp.Bones:Set(1, "head") end)
                pcall(function() autoAimComp.Bones:Set(2, "head") end)
            end
        end)
    end)
end

local function StartAimbotTimer()
    if IsExpired() then return end
    pcall(function()
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        
        if pc == _G._AimbotCurrentPC then return end
        _G._AimbotCurrentPC = pc
        
        if pc.AddGameTimer then
            pc:AddGameTimer(0.1, true, function()
                if not slua.isValid(_G._AimbotCurrentPC) then
                    _G._AimbotCurrentPC = nil
                    return
                end
                ModifyWeaponStats()
            end)
        end
    end)
end

local function InitAimbotRoutine()
    StartAimbotTimer()
    pcall(function()
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if slua.isValid(pc) and pc.AddGameTimer then
            pc:AddGameTimer(2.0, true, function()
                if not slua.isValid(_G._AimbotCurrentPC) then
                    _G._AimbotCurrentPC = nil
                    if not IsExpired() then
                        StartAimbotTimer()
                    end
                end
            end)
        end
    end)
end

local function ApplyMagicHead(localPlayer)
    if IsExpired() or not Client then return end
    pcall(function()
        local allPawns = Game:GetAllPlayerPawns() or {}
        for _, enemy in pairs(allPawns) do
            if slua.isValid(enemy) and enemy ~= localPlayer then
                local enemyTeam = enemy.TeamID or 0
                local myTeam = localPlayer.TeamID or 0
                
                if enemyTeam ~= myTeam then
                    local mesh = enemy.Mesh
                    if slua.isValid(mesh) then
                        local physAsset = mesh.PhysicsAssetOverride
                        if not slua.isValid(physAsset) and slua.isValid(mesh.SkeletalMesh) then
                            physAsset = mesh.SkeletalMesh.PhysicsAsset
                        end
                        
                        if slua.isValid(physAsset) and physAsset.SkeletalBodySetups then
                            _G._MBonesHead = _G._MBonesHead or {}
                            local assetName = physAsset.GetName and physAsset:GetName() or tostring(physAsset)
                            
                            if not _G._MBonesHead[assetName] then
                                local targetBones = { head = 300 }
                                
                                for i = 1, 80 do
                                    local bodySetup = nil
                                    pcall(function()
                                        if type(physAsset.SkeletalBodySetups.Get) == "function" then
                                            bodySetup = physAsset.SkeletalBodySetups:Get(i - 1)
                                        else
                                            bodySetup = physAsset.SkeletalBodySetups[i]
                                        end
                                    end)
                                    
                                    if not bodySetup or not slua.isValid(bodySetup) then break end
                                    
                                    local boneName = string.lower(tostring(bodySetup.BoneName))
                                    local scaleVal = nil
                                    
                                    for k, v in pairs(targetBones) do
                                        if string.find(boneName, k) then
                                            scaleVal = v
                                            break
                                        end
                                    end
                                    
                                    if scaleVal then
                                        local multiplier = 1.0 + (scaleVal / 100.0)
                                        local aggGeom = bodySetup.AggGeom
                                        
                                        pcall(function()
                                            local boxElems = (aggGeom and aggGeom.BoxElems) or bodySetup.BoxElems
                                            if boxElems then
                                                local elem = type(boxElems.Get) == "function" and boxElems:Get(0) or boxElems[1]
                                                if elem then
                                                    elem.X = (elem.X or 30) * multiplier
                                                    elem.Y = (elem.Y or 30) * multiplier
                                                    elem.Z = (elem.Z or 60) * multiplier
                                                    if type(boxElems.Set) == "function" then
                                                        boxElems:Set(0, elem)
                                                    else
                                                        boxElems[1] = elem
                                                    end
                                                    if aggGeom then bodySetup.AggGeom = aggGeom else bodySetup.BoxElems = boxElems end
                                                end
                                            end
                                        end)
                                        
                                        pcall(function()
                                            local sphylElems = (aggGeom and aggGeom.SphylElems) or bodySetup.SphylElems
                                            if sphylElems then
                                                local elem = type(sphylElems.Get) == "function" and sphylElems:Get(0) or sphylElems[1]
                                                if elem then
                                                    if elem.Radius then elem.Radius = elem.Radius * multiplier end
                                                    if elem.Length then elem.Length = elem.Length * multiplier end
                                                    if type(sphylElems.Set) == "function" then
                                                        sphylElems:Set(0, elem)
                                                    else
                                                        sphylElems[1] = elem
                                                    end
                                                    if aggGeom then bodySetup.AggGeom = aggGeom else bodySetup.SphylElems = sphylElems end
                                                end
                                            end
                                        end)
                                        
                                        pcall(function()
                                            local sphereElems = (aggGeom and aggGeom.SphereElems) or bodySetup.SphereElems
                                            if sphereElems then
                                                local elem = type(sphereElems.Get) == "function" and sphereElems:Get(0) or sphereElems[1]
                                                if elem then
                                                    if elem.Radius then
                                                        elem.Radius = elem.Radius * multiplier
                                                        if type(sphereElems.Set) == "function" then
                                                            sphereElems:Set(0, elem)
                                                        else
                                                            sphereElems[1] = elem
                                                        end
                                                        if aggGeom then bodySetup.AggGeom = aggGeom else bodySetup.SphereElems = sphereElems end
                                                    end
                                                end
                                            end
                                        end)
                                    end
                                end
                                
                                _G._MBonesHead[assetName] = true
                                if mesh.RecreatePhysicsState then mesh:RecreatePhysicsState() end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function InitMagicHeadTimer()
    if _G._MAGICHEAD_TMR or IsExpired() then return end
    _G._MAGICHEAD_TMR = true
    
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not pc then
        pc = GameplayStatics.GetPlayerController(slua_GameFrontendHUD:GetWorld(), 0)
    end
    
    if slua.isValid(pc) then
        pc:AddGameTimer(3.0, true, function()
            local localPlayer = GameplayData.GetPlayerCharacter()
            if slua.isValid(localPlayer) then
                ApplyMagicHead(localPlayer)
            end
        end)
    end
end

local ModCharacterClass = {}

function ModCharacterClass:postConstruct()
    CharacterBase._PostConstruct(self)
    Protection.Init()
end

function ModCharacterClass:receiveBeginPlay()
    CharacterBase.ReceiveBeginPlay(self)
    ShowWelcomeMessage()
    self:SetActorTickEnabled(true)
    InitESPTimer()
    InitAimbotRoutine()
    InitMagicHeadTimer()
end

function ModCharacterClass:receiveTick(deltaTime)
    -- Tick logic rỗng
end

function ModCharacterClass:receiveEndPlay(EndPlayReason)
    CharacterBase.ReceiveEndPlay(self, EndPlayReason)
    _G._STICKMAN_TMR = false
    _G._AimbotCurrentPC = nil
    _G._MAGICHEAD_TMR = false
end

local CombinedClass = combine_class(class, nil, {
    ServerRPC = RPCs.ServerRPC,
    ClientRPC = RPCs.ClientRPC,
    MulticastRPC = RPCs.MulticastRPC,
    _PostConstruct = ModCharacterClass.postConstruct,
    ReceiveBeginPlay = ModCharacterClass.receiveBeginPlay,
    ReceiveTick = ModCharacterClass.receiveTick,
    ReceiveEndPlay = ModCharacterClass.receiveEndPlay
})

return combine_class.DeclareFeature(CombinedClass, {
    {SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature"},
    {CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature"},
    {SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature"},
    {TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature"},
    {LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature"},
    {FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature"},
    {CampFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.Camp.PlayerCharacterCampFeature"},
    {BuildSkateFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.PlayerCharacterBuildVehicleFeature"},
    {CommonBornlandTransformFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.HeroPropFeature.CommonBornlandTransformFeature"}
}, "BRPlayerCharacterBase")
