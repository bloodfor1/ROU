--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleData.AdData", package.seeall)
--lua model end

--lua functions
Ad = {}
nowAdIndex = 0
nowImgIndex = 0
function Init()
	
end --func end
--next--
function Logout()
    Ad = {}
end --func end
--next--
--lua functions end

--lua custom scripts
function GetLastAd()
    return #Ad - nowAdIndex
end

function InitAdIndex()

    nowImgIndex = 1
    nowAdIndex = 1

end

function NextAd()

    if GetLastAd() > 0 then
        nowImgIndex = 1
        nowAdIndex = nowAdIndex + 1
    end

end

function NextAdImg(isLeft)

    if isLeft then
        nowImgIndex = nowImgIndex - 1
        if nowImgIndex == 0 then
            nowImgIndex = #Ad[nowAdIndex].imageList
        end
    else
        nowImgIndex = nowImgIndex + 1
        if nowImgIndex > #Ad[nowAdIndex].imageList then
            nowImgIndex = 1
        end
    end
    return nowImgIndex

end

function GetNowAd()
    return Ad[nowAdIndex]
end

function UpdateInfo(info)

    Ad = {}
    for i = 1, #info do
        local l_data = {}
        l_data.ID = info[i].ID
        l_data.index = i
        l_data.startTime = info[i].start_time
        l_data.endTime = info[i].end_time
        l_data.imageList = {}
        for j = 1, #info[i].image_list.image_list do
            local l_imgData = {}
            l_imgData.index = j
            l_imgData.imgURL = info[i].image_list.image_list[j].img_url
            l_imgData.btnURL = info[i].image_list.image_list[j].jump_url
            l_imgData.btnName = info[i].image_list.image_list[j].btn_title
            table.insert(l_data.imageList, l_imgData)
        end
        table.insert(Ad, l_data)
    end
    InitAdIndex()

end
--lua custom scripts end
return ModuleData.AdData