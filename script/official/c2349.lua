--Guardian Fantasmal
local s,id=GetID()
function s.initial_effect(c)
    -- Definición de atributos
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,id)
    c:SetAttribute(ATTRIBUTE_DARK)
    c:SetLevel(4)

    -- Efecto de no ser destruido en batalla
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTIBLE_BATTLE)
    e1:SetValue(s.indes)
    c:RegisterEffect(e1)
end

-- Función para el efecto de no ser destruido en batalla
function s.indes(e,c)
    return c:GetBaseAttack()<=e:GetHandler():GetAttack()
end