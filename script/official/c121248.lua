--Oculus el Majestuoso
local s,id=GetID()
function s.initial_effect(c)
    --Link Summon
    c:EnableReviveLimit()
    Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FUSION),1,1)
    Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_WARRIOR),1,1)
    
    --Negate effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.negcon)
    e1:SetTarget(s.negtg)
    e1:SetOperation(s.negop)
    c:RegisterEffect(e1)
    
    --Direct attack with ATK reduction
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.atkcon)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    --Prevent attacking this turn
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsHasEffect(EFFECT_CANNOT_ATTACK)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        --Reduce ATK by 1000
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        --Direct attack
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DIRECT_ATTACK)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
    end
end
