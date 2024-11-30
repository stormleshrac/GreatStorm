-- Rey Sortija
local s,id=GetID()
function s.initial_effect(c)
    -- prevent normal summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,1)
    e1:SetTarget(s.sumlimit)
    c:RegisterEffect(e1)
end

function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_HAND) and sumtype&SUMMON_TYPE_NORMAL==SUMMON_TYPE_NORMAL
end
