local m={}

--[[
use:
create a dhcp parser struct
poll -> check leases file for changes
lookups -> query current structs
close -> stop it.
]]
function m.new(filename)
end
function m:poll()
end
function m:lookupbyip(ip)
end
function m:lookupbymac(mac)
end
function m:close()
end
