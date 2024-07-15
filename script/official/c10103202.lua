--Omega Rodo Apex
local s,id=GetID()
function s.initial_effect(c)
    -- Cannot be Normal Summoned/Set
    c:EnableUnsummonable()
    -- Special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    -- Destroy all cards except this one and gain ATK/DEF
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(s.destg)
    e2:SetOperation(s.desop)
    c:RegisterEffect(e2)
    -- Destroy at end of turn
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetOperation(s.desop2)
    c:RegisterEffect(e3)
end

function s.spfilter(c)
    return c:IsFaceup() and c:IsCode(10103203)
end

function s.spcon(e,c)
    if c==nil then return true end
    return Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    -- No cost required for special summoning
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
    g:RemoveCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
    g:RemoveCard(c)
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
        local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
        if ct>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(ct*1000)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
            c:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            c:RegisterEffect(e2)
        end
    end
end

function s.desop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
