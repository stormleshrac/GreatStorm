--Nueva Calma
local s,id = GetID()
function s.initial_effect(c)
    -- Activar en respuesta a un ataque
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

-- Condición para activar: tener un monstruo de Raza Guerrero en el cementerio
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil)
end

-- Filtro para buscar monstruos de Raza Guerrero en el cementerio
function s.filter(c)
    return c:IsRace(RACE_WARRIOR)
end

-- Objetivo de la carta: negar el ataque
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

-- Activación de la carta: cancelar el ataque
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateAttack()
end
