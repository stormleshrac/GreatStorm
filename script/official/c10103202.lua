--Omega Rodo Apex
local s,id=GetID()
function s.initial_effect(c)
    -- Cannot be Normal Summoned/Set
    c:EnableUnsummonable()
    -- Special summon when Mega Rodo Divino is face-up on the field
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e2)
    -- Destroy all cards and gain ATK/DEF
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)
    -- Destroy at end of turn
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetOperation(s.desop2)
    c:RegisterEffect(e4)
end

function s.spfilter(c,tp)
    return c:IsFaceup() and c:IsCode(10103203)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
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
