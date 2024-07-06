-- Catedral Invertida
local s,id=GetID()
function s.initial_effect(c)
    -- Activar
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<=2000 and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,2,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,1,1,nil)
    local g2=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    if #g1>0 and #g2>0 then
        Duel.HintSelection(g1)
        Duel.HintSelection(g2)
        Duel.SwapControl(g1:GetFirst(),g2:GetFirst(),RESET_EVENT+RESETS_STANDARD)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        g1:GetFirst():RegisterEffect(e1)
        g2:GetFirst():RegisterEffect(e1:Clone())
    end
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(300)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
