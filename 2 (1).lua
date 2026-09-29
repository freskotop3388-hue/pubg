-- DECOMPLIED BY @nanamod96 + @alex_vietnam

local Class = require("class")
local CharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local CombineClass = require("combine_class")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")
local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local logic_common_legal_msg = require("client.slua.logic.common.logic_common_legal_msg")

pcall(function()
  require("GameLua.Mod.TPlan.Client.Backpack.BackpackPanelUI")
end)

local ModConfig = {
  WALLHACK = true,
  AIMBOT = true,
  IPAD_VIEW = true,
  ENEMY_COUNT = true,
  IPAD_VALUE = 107,
  AIM_SPEED = 3,
  AIM_RANGE = 2,
  AIM_SPEED_RATE = 2.5,
  AIM_RANGE_SCOPE = 3,
  AIM_SPEED_SCOPE = 2,
  AIM_CROUNCH = 1,
  AIM_PRONE = 1,
  AIM_DYING_RATE = 1.5
}

local ExpireTime = os.time({year = 2026, month = 6, day = 11, hour = 17, min = 29, sec = 59})

local function IsExpired()
  return os.time(os.date("!*t")) > ExpireTime
end

local lastPopTime = 0
local showedPop = false

local function ShowExpireWarning()
  local currentTime = os.clock()
  if currentTime - lastPopTime < 5 then return end
  lastPopTime = currentTime
  pcall(function()
    logic_common_legal_msg.ShowOnePopUI({
      tabType = 999,
      title = "LUA MOD RockDrake",
      content = "WARNING !!!\n\nSTATUS : EXPIRED\n\nContact @Lion_ZG",
      btnOKText = "",
      btnCancleText = ""
    })
  end)
end

local function ShowWelcome()
  if showedPop then return end
  showedPop = true
  
  local timeDiff = math.max(0, ExpireTime - os.time())
  local d = math.floor(timeDiff / 86400)
  local h = math.floor((timeDiff % 86400) / 3600)
  local m = math.floor((timeDiff % 3600) / 60)
  local s = timeDiff % 60
  
  local timeStr = string.format("%02dd %02dh %02dm %02ds", d, h, m, s)
  
  pcall(function()
    logic_common_legal_msg.ShowOnePopUI({
      tabType = 999,
      title = "PAK MOD RockDrake FREE TRIAL",
      content = "✅ MOD ACTIVATED!\n\nIPAD VIEW | WALLHACK\nENEMY COUNT\n\n⏳ VALID FOR: " .. timeStr .. "\n\n\nDEV: @Lion_ZG\nTELEGRAM: https://t.me/rockdrakepubg",
      btnOKText = "OK",
      btnCancleText = "Telegram",
      refuseFunc = function()
        pcall(function()
          import("KismetSystemLibrary"):LaunchURL("https://t.me/rockdrakepubg")
        end)
      end
    })
  end)
end

local function IsAlive(actor)
  if not slua.isValid(actor) then return false end
  if actor.HealthStatus then
    return SecurityCommonUtils.IsHealthStatusAlive(actor.HealthStatus)
  end
  if actor.IsAlive then
    return actor:IsAlive()
  end
  if actor.GetHealth then
    local health = actor:GetHealth() or 0
    return health > 0 or health
  end
  return false
end

local function IsValidActor(actor)
  return slua.isValid(actor)
end

local wallhackActive = false

local function ApplyWallhack(player, enemy, hud, apply, isEnemy)
  if not wallhackActive then return end
  if not IsValidActor(enemy) then return end
  
  local meshes = {}
  pcall(function()
    if IsValidActor(enemy.Mesh) then
      table.insert(meshes, enemy.Mesh)
    end
    local skelCompClass = import("SkeletalMeshComponent")
    if skelCompClass then
      local comps = enemy:GetComponentsByClass(skelCompClass)
      if comps then
        local count = type(comps.Num) == "function" and comps:Num() or #comps
        for i = 1, count do
          local comp = type(comps.Get) == "function" and comps:Get(i - 1) or comps[i]
          if IsValidActor(comp) and comp ~= enemy.Mesh then
            table.insert(meshes, comp)
          end
        end
      end
    end
  end)
  
  local doApply = apply or apply == nil and isEnemy
  if doApply then
    local blendMode = apply and 2 or 1
    pcall(function()
      for _, mesh in ipairs(meshes) do
        if IsValidActor(mesh) then
          local succ1, mat = pcall(function() return mesh:GetMaterial(0) end)
          if succ1 and IsValidActor(mat) then
            local succ2, baseMat = pcall(function() return mat:GetBaseMaterial() end)
            if succ2 and IsValidActor(baseMat) then
              if baseMat.bDisableDepthTest ~= apply then
                baseMat.bDisableDepthTest = apply
              end
              if baseMat.BlendMode ~= blendMode then
                baseMat.BlendMode = blendMode
              end
            end
          end
        end
      end
    end)
    
    pcall(function()
      for _, mesh in ipairs(meshes) do
        if IsValidActor(mesh) then
          mesh.UseScopeDistanceCulling = false
          mesh.PrimitiveShadingStrategy = 1
          mesh.ShadingRate = 6
        end
      end
      
      local color
      if apply then
        local isVisible = false
        if IsValidActor(hud) and IsValidActor(enemy) then
          if type(hud.LineOfSightTo) == "function" then
            pcall(function() isVisible = hud:LineOfSightTo(enemy) end)
          end
        end
        local redColor = {R=25.0, G=0.0, B=25.0, A=1.0, r=25.0, g=0.0, b=25.0, a=1.0}
        local greenColor = {R=0.0, G=25.0, B=25.0, A=1.0, r=0.0, g=25.0, b=25.0, a=1.0}
        color = (apply and isVisible) and greenColor or redColor
      else
        color = {R=50.0, G=50.0, B=50.0, A=1.0, r=50.0, g=50.0, b=50.0, a=1.0}
      end
      
      local scaleColor = {R=3.0, G=3.0, B=0.0, A=0.0, r=3.0, g=3.0, b=0.0, a=0.0}
      enemy.WH_MIDs = enemy.WH_MIDs or {}
      local colorChanged = enemy.WH_LastColorR ~= color.R
      
      for _, mesh in ipairs(meshes) do
        if IsValidActor(mesh) then
          local meshStr = tostring(mesh)
          enemy.WH_MIDs[meshStr] = enemy.WH_MIDs[meshStr] or {}
          for i = 0, 10 do
            local succ, mat = pcall(function() return mesh:GetMaterial(i) end)
            if succ and IsValidActor(mat) then
              local created = false
              local changed = false
              local mid = enemy.WH_MIDs[meshStr][i]
              if not IsValidActor(mid) then
                local s, newMid = pcall(function() return mesh:CreateAndSetMaterialInstanceDynamic(i) end)
                if s and IsValidActor(newMid) then
                  enemy.WH_MIDs[meshStr][i] = newMid
                  mid = newMid
                  created = true
                  changed = true
                end
              elseif mat ~= mid then
                pcall(function() mesh:SetMaterial(i, mid) end)
                changed = true
              end
              if IsValidActor(mid) and (colorChanged or created or changed) then
                pcall(function()
                  mid:SetVectorParameterValue("颜色", color)
                  mid:SetVectorParameterValue("Extra Light Color", color)
                  mid:SetVectorParameterValue("Para_Color", color)
                  mid:SetVectorParameterValue("Para_ColorTint", color)
                  mid:SetVectorParameterValue("Para_Color_1", color)
                  mid:SetVectorParameterValue("Tint", color)
                  mid:SetVectorParameterValue("Color", color)
                  mid:SetVectorParameterValue("BaseColor", color)
                  mid:SetVectorParameterValue("BodyColor", color)
                  mid:SetVectorParameterValue("MainColor", color)
                  mid:SetVectorParameterValue("DiffuseColor", color)
                  mid:SetVectorParameterValue("EmissiveColor", color)
                  mid:SetVectorParameterValue("ParaScaleOffset", scaleColor)
                end)
              end
            end
          end
        end
      end
      if colorChanged then
        enemy.WH_LastColorR = color.R
        enemy.WH_LastBlendMode = blendMode
      end
    end)
  else
    pcall(function()
      for _, mesh in ipairs(meshes) do
        if IsValidActor(mesh) then
          local succ1, mat = pcall(function() return mesh:GetMaterial(0) end)
          if succ1 and IsValidActor(mat) then
            local succ2, baseMat = pcall(function() return mat:GetBaseMaterial() end)
            if succ2 and IsValidActor(baseMat) then
              if baseMat.bDisableDepthTest ~= false then
                baseMat.bDisableDepthTest = false
              end
              if baseMat.BlendMode ~= 1 then
                baseMat.BlendMode = 1
              end
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

local function ClearWallhack()
  pcall(function()
    local pawns = Game:GetAllPlayerPawns() or {}
    for _, pawn in pairs(pawns) do
      if slua.isValid(pawn) then
        if pawn.WH_LastColorR then
          ApplyWallhack(nil, pawn, nil, false, false)
        end
      end
    end
  end)
end

local function AimTick(actor)
  if slua.isValid(actor) and ModConfig.AIMBOT then
    local weaponComp
    if slua.isValid(actor.WeaponManagerComponent) then
      if actor.WeaponManagerComponent.CurrentWeaponReplicated then
        weaponComp = actor.WeaponManagerComponent.CurrentWeaponReplicated.ShootWeaponEntityComp
      end
    end
    if slua.isValid(weaponComp) and weaponComp.AutoAimingConfig then
      for _, rangeKey in ipairs({"OuterRange", "InnerRange"}) do
        local rangeData = weaponComp.AutoAimingConfig[rangeKey]
        if rangeData then
          rangeData.Speed = ModConfig.AIM_SPEED
          rangeData.RangeRate = ModConfig.AIM_RANGE
          rangeData.SpeedRate = ModConfig.AIM_SPEED_RATE
          rangeData.RangeRateSight = ModConfig.AIM_RANGE_SCOPE
          rangeData.SpeedRateSight = ModConfig.AIM_SPEED_SCOPE
          rangeData.CrouchRate = ModConfig.AIM_CROUNCH
          rangeData.ProneRate = ModConfig.AIM_PRONE
          rangeData.DyingRate = ModConfig.AIM_DYING_RATE
        end
      end
    end
  end
end

local function FOVTick(actor)
  if slua.isValid(actor) and ModConfig.IPAD_VIEW then
    if slua.isValid(actor.ThirdPersonCameraComponent) then
      actor.ThirdPersonCameraComponent.FieldOfView = ModConfig.IPAD_VALUE
    end
  end
end

local function EnemyCountTick()
  pcall(function()
    local player = GameplayData.GetPlayerCharacter()
    if not slua.isValid(player) then return end
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local hud = pc:GetHUD()
    if not slua.isValid(hud) then return end
    
    local myTeamID = player.TeamID or 0
    local myLoc = player:K2_GetActorLocation()
    local pawns = Game:GetAllPlayerPawns() or {}
    local enemyCount = 0
    
    for _, pawn in pairs(pawns) do
      if slua.isValid(pawn) and pawn ~= player then
        local teamID = pawn.TeamID or 0
        if teamID ~= myTeamID then
          if IsAlive(pawn) then
            local dist = FVector.Dist2D(myLoc, pawn:K2_GetActorLocation())
            if dist < 20000 then
              enemyCount = enemyCount + 1
            end
          end
        end
      end
    end
    
    local timeDiff = math.max(0, ExpireTime - os.time())
    local d = math.floor(timeDiff / 86400)
    local h = math.floor((timeDiff % 86400) / 3600)
    local m = math.floor((timeDiff % 3600) / 60)
    local s = timeDiff % 60
    local timeStr = string.format("%02dd %02dh %02dm %02ds", d, h, m, s)
    
    hud:AddDebugText("PAKS MOD VIP BY @Lion_ZG", player, 1.2, {X=0,Y=0,Z=185}, {X=0,Y=0,Z=185}, {R=0,G=255,B=0,A=255}, true, false, true, nil, 1, true)
    hud:AddDebugText("EXPIRED IN : " .. timeStr, player, 1.2, {X=0,Y=0,Z=165}, {X=0,Y=0,Z=165}, {R=255,G=255,B=0,A=255}, true, false, true, nil, 1, true)
    
    local color = enemyCount > 0 and {R=255,G=0,B=0,A=255} or {R=0,G=255,B=0,A=255}
    local text = enemyCount > 0 and "ENEMY : " .. enemyCount or "CLEAR"
    
    hud:AddDebugText(text, player, 1.5, {X=0,Y=0,Z=145}, {X=0,Y=0,Z=145}, color, true, false, true, nil, 1.5, true)
  end)
end

local function WallhackTick()
  pcall(function()
    local player = GameplayData.GetPlayerCharacter()
    if not slua.isValid(player) then return end
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    
    if ModConfig.WALLHACK then
      if not wallhackActive then
        wallhackActive = true
      end
      ApplyWallhack(player, player, pc, false, true)
      
      local myTeamID = player.TeamID or 0
      local myLoc = player:K2_GetActorLocation()
      local pawns = Game:GetAllPlayerPawns() or {}
      
      for _, pawn in pairs(pawns) do
        if slua.isValid(pawn) and pawn ~= player then
          local teamID = pawn.TeamID or 0
          if teamID ~= myTeamID then
            if IsAlive(pawn) then
              local dist = FVector.Dist2D(myLoc, pawn:K2_GetActorLocation())
              if dist < 20000 then
                ApplyWallhack(player, pawn, pc, true, false)
              end
            end
          end
        end
      end
    else
      if wallhackActive then
        wallhackActive = false
        ClearWallhack()
      end
    end
  end)
end

local RPCDef = {
  ServerRPC = {
    ServerRPC_NearDeathGiveupRescue = {
      Reliable = true,
      Params = {}
    },
    ServerRPC_CarryDeadBox = {
      Reliable = true,
      Params = {UEnums.EPropertyClass.Object}
    },
    RPC_Server_GmPlayAction = {
      Reliable = true,
      Params = {UEnums.EPropertyClass.Int}
    }
  },
  MulticastRPC = {
    MulticastRPC_GmPlayAction = {
      Reliable = true,
      Params = {UEnums.EPropertyClass.Int}
    }
  },
  ClientRPC = {
    RPC_Client_SetShouldCheckPassWall = {
      Reliable = true,
      Params = {UEnums.EPropertyClass.Bool}
    }
  }
}

_G.ServerRPC = RPCDef.ServerRPC
_G.ClientRPC = RPCDef.ClientRPC
_G.MulticastRPC = RPCDef.MulticastRPC

local ModClass = Class(CharacterBase, nil, RPCDef)

function ModClass:ctor()
  self._MT = nil
end

function ModClass:_PostConstruct()
  CharacterBase._PostConstruct(self)
  self:InitAddSpecialMoveInfo()
  self.bCanNearDeathGiveup = true
end

function ModClass:ReceiveBeginPlay()
  CharacterBase.ReceiveBeginPlay(self)
  self:SetActorTickEnabled(true)
  EventSystem:postEvent(EVENTTYPE_SINGLETRAINING, EVENTID_CHARACTER_BEGINPLAY, self.Object)
  if Client then
    ShowWelcome()
    if IsExpired() then
      ShowExpireWarning()
      self:AddGameTimer(5, true, ShowExpireWarning)
      return
    end
  end
end

function ModClass:ReceiveEndPlay(endPlayReason)
  CharacterBase.ReceiveEndPlay(self, endPlayReason)
  if Client then
    if GameplayData.RemoveCharacter then
      GameplayData.RemoveCharacter(self.Object)
    end
  end
end

function ModClass:ReceiveTick()
  if IsExpired() then
    ShowExpireWarning()
    return
  end
  AimTick(self.Object)
  FOVTick(self.Object)
  WallhackTick()
  if ModConfig.ENEMY_COUNT then
    EnemyCountTick()
  end
end

return CombineClass(ModClass, {
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