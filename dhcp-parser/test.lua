#!/usr/bin/lua
local m={}
local dhcpdp=require"dhcpdp"
function m.time()
	-- fake time according to our leases file
  	-- starts 4 2013/12/05 12:26:50;
	return (os.time{year=2013,month=12,day=5,hour=12,minute=26,sec=52})
end
function m.new(newlease)
end
function m.delete(newlease,oldlease)
end
function m.update(newlease,olddease)
end
function m.change(newlease,oldlease)
end
local dh=assert(dhcpdp.new("/home/ard/dhcpl/dhcpd.leases~",m.time))

dh:poll()

for k,v in pairs(dh.ip) do
	print(k, v.mac,v.ends)
	io.write(string.format("%10.10s %10.10s %s\n",k,v.mac,v.ends))
end
for m,v in pairs(dh.mac) do
	io.write(m," :")
	for ip,v in pairs(v) do
		io.write(" ",ip)
	end
	io.write("\n")
end
