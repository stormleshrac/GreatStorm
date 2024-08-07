--Rey Sortija
local s, id = GetID()
function s.initial_effect(c)
    -- Effect when summoned
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DISABLE_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)

    -- Prevent opponent from summoning in attack position
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SUMMON)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0, LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED + LOCATION_EXTRA)
    e3:SetCondition(s.condition)
    e3:SetTarget(s.sumlimit)
    c:RegisterEffect(e3)

    local e4 = e3:Clone()
    e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    c:RegisterEffect(e4)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    -- Trigger the effect automatically
end

function s.condition(e)
    return e:GetHandler():IsFaceup()
end

function s.sumlimit(e, c, sump, sumtype, sumpos, targetp)
    return sumpos == POS_FACEUP_ATTACK
end
