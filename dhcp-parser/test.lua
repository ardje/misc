
local dh=require"dhcpdp"
dh.new("/home/ard/dhcpl/dhcpd.leases")

dh.poll()
