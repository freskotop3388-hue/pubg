
local DEBUG = true
local function log(...)
    if DEBUG then print("[AddOutfit]", ...) end
end


local MATCH_CONFIG = {
    outfitRes = 0,        -- مثال: 1405497  (0 = من الذاكرة)
    weaponSkins = {       -- weaponID → skinResID (0 أو بدون = من الذاكرة/الشنطة)
        
    },
}

-- ========== قائمة العناصر ==========
local ITEMS = {
    -- بدلات
    1405485, 1405486, 1405481, 1405482, 1405488, 1405489, 1405490, 1405491,
    1405492, 1405493, 1405494, 1405495, 1405496, 1405497, 1405498, 1405499,
    1405629, 1405630, 1405631, 1405632, 1405633, 1405634,
    -- M416 Lv.8
    1101004246,
    1101004236,
}

local INS_BASE = 2000000000
local PKG_SLOT = 3
local MELEE_ID = 108
local GUN_SUB = { [101]=true, [102]=true, [103]=true, [104]=true, [105]=true, [106]=true, [107]=true }
local NET_OK = NetErrorCode_NONE or "ok"

local R = { insToRes = {}, resToIns = {} }
local _matchApplied = false

-- ========== ذاكرة اللبس ==========
local function cache()
    _G.AddOutfitEquippedCache = _G.AddOutfitEquippedCache or {
        outfitRes = nil, outfitIns = nil,
        weapons = {},
    }
    return _G.AddOutfitEquippedCache
end

local function cfg(resID)
    if not resID or not CDataTable or not CDataTable.GetTableData then return nil end
    return CDataTable.GetTableData("Item", resID)
end

local function subType(c)
    return c and (c.ItemSubType or c.itemSubType) or nil
end

-- 403 = Package_Slot: تبويب البدلة (10) وتبويب التيشيرت (3) — نفس النوع، مختلف التبويب
local ST_TOP     = (ENUM_ITEM_SUBTYPE and ENUM_ITEM_SUBTYPE.Package_Slot) or 403
local ST_PANTS   = (ENUM_ITEM_SUBTYPE and ENUM_ITEM_SUBTYPE.Pants_Slot) or 404
local ST_SHOES   = (ENUM_ITEM_SUBTYPE and ENUM_ITEM_SUBTYPE.Shoes_Slot) or 405
local ST_UNDER_T = (ENUM_ITEM_SUBTYPE and ENUM_ITEM_SUBTYPE.UnderCloth) or 450
local ST_UNDER_P = (ENUM_ITEM_SUBTYPE and ENUM_ITEM_SUBTYPE.UnderPants) or 451
local WARDROBE_TAB_SUIT, WARDROBE_TAB_CLOTHES = 10, 3
pcall(function()
    local wm = require("client.slua.umg.Wardrobe.wardrobe_macro")
    WARDROBE_TAB_SUIT = wm.ENUM_WardrobeSubTabString.ENUM_WardrobeSubTabString_suit
    WARDROBE_TAB_CLOTHES = wm.ENUM_WardrobeSubTabString.ENUM_WardrobeSubTabString_clothes
end)

local FULL_SUIT_CLEAR_ST = {
    [ST_TOP] = true, [ST_PANTS] = true, [ST_SHOES] = true,
    [ST_UNDER_T] = true, [ST_UNDER_P] = true,
}

local function wardrobeTab(resID, depotData)
    if depotData and depotData.subTabType then return tonumber(depotData.subTabType) end
    local c = cfg(resID)
    return c and tonumber(c.WardrobeTab or c.wardrobeTab) or nil
end

local function isFullSuitRes(resID, depotData)
    resID = tonumber(resID)
    if not resID or resID <= 0 then return false end
    local ok, xs = pcall(function()
        local LogicXSuit = require("client.slua.logic.XSuit.logic_xsuit")
        return LogicXSuit.IsXSuit(resID)
    end)
    if ok and xs then return true end
    local tab = wardrobeTab(resID, depotData)
    if tab == WARDROBE_TAB_SUIT then return true end
    if tab == WARDROBE_TAB_CLOTHES then return false end
    for _, id in ipairs(ITEMS) do
        if tonumber(id) == resID and subType(cfg(resID)) == ST_TOP then
            return true
        end
    end
    return false
end

local function getClothKind(resID, depotData)
    resID = tonumber(resID)
    if not resID then return nil end
    local st = subType(cfg(resID))
    if st == ST_TOP then
        return isFullSuitRes(resID, depotData) and "full_suit" or "top"
    end
    if st == ST_PANTS then return "pants" end
    if st == ST_SHOES then return "shoes" end
    if st == ST_UNDER_T then return "under_top" end
    if st == ST_UNDER_P then return "under_pants" end
    return nil
end

local function subTypesToClearForKind(kind)
    if kind == "full_suit" then return FULL_SUIT_CLEAR_ST end
    if kind == "top" then return { [ST_TOP] = true } end
    if kind == "pants" then return { [ST_PANTS] = true } end
    if kind == "shoes" then return { [ST_SHOES] = true } end
    if kind == "under_top" then return { [ST_UNDER_T] = true } end
    if kind == "under_pants" then return { [ST_UNDER_P] = true } end
    return nil
end

local function isBodyClothSubType(st)
    st = tonumber(st)
    return st == ST_TOP or st == ST_PANTS or st == ST_SHOES or st == ST_UNDER_T or st == ST_UNDER_P
end

local function weaponIdFromSkin(resID)
    local m = CDataTable and CDataTable.GetTableData and CDataTable.GetTableData("WeaponSkinMapping", resID)
    if not m then return nil end
    return m.WeaponID or m.WeaponId
end

local function isInjectedIns(ins)
    return ins and R.insToRes[tonumber(ins)] ~= nil
end

local function isInjectedRes(res)
    return res and R.resToIns[tonumber(res)] ~= nil
end

local function invalidateSocialWearCache()
    local s = _G.AddOutfitSocialState
    if s then
        s.wearPatchKey, s.snapshotKey, s.fullSnapshot, s.lastHandSkin = nil, nil, nil, nil
    end
end

local function saveWeaponToCache(weaponID, resID, insID)
    weaponID, resID, insID = tonumber(weaponID), tonumber(resID), tonumber(insID)
    if not weaponID or not resID or resID <= 0 then return end
    local cch = cache()
    cch.weapons[weaponID] = { resID = resID, insID = insID or 0 }
    _G.AddOutfitLastAppliedSkin = {}
    _matchApplied = false
    invalidateSocialWearCache()
    log("ذاكرة سكن", weaponID, "→", resID)
end

-- حفظ سكن من الشنطة (أصلي أو محقون) عبر insID
local function cacheWeaponSkinFromIns(weaponID, insID)
    weaponID, insID = tonumber(weaponID), tonumber(insID)
    if not weaponID or not insID or insID <= 0 then return end
    if isInjectedIns(insID) then
        saveWeaponToCache(weaponID, R.insToRes[insID], insID)
        return
    end
    pcall(function()
        local wd = require("client.slua.logic.wardrobe.wardrobe_data")
        local d = wd:GetValidHallDepotItemDataByInsID(insID) or wd:GetHallDepotItemDataByInsID(insID)
        if d and d.resID and tonumber(d.resID) > 0 then
            saveWeaponToCache(weaponID, tonumber(d.resID), insID)
        end
    end)
end

local function saveEquip(resID, insID)
    resID, insID = tonumber(resID), tonumber(insID)
    if not resID or not insID then return end
    local c = cfg(resID)
    local st = subType(c)
    local cch = cache()
    if getClothKind(resID) == "full_suit" then
        cch.outfitRes, cch.outfitIns = resID, insID
        _G.AddOutfitLastLobbyOutfitRes = resID
        invalidateSocialWearCache()
    elseif getClothKind(resID) == "top" then
        if cch.outfitRes and isFullSuitRes(cch.outfitRes) then
            cch.outfitRes, cch.outfitIns = nil, nil
            invalidateSocialWearCache()
        end
    elseif GUN_SUB[st] then
        local wid = weaponIdFromSkin(resID)
        if wid then saveWeaponToCache(wid, resID, insID) end
    elseif st == MELEE_ID then
        saveWeaponToCache(MELEE_ID, resID, insID)
    end
    _matchApplied = false
end

-- يقرأ السكنات الملبوسة من الشنطة / الأرموري → يحفظها في الذاكرة (مثل البدلة)
local function syncWeaponCacheFromLobby()
    local cch = cache()
    pcall(function()
        local fbd = require("client.slua.logic.wardrobe.fashionbag.fashionbag_data")
        local bag = fbd.GetCurrentFashionBag and fbd:GetCurrentFashionBag()
        if bag and bag.weapon_skin_list then
            for weaponID, entry in pairs(bag.weapon_skin_list) do
                weaponID = tonumber(weaponID)
                local insID = tonumber(entry and (entry.skin_id or entry.skinId)) or 0
                if weaponID and weaponID > 0 and insID > 0 then
                    if isInjectedIns(insID) then
                        local res = tonumber(R.insToRes[insID])
                        if res and res > 0 then
                            cch.weapons[weaponID] = { resID = res, insID = insID }
                        end
                    else
                        local wd = require("client.slua.logic.wardrobe.wardrobe_data")
                        local d = wd:GetValidHallDepotItemDataByInsID(insID)
                            or wd:GetHallDepotItemDataByInsID(insID)
                        if d and d.resID and tonumber(d.resID) > 0 then
                            cch.weapons[weaponID] = { resID = tonumber(d.resID), insID = insID }
                        end
                    end
                end
            end
        end
    end)
    pcall(function()
        local Arm = require("client.logic.armory.logic_armory")
        if Arm.rsp_list and Arm.rsp_list.install_list then
            for weaponID, entry in pairs(Arm.rsp_list.install_list) do
                weaponID = tonumber(weaponID)
                local insID = tonumber(entry and entry.skin_id) or 0
                if weaponID and weaponID > 0 and insID > 0 then
                    if isInjectedIns(insID) then
                        local res = tonumber(R.insToRes[insID])
                        if res and res > 0 then
                            cch.weapons[weaponID] = { resID = res, insID = insID }
                        end
                    else
                        local wd = require("client.slua.logic.wardrobe.wardrobe_data")
                        local d = wd:GetValidHallDepotItemDataByInsID(insID)
                            or wd:GetHallDepotItemDataByInsID(insID)
                        if d and d.resID and tonumber(d.resID) > 0 then
                            cch.weapons[weaponID] = { resID = tonumber(d.resID), insID = insID }
                        end
                    end
                end
            end
        end
    end)
    pcall(function()
        local wgl = require("client.slua.logic.wardrobe.logic_wardrobe_gun")
        if wgl.GetSkinIdByWeaponID then
            local guns = { 101001, 101002, 101003, 101004, 101005, 101006, 101007, 101008, 101009, 101010, 101012, 102001, 102002, 102003, 102004, 102005, 102007, 103001, 103002, 103003, 103004, 103005, 103006, 103007, 103008, 103009, 103010, 103011, 103012, 104001, 104002, 104003, 104004, 105001, 105002, 106001, 106002, 106003, 106004, 106005, 106006, 106007, 106008, 106010 }
            local wd = require("client.slua.logic.wardrobe.wardrobe_data")
            for _, wid in ipairs(guns) do
                local insID = tonumber(wgl:GetSkinIdByWeaponID(wid)) or 0
                if insID > 0 then
                    local d = wd:GetValidHallDepotItemDataByInsID(insID) or wd:GetHallDepotItemDataByInsID(insID)
                    if d and d.resID and tonumber(d.resID) > 0 then
                        cch.weapons[wid] = { resID = tonumber(d.resID), insID = insID }
                    end
                end
            end
        end
    end)
end

-- سكن السلاح للماتش: الذاكرة أولاً، ثم MATCH_CONFIG إن وُجد رقم > 0
local function getCachedWeaponSkin(weaponID)
    weaponID = tonumber(weaponID) or 0
    if weaponID <= 0 then return nil end
    syncWeaponCacheFromLobby()
    local w = cache().weapons[weaponID]
    if w and w.resID and w.resID > 0 then return w.resID end
    return nil
end

local function getMatchWeaponSkin(weaponID)
    weaponID = tonumber(weaponID) or 0
    local fromCache = getCachedWeaponSkin(weaponID)
    if fromCache then return fromCache end
    if MATCH_CONFIG.weaponSkins then
        local fixed = tonumber(MATCH_CONFIG.weaponSkins[weaponID])
        if fixed and fixed > 0 then return fixed end
    end
    return nil
end

local function findWornInsBySubType(st)
    st = tonumber(st)
    if not st then return nil end
    local wd = require("client.slua.logic.wardrobe.wardrobe_data")
    local AvatarData = require("client.logic.data.AvatarData")
    for _, ins in pairs(AvatarData.GetRoleWear()) do
        ins = tonumber(ins)
        if ins and ins > 0 then
            local d = wd:GetHallDepotItemDataByInsID(ins)
            if d and tonumber(d.itemSubType) == st then
                return ins, d.resID
            end
        end
    end
    return nil
end

local function removeRoleWearBySubTypes(stMap)
    if not stMap then return end
    local wd = require("client.slua.logic.wardrobe.wardrobe_data")
    local AvatarData = require("client.logic.data.AvatarData")
    for _, ins in pairs(AvatarData.GetRoleWear()) do
        ins = tonumber(ins)
        if ins and ins > 0 then
            local d = wd:GetHallDepotItemDataByInsID(ins)
            if d and stMap[tonumber(d.itemSubType)] then
                AvatarData.RemoveRoleWearDataByValue(ins)
            end
        end
    end
end

local function clearFashionBagSlots(stMap)
    if not stMap then return end
    pcall(function()
        local fbd = require("client.slua.logic.wardrobe.fashionbag.fashionbag_data")
        local wfu = require("client.slua.logic.wardrobe.fashionbag.wardrobe_fashion_utils")
        local bag = fbd.GetCurrentFashionBag and fbd:GetCurrentFashionBag()
        if not bag or not bag.rolewear_list then return end
        for st, _ in pairs(stMap) do
            local idx = wfu.GetRoleWearIndexBySubType and wfu:GetRoleWearIndexBySubType(st)
            if idx then bag.rolewear_list[idx] = 0 end
        end
    end)
end

local function removeRoleWearBySubType(st)
    if not st then return end
    removeRoleWearBySubTypes({ [tonumber(st)] = true })
end

local function syncFashionBagRolewear()
    pcall(function()
        local fbd = require("client.slua.logic.wardrobe.fashionbag.fashionbag_data")
        fbd:SaveRolewearToFashionBag(fbd:GetFashionBagUseIndex())
    end)
end

-- ========== مؤقّت ==========
local _ticker
pcall(function() _ticker = require("common.time_ticker") end)
local function later(sec, fn)
    if _G.SetTimer then pcall(_G.SetTimer, sec, fn) return end
    if _ticker and _ticker.AddTimer then pcall(_ticker.AddTimer, sec, fn) end
end

-- ========== حقن في الخزانة (نفس AddData الأصلي) ==========
local function getEntity()
    local ok, dc = pcall(require, "client.slua.logic.wardrobe.logic_wardrobe_data_center")
    if not ok or not dc then return nil end
    local ok2, e = pcall(dc.GetWardrobeData)
    return ok2 and e or nil
end

local function alreadyHave(entity, resID)
    local arr = entity.ResIDToIndexArrayMap and entity.ResIDToIndexArrayMap[resID]
    if not arr then return false end
    for _, idx in pairs(arr) do
        local d = entity._data[idx]
        if d and d.count and d.count > 0 then return true end
    end
    return false
end

local function injectOne(entity, resID, insID)
    if alreadyHave(entity, resID) then
        R.resToIns[resID] = R.resToIns[resID] or insID
        R.insToRes[insID] = resID
        return true
    end
    local row = {
        instid = insID,
        res_id = resID,
        count = 1,
        lock_cnt = 0,
        isnew = 0,
        valid_hours = 0,
        expire_ts = 0,
    }
    entity:AddData(row)
    pcall(function()
        local data = entity.GetDataByInsID and entity:GetDataByInsID(insID)
        if data and entity.LoadConfigForData and CDataTable.GetTableData then
            entity:LoadConfigForData(data, CDataTable.GetTableData)
        end
    end)
    R.insToRes[insID] = resID
    R.resToIns[resID] = insID
    log("حقن", resID, insID)
    return true
end

local function injectArmory(resID, insID)
    local wid = weaponIdFromSkin(resID)
    if not wid then return end
    local Arm = require("client.logic.armory.logic_armory")
    Arm.rsp_list = Arm.rsp_list or { skin_list = {}, install_list = {} }
    Arm.rsp_list.skin_list = Arm.rsp_list.skin_list or {}
    Arm.rsp_list.install_list = Arm.rsp_list.install_list or {}
    if not Arm.rsp_list.skin_list[wid] then Arm.rsp_list.skin_list[wid] = {} end
    Arm.rsp_list.skin_list[wid][resID] = { is_open = 1 }
    Arm.WardrobeInsList = Arm.WardrobeInsList or {}
    Arm.WardrobeInsList[resID] = insID
end

local function injectAll(entity)
    entity = entity or getEntity()
    if not entity or not entity.bInit then return false end
    local n = 0
    for i, resID in ipairs(ITEMS) do
        local insID = INS_BASE + i
        if injectOne(entity, resID, insID) then
            n = n + 1
            local c = cfg(resID)
            if GUN_SUB[subType(c)] or subType(c) == MELEE_ID then
                injectArmory(resID, insID)
            end
        end
    end
    log("حقن", n, "/", #ITEMS)
    return n > 0
end

local function refreshWardrobe()
    pcall(function()
        if EventSystem and EVENTTYPE_WARDROBE then
            if EVENTID_WARDROBE_UPDATE_ITEM_LIST then
                EventSystem:postEvent(EVENTTYPE_WARDROBE, EVENTID_WARDROBE_UPDATE_ITEM_LIST)
            end
            if EVENTID_WARDROBE_UPDATE_AVATAR_LIST then
                EventSystem:postEvent(EVENTTYPE_WARDROBE, EVENTID_WARDROBE_UPDATE_AVATAR_LIST)
            end
            if EVENTID_WARDROBE_UPDATE_GUN_LIST then
                EventSystem:postEvent(EVENTTYPE_WARDROBE, EVENTID_WARDROBE_UPDATE_GUN_LIST, -1)
            end
        end
    end)
end

-- ========== لبس ملابس (ذكي: بدلة كاملة / تيشيرت / بنطلون / حذاء) ==========
local function putOnCloth(insID)
    insID = tonumber(insID)
    local resID = R.insToRes[insID]
    if not resID then return end
    local wd = require("client.slua.logic.wardrobe.wardrobe_data")
    local d = wd:GetHallDepotItemDataByInsID(insID)
    if not d then return end

    local kind = getClothKind(resID, d)
    if not kind then return end
    local clearMap = subTypesToClearForKind(kind)
    if not clearMap then return end

    local itemSt = subType(cfg(resID)) or ST_TOP
    local oldIns, oldRes = findWornInsBySubType(itemSt)
    removeRoleWearBySubTypes(clearMap)
    clearFashionBagSlots(clearMap)
    saveEquip(resID, insID)

    local slot = PKG_SLOT
    pcall(function()
        local wfu = require("client.slua.logic.wardrobe.fashionbag.wardrobe_fashion_utils")
        local idx = wfu.GetRoleWearIndexBySubType and wfu:GetRoleWearIndexBySubType(itemSt)
        if idx then slot = idx end
    end)

    local olditem
    if oldIns and oldIns ~= insID then
        olditem = { res_id = oldRes or R.insToRes[oldIns], count = 1, instid = oldIns }
    end

    local WRH = require("client.network.Protocol.WardRobeHandler")
    local item = { res_id = resID, count = 1, instid = insID }
    WRH.on_depot_put_on_rsp(NET_OK, item, olditem, slot, insID, oldIns or 0)

    pcall(function()
        local av = require("client.slua.logic.wardrobe.logic_wardrobe_avatar")
        av:AddToWearInfo(itemSt, insID, resID, 0, 0)
        local displayResID = resID
        local LogicXSuit = require("client.slua.logic.XSuit.logic_xsuit")
        if LogicXSuit.IsXSuit(displayResID) then
            displayResID = LogicXSuit.GetItemShowID(insID) or displayResID
        end
        av:AvatarChange(displayResID, true, 0, 0)
        av:ProcessTakeOff()
        syncFashionBagRolewear()
    end)
    log("لبس", kind, resID)
end

local function putOnOutfit(insID)
    putOnCloth(insID)
end

-- ========== تجهيز سكن سلاح (مسار اللعبة الكامل) ==========
local function equipWeaponSkin(weaponID, insID)
    weaponID, insID = tonumber(weaponID), tonumber(insID)
    if not weaponID or not insID or not isInjectedIns(insID) then return end
    local resID = R.insToRes[insID]
    saveEquip(resID, insID)

    local Arm = require("client.logic.armory.logic_armory")
    local fbd = require("client.slua.logic.wardrobe.fashionbag.fashionbag_data")
    local HT = require("client.logic.lobby.hall_theme_utils")
    local wgl = require("client.slua.logic.wardrobe.logic_wardrobe_gun")

    injectArmory(resID, insID)
    Arm.rsp_list.install_list[weaponID] = { skin_id = insID }
    if fbd.UpdateCurrentFashionBagWeaponSkin then
        fbd:UpdateCurrentFashionBagWeaponSkin(weaponID, insID)
    end

    local bagIdx = fbd:GetFashionBagUseIndex()
    HT.proc_skin_list_chg("weapon_skin", weaponID, insID, bagIdx, {})

    wgl:SetGunID(weaponID)
    wgl:UpdateCurrentGunAvatar(weaponID, insID)

    if EventSystem and EVENTTYPE_ARMORY and EVENTID_ARMORY_EQUIP_STAT_CHANGE then
        EventSystem:postEvent(EVENTTYPE_ARMORY, EVENTID_ARMORY_EQUIP_STAT_CHANGE, resID)
    end
    if EventSystem and EVENTTYPE_WARDROBE and EVENTID_WARDROBE_UPDATE_CURRENT_PUT_ON_GUN then
        EventSystem:postEvent(EVENTTYPE_WARDROBE, EVENTID_WARDROBE_UPDATE_CURRENT_PUT_ON_GUN, resID)
    end
    log("سكن سلاح", weaponID, resID, insID)
end

-- ========== سوشيال — مسار خفيف (بدون تعليق عند السحب) ==========
local SOCIAL = _G.AddOutfitSocialState or {}
_G.AddOutfitSocialState = SOCIAL
SOCIAL.debGen = SOCIAL.debGen or 0
SOCIAL.wearPatchKey = SOCIAL.wearPatchKey or nil
SOCIAL.snapshotKey = SOCIAL.snapshotKey or nil
SOCIAL.fullSnapshot = SOCIAL.fullSnapshot or nil

local function socialDebounce(sec, fn)
    SOCIAL.debGen = (SOCIAL.debGen or 0) + 1
    local gen = SOCIAL.debGen
    later(sec, function()
        if gen ~= SOCIAL.debGen then return end
        pcall(fn)
    end)
end

local function getLobbyCurPage()
    local p = nil
    pcall(function()
        local LMC = require("client.slua.logic.lobby.Main.Lobby_Main_Control")
        if LMC.GetCurPage then p = LMC.GetCurPage() end
    end)
    return p
end

local function getWeaponSkinResFast()
    local cch = cache()
    local wid = tonumber(DataMgr.Weapon_ID) or 0
    local w = wid > 0 and cch.weapons[wid] or nil
    if w and w.resID and w.resID > 0 then return w.resID end
    for _, ww in pairs(cch.weapons) do
        if ww.resID and ww.resID > 0 then return ww.resID end
    end
    return nil
end

-- كل مصادر السكن (ذاكرة + MATCH_CONFIG + أرموري + حقن)
local function resolveLobbyWeaponSkinRes()
    local wid = tonumber(DataMgr.Weapon_ID) or 0
    local skin = getWeaponSkinResFast()
    if skin and skin > 0 then return skin end

    if wid > 0 then
        local fromMatch = getMatchWeaponSkin(wid)
        if fromMatch and fromMatch > 0 then return fromMatch end
    end
    if MATCH_CONFIG.weaponSkins then
        for _, s in pairs(MATCH_CONFIG.weaponSkins) do
            s = tonumber(s)
            if s and s > 0 then return s end
        end
    end

    pcall(function()
        local Arm = require("client.logic.armory.logic_armory")
        local entry = Arm.rsp_list and Arm.rsp_list.install_list
            and Arm.rsp_list.install_list[wid > 0 and wid or 101004]
        local insID = tonumber(entry and entry.skin_id) or 0
        if insID > 0 and isInjectedIns(insID) then
            skin = tonumber(R.insToRes[insID])
        elseif insID > 0 then
            local wd = require("client.slua.logic.wardrobe.wardrobe_data")
            local d = wd:GetHallDepotItemDataByInsID(insID)
            if d and d.resID then skin = tonumber(d.resID) end
        end
    end)
    if skin and skin > 0 then return skin end

    pcall(function()
        local wgl = require("client.slua.logic.wardrobe.logic_wardrobe_gun")
        if wgl.GetSkinIdByWeaponID and wid > 0 then
            local insID = tonumber(wgl:GetSkinIdByWeaponID(wid)) or 0
            if insID > 0 and isInjectedIns(insID) then
                skin = tonumber(R.insToRes[insID])
            end
        end
    end)
    return (skin and skin > 0) and skin or nil
end

local function rememberLobbyOutfitRes(resID)
    resID = tonumber(resID)
    if not resID or resID <= 0 or not isFullSuitRes(resID) then return end
    _G.AddOutfitLastLobbyOutfitRes = resID
    local cch = cache()
    if not cch.outfitRes or cch.outfitRes <= 0 then
        cch.outfitRes = resID
        if isInjectedRes(resID) then cch.outfitIns = R.resToIns[resID] end
    end
end

-- البدلة: ذاكرة + آخر بدلة في الوسط + MATCH_CONFIG + حقن + شنطة
local function resolveLobbyOutfitRes()
    local cch = cache()
    local outfitRes = tonumber(cch.outfitRes) or 0
    if outfitRes > 0 then return outfitRes end
    outfitRes = tonumber(_G.AddOutfitLastLobbyOutfitRes) or 0
    if outfitRes > 0 then return outfitRes end
    if MATCH_CONFIG.outfitRes and tonumber(MATCH_CONFIG.outfitRes) > 0 then
        return tonumber(MATCH_CONFIG.outfitRes)
    end

    local injectedRes, anyRes
    pcall(function()
        local AvatarData = require("client.logic.data.AvatarData")
        local wd = require("client.slua.logic.wardrobe.wardrobe_data")
        local function resFromIns(ins)
            ins = tonumber(ins)
            if not ins or ins <= 0 then return nil end
            if isInjectedIns(ins) then return tonumber(R.insToRes[ins]) end
            local d = wd:GetHallDepotItemDataByInsID(ins)
            return d and tonumber(d.resID) or nil
        end
        for _, ins in pairs(AvatarData.GetRoleWear()) do
            local res = resFromIns(ins)
            if res and isFullSuitRes(res) then
                if isInjectedRes(res) then injectedRes = res end
                anyRes = anyRes or res
            end
        end
        local fbd = require("client.slua.logic.wardrobe.fashionbag.fashionbag_data")
        local bag = fbd.GetCurrentFashionBag and fbd:GetCurrentFashionBag()
        if bag and bag.rolewear_list then
            for _, ins in pairs(bag.rolewear_list) do
                local res = resFromIns(ins)
                if res and isFullSuitRes(res) then
                    if isInjectedRes(res) then injectedRes = res end
                    anyRes = anyRes or res
                end
            end
        end
    end)
    if injectedRes and injectedRes > 0 then return injectedRes end
    if anyRes and anyRes > 0 then return anyRes end
    return nil
end

local function wearPatchKey()
    local outfit = resolveLobbyOutfitRes() or 0
    local skin = resolveLobbyWeaponSkinRes() or 0
    local openGun = 1
    pcall(function()
        local lds = require("client.slua.logic.wardrobe.logic_display_setting")
        if lds.data and lds.data.OpenGun ~= nil then openGun = lds.data.OpenGun and 1 or 0 end
    end)
    return outfit .. "_" .. skin .. "_" .. openGun
end

local function syncDepotShowWeaponFlags(depot)
    depot = depot or {}
    pcall(function()
        local lds = require("client.slua.logic.wardrobe.logic_display_setting")
        if lds.data then
            if lds.data.OpenGun ~= nil then depot.weapon = lds.data.OpenGun end
            if lds.data.OpenSocialWeapon ~= nil then depot.social_weapon = lds.data.OpenSocialWeapon end
        end
    end)
    return depot
end

-- تعديل pspace فقط (بدون مسح خزانة / بدون إعادة بناء كامل)
local function applyInjectedPspace(roleData)
    if not roleData then return end
    roleData.bshow = true
    roleData.pspace_wear_ext = roleData.pspace_wear_ext or {}
    local outfitRes = resolveLobbyOutfitRes()
    if outfitRes and outfitRes > 0 then
        roleData.pspace_wear_ext[ENUM_AVATAR_SHOW_TYPE.SHOW_POS_CLOTH] = { outfitRes, 0, 0 }
    end
    local skinRes = resolveLobbyWeaponSkinRes()
    if skinRes and skinRes > 0 then
        roleData.pspace_wear_ext[ENUM_AVATAR_SHOW_TYPE.SHOW_POS_WEAPON] = { 0, 0, 0 }
        roleData.pspace_wear_ext[ENUM_AVATAR_SHOW_TYPE.SHOW_POS_WEAPONSKIN] = { skinRes, 0, 0 }
        roleData.depot_show_info = roleData.depot_show_info or {}
        if roleData.depot_show_info.weapon == nil then
            roleData.depot_show_info.weapon = true
        end
    end
    roleData.depot_show_info = syncDepotShowWeaponFlags(roleData.depot_show_info)
end

local function patchSelfWearCache(force)
    local key = wearPatchKey()
    if not force and SOCIAL.wearPatchKey == key then return false end
    SOCIAL.wearPatchKey = key
    SOCIAL.snapshotKey = nil
    SOCIAL.fullSnapshot = nil

    local myUid = tonumber(DataMgr.roleData.uid)
    if not myUid then return false end

    local changed = false
    pcall(function()
        local BD = ModuleManager.GetModule(ModuleManager.DataModuleConfig.BasicDataAvatarWearInfo)
        local d = BD:GetCacheData(myUid)
        if not d then
            BD:OnHandleMsgDataAndCallback(myUid, buildLocalRoleDataForCoupleAvatar())
            return true
        end
        local oldCloth = d.pspace_wear_ext and d.pspace_wear_ext[ENUM_AVATAR_SHOW_TYPE.SHOW_POS_CLOTH]
        local oldSkin = d.pspace_wear_ext and d.pspace_wear_ext[ENUM_AVATAR_SHOW_TYPE.SHOW_POS_WEAPONSKIN]
        applyInjectedPspace(d)
        local nc = d.pspace_wear_ext[ENUM_AVATAR_SHOW_TYPE.SHOW_POS_CLOTH]
        local ns = d.pspace_wear_ext[ENUM_AVATAR_SHOW_TYPE.SHOW_POS_WEAPONSKIN]
        if oldCloth ~= nc or oldSkin ~= ns or not d.bshow then changed = true end
    end)
    return force or changed
end

local function requestSocialAvatarRefresh()
    pcall(function()
        if EventSystem and EVENTTYPE_LOBBY_SOCIAL and EVENTID_SOCIAL_LOBBY_REFRESH_AVATAR then
            EventSystem:postEvent(EVENTTYPE_LOBBY_SOCIAL, EVENTID_SOCIAL_LOBBY_REFRESH_AVATAR)
        end
    end)
end

local function onSocialWearDirty(forceRefresh)
    SOCIAL.lastHandSkin = nil
    if patchSelfWearCache(forceRefresh) then
        requestSocialAvatarRefresh()
    end
end

-- بيانات كاملة (مرة واحدة عند غياب الكاش)
local function buildLocalRoleDataForCoupleAvatar()
    local key = wearPatchKey()
    if SOCIAL.fullSnapshot and SOCIAL.snapshotKey == key then
        return SOCIAL.fullSnapshot
    end
    syncWeaponCacheFromLobby()
    local cch = cache()
    local ad = DataMgr.avatarData or {}
    local gender = tonumber(ad.gamegender) or 2
    if gender < 1 then gender = 2 end

    local data = {
        uid = DataMgr.roleData.uid,
        gender = gender,
        bshow = true,
        pspace_wear_ext = {
            [ENUM_AVATAR_SHOW_TYPE.SHOW_POS_HEAD] = { tonumber(ad.headid) or 401993, 0, 0 },
            [ENUM_AVATAR_SHOW_TYPE.SHOW_POS_HAIR] = { tonumber(ad.hairid) or 40601001, 0, 0 },
            [ENUM_AVATAR_SHOW_TYPE.SHOW_POS_WEAPON] = { 0, 0, 0 },
            [ENUM_AVATAR_SHOW_TYPE.SHOW_POS_WEAPONSKIN] = { 0, 0, 0 },
        },
        depot_show_info = {
            weapon = true, social_weapon = true, idle = true,
            helmet = true, bag = true, vehicle = true, hand = true,
        },
    }

    local outfitRes = resolveLobbyOutfitRes()
    if outfitRes and outfitRes > 0 then
        data.pspace_wear_ext[ENUM_AVATAR_SHOW_TYPE.SHOW_POS_CLOTH] = { outfitRes, 0, 0 }
    end

    local skinRes = resolveLobbyWeaponSkinRes()
    if skinRes and skinRes > 0 then
        data.pspace_wear_ext[ENUM_AVATAR_SHOW_TYPE.SHOW_POS_WEAPON][1] = 0
        data.pspace_wear_ext[ENUM_AVATAR_SHOW_TYPE.SHOW_POS_WEAPONSKIN][1] = skinRes
    end
    data.depot_show_info = syncDepotShowWeaponFlags(data.depot_show_info)
    SOCIAL.fullSnapshot = data
    SOCIAL.snapshotKey = wearPatchKey()
    return data
end

local _myUidCached
local function isMyWearData(wearData)
    if not wearData then return false end
    if not _myUidCached then
        pcall(function() _myUidCached = tonumber(DataMgr.roleData.uid) end)
    end
    return _myUidCached and tonumber(wearData.uid) == _myUidCached
end

-- سلاح في wearData (يد الشخصية — يجب weaponSkinId وليس السلاح الأساسي)
local function mergeInjectedWeaponIntoWearData(wearData)
    if not isMyWearData(wearData) then return end
    local skinRes = resolveLobbyWeaponSkinRes()
    wearData.depot_show_info = syncDepotShowWeaponFlags(wearData.depot_show_info)
    if not skinRes or skinRes <= 0 then return end
    wearData.mainWeaponInfo = wearData.mainWeaponInfo or {
        weaponResId = 0, weaponSkinId = 0,
        diyInfo = { diyWeaponId = 0, diyDefaultScheme = false, diyScheme = nil },
    }
    if wearData.mainWeaponInfo.weaponSkinId == skinRes
        and (tonumber(wearData.mainWeaponInfo.weaponResId) or 0) == 0 then
        return
    end
    wearData.mainWeaponInfo.weaponSkinId = skinRes
    wearData.mainWeaponInfo.weaponResId = 0
end

local function equipSocialHandWeapon(avatar, skinRes)
    if not avatar or not skinRes or skinRes <= 0 then return end
    if SOCIAL.lastHandSkin == skinRes then return end
    SOCIAL.lastHandSkin = skinRes
    pcall(function()
        avatar:PutonEquipment(skinRes, nil, { bIsUse = true })
    end)
end

local function shouldShowHandWeapon()
    local show = true
    pcall(function()
        local lds = require("client.slua.logic.wardrobe.logic_display_setting")
        if lds.data and lds.data.OpenGun ~= nil then
            show = lds.data.OpenGun ~= false
        end
    end)
    return show
end

-- استبدال البدلة الكاملة في WearInfoList — إزالة تيشيرت/بنطلون/حذاء المتداخلة
local function mergeInjectedOutfitIntoWearData(wearData)
    if not isMyWearData(wearData) then return end
    local outfitRes = resolveLobbyOutfitRes()
    if not outfitRes or outfitRes <= 0 or not isFullSuitRes(outfitRes) then return end
    rememberLobbyOutfitRes(outfitRes)
    local AvatarData = require("client.logic.data.AvatarData")
    local converted = AvatarData.ConvertToAvatarCustom({ outfitRes, 0, 0 })
    if not converted then return end
    local newList = {}
    for _, e in ipairs(wearData.WearInfoList or {}) do
        if e and e.ItemID and isBodyClothSubType(subType(cfg(e.ItemID))) then
            -- حذف قطع الجسم المتعارضة مع البدلة
        else
            newList[#newList + 1] = e
        end
    end
    newList[#newList + 1] = converted
    wearData.WearInfoList = newList
end

local function mergeInjectedIntoWearData(wearData)
    if not wearData then return end
    mergeInjectedWeaponIntoWearData(wearData)
    mergeInjectedOutfitIntoWearData(wearData)
end

local function reapplyLobbyEquipped()
    if not GameStatus or not GameStatus.IsInLobbyOrMainCity or not GameStatus.IsInLobbyOrMainCity() then
        return
    end
    syncWeaponCacheFromLobby()
    local curPage = getLobbyCurPage()

    if ENUM_LobbyPageType and curPage == ENUM_LobbyPageType.Left then
        onSocialWearDirty(true)
        return
    end

    local cch = cache()
    if cch.outfitIns and isInjectedIns(cch.outfitIns) then
        putOnOutfit(cch.outfitIns)
    end

    for wid, w in pairs(cch.weapons) do
        wid = tonumber(wid)
        if wid and w and w.resID and w.resID > 0 then
            if w.insID and isInjectedIns(w.insID) then
                equipWeaponSkin(wid, w.insID)
            else
                pcall(function() DataMgr.InitWeaponData(wid, w.resID, w.insID or 0) end)
            end
        end
    end

    pcall(function()
        local uid = tostring(DataMgr.roleData.uid)
        local LAM = require("client.logic.avatar.LobbyAvatarManager")
        local TAM = require("client.logic.avatar.logic_team_avatar_manager")
        local mainWid = tonumber(DataMgr.Weapon_ID) or 0
        local mw = mainWid > 0 and cch.weapons[mainWid] or nil
        if mw and mw.resID and mw.resID > 0 and TAM.GetAvatarByUid(uid) then
            LAM.EquipWeapon(uid, { weaponId = mainWid, skinId = mw.resID }, nil, true)
        end
    end)

    pcall(function()
        if EventSystem and EVENTTYPE_WARDROBE and EVENTID_WARDROBE_UPDATE_AVATAR_LIST then
            EventSystem:postEvent(EVENTTYPE_WARDROBE, EVENTID_WARDROBE_UPDATE_AVATAR_LIST)
        end
    end)
    log("إعادة تطبيق لوبي")
end

local function hookLobbySwipePersistence()
    pcall(function()
        local BD = ModuleManager.GetModule(ModuleManager.DataModuleConfig.BasicDataAvatarWearInfo)
        local oRsp = BD.on_get_avatar_show_rsp
        BD.on_get_avatar_show_rsp = function(self, res, target_uid, data)
            oRsp(self, res, target_uid, data)
                if tonumber(target_uid) == tonumber(DataMgr.roleData.uid) then
                patchSelfWearCache(true)
                SOCIAL.forceAvatarRedraw = true
                SOCIAL.lastHandSkin = nil
                if ENUM_LobbyPageType and getLobbyCurPage() == ENUM_LobbyPageType.Left then
                    requestSocialAvatarRefresh()
                end
            end
        end
    end)

    pcall(function()
        local AC = require("client.slua.logic.avatar.avatar_common")
        local oGetWear = AC.GetWearDataFromRoleData
        AC.GetWearDataFromRoleData = function(roleData)
            local wearData = oGetWear(roleData)
            if wearData and roleData and tonumber(roleData.uid) == tonumber(DataMgr.roleData.uid) then
                mergeInjectedIntoWearData(wearData)
            end
            return wearData
        end
        local oUp = AC.UpdateAvatar
        AC.UpdateAvatar = function(avatar, wearData, isShowWeapon, isShowHelmet, isShowBag)
            if isMyWearData(wearData) then
                mergeInjectedIntoWearData(wearData)
            end
            local showGun = isShowWeapon and shouldShowHandWeapon()
            if wearData and wearData.depot_show_info then
                showGun = showGun and wearData.depot_show_info.weapon ~= false
            end
            if isMyWearData(wearData) then
                for _, e in ipairs(wearData.WearInfoList or {}) do
                    if e and e.ItemID and isInjectedRes(e.ItemID) and isFullSuitRes(e.ItemID) then
                        rememberLobbyOutfitRes(e.ItemID)
                        break
                    end
                end
            end
            local ret = oUp(avatar, wearData, showGun, isShowHelmet, isShowBag)
            if showGun and isMyWearData(wearData) and avatar
                and ENUM_LobbyPageType and getLobbyCurPage() == ENUM_LobbyPageType.Left then
                local skin = tonumber(wearData.mainWeaponInfo and wearData.mainWeaponInfo.weaponSkinId) or 0
                if skin <= 0 then skin = resolveLobbyWeaponSkinRes() or 0 end
                if skin > 0 then equipSocialHandWeapon(avatar, skin) end
            end
            return ret
        end
    end)

    pcall(function()
        local CA = require("client.logic.avatar.CoupleAvatar")
        local Cfg = require("client.slua.logic.lobby.Left.CoupleAvatarConfig")
        local oMulti = CA._UpdateMultiAvatar
        if oMulti then
            CA._UpdateMultiAvatar = function(self, avatar, avatarType)
                local isSelf = avatarType == Cfg.AvatarType.Self
                    and self.SelfUID and tostring(self.SelfUID) == tostring(DataMgr.roleData.uid)
                if isSelf then
                    pcall(function()
                        local BD = ModuleManager.GetModule(ModuleManager.DataModuleConfig.BasicDataAvatarWearInfo)
                        local d = BD:GetCacheData(tonumber(self.SelfUID))
                        if d then applyInjectedPspace(d) end
                    end)
                    if SOCIAL.forceAvatarRedraw then
                        self.CompareDataCache[avatarType] = nil
                        SOCIAL.forceAvatarRedraw = nil
                    end
                end
                oMulti(self, avatar, avatarType)
                if isSelf and self.isShowWeapon ~= false and shouldShowHandWeapon()
                    and ENUM_LobbyPageType and getLobbyCurPage() == ENUM_LobbyPageType.Left then
                    local skin = resolveLobbyWeaponSkinRes()
                    if skin and skin > 0 then equipSocialHandWeapon(avatar, skin) end
                end
            end
        end
        local oHideCheck = CA.CheckSelfIsHideAvatar
        CA.CheckSelfIsHideAvatar = function(self, nSelfUId, tRoleData)
            if tostring(nSelfUId) == tostring(DataMgr.roleData.uid) then
                return false
            end
            return oHideCheck(self, nSelfUId, tRoleData)
        end

        local oUpdate = CA.Update
        CA.Update = function(self)
            local isSelf = self.SelfUID and tostring(self.SelfUID) == tostring(DataMgr.roleData.uid)
            local oHide = CA.HideAvatars
            if isSelf then
                CA.HideAvatars = function() end
            end
            local ok, err = pcall(oUpdate, self)
            CA.HideAvatars = oHide
            if not ok then log("CoupleAvatar.Update", err) end
        end

        local oRecv = CA.OnReceiveData
        CA.OnReceiveData = function(self, uid, data)
            if uid == self.SelfUID and tostring(uid) == tostring(DataMgr.roleData.uid) then
                if data then
                    applyInjectedPspace(data)
                else
                    data = buildLocalRoleDataForCoupleAvatar()
                end
            end
            return oRecv(self, uid, data)
        end
    end)

    pcall(function()
        if not EventSystem or not EventSystem.registEvent then return end
        if EVENTTYPE_LOBBY and EVENTID_SWITCHTO_PAGE_START then
            EventSystem:registEvent(EVENTTYPE_LOBBY, EVENTID_SWITCHTO_PAGE_START, function(_, _, toPage)
                if ENUM_LobbyPageType and toPage == ENUM_LobbyPageType.Left then
                    syncWeaponCacheFromLobby()
                    SOCIAL.lastHandSkin = nil
                    local o = resolveLobbyOutfitRes()
                    if o then rememberLobbyOutfitRes(o) end
                    patchSelfWearCache(true)
                    SOCIAL.forceAvatarRedraw = true
                end
            end)
        end
        if EVENTTYPE_LOBBY and EVENTID_SWITCHTO_PAGE_END then
            EventSystem:registEvent(EVENTTYPE_LOBBY, EVENTID_SWITCHTO_PAGE_END, function(_, _, _, toPage)
                if ENUM_LobbyPageType and toPage == ENUM_LobbyPageType.Left then
                    syncWeaponCacheFromLobby()
                    SOCIAL.lastHandSkin = nil
                    socialDebounce(0.45, function()
                        onSocialWearDirty(true)
                    end)
                elseif ENUM_LobbyPageType and toPage == ENUM_LobbyPageType.Mid then
                    SOCIAL.wearPatchKey = nil
                    socialDebounce(0.35, reapplyLobbyEquipped)
                end
            end)
        end
        if EVENTTYPE_LOBBY_SOCIAL and EVENTID_GOT_SOCIAL_LOBBY_SHOW_DATA then
            EventSystem:registEvent(EVENTTYPE_LOBBY_SOCIAL, EVENTID_GOT_SOCIAL_LOBBY_SHOW_DATA, function(_, _, nUId)
                if tonumber(nUId) == tonumber(DataMgr.roleData.uid) then
                    socialDebounce(0.2, function() patchSelfWearCache(false) end)
                end
            end)
        end
        if EVENTTYPE_WARDROBE and EVENTID_WARDROBE_UPDATE_CURRENT_PUT_ON_GUN then
            EventSystem:registEvent(EVENTTYPE_WARDROBE, EVENTID_WARDROBE_UPDATE_CURRENT_PUT_ON_GUN, function()
                SOCIAL.wearPatchKey = nil
                SOCIAL.snapshotKey = nil
                syncWeaponCacheFromLobby()
                if ENUM_LobbyPageType and getLobbyCurPage() == ENUM_LobbyPageType.Left then
                    socialDebounce(0.25, function() onSocialWearDirty(true) end)
                end
            end)
        end
    end)

    pcall(function()
        local lds = require("client.slua.logic.wardrobe.logic_display_setting")
        local oSwitch = lds.SwitchGun
        lds.SwitchGun = function(...)
            local r = oSwitch(...)
            SOCIAL.wearPatchKey = nil
            if ENUM_LobbyPageType and getLobbyCurPage() == ENUM_LobbyPageType.Left then
                socialDebounce(0.2, function() onSocialWearDirty(true) end)
            end
            return r
        end
    end)
end

-- ========== HOOKS ==========
local function hookDepotInit()
    pcall(function()
        local WDE = require("client.slua.logic.wardrobe.WardrobeDataEntity")
        local orig = WDE.InitData
        WDE.InitData = function(self, pkg)
            orig(self, pkg)
            injectAll(self)
            refreshWardrobe()
        end
    end)
end

local function hookWardrobeData()
    pcall(function()
        local wd = require("client.slua.logic.wardrobe.wardrobe_data")
        local function wrapGet(name)
            local o = wd[name]
            if not o then return end
            wd[name] = function(self, insID, ...)
                insID = tonumber(insID)
                if isInjectedIns(insID) then
                    local e = getEntity()
                    if e then return e:GetDataByInsID(insID) end
                end
                return o(self, insID, ...)
            end
        end
        wrapGet("GetHallDepotItemDataByInsID")
        wrapGet("GetValidHallDepotItemDataByInsID")
        local function wrapBool(name)
            local o = wd[name]
            if not o then return end
            wd[name] = function(self, id, ...)
                if isInjectedRes(tonumber(id)) or isInjectedIns(tonumber(id)) then return true end
                return o(self, id, ...)
            end
        end
        wrapBool("HasItem")
        wrapBool("HasValidItem")
        wrapBool("CheckHasPermanentItem")
    end)
end

local function hookPageFilter()
    pcall(function()
        local wl = require("client.slua.logic.wardrobe.logic_wardrobe_new")
        local o1 = wl.IsValidCurrentPageItem
        wl.IsValidCurrentPageItem = function(self, mainTab, subTab, v, t)
            if v and isInjectedRes(v.resID) and mainTab == 1 then
                if v.expireTS == 0 or not t or t < v.expireTS then
                    local st = v.itemSubType or subType(cfg(v.resID))
                    if st == ST_TOP then
                        local full = isFullSuitRes(v.resID, v)
                        if subTab == WARDROBE_TAB_SUIT and full then return true end
                        if subTab == WARDROBE_TAB_CLOTHES and not full then return true end
                    end
                    if v.subTabType == subTab then return true end
                end
            end
            return o1(self, mainTab, subTab, v, t)
        end
        local o2 = wl.IsCanUse
        wl.IsCanUse = function(self, resId)
            if isInjectedRes(resId) then return true end
            return o2(self, resId)
        end
        local o3 = wl.IsCharacterUse
        wl.IsCharacterUse = function(self, resId)
            if isInjectedRes(resId) then return true end
            return o3(self, resId)
        end
        local o4 = wl.GetWardrobeInsIdByResId
        wl.GetWardrobeInsIdByResId = function(self, resid)
            resid = tonumber(resid)
            if isInjectedRes(resid) then return R.resToIns[resid] end
            return o4(self, resid)
        end
    end)
end

local function hookArmory()
    pcall(function()
        local Arm = require("client.logic.armory.logic_armory")
        local og = Arm.GetSkinListByWeaponID
        Arm.GetSkinListByWeaponID = function(wid)
            local t = og(wid) or {}
            for resID, _ in pairs(R.resToIns) do
                if tonumber(weaponIdFromSkin(resID)) == tonumber(wid) then
                    t[resID] = t[resID] or { is_open = 1 }
                end
            end
            return t
        end
        local oa = Arm.get_weapon_skin_list_rsp
        Arm.get_weapon_skin_list_rsp = function(a, b, c, d)
            oa(a, b, c, d)
            for resID, insID in pairs(R.resToIns) do injectArmory(resID, insID) end
        end
        local oi = Arm.install_weapon_skin
        Arm.install_weapon_skin = function(cd, wid, ins)
            ins = tonumber(ins)
            if isInjectedIns(ins) then
                wid = tonumber(weaponIdFromSkin(R.insToRes[ins]) or wid)
                equipWeaponSkin(wid, ins)
                return
            end
            return oi(cd, wid, ins)
        end
    end)
    pcall(function()
        local AH = require("client.network.Protocol.ArmoryHandler")
        local o = AH.send_install_weapon_skin
        AH.send_install_weapon_skin = function(cd, wid, ins)
            ins = tonumber(ins)
            if isInjectedIns(ins) then
                wid = tonumber(weaponIdFromSkin(R.insToRes[ins]) or wid)
                equipWeaponSkin(wid, ins)
                return
            end
            return o(cd, wid, ins)
        end
    end)
end

local function hookGunSkinId()
    pcall(function()
        local wgl = require("client.slua.logic.wardrobe.logic_wardrobe_gun")
        local o = wgl.GetSkinIdByWeaponID
        wgl.GetSkinIdByWeaponID = function(self, wid)
            local c = cache()
            local w = c.weapons[wid]
            if w and isInjectedIns(w.insID) then return w.insID end
            local Arm = require("client.logic.armory.logic_armory")
            if Arm.rsp_list and Arm.rsp_list.install_list and Arm.rsp_list.install_list[wid] then
                local sid = Arm.rsp_list.install_list[wid].skin_id
                if sid and isInjectedIns(sid) then return sid end
            end
            return o(self, wid)
        end
    end)
end

local function hookPutOn()
    pcall(function()
        local WRH = require("client.network.Protocol.WardRobeHandler")
        local o = WRH.send_depot_put_on_req
        WRH.send_depot_put_on_req = function(insID, extra)
            insID = tonumber(insID)
            if isInjectedIns(insID) then
                local resID = R.insToRes[insID]
                local c = cfg(resID)
                local st = subType(c)
                local kind = getClothKind(resID)
                if kind then
                    putOnCloth(insID)
                    return
                end
                if GUN_SUB[st] then
                    local wid = weaponIdFromSkin(resID)
                    if wid then equipWeaponSkin(wid, insID) end
                    return
                end
                if st == MELEE_ID then
                    equipWeaponSkin(MELEE_ID, insID)
                    return
                end
                local wd = require("client.slua.logic.wardrobe.wardrobe_data")
                local d = wd:GetHallDepotItemDataByInsID(insID)
                if d then
                    WRH.on_depot_put_on_rsp(NET_OK, { res_id = resID, count = 1, instid = insID }, nil, 1, insID, 0, extra)
                end
                return
            end
            return o(insID, extra)
        end
    end)
end

local function hookWeaponWear()
    pcall(function()
        local HT = require("client.logic.lobby.hall_theme_utils")
        local o = HT.IsWeaponWear
        HT.IsWeaponWear = function(insId)
            insId = tonumber(insId)
            if isInjectedIns(insId) then
                local c = cache()
                local Arm = require("client.logic.armory.logic_armory")
                for wid, w in pairs(c.weapons) do
                    if tonumber(w.insID) == insId then
                        if Arm.rsp_list and Arm.rsp_list.install_list and Arm.rsp_list.install_list[wid] then
                            return tonumber(Arm.rsp_list.install_list[wid].skin_id) == insId
                        end
                        return true
                    end
                end
            end
            return o(insId)
        end
    end)
end



local function hookAvatarValid()
    pcall(function()
        local path = "GameLua.Mod.Library.GamePlay.Avatar.Component.CharacterAvatarComponent"
        local comp = require(path)
        if comp and comp.CheckItemValid then
            local o = comp.CheckItemValid
            comp.CheckItemValid = function(self, resID)
                if isInjectedRes(resID) then return true end
                return o(self, resID)
            end
        end
    end)
end

-- ========== ماتش: تطبيق البدلة والسكن ==========
local function isInRealMatch()
    local ok, r = pcall(function()
        return GameStatus and GameStatus.IsInFightingStatus and GameStatus.IsInFightingStatus()
    end)
    return ok and r == true
end

local function getLocalChar()
    local ok, GD = pcall(require, "GameLua.GameCore.Data.GameplayData")
    if not ok or not GD then return nil end
    local char = GD.GetPlayerCharacter()
    if char and slua.isValid(char) then return char end
    return nil
end

local function getWAC(char)
    local w = char and char.GetCurrentWeapon and char:GetCurrentWeapon()
    if slua.isValid(w) and slua.isValid(w.WeaponAvatarComponent) then
        return w.WeaponAvatarComponent
    end
    return nil
end



-- ===== البدلة في الماتش =====
local function getDesiredOutfit()
    if MATCH_CONFIG.outfitRes and MATCH_CONFIG.outfitRes > 0 then
        return MATCH_CONFIG.outfitRes
    end
    local c = cache()
    return c.outfitRes
end

local function matchApplyOutfit(char)
    local outfitRes = getDesiredOutfit()
    if not outfitRes then return false end
    local comp = char.CharacterAvatarComp2_BP
    if not slua.isValid(comp) then
        return false
    end
    local ok = false
    -- الطريقة الأساسية التي اشتغلت سابقاً
    pcall(function()
        comp:PutOnCustomEquipmentByID(outfitRes)
        ok = true
    end)
    -- بديل: HandleEquipItem
    if not ok then
        pcall(function()
            comp:HandleEquipItem(FItemDefineID(4, outfitRes), FAvatarCustomDefault())
            ok = true
        end)
    end
    if ok then notify("بدلة OK " .. tostring(outfitRes)) end
    return ok
end

-- ===== سكن السلاح في الماتش (آلية اللعبة: WeaponAvatarItemList على الـ controller) =====
local _avatarItemsRegistered = false

-- قائمة سكنات السلاح المطلوبة: { resID, ... } من الإعدادات + الذاكرة
local function getDesiredWeaponSkins()
    syncWeaponCacheFromLobby()
    local out, seen = {}, {}
    local function add(res)
        res = tonumber(res)
        if res and res > 0 and not seen[res] then seen[res] = true; out[#out+1] = res end
    end
    for wid, w in pairs(cache().weapons) do
        if wid ~= MELEE_ID and w.resID then add(w.resID) end
    end
    if MATCH_CONFIG.weaponSkins then
        for _, res in pairs(MATCH_CONFIG.weaponSkins) do add(res) end
    end
    return out
end

local GUN_MASTER_SYN_SLOT = 7  -- نفس GUN_MASTER_SLOT في WeaponAvatarComponent.lua

-- ===== مساعدات تحديد السلوت والمطابقة =====

-- يبحث في synData عن السلوت الذي يحتوي سكن السلاح (TypeSpecificID كبير)
local function findSkinSlotInSynData(weapon)
    if not slua.isValid(weapon) then return GUN_MASTER_SYN_SLOT, 0 end
    local arr = weapon.synData
    if not arr or not slua.isValid(arr) then return GUN_MASTER_SYN_SLOT, 0 end
    local count = 0
    pcall(function() count = arr:Num() end)
    for i = 0, math.min(count - 1, 15) do
        local ok2, att = pcall(function() return arr:Get(i) end)
        if ok2 and att then
            local ok3, defRef = pcall(slua.IndexReference, att, "defineID")
            if ok3 and defRef then
                local tid = 0
                pcall(function() tid = tonumber(defRef.TypeSpecificID) or 0 end)
                if tid >= 1000000 then
                    return i, tid
                end
            end
        end
    end
    return GUN_MASTER_SYN_SLOT, 0
end

-- يحاول الحصول على weaponTypeID من جداول البيانات
local function resolveWeaponTypeID(weaponResID)
    weaponResID = tonumber(weaponResID) or 0
    if weaponResID <= 0 then return 0 end
    local found = 0
    pcall(function()
        local wc = CDataTable.GetTableData("WeaponConfig", weaponResID)
        if wc then found = tonumber(wc.WeaponID or wc.WeaponId or wc.weaponID or 0) end
    end)
    if found > 0 then return found end
    pcall(function()
        local ic = CDataTable.GetTableData("Item", weaponResID)
        if ic then found = tonumber(ic.WeaponID or ic.weaponId or 0) end
    end)
    return found > 0 and found or weaponResID
end

local function findTargetSkinForWeaponRes(weaponResID)
    weaponResID = tonumber(weaponResID) or 0
    if weaponResID <= 0 then return nil end

    -- 0. الذاكرة / الشنطة (أولوية مثل البدلة)
    local memSkin = getMatchWeaponSkin(weaponResID)
    if memSkin then return memSkin end
    local typeID = resolveWeaponTypeID(weaponResID)
    if typeID > 0 and typeID ~= weaponResID then
        memSkin = getMatchWeaponSkin(typeID)
        if memSkin then return memSkin end
    end

    -- 1. تطابق مباشر (MATCH_CONFIG فقط إن الرقم > 0)
    if MATCH_CONFIG.weaponSkins and MATCH_CONFIG.weaponSkins[weaponResID] then
        local fixed = tonumber(MATCH_CONFIG.weaponSkins[weaponResID])
        if fixed and fixed > 0 then return fixed end
    end

    -- 2. تطابق عبر weaponIdFromSkin
    for _, skinRes in ipairs(getDesiredWeaponSkins()) do
        local wid = weaponIdFromSkin(skinRes)
        if wid and tonumber(wid) == weaponResID then return skinRes end
    end

    -- 3. تطابق عبر resolveWeaponTypeID (ResID ≠ TypeID)
    local typeID = resolveWeaponTypeID(weaponResID)
    if typeID > 0 and typeID ~= weaponResID then
        if MATCH_CONFIG.weaponSkins and MATCH_CONFIG.weaponSkins[typeID] then
            local fixed = tonumber(MATCH_CONFIG.weaponSkins[typeID])
            if fixed and fixed > 0 then return fixed end
        end
        for _, skinRes in ipairs(getDesiredWeaponSkins()) do
            local wid = weaponIdFromSkin(skinRes)
            if wid and tonumber(wid) == typeID then return skinRes end
        end
    end

    -- 4. تطابق عبر AvatarUtils parent ID
    local avatarMatch = nil
    pcall(function()
        local AU = import("AvatarUtils")
        local weaponBase = AU.GetWeaponAvatarParentID(AU.GetBPIDByResID(weaponResID), false)
        if not weaponBase or weaponBase <= 0 then return end
        for _, skinRes in ipairs(getDesiredWeaponSkins()) do
            local skinBase = AU.GetWeaponAvatarParentID(AU.GetBPIDByResID(skinRes), false)
            if skinBase and skinBase > 0 and skinBase == weaponBase then
                avatarMatch = skinRes
                return
            end
        end
    end)
    if avatarMatch then return avatarMatch end

    -- 5. تطابق عبر ItemSubType (نوع السلاح — نفس الفئة)
    local c = cfg(weaponResID)
    local st = subType(c)
    if st and GUN_SUB[st] and MATCH_CONFIG.weaponSkins then
        for _, skinRes in pairs(MATCH_CONFIG.weaponSkins) do
            local skinWid = weaponIdFromSkin(skinRes)
            if skinWid then
                local sc = cfg(tonumber(skinWid))
                if sc and subType(sc) == st then return skinRes end
            end
            -- fallback: أي سكن في MATCH_CONFIG لسلاح من نفس الفئة
            local sc = cfg(skinRes)
            if sc and GUN_SUB[subType(sc)] and subType(sc) == st then return skinRes end
        end
    end

    return nil
end

local function getSynMasterSkinID(weapon)
    if not slua.isValid(weapon) then return 0 end
    local id = 0
    pcall(function()
        local slot, tid = findSkinSlotInSynData(weapon)
        id = tid
        if id == 0 then
            local arr = weapon.synData
            if not arr or not slua.isValid(arr) then return end
            local att = arr:Get(GUN_MASTER_SYN_SLOT)
            if not att then return end
            id = slua.IndexReference(att, "defineID").TypeSpecificID or 0
        end
    end)
    return id
end

-- نفس فكرة get_skin_id في السكربت المرجعي: يحوّل معرف السلاح/السكن الحالي → سكن مطلوب
_G.AddOutfitSkinIdMappings = _G.AddOutfitSkinIdMappings or {}
_G.AddOutfitLastAppliedSkin = _G.AddOutfitLastAppliedSkin or {}

local function buildSkinMappings()
    syncWeaponCacheFromLobby()
    local m = _G.AddOutfitSkinIdMappings
    for k in pairs(m) do m[k] = nil end
    -- 1) الذاكرة أولاً (آخر سكن من الشنطة)
    for wid, w in pairs(cache().weapons) do
        wid = tonumber(wid)
        if wid and w.resID and w.resID > 0 then
            m[wid] = { tonumber(w.resID) }
        end
    end
    -- 2) MATCH_CONFIG فقط للأسلحة بدون ذاكرة
    if MATCH_CONFIG.weaponSkins then
        for weaponKey, skinRes in pairs(MATCH_CONFIG.weaponSkins) do
            weaponKey = tonumber(weaponKey)
            skinRes = tonumber(skinRes)
            if weaponKey and skinRes and skinRes > 0 and not m[weaponKey] then
                m[weaponKey] = { skinRes }
            end
        end
    end
end

local function get_skin_id(currentGunId, maxIt)
    currentGunId = tonumber(currentGunId) or 0
    maxIt = tonumber(maxIt) or 0
    if currentGunId <= 0 and maxIt <= 0 then return 0 end
    buildSkinMappings()
    if maxIt > 0 then
        local fromMem = getMatchWeaponSkin(maxIt)
        if fromMem then return fromMem end
    end
    local fromMem2 = getMatchWeaponSkin(resolveWeaponTypeID(currentGunId))
    if fromMem2 then return fromMem2 end
    local m = _G.AddOutfitSkinIdMappings
    if maxIt > 0 and m[maxIt] and m[maxIt][1] then return tonumber(m[maxIt][1]) end
    local list = m[currentGunId]
    if list and list[1] then return tonumber(list[1]) end
    local typeId = resolveWeaponTypeID(currentGunId)
    if typeId > 0 and m[typeId] and m[typeId][1] then return tonumber(m[typeId][1]) end
    local target = findTargetSkinForWeaponRes(maxIt > 0 and maxIt or currentGunId)
    if target then return target end
    return currentGunId
end

-- تطبيق سكن سلاح واحد — نفس مسار equip_weapon_avatar المرجعي (synData[7] + Set + DelayHandle)
local function applySkinToWeaponRef(CurWeapon)
    if not slua.isValid(CurWeapon) then return false end
    local AttachmentArray = CurWeapon.synData
    if not AttachmentArray or not slua.isValid(AttachmentArray) then return false end

    local AttachmentData = AttachmentArray:Get(GUN_MASTER_SYN_SLOT)
    if not AttachmentData then return false end

    local current_gunid = 0
    pcall(function()
        current_gunid = slua.IndexReference(AttachmentData, "defineID").TypeSpecificID or 0
    end)
    if not current_gunid or current_gunid <= 0 then return false end

    local MaxIt = 0
    pcall(function()
        if CurWeapon.GetWeaponID then
            MaxIt = CurWeapon:GetWeaponID()
        end
        if MaxIt <= 0 then
            MaxIt = CurWeapon:GetItemDefineID().TypeSpecificID
        end
    end)
    MaxIt = tonumber(MaxIt) or 0
    local tmp_id = get_skin_id(current_gunid, MaxIt)
    tmp_id = tonumber(tmp_id) or 0
    if tmp_id <= 0 or MaxIt <= 0 then return false end
    if tmp_id == MaxIt and tmp_id == current_gunid then return true end

    local vWriteVals = _G.AddOutfitSkinIdMappings[MaxIt] or {}
    local isSkinValid = false
    local lastSkin = _G.AddOutfitLastAppliedSkin[MaxIt]
    if lastSkin then
        for _, writeVal in ipairs(vWriteVals) do
            if tonumber(writeVal) == lastSkin then
                isSkinValid = true
                break
            end
        end
    else
        for _, writeVal in ipairs(vWriteVals) do
            if tonumber(writeVal) == tmp_id then
                isSkinValid = true
                break
            end
        end
    end

    if not isSkinValid then
        local scopeID = 0
        pcall(function()
            if CurWeapon.GetScopeID then scopeID = CurWeapon:GetScopeID(false) or 0 end
        end)
        if scopeID > 0 then
            pcall(function()
                local scopeData = AttachmentArray:Get(4)
                if scopeData then
                    slua.IndexReference(scopeData, "defineID").TypeSpecificID = scopeID
                    AttachmentArray:Set(4, scopeData)
                end
            end)
        end
    end

    _G.AddOutfitLastAppliedSkin[current_gunid] = tmp_id

    if tmp_id ~= current_gunid then
        pcall(function()
            local defRef = slua.IndexReference(AttachmentData, "defineID")
            defRef.TypeSpecificID = tmp_id
            local c0 = cfg(tmp_id)
            if c0 and c0.ItemType and defRef.Type ~= nil then
                defRef.Type = c0.ItemType
            end
            AttachmentData.operationType = 0
            AttachmentArray:Set(GUN_MASTER_SYN_SLOT, AttachmentData)
        end)
        if CurWeapon.DelayHandleAvatarMeshChanged then
            CurWeapon:DelayHandleAvatarMeshChanged()
        end
        _G.AddOutfitLastAppliedSkin[MaxIt] = tmp_id
        return true
    end
    return false
end

-- equip_weapon_avatar — نفس السكربت المرجعي (يعمل في الماتش)
function _G.equip_weapon_avatar(uCharacter)
    if not uCharacter or not slua.isValid(uCharacter) then return false end
    buildSkinMappings()
    local WeaponManager = uCharacter:GetWeaponManager()
    if not WeaponManager or not slua.isValid(WeaponManager) then return false end
    local uWeaponList = WeaponManager:GetAllInventoryWeaponList(false)
    if not uWeaponList or not slua.isValid(uWeaponList) then return false end

    local appliedAny = false
    for i = 0, uWeaponList:Num() - 1 do
        local CurWeapon = uWeaponList:Get(i)
        if slua.isValid(CurWeapon) and applySkinToWeaponRef(CurWeapon) then
            appliedAny = true
        end
    end
    return appliedAny
end

local function equipWeaponAvatarSynData(char)
    return _G.equip_weapon_avatar(char)
end

local applySkinToWeapon = applySkinToWeaponRef

-- تسجيل السكنات على الـ controller ثم تطبيقها (آلية اللعبة: ChangeWeaponAvatarList)
local function registerWeaponAvatarItems(char)
    local pc = char.GetPlayerControllerSafety and char:GetPlayerControllerSafety()
    if not slua.isValid(pc) then
        return false
    end
    local AU = import("AvatarUtils")
    local BU = import("BackpackUtils")
    local addedCount = 0

    for _, resID in ipairs(getDesiredWeaponSkins()) do
        local doneDirect = false
        pcall(function()
            if pc.AddWeaponAvatarItem then
                pc:AddWeaponAvatarItem(tonumber(resID))
                doneDirect = true
                addedCount = addedCount + 1
            end
        end)
        if not doneDirect then
            pcall(function()
                local skinBPID = BU.GetBPIDByResID(tonumber(resID))
                local arr = slua.Array(UEnums.EPropertyClass.Int)
                local parents = AU.GetWeaponAvatarParentIDList(skinBPID, arr, false)
                if parents and parents.Num and parents:Num() > 0 and pc.WeaponAvatarItemList then
                    for _, parentID in pairs(parents) do
                        pc.WeaponAvatarItemList:Add(parentID, skinBPID)
                    end
                    addedCount = addedCount + 1
                end
            end)
        end
    end

    if addedCount == 0 then
        return false
    end

    pcall(function() if pc.InitWeaponAvatarItems then pc:InitWeaponAvatarItems() end end)
    pcall(function() if pc.OnWeaponAvatarUpdate then pc:OnWeaponAvatarUpdate() end end)
    return true
end

local function reloadCurrentWeaponAvatar(char)
    pcall(function()
        local weapon = char.GetCurrentWeapon and char:GetCurrentWeapon()
        if not slua.isValid(weapon) then return end
        local wac = weapon.WeaponAvatarComponent
        if slua.isValid(wac) then
            local ES = import("EWeaponAttachmentSocketType")
            pcall(function() wac:ClearMeshPathCacheBySlot(ES.MasterGun) end)
            pcall(function() wac:ClearMeshBySlot(ES.MasterGun, true, true) end)
        end
        if weapon.DelayHandleAvatarMeshChanged then
            weapon:DelayHandleAvatarMeshChanged()
        elseif slua.isValid(wac) and wac.ReloadAllEquippedAvatar then
            local ESlotDescDiff = import("ESlotDescDiff")
            wac:ReloadAllEquippedAvatar(ESlotDescDiff.MeshDiff)
        end
    end)
end

local _weaponDiagDone = false
local _weaponApplied = false
local _lastWeaponResID = 0
local _weaponSpawnHooked = false

local function onWeaponLuaInit(_, _, weapon)
    if not weapon or not slua.isValid(weapon) then return end
    local char = getLocalChar()
    if not char then return end
    local owner = nil
    pcall(function()
        if weapon.GetOwnerPawn then owner = weapon:GetOwnerPawn() end
    end)
    if not slua.isValid(owner) or owner ~= char then return end
    pcall(function()
        char:AddGameTimer(0.15, false, function()
            local c = getLocalChar()
            if c and slua.isValid(weapon) then
                applySkinToWeapon(weapon)
                _weaponApplied = false
            end
        end)
    end)
end

local function hookWeaponSpawn()
    if _weaponSpawnHooked then return end
    pcall(function()
        if EventSystem and EventSystem.registEvent and EVENTTYPE_PLAYEREVENT_WEAPON and EVENTID_PLAYEREVENT_WEAPON_LUA_INIT then
            EventSystem:registEvent(EVENTTYPE_PLAYEREVENT_WEAPON, EVENTID_PLAYEREVENT_WEAPON_LUA_INIT, onWeaponLuaInit)
            _weaponSpawnHooked = true
        end
    end)
end

local function matchApplyWeaponSkin(char)
    if not _avatarItemsRegistered then
        _avatarItemsRegistered = registerWeaponAvatarItems(char)
    end

    local curWeapon = char.GetCurrentWeapon and char:GetCurrentWeapon()
    if not slua.isValid(curWeapon) then return false end

    local curWeaponResID = 0
    pcall(function() curWeaponResID = curWeapon:GetItemDefineID().TypeSpecificID end)
    if curWeaponResID ~= _lastWeaponResID then
        _lastWeaponResID = curWeaponResID
        _weaponApplied = false
        _weaponDiagDone = false
    end

    if _weaponApplied then return true end

    local targetSkin = findTargetSkinForWeaponRes(curWeaponResID)
    local loadedSkin = 0
    pcall(function()
        local wac = getWAC(char)
        if wac then
            loadedSkin = wac.CachedLoadedID or 0
            if loadedSkin <= 0 then
                local ES = import("EWeaponAttachmentSocketType")
                loadedSkin = wac:GetEquippedItemDefineID(ES.MasterGun).TypeSpecificID or 0
            end
        end
    end)

    local synSkin = getSynMasterSkinID(curWeapon)
    if targetSkin and (loadedSkin == targetSkin or synSkin == targetSkin) then
        _weaponApplied = true
        return true
    end

    buildSkinMappings()
    local okSyn = applySkinToWeapon(curWeapon) or equipWeaponAvatarSynData(char)

    if not _weaponDiagDone then
        _weaponDiagDone = true
        local list = table.concat(getDesiredWeaponSkins(), ",")
        notify("سلاح: res=" .. tostring(curWeaponResID)
            .. " type=" .. tostring(resolveWeaponTypeID(curWeaponResID))
            .. " target=" .. tostring(targetSkin)
            .. " syn=" .. tostring(synSkin)
            .. " loaded=" .. tostring(loadedSkin)
            .. " ctrl=" .. tostring(_avatarItemsRegistered)
            .. " skins=[" .. list .. "]")
    end

    if okSyn and char.AddGameTimer then
        pcall(function()
            char:AddGameTimer(1.0, false, function()
                local c = getLocalChar()
                if not c then return end
                local w = c.GetCurrentWeapon and c:GetCurrentWeapon()
                if not slua.isValid(w) then return end
                local wac2 = w.WeaponAvatarComponent
                if not slua.isValid(wac2) then return end
                local cid = wac2.CachedLoadedID or 0
                local synId = getSynMasterSkinID(w)
                notify("تحقق: syn=" .. tostring(synId) .. " cached=" .. tostring(cid) .. " target=" .. tostring(targetSkin))
                if targetSkin and (synId == targetSkin or cid == targetSkin) then
                    _weaponApplied = true
                end
            end)
        end)
    end

    return okSyn
end

local _matchTimer = nil
local _matchOutfitDone = false

local function startMatchWatcher(char)
    if _matchTimer then return end
    _matchOutfitDone = false
    _avatarItemsRegistered = false
    _weaponDiagDone = false
    _weaponApplied = false
    _lastWeaponResID = 0
    local elapsed = 0

    _matchTimer = char:AddGameTimer(1.5, true, function()
        elapsed = elapsed + 1.5
        local cur = getLocalChar()
        if not cur or not slua.isValid(cur) then return end

        if not _matchOutfitDone then
            _matchOutfitDone = matchApplyOutfit(cur)
        end
        matchApplyWeaponSkin(cur)

        if elapsed >= 120 then
            if _matchTimer and cur.RemoveGameTimer then
                pcall(function() cur:RemoveGameTimer(_matchTimer) end)
            end
            _matchTimer = nil
        end
    end)
end

local function stopMatchWatcher()
    if _matchTimer then
        pcall(function()
            local char = getLocalChar()
            if char and char.RemoveGameTimer then char:RemoveGameTimer(_matchTimer) end
        end)
        _matchTimer = nil
    end
    _matchOutfitDone = false
    _avatarItemsRegistered = false
    _weaponApplied = false
    _weaponDiagDone = false
    _lastWeaponResID = 0
end

local function hookPutOnRsp()
    pcall(function()
        local wl = require("client.slua.logic.wardrobe.logic_wardrobe_new")
        local o = wl.on_puton_rsp
        wl.on_puton_rsp = function(self, res, item, olditem, index, extra)
            o(self, res, item, olditem, index, extra)
            if not item or not item.instid then return end
            local resID = tonumber(item.res_id)
            local insID = tonumber(item.instid)
            if not resID or not insID then return end
            local c = cfg(resID)
            local st = subType(c)
            if getClothKind(resID) == "full_suit" and isInjectedIns(insID) then
                saveEquip(resID, insID)
            elseif GUN_SUB[st] then
                local wid = weaponIdFromSkin(resID)
                if wid then cacheWeaponSkinFromIns(wid, insID) end
            elseif st == MELEE_ID then
                cacheWeaponSkinFromIns(MELEE_ID, insID)
            elseif isInjectedIns(insID) then
                saveEquip(resID, insID)
            end
        end
    end)
end

local function hookLobbyWeaponCache()
    pcall(function()
        local Arm = require("client.logic.armory.logic_armory")
        local oRsp = Arm.install_weapon_skin_rsp
        Arm.install_weapon_skin_rsp = function(client_data, errorCode, weapon_id, instanceID)
            oRsp(client_data, errorCode, weapon_id, instanceID)
            if errorCode == 0 or errorCode == NET_OK then
                cacheWeaponSkinFromIns(weapon_id, instanceID)
            end
        end
        local oH = Arm.HandleWeaponSkinChange
        Arm.HandleWeaponSkinChange = function(client_data, weapon_id, instanceID)
            oH(client_data, weapon_id, instanceID)
            cacheWeaponSkinFromIns(weapon_id, instanceID)
        end
    end)
    pcall(function()
        local wgl = require("client.slua.logic.wardrobe.logic_wardrobe_gun")
        local o = wgl.on_put_on_weapon_wear_rsp
        wgl.on_put_on_weapon_wear_rsp = function(self, client_data, res, weapon_id, new_skin_id, extra_weapon_list)
            o(self, client_data, res, weapon_id, new_skin_id, extra_weapon_list)
            if res == 0 or res == NET_OK then
                cacheWeaponSkinFromIns(weapon_id, new_skin_id)
            end
        end
    end)
    pcall(function()
        if not EventSystem or not EventSystem.registEvent then return end
        if EVENTTYPE_WARDROBE and EVENTID_WARDROBE_UPDATE_CURRENT_PUT_ON_GUN then
            EventSystem:registEvent(EVENTTYPE_WARDROBE, EVENTID_WARDROBE_UPDATE_CURRENT_PUT_ON_GUN, function(_, _, resOrFlag, weapon_id)
                weapon_id = tonumber(weapon_id)
                if weapon_id and weapon_id > 0 then
                    pcall(function()
                        local wgl = require("client.slua.logic.wardrobe.logic_wardrobe_gun")
                        local insID = tonumber(wgl:GetSkinIdByWeaponID(weapon_id)) or 0
                        if insID > 0 then cacheWeaponSkinFromIns(weapon_id, insID) end
                    end)
                elseif tonumber(resOrFlag) and tonumber(resOrFlag) > 100000 then
                    pcall(function()
                        local wid = weaponIdFromSkin(resOrFlag)
                        if wid then
                            local wd = require("client.slua.logic.wardrobe.wardrobe_data")
                            local ins = wd.GetWardrobeInsIdByResId and wd:GetWardrobeInsIdByResId(resOrFlag)
                            if ins and ins > 0 then cacheWeaponSkinFromIns(wid, ins) end
                        end
                    end)
                end
            end)
        end
    end)
end

local function hookWardrobePutOnReq()
    pcall(function()
        local wl = require("client.slua.logic.wardrobe.logic_wardrobe_new")
        local o = wl.wardrobe_puton_req
        wl.wardrobe_puton_req = function(self, insID, extra)
            insID = tonumber(insID)
            if isInjectedIns(insID) then
                local resID = R.insToRes[insID]
                local c = cfg(resID)
                local st = subType(c)
                if getClothKind(resID) then
                    putOnCloth(insID)
                    return
                end
            end
            return o(self, insID, extra)
        end
    end)
end

local _bootstrapNotified = false

local function bootstrapMatch(char)
    char = char or getLocalChar()
    if not char or not slua.isValid(char) then return false end
    syncWeaponCacheFromLobby()
    _weaponApplied = false
    _weaponDiagDone = false
    _matchApplied = false
    if not _bootstrapNotified then
        _bootstrapNotified = true
        local cch = cache()
        local w = cch.weapons[101004]
    end
    startMatchWatcher(char)
    return true
end

local function hookMatchAvatar()
    pcall(function()
        local CAC = require("GameLua.Mod.Library.GamePlay.Avatar.Component.CharacterAvatarComponent")
        local o = CAC.OnAvatarAllMeshLoadedLua
        CAC.OnAvatarAllMeshLoadedLua = function(self)
            o(self)
            pcall(function()
                if self.IsLobbyActor and self:IsLobbyActor() then return end
                local isSelf = self.IsSelf and self:IsSelf()
                if not isSelf then return end
                local char = getLocalChar()
                if char and char.AddGameTimer then
                    char:AddGameTimer(0.5, false, function() bootstrapMatch(char) end)
                end
            end)
        end
    end)
    pcall(function()
        local WAC = require("GameLua.Mod.Library.GamePlay.Avatar.Component.WeaponAvatarComponent")
        local oLoad = WAC.OnWeaponAvatarLoadedLua
        WAC.OnWeaponAvatarLoadedLua = function(self, slotID, definedID)
            oLoad(self, slotID, definedID)
            pcall(function()
                if self.IsLobbyActor and self:IsLobbyActor() then return end
                local isSelf = self.IsSelf and self:IsSelf()
                if not isSelf then return end
                local char = getLocalChar()
                if not char then return end
                bootstrapMatch(char)
                _weaponApplied = false  -- سلاح جديد → أعد التطبيق
                if char.AddGameTimer then
                    char:AddGameTimer(0.2, false, function()
                        local c = getLocalChar()
                        if c then matchApplyWeaponSkin(c) end
                    end)
                end
            end)
        end
    end)
end

local function hookEnterGame()
    pcall(function()
        if EventSystem and EventSystem.registEvent and EVENTTYPE_LOBBY and EVENTID_ENTER_GAME_BEGIN then
            EventSystem:registEvent(EVENTTYPE_LOBBY, EVENTID_ENTER_GAME_BEGIN, function()
                syncWeaponCacheFromLobby()
                stopMatchWatcher()
                _bootstrapNotified = false
            end)
        end
    end)
end
local function start()
    log("AddOutfit v3 start")
    buildSkinMappings()
    _G.get_skin_id = get_skin_id
    _G.skinIdMappings = _G.AddOutfitSkinIdMappings
    hookDepotInit()
    hookWardrobeData()
    hookPageFilter()
    hookArmory()
    hookGunSkinId()
    hookPutOn()
    hookWeaponWear()
    hookAvatarValid()
    hookPutOnRsp()
    hookLobbyWeaponCache()
    hookLobbySwipePersistence()
    hookWardrobePutOnReq()
    hookMatchAvatar()
    hookWeaponSpawn()
    hookEnterGame()

    pcall(function()
        if isInRealMatch() then
            local char = getLocalChar()
            if char then
                notify("السكربت حُقن داخل الماتش — بدء التطبيق")
                bootstrapMatch(char)
            end
        end
    end)

    if injectAll() then
        refreshWardrobe()
        later(1.0, reapplyLobbyEquipped)
        return
    end
    local tries = 0
    local function retry()
        tries = tries + 1
        if injectAll() then
            refreshWardrobe()
            later(1.0, reapplyLobbyEquipped)
            return
        end
        if tries < 40 then later(1.5, retry) end
    end
    later(1.5, retry)
end

start()
