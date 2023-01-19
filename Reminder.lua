script_name("reminder-by-ronald-benent")
script_version("19.01.2023")

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/DEBIJI/Remined-By-Ronald-Benent/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/DEBIJI/Remined-By-Ronald-Benent"
        end
    end
end

script_author('Ronald_Bennet')
script_description('Hello, i hack your PC hehehe')
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local cfg = inicfg.load({
	Remind={
		hours = 0,
		minuts = 0,
		countR = 2
	},
	RemindOn={
		remindActivate = false
	},
	RemindR={
		rr = 'Напоминалке'
	}
}, "Reminder")

local tag = '{0087FF}Reminder: {FFFFFF}'
local scriptname = 'reminder-by-ronald-bennet'
local scriptversion = 'v0.0.1'

mcx = 0x0087FF
mc = '{0087FF}'
ff = '{FFFFFF}'

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(100)
    end
    -- вырежи тут, если хочешь отключить проверку обновлений
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    -- вырежи тут, если хочешь отключить проверку обновлений
   
    -- дальше идёт ваш код
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end

	if not doesFileExist('moonloader/config/Reminder.ini') then
        if inicfg.save(cfg, 'Reminder.ini') then sampfuncsLog(tag..'Создан файл конфигурации: Reminder.ini') end
    end

	sampRegisterChatCommand('remind', cmd_remind)
    sampRegisterChatCommand('remindt', cmd_remindt)
    sampRegisterChatCommand('remindc', cmd_remindc)

	sampAddChatMessage(tag..'Скрипт '..mc..scriptname..' {FFFFFF}| '..mc..scriptversion..ff..' Загружен!', mcx)
	sampAddChatMessage(tag..'Команды: '..mc..'/remind'..ff..' | '..mc..'/remindt'..ff..' | '..mc..'/remindc', mcx)

	while true do
        nowHours = tonumber(os.date("%H", os.time()))
        nowMinuts = tonumber(os.date("%M", os.time()))

        if cfg.RemindOn.remindActivate then
            if (nowHours == cfg.Remind.hours) and (nowMinuts == cfg.Remind.minuts) then
                alarm()
            end
        end
		wait(0)
    end
end

function cmd_remind(arg)
	local hour, minute = string.match(arg, "(%d+)%s(%d+)")
	result = (hour ~= nil) and (minute ~= nil)
	if result then 
		hour_s = tonumber(hour)
		minute_s = tonumber(minute)
		if ((hour_s>-1) and (hour_s <24)) and ((minute_s>-1) and (minute_s<60)) then
			hour_ss = hour_s
			minute_ss = minute_s
			if hour_s<10 then hour_ss = ('0'..hour_s) end
			if minute_s<10 then minute_ss = ('0'..minute_s) end
			sampAddChatMessage(tag..'Напоминалка уставновленна на '..hour_ss..':'..minute_ss, mcx)set_remind()
		else
			sampAddChatMessage(tag.."Вы ввели не корректное время", mcx)
		end
	else
		sampAddChatMessage(tag..'Использование '..mc..'/remind'..ff..' [час] [минуты]', mcx)
	end
end

function cmd_remindt(arg)
	if #arg == 0 then sampAddChatMessage(tag..'Вы не ввели текст напоминания.', mcx)
	else 
        cfg.RemindR.rr = arg
		inicfg.save(cfg, "Reminder.ini")
		sampAddChatMessage(tag..'Вы успешно изменили текст напоминания на '..mc..arg,mcx)
	end
end

function cmd_remindc(arg)
	if #arg==0 then sampAddChatMessage(tag..'Используйте '..mc..'/remindc [кол-во]',mcx)
    else
        local argCount = string.match(arg, "(%d+)")
        if argCount ~= nil then
            sampAddChatMessage(tag..'Вы успешно изменили кол-во строк напоминания на '..mc..argCount..ff..', было '..mc..cfg.Remind.countR..'',mcx)--сообщение об успешной замене текста
            cfg.Remind.countR = argCount
            inicfg.save(cfg, "Reminder.ini")
        else 
            sampAddChatMessage(tag..'Введите число ', mcx)
        end
    end
end

function alarm()
    for i = 1, cfg.Remind.countR, 1 do
         sampAddChatMessage(tag..'Мы напоминаем вам о '..mc..cfg.RemindR.rr, mcx)
    end
    cfg.RemindOn.remindActivate = false
    inicfg.save(cfg, "Reminder.ini")
end

function set_remind()
    cfg.RemindOn.remindActivate = true
    cfg.Remind.hours = hour_ss
    cfg.Remind.minuts = minute_ss
    inicfg.save(cfg, "Reminder.ini")
end
