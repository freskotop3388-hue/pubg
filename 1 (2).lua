-- DECOMPLIED BY @nanamod96 + @alex_vietnam

local L0_1 = {}

function L0_1.ctor(A0_2)
end

function L0_1.OnInitialize(A0_2)
end

function L0_1.RegistEvents(A0_2)
end

function L0_1.IsTPlanMod(A0_2)
  return true
end

if not _G.SkinLoaded then
  _G.SkinLoaded = true
  _G.SkinCfgPath = "Paks/SKIN_LUA.txt"
  _G.SkinModEnabled = false
  
  _G.BaseSkinIDs = {
    Weapons = {
      101004, 101001, 101003, 103001, 102002, 103002, 103003, 101008, 102003, 105010, 102004, 105002, 105001, 101006, 104004, 101102, 101007, 103012, 103007, 104003
    },
    Outfits = {
      Suit = 403003,
      Bag = 501001,
      Helmet = 502001,
      Parachut = 703001,
      Pet = 50000
    }
  }
  
  _G.OutfitSkins = {
    Suit = { _G.BaseSkinIDs.Outfits.Suit },
    Bag = { _G.BaseSkinIDs.Outfits.Bag },
    Helmet = { _G.BaseSkinIDs.Outfits.Helmet },
    Parachut = { _G.BaseSkinIDs.Outfits.Parachut },
    Pet = { _G.BaseSkinIDs.Outfits.Pet }
  }

  _G.SkinMap = {}
  for _, weaponId in ipairs(_G.BaseSkinIDs.Weapons) do
    _G.SkinMap[weaponId] = { weaponId }
  end

  _G.VehMap = {
    UAZ = 1908001,
    Dacia = 1903001,
    Buggy = 1907001,
    Motor = 1901001,
    CoupeRB = 1961001
  }

  _G.VehSkins = {}
  _G.VehSkinIdx = {}

  _G.CustSlot = {
    ClothSlot = 5,
    BagSlot = 8,
    HelmSlot = 9,
    ParaSlot = 11,
    GlideSlot = 15
  }

  _G.WpnSkinIdx = _G.WpnSkinIdx or {}

  _G.PetSkin = 0
  _G.GlideSkin = 0
  _G.ParaSkin = 0
  _G.HelmSkin = 0
  _G.BagSkin = 0
  _G.SuitSkin = 0

  _G.LastHelmVal = 0
  _G.LastBagVal = 0

  _G.SkinCache2 = {}
  _G.SkinCache = {}

  _G._skinApplied = false

  local function readFile(path)
    if Client and Client.LoadFileToString then
      local data = Client.LoadFileToString(path)
      if data and data ~= "" then
        return data
      end
    end
    local file = io.open(path, "r")
    if file then
      local data = file:read("*all")
      file:close()
      return data
    end
    return nil
  end

  local function readConfig()
    local data = readFile(_G.SkinCfgPath)
    if not data then
      _G.SkinModEnabled = false
      return
    end
    local enabled = false
    for line in data:gmatch("[^\r\n]+") do
      line = line:match("^%s*(.-)%s*$")
      if line and line ~= "" then
        local k, v = line:match("^(SKIN_MOD)%s*=%s*(%d+)$")
        if k and v then
          enabled = tonumber(v) == 1
          break
        end
      end
    end
    _G.SkinModEnabled = enabled
  end

  local function ForceKCUI(obj)
    if obj and slua.isValid(obj) then
      pcall(function()
        local weaponManager = obj:GetWeaponManager()
        if slua.isValid(weaponManager) then
          for i = 1, 3 do
            local weapon = weaponManager:GetInventoryWeaponByPropSlot(i)
            if slua.isValid(weapon) and slua.isValid(weapon.synData) then
              local weaponID = weapon:GetWeaponID()
              if weaponID and weaponID > 0 then
                local synData = weapon.synData:Get(7)
                if synData and synData.defineID then
                  if synData.defineID.TypeSpecificID ~= weaponID then
                    synData.defineID.TypeSpecificID = weaponID
                    weapon.synData:Set(7, synData)
                    if weapon.SetWeaponAvatarID then
                      pcall(function() weapon:SetWeaponAvatarID(weaponID) end)
                    end
                    if weapon.DelayHandleAvatarMeshChanged then
                      pcall(function() weapon:DelayHandleAvatarMeshChanged() end)
                    end
                    if weapon.OnRep_synData then
                      pcall(function() weapon:OnRep_synData() end)
                    end
                  end
                end
              end
            end
          end
        end
      end)
      pcall(function()
        if obj.AvatarComponent2 then
          obj.AvatarComponent2:OnRep_BodySlotStateChanged()
        end
      end)
      _G._skinApplied = false
      _G.LastVehEnt = nil
      _G.CurVehID = nil
    end
  end

  _G.DnItem = function(itemID)
    pcall(function()
      local puffer_manager = require("client.slua.logic.download.puffer.puffer_manager")
      local puffer_const = require("client.slua.logic.download.puffer_const")
      if puffer_manager and puffer_const then
        if puffer_manager.GetState(puffer_const.ENUM_DownloadType.ODPAK, {itemID}) ~= puffer_const.ENUM_DownloadState.Done then
          puffer_manager.Download(puffer_const.ENUM_DownloadType.ODPAK, {itemID})
        end
      end
    end)
  end

  _G.GetWpnSkin = function(weaponID)
    if not _G.SkinModEnabled then return weaponID end
    if not weaponID then return nil end
    local idx = _G.WpnSkinIdx[weaponID] or 1
    local skinMap = _G.SkinMap[weaponID]
    if skinMap then
      local skinID = skinMap[idx]
      if skinID then
        if not _G.SkinCache2[skinID] then
          pcall(_G.DnItem, skinID)
          _G.SkinCache2[skinID] = true
        end
        return skinID
      end
    end
    return weaponID
  end

  _G.GetVehSkin = function(vehID)
    if not _G.SkinModEnabled then return vehID end
    if not vehID or vehID == 0 then return vehID end
    local idPrefix = tonumber(string.sub(tostring(vehID), 1, 4) .. "001")
    local vehSkins = _G.VehSkins[idPrefix]
    if vehSkins then
      local idx = _G.VehSkinIdx[idPrefix] or 1
      if idx < 1 then 
        idx = 1 
      elseif idx > #vehSkins then 
        idx = #vehSkins 
      end
      local skinID = vehSkins[idx]
      if skinID and skinID > 0 then
        if not _G.SkinCache2[skinID] then
          pcall(_G.DnItem, skinID)
          _G.SkinCache2[skinID] = true
        end
        return skinID
      end
    end
    return vehID
  end

  _G.LoadSkinData = function()
    local data = readFile(_G.SkinCfgPath)
    if not data then return end
    local isSkinList = false
    for line in data:gmatch("[^\r\n]+") do
      line = line:match("^%s*(.-)%s*$")
      if line and line ~= "" then
        if line:match("^%[SKIN_LIST%]") then
          isSkinList = true
        elseif line:match("^%[SELECTED%]") or line:match("^%[") then
          isSkinList = false
        end
        if isSkinList then
          if not line:match("^%[") and not line:match("^%s*#") then
            local k, v = line:match("([^=]+)=(.+)")
            if k and v then
              k = k:match("^%s*(.-)%s*$")
              local ids = {}
              for id in v:gmatch("([^,]+)") do
                local num = tonumber(id:match("^%s*(.-)%s*$"))
                if num then
                  table.insert(ids, num)
                end
              end
              if #ids > 0 then
                if _G.OutfitSkins[k] ~= nil then
                  _G.OutfitSkins[k] = ids
                elseif _G.VehMap[k] ~= nil then
                  _G.VehSkins[_G.VehMap[k]] = ids
                elseif tonumber(k) then
                  _G.SkinMap[tonumber(k)] = ids
                end
              end
            end
          end
        end
      end
    end
    _G.SuitMap = _G.OutfitSkins.Suit
    _G.BagMap = _G.OutfitSkins.Bag
    _G.HelmMap = _G.OutfitSkins.Helmet
    _G.ParaMap = _G.OutfitSkins.Parachut
    _G.PetMap = _G.OutfitSkins.Pet
  end

  pcall(_G.LoadSkinData)

  _G.ReadCfg = function()
    local data = readFile(_G.SkinCfgPath)
    if not data then return end
    local selected = {}
    local isSelected = false
    for line in data:gmatch("[^\r\n]+") do
      line = line:match("^%s*(.-)%s*$")
      if line and line ~= "" then
        if line:match("^%[SELECTED%]") then
          isSelected = true
        elseif line:match("^%[SKIN_LIST%]") or line:match("^%[ATTACHMENTS%]") then
          isSelected = false
        end
        if isSelected then
          if not line:match("^%[") and not line:match("^%s*#") then
            local k, v = line:match("([%w_]+)%s*=%s*(%d+)")
            if k and v then
              if not line:match(",") then
                selected[k] = tonumber(v)
              end
            end
          end
        end
      end
    end

    local function updateSelection(key, map, globalKey)
      if selected[key] then
        if selected[key] ~= _G[key] then
          local val = 0
          if map then
            val = map[selected[key] + 1]
            if not val then val = 0 end
          end
          _G[globalKey] = val
          _G[key] = selected[key]
        end
      end
    end

    updateSelection("Suit", _G.SuitMap, "SuitSkin")
    updateSelection("Bag", _G.BagMap, "BagSkin")
    updateSelection("Helmet", _G.HelmMap, "HelmetSkin")
    updateSelection("Parachute", _G.ParaMap, "ParachuteSkin")
    updateSelection("Pet", _G.PetMap, "PetSkin")

    local weapons = {
      M416 = 101004, AKM = 101001, SCAR = 101003, M762 = 101008, AUG = 101006, ACE32 = 101102, QBZ = 101007,
      UMP = 102002, Vector = 102003, UZI = 102004,
      Kar98k = 103001, M24 = 103002, AWM = 103003, AMR = 103012, Mk14 = 103007,
      MG3 = 105010, S12K = 104003, DBS = 104004
    }

    for k, v in pairs(weapons) do
      if selected[k] then
        if selected[k] ~= _G[k] then
          _G.WpnSkinIdx[v] = selected[k] + 1
          _G[k] = selected[k]
        end
      end
    end

    for k, v in pairs(_G.VehMap) do
      if selected[k] then
        if selected[k] ~= _G[k] then
          _G.VehSkinIdx[v] = selected[k] + 1
          _G[k] = selected[k]
        end
      end
    end
  end

  _G.BaseAttIdx = {
    [201010] = 1, [201005] = 1, [201004] = 1,
    [201009] = 2, [201003] = 2, [201002] = 2,
    [201011] = 3, [201007] = 3, [201006] = 3,
    [204012] = 4, [204005] = 4, [204008] = 4,
    [204011] = 5, [204004] = 5, [204007] = 5,
    [204013] = 6, [204006] = 6, [204009] = 6,
    [203001] = 7, [203002] = 8, [203003] = 9,
    [203014] = 10, [203004] = 11, [203015] = 12,
    [203005] = 13, [202002] = 14, [202001] = 15,
    [202004] = 16, [202005] = 17, [202007] = 18,
    [202006] = 19, [205002] = 20, [205003] = 20,
    [205001] = 20, [203018] = 21, [204014] = 22
  }

  _G.VipAttach = {}
  _G.VipAttIdx = {}

  _G.LoadAttach = function()
    local data = readFile(_G.SkinCfgPath)
    if not data then return end
    _G.VipAttach = {}
    _G.VipAttIdx = {}
    local isAttachList = false
    for line in data:gmatch("[^\r\n]+") do
      line = line:match("^%s*(.-)%s*$")
      if line and line ~= "" then
        if line:match("^%[ATTACHMENTS%]") then
          isAttachList = true
        elseif line:match("^%[") then
          isAttachList = false
        end
        if isAttachList then
          if not line:match("^%[") and not line:match("^%s*#") then
            local k, v = line:match("^(%d+)=(.+)$")
            if k and v then
              k = tonumber(k)
              local attachs = {}
              local idx = 1
              for attachID in v:gmatch("([^,]+)") do
                local aid = tonumber(attachID)
                if not aid then aid = 0 end
                table.insert(attachs, aid)
                if aid > 0 then
                  _G.VipAttIdx[aid] = idx
                end
                idx = idx + 1
              end
              _G.VipAttach[k] = attachs
            end
          end
        end
      end
    end
  end

  pcall(_G.LoadAttach)

  _G.EquipAvatar = function(obj)
    if not _G.SkinModEnabled then return end
    if obj and slua.isValid(obj) then
      if obj.AvatarComponent2 then
        local bpUtils = import("BackpackUtils")
        local slotSyncData
        if obj.AvatarComponent2.NetAvatarData then
          slotSyncData = obj.AvatarComponent2.NetAvatarData.SlotSyncData
        end
        if slotSyncData and slua.isValid(slotSyncData) and bpUtils then
          local function updateSlot(slotIndex, skinID, expectedSlotID, useAdditional, getLevelFunc, lastValKey)
            if skinID == 0 then return end
            local slotData = slotSyncData:Get(slotIndex)
            if slotData then
              if slotData.SlotID == expectedSlotID then
                local finalSkinID = skinID
                if useAdditional then
                  local level = getLevelFunc(slotData.AdditionalItemID)
                  if not level then level = 1 end
                  finalSkinID = skinID + (level - 1) * 1000
                  if finalSkinID == slotData.ItemId then
                    if _G[lastValKey] == skinID then return end
                  end
                  _G[lastValKey] = skinID
                else
                  if slotData.ItemId == skinID then return end
                end
                
                if not _G.SkinCache[finalSkinID] then
                  _G.DnItem(finalSkinID)
                  _G.SkinCache[finalSkinID] = true
                end
                
                slotData.ItemId = finalSkinID
                slotSyncData:Set(slotIndex, slotData)
                obj.AvatarComponent2:OnRep_BodySlotStateChanged()
              end
            end
          end
          
          local hasGlide = false
          for i = 0, slotSyncData:Num() - 1 do
            local slotData = slotSyncData:Get(i)
            if slotData and slotData.SlotID == _G.CustSlot.GlideSlot then
              hasGlide = true
              break
            end
          end
          
          if not hasGlide then
            slotSyncData:Add({SlotID = _G.CustSlot.GlideSlot, ItemId = 0})
          end
          
          for i = 0, slotSyncData:Num() - 1 do
            updateSlot(i, _G.SuitSkin, _G.CustSlot.ClothSlot, false)
            updateSlot(i, _G.BagSkin, _G.CustSlot.BagSlot, true, bpUtils.GetEquipmentBagLevel, "LastBagVal")
            updateSlot(i, _G.HelmSkin, _G.CustSlot.HelmSlot, true, bpUtils.GetEquipmentHelmetLevel, "LastHelmVal")
            updateSlot(i, _G.GlideSkin, _G.CustSlot.GlideSlot, false)
            updateSlot(i, _G.ParaSkin, _G.CustSlot.ParaSlot, false)
          end
          _G._skinApplied = true
        end
      end
    end
  end

  _G.ApplyWpnSkin = function(obj)
    if not _G.SkinModEnabled then return end
    pcall(function()
      local weaponManager = obj:GetWeaponManager()
      if not slua.isValid(weaponManager) then return end
      for i = 1, 3 do
        local weapon = weaponManager:GetInventoryWeaponByPropSlot(i)
        if slua.isValid(weapon) and slua.isValid(weapon.synData) then
          local weaponID = weapon:GetWeaponID()
          local skinID = _G.GetWpnSkin(weaponID)
          if not skinID then skinID = weaponID end
          local changed = false
          local synData = weapon.synData:Get(7)
          if synData and synData.defineID then
            if synData.defineID.TypeSpecificID ~= skinID then
              synData.defineID.TypeSpecificID = skinID
              weapon.synData:Set(7, synData)
              if weapon.SetWeaponAvatarID then
                pcall(function() weapon:SetWeaponAvatarID(skinID) end)
              end
              if not _G.SkinCache[skinID] then
                _G.DnItem(skinID)
                _G.SkinCache[skinID] = true
              end
              changed = true
            end
          end
          
          if skinID >= 10000000 then
            if _G.VipAttach and _G.VipAttach[skinID] then
              for attachIdx = 0, 5 do
                local attachData = weapon.synData:Get(attachIdx)
                if attachData and slua.IndexReference(attachData, "defineID") then
                  local typeSpecificID = attachData.defineID.TypeSpecificID
                  if typeSpecificID and typeSpecificID > 0 then
                    local attIdx = _G.BaseAttIdx[typeSpecificID] or _G.VipAttIdx[typeSpecificID]
                    if attIdx then
                      local vipAttachSkin = _G.VipAttach[skinID][attIdx]
                      if vipAttachSkin and vipAttachSkin > 0 and vipAttachSkin ~= typeSpecificID then
                        attachData.defineID.TypeSpecificID = vipAttachSkin
                        weapon.synData:Set(attachIdx, attachData)
                        if not _G.SkinCache2[vipAttachSkin] then
                          pcall(_G.DnItem, vipAttachSkin)
                          _G.SkinCache2[vipAttachSkin] = true
                        end
                        changed = true
                      end
                    end
                  end
                end
              end
            end
          end
          
          if changed then
            if weapon.DelayHandleAvatarMeshChanged then
              pcall(function() weapon:DelayHandleAvatarMeshChanged() end)
            end
            if weapon.OnRep_synData then
              pcall(function() weapon:OnRep_synData() end)
            end
          end
        end
      end
    end)
  end

  _G.ApplyVehSkin = function(obj)
    if not _G.SkinModEnabled then return end
    pcall(function()
      local currentVeh = obj:GetCurrentVehicle()
      if not slua.isValid(currentVeh) then
        _G.LastVehEnt = nil
        return
      end
      if not Game:IsDriver(obj.Object) then return end
      
      local vehAvatarComp = currentVeh.VehicleAvatarComponent_BP or currentVeh:GetAvatarComponent()
      if not slua.isValid(vehAvatarComp) then return end
      
      local vehID = 0
      if currentVeh.AvatarDefaultCfg then
        vehID = currentVeh.AvatarDefaultCfg.TypeSpecificID
      end
      if vehID == 0 then
        if vehAvatarComp.VehicleNetAvatarData and vehAvatarComp.VehicleNetAvatarData.ItemDefineID then
          vehID = vehAvatarComp.VehicleNetAvatarData.ItemDefineID.TypeSpecificID
        end
      end
      if vehID == 0 then return end
      
      local skinID = _G.GetVehSkin(vehID)
      local curSkinID = vehAvatarComp:GetCurItemAvatarID()
      
      if skinID and skinID ~= 0 and curSkinID ~= skinID then
        if not _G.SkinCache[skinID] then
          if _G.DnItem then pcall(_G.DnItem, skinID) end
          _G.SkinCache[skinID] = true
        end
        
        if vehAvatarComp.VehicleNetAvatarData and vehAvatarComp.VehicleNetAvatarData.ItemDefineID then
          vehAvatarComp.VehicleNetAvatarData.ItemDefineID.TypeSpecificID = skinID
          vehAvatarComp.VehicleNetAvatarData.SkinOwnerUID = obj.PlayerUID
        end
        
        if _G.LastVehEnt == currentVeh and _G.CurVehID == skinID then
          if vehAvatarComp.ChangeItemAvatar then
            vehAvatarComp:ChangeItemAvatar(skinID, false)
          end
        else
          _G.LastVehEnt = currentVeh
          _G.CurVehID = skinID
          pcall(function()
            vehAvatarComp.lastEquipedAvatarId = curSkinID
            if vehAvatarComp.ShowVehicleSwitchEffect then vehAvatarComp:ShowVehicleSwitchEffect() end
            vehAvatarComp.ClientUsedAvatarID = skinID
            currentVeh.ClientUsedAvatarID = skinID
            if vehAvatarComp.ChangeItemAvatar then vehAvatarComp:ChangeItemAvatar(skinID, false) end
          end)
        end
        
        if vehAvatarComp.EnableHighTireLight then
          vehAvatarComp:EnableHighTireLight(true, skinID)
        end
        if currentVeh.UpdateParticle then
          pcall(function() currentVeh:UpdateParticle(skinID) end)
        end
        if currentVeh.ChangeParticles then
          pcall(function() currentVeh:ChangeParticles(skinID) end)
        end
        if currentVeh.ReActivateExhaustParticle then
          pcall(function() currentVeh:ReActivateExhaustParticle() end)
        end
        
        local vehLicenseComp = currentVeh:GetComponentByClass(import("VehicleLicenseNumberComponent"))
        if slua.isValid(vehLicenseComp) then
          if vehLicenseComp.LicensePlate then
            vehLicenseComp.LicensePlate.ItemID = skinID
            vehLicenseComp.LicensePlate.ChassisLightId = skinID + 1000
          end
          if vehLicenseComp.PreChangeEffect then vehLicenseComp:PreChangeEffect() end
          if vehLicenseComp.PreChangeChassisLight then vehLicenseComp:PreChangeChassisLight() end
        end
        
        if currentVeh.SetVehicleMusicPlayState then
          currentVeh:SetVehicleMusicPlayState(true)
        end
      end
    end)
  end

  _G.HandlePet = function()
    if not _G.SkinModEnabled then return end
    if _G.PetSkin and _G.PetSkin ~= 0 and _G.PetSkin ~= 50000 and _G.PetSkin ~= _G.LastPet then
      if not _G.SkinCache[_G.PetSkin] then
        _G.DnItem(_G.PetSkin)
        _G.SkinCache[_G.PetSkin] = true
      end
      pcall(function()
        local moduleManager = require("client.module_framework.ModuleManager")
        if moduleManager then
          local logicPet = moduleManager.GetModule(moduleManager.CommonModuleConfig.logic_pet)
          if logicPet then
            if logicPet.SetCurPetID then logicPet:SetCurPetID(_G.PetSkin) end
            if logicPet.EquipPet then logicPet:EquipPet(_G.PetSkin) end
          end
        end
      end)
      _G.LastPet = _G.PetSkin
    end
  end

  _G.AKKills = _G.AKKills or {}

  _G.ForceKCUI = function()
    pcall(function()
      local killInfo = package.loaded["GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo"]
      if killInfo and killInfo.__inner_impl then
        if not _G.KillInfoHkd then
          local originalFileItem = killInfo.__inner_impl.FileItem
          killInfo.__inner_impl.FileItem = function(self, param)
            pcall(function()
              local player = require("GameLua.GameCore.Data.GameplayData").GetPlayerCharacter()
              if slua.isValid(player) then
                if param.Causer == player:GetPlayerNameSafety() then
                  local weapon = player:GetCurrentWeapon()
                  if slua.isValid(weapon) then
                    local weaponID = weapon:GetWeaponID()
                    local skinID = _G.GetWpnSkin(weaponID)
                    if skinID then param.CauserWeaponAvatarID = skinID end
                    if _G.SuitSkin and _G.SuitSkin ~= 0 then param.CauserClothAvatarID = _G.SuitSkin end
                    if param.ResultHealthStatus == 2 then
                      _G.AKKills[weaponID] = (_G.AKKills[weaponID] or 0) + 1
                    end
                  end
                end
              end
            end)
            if originalFileItem then
              return originalFileItem(self, param)
            end
          end
          _G.KillInfoHkd = true
        end
      end
    end)
  end

  _G.AKSkinStart = false

  _G.InitSkinSys = function()
    if _G.AKSkinStart then return end
    _G.AKSkinStart = true
    readConfig()
    if _G.SkinModEnabled then
      pcall(_G.ReadCfg)
      pcall(_G.LoadAttach)
    end
    local function timerFunc()
      pcall(function()
        local skinEnabled = _G.SkinModEnabled
        readConfig()
        local player = require("GameLua.GameCore.Data.GameplayData").GetPlayerCharacter()
        if skinEnabled and not _G.SkinModEnabled then
          if slua.isValid(player) then
            ForceKCUI(player)
          end
        end
        if not skinEnabled and _G.SkinModEnabled then
          pcall(_G.ReadCfg)
          pcall(_G.LoadAttach)
        end
        if slua.isValid(player) then
          _G.ForceKCUI()
          if _G.SkinModEnabled then
            local currTime = os.clock()
            if not _G._lastCfgTime or (currTime - _G._lastCfgTime >= 2.0) then
              _G._lastCfgTime = currTime
              pcall(_G.ReadCfg)
              pcall(_G.LoadAttach)
            end
            _G.EquipAvatar(player)
            _G.ApplyWpnSkin(player)
            _G.ApplyVehSkin(player)
            _G.HandlePet()
          end
        end
      end)
      local timeTicker = require("common.time_ticker")
      if timeTicker and timeTicker.AddTimerOnce then
        timeTicker.AddTimerOnce(0.3, timerFunc)
      end
    end
    timerFunc()
  end

  _G.InitSkinSys()
end

return require("class")(require("GameLua.Mod.BaseMod.Client.Backpack.BackPackPanelUI"), nil, L0_1)