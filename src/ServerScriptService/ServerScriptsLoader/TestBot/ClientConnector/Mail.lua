local Globals = _G.Arcaneum
local BaseClass = Globals.ClassFunctions.Internal
local Mail = BaseClass:Extend({
    Version = 2;
    Object = script;
    Timeout = 10;
})

Mail.Statuses = {
    "Requested",
    "Processing",
    "Received",
    "Read"
}

function Mail:New(Name: string): Mail
    local Birthtime = tick()
    local NewMail = self:Extend(BaseClass:New("Mail",Name));
    NewMail.Status = 1
    NewMail.Contents = nil
    NewMail.LastUpdated = Birthtime
    NewMail.StatusLog = {
        Birthtime,
        -1,
        -1,
        -1
    }
    return NewMail
end

function Mail:GetStatus(): string
    return self.Statuses[self.Status]
end

function Mail:SetStatus(StatusCode: integer): string
    local UpdateTime = nil
    if self.Status < StatusCode then
        UpdateTime = tick()
        self.StatusLog[StatusCode] = UpdateTime
        self.Status = StatusCode
    end
    self.LastUpdated = UpdateTime or tick()
    return self:GetStatus()
end

function Mail:SetContents(Contents: any)
    self.Contents = Contents
    return self:SetStatus(3)
end

function Mail:GetContents(): any
    if self.Contents ~= nil then
        self:SetStatus(4)
        return self.Contents
    end
end

function Mail:Destroy()
    self.Status = nil
    self.Contents = nil
    self.LastUpdated = nil
    self.StatusLog = nil
    return BaseClass.Destroy(self)
end

return Mail