
local dhcpdp=require"dhcpdp"
local dh=assert(dhcpdp.new("/home/ard/dhcpl/dhcpd.leases"))

dh:poll()
