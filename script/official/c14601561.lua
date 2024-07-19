--Alraptor Yagga
local s,id=GetID()
function s.initial_effect(c)
	--Special summon effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)
	--Double attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetCondition(s.atkcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end

function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- Reduce level to 4
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e1)
end

function s.atkcon(e)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end