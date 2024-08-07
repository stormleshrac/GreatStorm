--Rey Sortija
local s,id=GetID()
function s.initial_effect(c)
    --Cannot summon in attack position
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    c:RegisterEffect(e2)
end
function s.condition(e)
    return e:GetHandler():IsFaceup()
end
function s.target(e,c)
    return c:IsPosition(POS_FACEUP_ATTACK)
end
