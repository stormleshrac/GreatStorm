-- Alraptor Dual Wavva
local s, id = GetID()
function s.initial_effect(c)
    -- Gain ATK/DEF
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_RELEASE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
end

function s.filter(c, tp)
    return c:IsSetCard(0x7a0) and c:IsReleasableByEffect() and (c:IsControler(tp) or c:IsFaceup())
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, 0, 1, nil, tp) end
    Duel.SetOperationInfo(0, CATEGORY_RELEASE, nil, 1, tp, LOCATION_MZONE)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, nil, tp)
    if #g > 0 and Duel.Release(g, REASON_EFFECT) > 0 then
        local lv = g:GetFirst():GetLevel()
        if lv > 0 then
            local c = e:GetHandler()
            local atk = lv * 600
            -- Gain ATK
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(atk)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
            c:RegisterEffect(e1)
            -- Gain DEF
            local e2 = e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            c:RegisterEffect(e2)
        end
    end
end