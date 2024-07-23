--Carga Imbatible
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x7a0) and c:IsType(TYPE_MONSTER)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at and at:IsControler(tp) and at:IsSetCard(0x7a0) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local at=Duel.GetAttacker()
    if at and at:IsRelateToBattle() and at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x7a0) then
        --Unaffected by opponent's card effects
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(s.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        e1:SetOwnerPlayer(tp)
        at:RegisterEffect(e1)
    end
end

function s.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
