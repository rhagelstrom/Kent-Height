--  	Author: Ryan Hagelstrom
--	  	Copyright © 2021
--	  	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--	  	https://creativecommons.org/licenses/by-sa/4.0/

local checkMeleeDistanceBetweenTokens = nil
local getRangeBetweenTokens = nil
local checkDistanceBetweenTokens = nil
local checkDistanceBetweenTokensPack = nil

local bHeight = false
local bFlankingRange = false
local bSneakAttack = false
local bPackTactics = false

function onInit()
	aExtensions = Extension.getExtensions()
	for _,sExtension in ipairs(aExtensions) do
		tExtension = Extension.getExtensionInfo(sExtension)
		if (tExtension.name == "Token Height Indication") or (tExtension.name == "Feature: Token Height Indication") then
			bHeight = true
		end
		if (tExtension.name == "5E - Automatic Flanking and Range") then
			bFlankingRange = true
		end
		if (tExtension.name == "5E - Automatic Sneak Attack") then
			bSneakAttack = true
		end
		if (tExtension.name == "5E - Automatic Pack Tactics") then
			bPackTactics = true
		end
	end

	if bHeight and bFlankingRange then
		checkMeleeDistanceBetweenTokens = ActionAttackAFAR.checkMeleeDistanceBetweenTokens
		getRangeBetweenTokens = ActionAttackAFAR.getRangeBetweenTokens
		
		ActionAttackAFAR.checkMeleeDistanceBetweenTokens = customCheckMeleeDistanceBetweenTokens
		ActionAttackAFAR.getRangeBetweenTokens = customGetRangeBetweenTokens
	end
	if bHeight and bSneakAttack then
		checkDistanceBetweenTokens = ActionAttackBSA.checkDistanceBetweenTokens
		ActionAttackBSA.checkDistanceBetweenTokens = customCheckDistanceBetweenTokens
	end
	if bHeight and bPackTactics then
		checkDistanceBetweenTokensPack = ActionAttackPTACT.checkDistanceBetweenTokens
		ActionAttackPTACT.checkDistanceBetweenTokens = customCheckDistanceBetweenTokensPack
	end
end

function onClose()
	if bHeight and bFlankingRange then
		ActionAttackAFAR.checkMeleeDistanceBetweenTokens = checkMeleeDistanceBetweenTokens
		ActionAttackAFAR.getRangeBetweenTokens = getRangeBetweenTokens
	end
	if bHeight and bSneakAttack then
		ActionAttackBSA.checkDistanceBetweenTokens = checkDistanceBetweenTokens
	end
	if bHeight and bPackTactics then
	 	ActionAttackPTACT.checkDistanceBetweenTokens =	checkDistanceBetweenTokensPack
	end
end

function customGetRangeBetweenTokens(sourceToken, targetToken)
	local nDistance = Token.getDistanceBetween(sourceToken, targetToken)
	if nDistance == 0 then
		Debug.console("Range: Height returned 0 distance")
		return getRangeBetweenTokens(sourceToken, targetToken)
	else
		return nDistance
	end
 
end

function customCheckMeleeDistanceBetweenTokens(token, targetToken)
	local nDistance = Token.getDistanceBetween(token, targetToken)
	if nDistance == 0 then
		Debug.console("Range: Height returned 0 distance")
		return checkMeleeDistanceBetweenTokens(token, targetToken)
	else
		return nDistance <= GameSystem.getDistanceUnitsPerGrid()
	end
end

function customCheckDistanceBetweenTokens(token, targetToken)
	local nDistance = Token.getDistanceBetween(token, targetToken)
	if nDistance == 0 then
		Debug.console("SA: Height returned 0 distance")
		return checkDistanceBetweenTokens(token, targetToken)
	else
		return nDistance <= GameSystem.getDistanceUnitsPerGrid()
	end
end

function customCheckDistanceBetweenTokensPack(token, targetToken)
	local nDistance = Token.getDistanceBetween(token, targetToken)
	if nDistance == 0 then
		Debug.console("PT: Height returned 0 distance")
		return checkDistanceBetweenTokensPack(token, targetToken)
	else
		return nDistance <= GameSystem.getDistanceUnitsPerGrid()
	end
end