--Alraptor Voraggro Amion
local s,id=GetID()
function s.initial_effect(c)
    --xyz summon
    Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x7a0),4,2)
    c:EnableReviveLimit()
    
    --Swap ATK and DEF
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    
    --Recover material
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_LEAVE_GRAVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCondition(s.reccon)
    e2:SetOperation(s.recop)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    e:SetLabel(Duel.GetOperatedGroup():GetFirst():GetCode())
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
    if not tc then return end
    if c:IsRelateToEffect(e) and tc:IsFaceup() then
        local atk=tc:GetAttack()
        local def=tc:GetDefense()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(def)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e2:SetValue(atk)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
    end
    e:SetLabelObject(tc)
end

function s.reccon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local tc=e:GetLabelObject():GetLabelObject()
    return bc and bc==tc and bc:IsLocation(LOCATION_GRAVE)
end

function s.recop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local code=e:GetLabelObject():GetLabel()
    if c:IsRelateToBattle() then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        Duel.Overlay(c,Group.FromCards(Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,nil,code)))
    end
end
