-- =========================================================================
-- UI COUNTER - Permanent Bot / Player / Total Counter Widget
-- Centered, clean rendering (recreates widget on text change)
-- =========================================================================
local require = require
local import  = import
local isValid = slua.isValid

local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local game_frontend_hud = require("game_frontend_hud")

local BTN_BP = "/Game/UMG/UI_BP/Common/BaseComponent/CommonBaseComponent_TextButton_UIBP.CommonBaseComponent_TextButton_UIBP"
local Z_COUNTER = 9900

local counterWidget = nil
local lastText = ""
local cachedPawns = {}
local lastPawnRefresh = 0

local function IsPawnAlive(p)
    if not isValid(p) then return false end
    if p.HealthStatus then
        return SecurityCommonUtils and SecurityCommonUtils.IsHealthStatusAlive(p.HealthStatus)
    end
    if p.IsAlive then return p:IsAlive() end
    local health = p.GetHealth and p:GetHealth()
    return health and health > 0 or false
end

local function CountEnemies(localChar, currentPawn)
    local botCount, playerCount = 0, 0
    local myTeamId = 0
    pcall(function()
        if isValid(localChar) and localChar.TeamID then
            myTeamId = localChar.TeamID
        elseif isValid(currentPawn) and currentPawn.TeamID then
            myTeamId = currentPawn.TeamID
        end
    end)
    local now = os.time()
    if now - lastPawnRefresh >= 1 then
        lastPawnRefresh = now
        pcall(function() cachedPawns = Game:GetAllPlayerPawns() or {} end)
    end
    for _, p in pairs(cachedPawns) do
        if isValid(p) and p ~= currentPawn and p ~= localChar then
            local pTeamId = 0
            pcall(function() pTeamId = p.TeamID or 0 end)
            if pTeamId ~= myTeamId and IsPawnAlive(p) then
                local isBot = false
                pcall(function()
                    if Game.IsAI then isBot = Game:IsAI(p)
                    elseif type(p.IsAI) == "function" then isBot = p:IsAI()
                    elseif p.bIsAI ~= nil then isBot = p.bIsAI end
                end)
                if isBot then botCount = botCount + 1
                else playerCount = playerCount + 1 end
            end
        end
    end
    return botCount, playerCount
end

local function DestroyWidget()
    if counterWidget then
        pcall(function()
            if isValid(counterWidget) then
                counterWidget:RemoveFromParent()
            end
        end)
        counterWidget = nil
    end
end

local function CreateWidget(text)
    DestroyWidget()
    pcall(function()
        counterWidget = slua.loadUI(BTN_BP)
        if not counterWidget or not isValid(counterWidget) then
            counterWidget = nil
            return
        end

        counterWidget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)

        if counterWidget.Button_Temp then
            if counterWidget.Button_Temp.OnClicked then
                counterWidget.Button_Temp.OnClicked:Clear()
            end
            counterWidget.Button_Temp:SetIsEnabled(false)
        end

        if counterWidget.RichText_Content then
            counterWidget.RichText_Content:SetText(text)
        end

        game_frontend_hud.AddToContainer(UIContainers.Top, counterWidget, Z_COUNTER)

        local slot = import("WidgetLayoutLibrary").SlotAsCanvasSlot(counterWidget)
        if slot then
            slot:SetAnchors(FAnchors(0.5, 0, 0.5, 0))
            slot:SetAlignment(FVector2D(0.5, 0))
            slot:SetPosition(FVector2D(0, 50))
            slot:SetSize(FVector2D(500, 40))
        end
    end)
end

local function UpdateCounterText(botCount, playerCount)
    local total = botCount + playerCount
    local text = string.format("BOT : %d     PLAYER : %d     TOTAL : %d", botCount, playerCount, total)

    if text ~= lastText then
        lastText = text
        CreateWidget(text)
    end

    _G._Counter_Bots = botCount
    _G._Counter_Players = playerCount
    _G._Counter_Total = total
end

local function CounterTick()
    pcall(function()
        local uCon = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not isValid(uCon) then return end
        local currentPawn = uCon:GetCurPawn()
        if not isValid(currentPawn) then return end
        local localChar = uCon:GetPlayerCharacterSafety()
        local botCount, playerCount = CountEnemies(localChar, currentPawn)
        UpdateCounterText(botCount, playerCount)
    end)
end

local function TryInit()
    pcall(function()
        local uCon = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if isValid(uCon) and uCon:GetCurPawn() then
            if not _G._UICounterTimerStarted then
                _G._UICounterTimerStarted = true
                if _G._UICounterTimer then
                    pcall(function() Game:ClearTimer(_G._UICounterTimer) end)
                end
                _G._UICounterTimer = Game:SetTimer(1, true, CounterTick)
                CounterTick()
            end
        else
            Game:SetTimer(2, false, TryInit)
        end
    end)
end

Game:SetTimer(1, false, TryInit)

return {
    CountEnemies = CountEnemies,
    CounterTick = CounterTick,
    CreateWidget = CreateWidget,
    DestroyWidget = DestroyWidget,
    UpdateCounterText = UpdateCounterText
}