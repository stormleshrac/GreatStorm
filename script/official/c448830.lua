-- Rey Sortija
local s,id=GetID()
function s.initial_effect(c)
    -- cannot summon in attack position
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,1)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.sumlimit)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    c:RegisterEffect(e2)
end

function s.condition(e)
    return e:GetHandler():IsFaceup()
end

function s.sumlimit(e,c)
    return c:IsPosition(POS_FACEUP_ATTACK)
end
