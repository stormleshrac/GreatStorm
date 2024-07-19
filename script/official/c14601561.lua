--Alraptor Yagga
local s,id=GetID()
function s.initial_effect(c)
    --Set level to 4 when summoned
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_COST)
    e1:SetOperation(s.lvop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SPSUMMON_COST)
    c:RegisterEffect(e2)
    
    --Double attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    e3:SetCondition(s.atkcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
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
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
