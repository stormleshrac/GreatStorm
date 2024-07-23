-- Carga Imbatible
local s, id = GetID()
function s.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local atk=Duel.GetAttacker()
    local tc=Duel.GetAttackTarget()
    return atk and tc and atk:IsSetCard(0x7a0) and tc:IsControler(1-tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
    if tc and Duel.NegateEffect(tc:GetOriginalCode()) then
        local atk=Duel.GetAttacker()
        if atk:IsRelateToBattle() and not atk:IsImmuneToEffect(e) then
            Duel.ChangeAttackTarget(atk)
        end
    end
end