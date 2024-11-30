-- Rey Sortija
local s,id=GetID()
function s.initial_effect(c)
    -- Activate effect when summoned
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.sumlimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    Duel.RegisterEffect(e2,tp)
end

function s.condition(e)
    return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end

function s.sumlimit(e,c)
    return c:IsPosition(POS_FACEUP_ATTACK)
end
