-- AIraptor Yagga
local s,id=GetID()
function s.initial_effect(c)
    -- Nivel 4 al ser invocado
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_COST)
    e1:SetOperation(s.lvop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SPSUMMON_COST)
    c:RegisterEffect(e2)
    -- Ataca dos veces
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetLevel()~=4 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(4)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
    end
end
