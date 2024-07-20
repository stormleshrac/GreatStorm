--Alraptor Voraggro Amion
local s,id=GetID()
function s.initial_effect(c)
    --Xyz Summon
    Xyz.AddProcedure(c,nil,4,2,nil,nil,99)
    c:EnableReviveLimit()
    --Swap ATK and DEF
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    --Return material
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.retcon)
    e2:SetOperation(s.retop)
    c:RegisterEffect(e2)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END,0,1)
end

function s.filter(c)
    return c:IsFaceup()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local atk=tc:GetAttack()
        local def=tc:GetDefense()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(def)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e2:SetValue(atk)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() then
            c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
            c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
        end
    end
end

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetFlagEffect(id)~=0 and eg:IsExists(Card.IsReason,1,nil,REASON_BATTLE)
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(id+1)~=0 and c:GetFlagEffect(id+2)~=0 then
        Duel.Hint(HINT_CARD,0,id)
        c:AddCounter(0x1041,1)
    end
end
