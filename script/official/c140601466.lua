--Carga Imbatible
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_DISABLED)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x7a0) and c:IsLocation(LOCATION_MZONE)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    return tc and s.cfilter(tc) and tc:IsControler(tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local tc=Duel.GetAttacker()
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc and tc:IsRelateToBattle() and tc:IsControler(tp) then
        -- Negate effects that would negate the attack
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
        e1:SetTarget(s.distg)
        e1:SetReset(RESET_PHASE+PHASE_BATTLE)
        Duel.RegisterEffect(e1,tp)
        -- Continue the attack
        Duel.ContinueAttack()
    end
end

function s.distg(e,c)
    return c:IsType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER) and c:IsNegatableMonster()
end
