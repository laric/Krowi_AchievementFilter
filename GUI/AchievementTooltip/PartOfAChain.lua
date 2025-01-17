-- [[ Namespaces ]] --
local _, addon = ...;
local section = {};

local firstAchievement;
function section.CheckAdd(achievement)
	if not addon.Options.db.Tooltip.Achievements.ShowPartOfAChain then
		return;
	end
    local id = addon.GetFirstAchievementId(achievement.Id);
    firstAchievement = addon.Data.Achievements[id];
    return firstAchievement.NextAchievements ~= nil;
end

local function AddPartOfAChainAchievement(currentAchievement, id, nameSuffix)
	addon.GUI.AchievementTooltip.AddAchievementLine(currentAchievement, id, addon.Options.db.Tooltip.Achievements.ShowCurrentCharacterIconsPartOfAChain, nameSuffix);
	local achievement = addon.Data.Achievements[id];
	local nextAchievements = achievement.NextAchievements;
	if nextAchievements == nil then
		return;
	end
	for nextId, _ in next, nextAchievements do
		if achievement.NumNextAchievements > 1 then
			if addon.Data.Achievements[nextId].Faction then
				nameSuffix = " (";
				if addon.Data.Achievements[nextId].Faction then
					nameSuffix = nameSuffix .. addon.L[addon.Objects.Faction[addon.Data.Achievements[nextId].Faction]];
					nameSuffix = nameSuffix .. ")";
				end
			end
		end
		AddPartOfAChainAchievement(currentAchievement, nextId, nameSuffix);
	end
end

function section.Add(achievement)
	GameTooltip:AddLine(addon.L["Part of a chain"]); -- Header
	AddPartOfAChainAchievement(achievement, firstAchievement.Id);
end

tinsert(addon.GUI.AchievementTooltip.Sections, section);