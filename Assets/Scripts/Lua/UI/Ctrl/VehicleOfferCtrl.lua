--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/VehicleOfferPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
VehicleOfferCtrl = class("VehicleOfferCtrl", super)
--lua class define end

local Mgr = MgrMgr:GetMgr("VehicleMgr")

--lua functions
function VehicleOfferCtrl:ctor()

	super.ctor(self, CtrlNames.VehicleOffer, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function VehicleOfferCtrl:Init()
	self.panel = UI.VehicleOfferPanel.Bind(self)
	super.Init(self)
    self.offerList = {}
    self.doList = false
end --func end
--next--
function VehicleOfferCtrl:Uninit()
	super.Uninit(self)
	self.panel = nil
end --func end

--next--
function VehicleOfferCtrl:OnActive()
	self.totalTime = 9
	self.remainTime = 9
    if self.uiPanelData ~= nil then
        if self.uiPanelData.openType == MgrMgr:GetMgr("VehicleMgr").EOpenType.AddOfferInfo then
            self:AddOfferInfo(self.uiPanelData.nameTxt, self.uiPanelData.labTxt, self.uiPanelData.closeFuc, self.uiPanelData.okFuc, self.uiPanelData.totalTime, self.uiPanelData.cTime, self.uiPanelData.timeOverIsCancle, self.uiPanelData.strBtnYesKey)
        elseif self.uiPanelData.openType == MgrMgr:GetMgr("VehicleMgr").EOpenType.SetVehicleInfo then
            self:SetVehicleInfo(self.uiPanelData.driverUid, self.uiPanelData.passengerUid, self.uiPanelData.isDriver)
        end
    end
end --func end

--next--
function VehicleOfferCtrl:OnDeActive()
	self.totalTime = nil
	self.remainTime = nil
    self.offerList = {}
    self.doList = false
end --func end

--next--
function VehicleOfferCtrl:Update()
	if self.remainTime == nil then
		return
	end

    if not self.doList then
        self.remainTime = self.remainTime - UnityEngine.Time.deltaTime
        if self.remainTime <= 0 then
            UIMgr:DeActiveUI(UI.CtrlNames.VehicleOffer)
        else
            self.panel.Slider.Slider.value = self.remainTime / self.totalTime
        end
    else
        self:ShowOfferList()
    end
end --func end




--next--
function VehicleOfferCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function VehicleOfferCtrl:SetVehicleInfo(driver_uuid, passenger_uuid, is_driver)
    local driver = MEntityMgr:GetEntity(driver_uuid)
    if MLuaCommonHelper.IsNull(driver) or (not driver.IsRideVehicle) then
        UIMgr:DeActiveUI(UI.CtrlNames.VehicleOffer)
        return
    end
	local vehicleName = TableUtil.GetVehicleTable().GetRowByID(driver.VehicleCtrlComp.VehicleID).Name
	if is_driver then
		local passenger = MEntityMgr:GetEntity(passenger_uuid)
		self.panel.TxName.LabText = passenger.Name
		self.panel.TxAsk.LabText = StringEx.Format(Common.Utils.Lang("VEHICLE_ASK"), vehicleName)
	else
		self.panel.TxName.LabText = driver.Name
		self.panel.TxAsk.LabText = StringEx.Format(Common.Utils.Lang("VEHICLE_INVITE"), vehicleName)
	end
	self.panel.BtClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.VehicleOffer)
	end)
	self.panel.BtYes:AddClick(function()
		Mgr.RequestGetOnVehicleAgree(driver_uuid, passenger_uuid)
		UIMgr:DeActiveUI(UI.CtrlNames.VehicleOffer)
	end)
end

function VehicleOfferCtrl:AddOfferInfo(nameTxt,labTxt,closeFunc,okFunc,totalTime,cTime,timeOverIsCancle,strBtnYesKey)
    self.doList = true
    local offerData = {}
    offerData.nameTxt = nameTxt
    offerData.labTxt = labTxt
    offerData.closeFunc = closeFunc
    offerData.okFunc = okFunc
    offerData.totalTime = totalTime
    offerData.cTime = cTime
    offerData.timeOverIsCancle = timeOverIsCancle
    offerData.strBtnYesKey = strBtnYesKey
    table.insert(self.offerList,offerData)
end

function VehicleOfferCtrl:SetBtnYesName(strBtnKey)
    if strBtnKey == nil or strBtnKey == "" then
        strBtnKey = "FRAME_TIP_CONFIRM"
    end
    self.panel.TxBtnYesName.LabText = Common.Utils.Lang(strBtnKey)
end

function VehicleOfferCtrl:ShowInfoByData(data)
    self.panel.TxName.LabText = data.nameTxt
    self.panel.TxAsk.LabText = data.labTxt
    self:SetBtnYesName(data.strBtnYesKey);

	self.panel.BtClose:AddClick(function()
        if data.closeFunc ~= nil then
            data.closeFunc()
        end
        if table.maxn(self.offerList) > 0 then
           table.remove(self.offerList, 1)
        else
           UIMgr:DeActiveUI(UI.CtrlNames.VehicleOffer)
        end
	end)

	self.panel.BtYes:AddClick(function()
        if data.okFunc ~= nil then
            data.okFunc()
        end
        if table.maxn(self.offerList) > 0 then
           table.remove(self.offerList, 1)
        else
           UIMgr:DeActiveUI(UI.CtrlNames.VehicleOffer)
        end
	end)
end

function VehicleOfferCtrl:ShowOfferList()

    if table.maxn(self.offerList) > 0 then
        local cData = self.offerList[1]
        if cData.cTime < cData.totalTime then
            cData.cTime = cData.cTime + UnityEngine.Time.deltaTime
            self:ShowInfoByData(cData)
            self.panel.Slider.Slider.value = (1- (cData.cTime / cData.totalTime))
        else
            if cData.timeOverIsCancle ~= true then
                if cData.okFunc ~= nil then
                    cData.okFunc()
                end
            else
                if cData.closeFunc ~= nil then
                    cData.closeFunc()
                end
            end
            table.remove(self.offerList, 1)
        end
    else
        UIMgr:DeActiveUI(UI.CtrlNames.VehicleOffer)
    end
end
--lua custom scripts end
