
--[[

  Enchant Tips
  Display potency rune levels and unknown rune translations
  version 0.6.9
  by RogueEffect

]]

local EnchantTips = {
  name = "EnchantTips",
  font = "ZoFontGame",
  color = ZO_ColorDef:New(255/255, 31/255, 190/255),
}



local PotencyRunes = {
  [45855] = {type = 1, level = "1"},
  [45856] = {type = 1, level = "5"},
  [45857] = {type = 1, level = "10"},
  [45806] = {type = 1, level = "15"},
  [45807] = {type = 1, level = "20"},
  [45808] = {type = 1, level = "25"},
  [45809] = {type = 1, level = "30"},
  [45810] = {type = 1, level = "35"},
  [45811] = {type = 1, level = "40"},
  [45812] = {type = 1, level = "CP 10"},
  [45813] = {type = 1, level = "CP 30"},
  [45814] = {type = 1, level = "CP 50"},
  [45815] = {type = 1, level = "CP 70"},
  [45816] = {type = 1, level = "CP 100"},
  [64509] = {type = 1, level = "CP 150"},
  [68341] = {type = 1, level = "CP 160"},
  [45817] = {type = -1, level = "1"},
  [45818] = {type = -1, level = "5"},
  [45819] = {type = -1, level = "10"},
  [45820] = {type = -1, level = "15"},
  [45821] = {type = -1, level = "20"},
  [45822] = {type = -1, level = "25"},
  [45823] = {type = -1, level = "30"},
  [45824] = {type = -1, level = "35"},
  [45825] = {type = -1, level = "40"},
  [45826] = {type = -1, level = "CP 10"},
  [45827] = {type = -1, level = "CP 30"},
  [45828] = {type = -1, level = "CP 50"},
  [45829] = {type = -1, level = "CP 70"},
  [45830] = {type = -1, level = "CP 100"},
  [64508] = {type = -1, level = "CP 150"},
  [68340] = {type = -1, level = "CP 160"},
}

local OtherRunes = {
  [45831] = "Health",
  [45832] = "Magicka",
  [45833] = "Stamina",
  [45834] = "Health Regen",
  [45835] = "Magicka Regen",
  [45836] = "Stamina Regen",
  [45837] = "Poison",
  [45838] = "Fire",
  [45839] = "Frost",
  [45840] = "Shock",
  [45841] = "Disease",
  [45842] = "Armor",
  [45843] = "Power",
  [45846] = "Alchemist",
  [45847] = "Physical Harm",
  [45848] = "Spell Harm",
  [45849] = "Shield",
  [68342] = "Prism",
  [45850] = "|cFFFFFFBase|r",
  [45851] = "|c00FF00Fine|r",
  [45852] = "|c4488EESuperior|r",
  [45853] = "|cFF33FFArtifact|r",
  [45854] = "|cFFDD00Legendary|r",
}



function EnchantTips.TooltipText(itemId)
  if PotencyRunes[itemId] then
    local type = "Positive"
    if PotencyRunes[itemId].type == -1 then
      type = "Negative"
    end
    return "Minimum level " .. PotencyRunes[itemId].level .. ", " .. type
  end
  if OtherRunes[itemId] then
    return OtherRunes[itemId]
  end
end

function EnchantTips.KnownRune(itemLink)
  local _, name = GetItemLinkEnchantingRuneName(itemLink)
  return name ~= nil
end

function EnchantTips.GetItemLinkItemId(itemLink)
  local match = string.match(itemLink, "|H%d+:item:(%d+):%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+|h|h")
  return tonumber(match)
end

function EnchantTips.AddTooltipLine(itemLink, tooltip)
  local itemId = EnchantTips.GetItemLinkItemId(itemLink)
  if not PotencyRunes[itemId] and not OtherRunes[itemId] then return end
  if OtherRunes[itemId] and EnchantTips.KnownRune(itemLink) then return end
  
  local ttLine = EnchantTips.TooltipText(itemId)
  tooltip:AddVerticalPadding(8)
  tooltip:AddLine(ttLine, EnchantTips.font, EnchantTips.color:UnpackRGB())
end



function EnchantTips.SetAttachedMailItem(orgFunc, tooltip, mailId, attachementIndex, ...)
  orgFunc(tooltip, mailId, attachementIndex, ...)
  local itemLink = GetAttachedItemLink(mailId, attachementIndex)
  EnchantTips.AddTooltipLine(itemLink, tooltip)
end

function EnchantTips.SetBagItem(orgFunc, tooltip, bagId, slotIndex, ...)
  orgFunc(tooltip, bagId, slotIndex, ...)
  local itemLink = GetItemLink(bagId, slotIndex)
  EnchantTips.AddTooltipLine(itemLink, tooltip)
end

function EnchantTips.SetBuybackItem(orgFunc, tooltip, index, ...)
  orgFunc(tooltip, index, ...)
  local itemLink = GetBuybackItemLink(index)
  EnchantTips.AddTooltipLine(itemLink, tooltip)
end

function EnchantTips.SetLink(orgFunc, tooltip, itemLink, ...)
  orgFunc(tooltip, itemLink, ...)
  EnchantTips.AddTooltipLine(itemLink, tooltip)
end

function EnchantTips.SetLootItem(orgFunc, tooltip, lootId)
  orgFunc(tooltip, lootId)
  local itemLink = GetLootItemLink(lootId)
  EnchantTips.AddTooltipLine(itemLink, tooltip)
end

function EnchantTips.SetStoreItem(orgFunc, tooltip, index)
  orgFunc(tooltip, index)
  local itemLink = GetStoreItemLink(index)
  EnchantTips.AddTooltipLine(itemLink, tooltip)
end

function EnchantTips.SetTradeItem(orgFunc, tooltip, who, tradeIndex, ...)
  orgFunc(tooltip, who, tradeIndex, ...)
  local itemLink = GetTradeItemLink(who, tradeIndex, LINK_STYLE_DEFAULT)
  EnchantTips.AddTooltipLine(itemLink, tooltip)
end

function EnchantTips.SetTradingHouseItem(orgFunc, tooltip, index)
  orgFunc(tooltip, index)
  local itemLink = GetTradingHouseListingItemLink(index)
  EnchantTips.AddTooltipLine(itemLink, tooltip)
end

function EnchantTips.SetTradingHouseListing(orgFunc, tooltip, index)
  orgFunc(tooltip, index)
  local itemLink = GetTradingHouseListingItemLink(index)
  EnchantTips.AddTooltipLine(itemLink, tooltip)
end



local function hookFunc(map, name, hook)
  local orgFunc = map[name]
  map[name] = function(...)
    return hook(orgFunc, ...)
  end
end

function EnchantTips.InitHooks()
  hookFunc(ItemTooltip,  "SetAttachedMailItem",    EnchantTips.SetAttachedMailItem)
  hookFunc(ItemTooltip,  "SetBagItem",             EnchantTips.SetBagItem)
  hookFunc(ItemTooltip,  "SetBuybackItem",         EnchantTips.SetBuybackItem)
  hookFunc(PopupTooltip, "SetLink",                EnchantTips.SetLink)
  hookFunc(ItemTooltip,  "SetLootItem",            EnchantTips.SetLootItem)
  hookFunc(ItemTooltip,  "SetStoreItem",           EnchantTips.SetStoreItem)
  hookFunc(ItemTooltip,  "SetTradeItem",           EnchantTips.SetTradeItem)
  hookFunc(ItemTooltip,  "SetTradingHouseItem",    EnchantTips.SetTradingHouseItem)
  hookFunc(ItemTooltip,  "SetTradingHouseListing", EnchantTips.SetTradingHouseListing)
end



local function OnAddOnLoaded(event, addonName)
  if addonName ~= EnchantTips.name then
    return
  end
  EnchantTips.InitHooks()
  EVENT_MANAGER:UnregisterForEvent(EnchantTips.name, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(EnchantTips.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
