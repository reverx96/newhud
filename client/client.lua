local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local minimapEnabled = true
local wasMinimapEnabled = true
local IsEngineOn = true
local tempomat = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			if IsControlJustReleased(1, 246) then
				TriggerEvent('esx_customui:Engine')
			end
		else
			Citizen.Wait(50)
		end
	end
end)

local IsUsingPhone = false
local blackBars = false

-- Ukrywanie HUDa (nie ukrywa minimapy)
local hudhide = false
RegisterCommand("hud", function()  
if hudhide == false then
	hudhide = true
elseif hudhide == true then
	hudhide = false
end

	SendNUIMessage({action = "toggle_hud"}) 
end, false)

RegisterCommand("cam", function()  
	if blackBars == false then
		TriggerEvent('cocorp:cam', true)
	elseif blackBars == true then
		TriggerEvent('cocorp:cam', false)
	end
end, false)

RegisterNetEvent('cocorp:cam')
AddEventHandler('cocorp:cam', function(on)
	if on == true then
		blackBars = true
		hudhide = true
	else
		blackBars = false
		hudhide = false
	end
	SendNUIMessage({action = "toggle_hud"}) 	
end)


Citizen.CreateThread(function()
    while true do 
	Citizen.Wait(0)
		if blackBars then
			DrawRect(1.0, 1.0, 2.0, 0.25, 0, 0, 0, 255)
			DrawRect(1.0, 0.0, 2.0, 0.25, 0, 0, 0, 255)
			DisplayRadar(false)
		else
			Citizen.Wait(500)
		end	            
    end
end)


Citizen.CreateThread(function()
    while true do 
	Citizen.Wait(50)
		if blackBars then
			TriggerEvent('chat:clear')
		else
			Citizen.Wait(500)
		end	            
    end
end)


RegisterNetEvent('esx_customui:Engine')
AddEventHandler('esx_customui:Engine', function()
	local player = PlayerPedId()
	local MyPedVeh = GetVehiclePedIsIn(PlayerPedId(),false)
	local PlateVeh = GetVehicleNumberPlateText(MyPedVeh)
	if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and IsPedInAnyVehicle(PlayerPedId(), false) then
		if (IsPedSittingInAnyVehicle(player)) then 
			local vehicle = GetVehiclePedIsIn(player,false)
			
			if IsEngineOn == true then
				IsEngineOn = false
				SetVehicleEngineOn(vehicle,false,false,false)
				ESX.ShowNotification("Silnik ~g~wyłączony")			
				
			else
				IsEngineOn = true
				SetVehicleUndriveable(vehicle,false)
				SetVehicleEngineOn(vehicle,true,false,false)
				ESX.ShowNotification("Silnik ~g~włączony")
			end
			
			while (IsEngineOn == false) do
				SetVehicleUndriveable(vehicle,true)
				Citizen.Wait(0)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			if IsControlJustReleased(0, 168) then
				if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and IsPedInAnyVehicle(PlayerPedId(), false) then
					local samochod = GetVehiclePedIsIn(PlayerPedId(), false)
					local speed = GetEntitySpeed(samochod) * 3.6
					if UszkodzonyPojazd then
						TriggerEvent("pNotify:SendNotification", {text = 'Tempomat został uszkodzony! Napraw pojazd!'})
					else
						if tempomat == 0 then
							tempomat = 1
							if speed <= 50 then
								SetEntityMaxSpeed(samochod, 13.67)
								TriggerEvent("pNotify:SendNotification", {text = 'Tempomat Ustawiony na 50 km/h'})
							else
								TriggerEvent("pNotify:SendNotification", {text = 'Jedziesz powyżej 50 km/h!'})
							end
						elseif tempomat == 1 then
							tempomat = 2
							if speed <= 80 then
								SetEntityMaxSpeed(samochod, 21.87)
								TriggerEvent("pNotify:SendNotification", {text = 'Tempomat Ustawiony na 80 km/h'})
							else
								TriggerEvent("pNotify:SendNotification", {text = 'Jedziesz powyżej 80 km/h!'})
							end
						elseif tempomat == 2 then
							tempomat = 3
							if speed <= 130 then
								SetEntityMaxSpeed(samochod, 35.53)
								TriggerEvent("pNotify:SendNotification", {text = 'Tempomat Ustawiony na 130 km/h'})
							else
								TriggerEvent("pNotify:SendNotification", {text = 'Jedziesz powyżej 130 km/h!'})
							end
						elseif tempomat == 3 then
							tempomat = 4
							if speed <= 170 then
								SetEntityMaxSpeed(samochod, 46.46)
								TriggerEvent("pNotify:SendNotification", {text = 'Tempomat Ustawiony na 170 km/h'})
							else
								TriggerEvent("pNotify:SendNotification", {text = 'Jedziesz powyżej 170 km/h!'})
							end
						elseif tempomat == 4 then
							tempomat = 5
							if speed <= 200 then
								SetEntityMaxSpeed(samochod, 54.66)
								TriggerEvent("pNotify:SendNotification", {text = 'Tempomat Ustawiony na 200 km/h'})
							else
								TriggerEvent("pNotify:SendNotification", {text = 'Jedziesz powyżej 200 km/h!'})
							end
						elseif tempomat == 5 then
							tempomat = 0
							TriggerEvent("pNotify:SendNotification", {text = 'Tempomat wyłączony.'})
							SetEntityMaxSpeed(samochod, GetVehicleHandlingFloat(samochod,"CHandlingData","fInitialDriveMaxFlatVel"))
						end			
					end			
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)


-- pasy

local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

IsCar = function(veh)
        local vc = GetVehicleClass(veh)
        return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end 

Fwv = function (entity)
        local hr = GetEntityHeading(entity) + 90.0
        if hr < 0.0 then hr = 360.0 + hr end
        hr = hr * 0.0174533
        return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

--------- PASY 
Citizen.CreateThread(function()
  while true do
  Citizen.Wait(2)
  
    local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then

		local car = GetVehiclePedIsIn(ped)	
		RequestStreamedTextureDict('mpinventory')
		while not HasStreamedTextureDictLoaded('mpinventory') do
			Citizen.Wait(0)
		end    
			if car ~= 0 and (wasInCar or IsCar(car)) then
			  wasInCar = true

			  if beltOn then DisableControlAction(0, 75) end

			  speedBuffer[2] = speedBuffer[1]
			  speedBuffer[1] = GetEntitySpeed(car)
			  
			  if speedBuffer[2] ~= nil 
				 and not beltOn
				 and GetEntitySpeedVector(car, true).y > 1.0  
				 and speedBuffer[1] > 19.25 
				 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
				 
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			  end
				
			  velBuffer[2] = velBuffer[1]
			  velBuffer[1] = GetEntityVelocity(car)
				
			  if IsControlJustReleased(0, 182) and GetLastInputMethod(0) then
				beltOn = not beltOn 
				if beltOn then 
				  TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "belton", 0.5)

				else 
				  TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "beltoff", 0.5)

		 
				end
			  end
			  
			elseif wasInCar then
			  wasInCar = false
			  beltOn = false
			  speedBuffer[1], speedBuffer[2] = 0.0, 0.0

			end
		else
			beltOn = false
			Citizen.Wait(500)
		end
	end
end)

---- HUD Prędkościomierza
local isDriving = false;
local isUnderwater = false;
local enginehealth = 1000;
local getdoorlock = nil;
local highbeamsOn = nil;
local a1,a2,a3;

Citizen.CreateThread(function()
    while true do
        Wait(50)
        if isDriving and IsPedInAnyVehicle(PlayerPedId(), true) then
            local veh = GetVehiclePedIsUsing(PlayerPedId(), false)
            local speed = math.floor(GetEntitySpeed(veh) * 3.6)
            local vehhash = GetEntityModel(veh)
            local maxspeed = GetVehicleModelMaxSpeed(vehhash) * 3.6
			enginehealth = GetVehicleEngineHealth(veh)
			getdoorlock =	GetVehicleDoorLockStatus(veh)
			highbeamsOn = GetVehicleLightsState(veh)
			a1,a2,a3 = GetVehicleLightsState(veh)
			local vehicleGear = GetVehicleCurrentGear(veh)

			if (speed == 0 and vehicleGear == 0) or (speed == 0 and vehicleGear == 1) then
				vehicleGear = 'N'
			elseif speed > 0 and vehicleGear == 0 then
				vehicleGear = 'R'
			end
            SendNUIMessage({speed = speed, maxspeed = maxspeed, gear = vehicleGear})
		else
			Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if Config.ShowSpeedo then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                isDriving = true
                SendNUIMessage({showSpeedo = true})
            elseif not IsPedInAnyVehicle(PlayerPedId(), false) then
                isDriving = false
                SendNUIMessage({showSpeedo = false})
            end
        end
    end
end)
-------------------------------------------------------------------------------



--			Nazwy ulic
local zones = { ['AIRP'] = "Lotnisko LS", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "Klub Golfowy", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port LS", ['ZQ_UAR'] = "Davis Quartz" }
local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', }
local lokalizacja = ''
local tekstkierunek = ''

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		local current_zone = zones[GetNameOfZone(pos.x, pos.y, pos.z)]

		for k,v in pairs(directions)do
			direction = GetEntityHeading(GetPlayerPed(-1))
			if(math.abs(direction - k) < 22.5)then
				direction = v
				break;
			end
		end

		if(GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z)) then
			if(zones[GetNameOfZone(pos.x, pos.y, pos.z)] and tostring(GetStreetNameFromHashKey(var1))) then
				tekstLokalizacji = tostring(GetStreetNameFromHashKey(var1))
				tekstkierunek = direction
			end
		end

	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(250)
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  
		if veh ~= 0 and not inVehicle then
			inVehicle = true
		elseif veh == 0 and inVehicle then
			inVehicle = false
		end
		
		local eon = IsVehicleEngineOn(veh)
		IsUsingPhone = GlobalState.TelefonON 
		conditionengine = inVehicle and not VehBool
		conditionphone = IsUsingPhone and not phonebool
  
  
		if conditionphone or conditionengine then
			VehBool = true
			phonebool = true
			if hudhide == false then
			DisplayRadar(1)
			elseif hudhide == true then
			DisplayRadar(0)
			end
  
		elseif not inVehicle and VehBool and not IsUsingPhone and phonebool then
			VehBool = false
			phonebool = false
  
			Citizen.Wait(32)
				DisplayRadar(0)
			
  
  
		end
	end
  end)

  local hudvision = false
  local hudvisionstart = false
-- Podstawa!!! Wysyłanie info do JS
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

		if IsControlJustPressed(0, 348) then
			if hudvision == false then
				hudvision = true
				elseif hudvision == true then
					hudvision = false
				  end
		end	

    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(500)

        if IsPedSwimmingUnderWater(PlayerPedId()) then
            isUnderwater = true
            SendNUIMessage({showOxygen = true})
        elseif not IsPedSwimmingUnderWater(PlayerPedId()) then
            isUnderwater = false
            SendNUIMessage({showOxygen = false})
        end

        TriggerEvent('esx_status:getStatus', 'hunger',
                     function(status) hunger = status.val / 10000 end)
        TriggerEvent('esx_status:getStatus', 'thirst',
                     function(status) thirst = status.val / 10000 end)

					 
			local hp = GetEntityHealth(PlayerPedId()) - 100
            local armor = GetPedArmour(PlayerPedId())
            local stress = LocalPlayer.state.stress

        SendNUIMessage({
            action = "update_hud",
            oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10,
            talking = isTalking,
			engineon = IsEngineOn,
			pasyon = beltOn,
			enginebroken = enginehealth,
			doorlock = getdoorlock,
			kompas = kompasval,
			prowadzi = isDriving,
			lokalizacja1 = tekstLokalizacji,
			tekstkierunek1 = tekstkierunek,
			b1 = a1,
			b2 = a2,
			b3 = a3,
        })

		if hudvision == false then
			SendNUIMessage({
				action = "update_hud2",
			  })
			end

			if hudvision == true then
				SendNUIMessage({
					action = "update_hud1",
					hp = hp,
					armor = armor,
					hunger = hunger,
					thirst = thirst,
					stress = stress,
				  })
			  end



        if IsPauseMenuActive() then
            SendNUIMessage({showUi = false})
        elseif not IsPauseMenuActive() then
            SendNUIMessage({showUi = true})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(200)
        local isTalking = NetworkIsPlayerTalking(PlayerId())  
		local voice = exports['mumble-voip']:VoiceState()
        SendNUIMessage({
            action = "update_voice",
            talking = isTalking,
			voicelev = voice,
        })
	end
end)


local ide = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))
Citizen.CreateThread(function()
    Wait(1000)
    while true do
		if hudhide == false then
		miid(1.561, 0.652, 1.2,1.2,0.6, "~w~ID:~y~ ".. ide .. '', 255, 255, 255, 255)
		end
        Citizen.Wait(7)
    end
end)

function miid(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
	SetTextColour( 0,0,0, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end


Citizen.CreateThread(function()
	SetRadarZoom(1100)
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
    SetMapZoomDataLevel(4, 24.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
    SetMapZoomDataLevel(5, 55.0, 0.0, 0.1, 2.0, 1.0) -- ZOOM_LEVEL_GOLF_COURSE
    SetMapZoomDataLevel(6, 450.0, 0.0, 0.1, 1.0, 1.0) -- ZOOM_LEVEL_INTERIOR
    SetMapZoomDataLevel(7, 4.5, 0.0, 0.0, 0.0, 0.0) -- ZOOM_LEVEL_GALLERY
    SetMapZoomDataLevel(8, 11.0, 0.0, 0.0, 2.0, 3.0) -- ZOOM_LEVEL_GALLERY_MAXIMIZE
end)

--------------------------------------------------------


--- OPISY



local opisy = {}

local displayOpisHeight = -0.1
local playerOpisDist = 7

local red = 255
local green = 255
local blue = 255

function DrawText3DOpis(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov*0.6

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(red, green, blue, 255)
        SetTextDropshadow(3, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
		    World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end

RegisterNetEvent('cocorp:opis')
AddEventHandler('cocorp:opis', function(player, opis)
    local info = opis
    local ajdi = player
	if info == nil then
		return
	else
		opisy[ajdi] = info
	end
end)

RegisterNetEvent('cocorpID:distance')
AddEventHandler('cocorpID:distance', function(bool)
    ignorePlayerNameDistance = bool
end)

RegisterNetEvent('cocorp:opisInnychGraczy')
AddEventHandler('cocorp:opisInnychGraczy', function()
    local AjDi = GetPlayerServerId(PlayerId())
    local MojOpis = opisy[AjDi]
    TriggerServerEvent('cocorp:opisInnychGraczyServer', AjDi, MojOpis)
end)
				
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
		local letsleep = true
        for _, player in ipairs(GetActivePlayers()) do
            N_0x31698aa80e0223f8(player)
        end
        for _, player2 in ipairs(GetActivePlayers()) do
            local ajdi = GetPlayerServerId(player2)
            if (opisy[ajdi] ~= nil and tostring(opisy[ajdi]) ~= '') then

                ped = GetPlayerPed( player2 )
                blip = GetBlipFromEntity( ped )

                xx1, yy1, zz1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
                xx2, yy2, zz2 = table.unpack( GetEntityCoords( GetPlayerPed( player2 ), true ) )
                distance2 = math.floor(GetDistanceBetweenCoords(xx1,  yy1,  zz1,  xx2,  yy2,  zz2,  true))
				
                if ((distance2 < playerOpisDist)) then
					letsleep = false
					red = 230
					green = 255
                    blue = 255
                    local tekst = tostring(opisy[ajdi])
                    local words = {}
                    for word in tekst:gmatch("%w+") do table.insert(words, word) end
                    if #tekst > 40 then
                        local part1 = ''
                        local part2 = ''
                        local srodek = math.floor(#words * 0.5)
                        local srodek2 = srodek + 1
                        for i=1, srodek do
                            part1 = part1..words[i]..' '
                        end
                        for i=srodek+1, #words do
                            if i ~= #words then
                                part2 = part2..words[i]..' '
                            elseif i ==  #words then
                                part2 = part2..words[i]
                            end
                        end
                        DrawText3DOpis(xx2, yy2, zz2 + displayOpisHeight, part1..'~n~'..part2)
                    else
                        DrawText3DOpis(xx2, yy2, zz2 + displayOpisHeight, tekst)
                    end
                end

            end
        end
		if letsleep then
			Citizen.Wait(1000)
		end
    end
end)
