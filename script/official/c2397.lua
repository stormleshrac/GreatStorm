-- Dracoescudo Rrar
local s,id=GetID()
function s.initial_effect(c)
    -- Efecto de equipar
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.eqtg)
    e1:SetOperation(s.eqop)
    c:RegisterEffect(e1)
    -- Efecto de inmunidad
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(s.efilter)
    c:RegisterEffect(e2)
end
s.listed_series={0xff}
function s.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xff)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
        if Duel.Equip(tp,e:GetHandler(),tc) then
            -- Añade un efecto adicional de equipamiento
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(s.eqlimit)
            e1:SetLabelObject(tc)
            e:GetHandler():RegisterEffect(e1)
        end
    end
end
function s.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function s.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
end
