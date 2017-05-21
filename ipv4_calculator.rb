#Given an IPv4 address and a subnet mask, compute the network,
#broadcast, and first/last host addresses

#Error message method
def invalid(message)
  puts "Invalid #{message}"
  exit
end

#Converts masks given in the form x.x.x.x/XX to subnet
def mask_to_subnet(mask)
  invalid("mask") if mask < 8 || mask > 30
  subnet = []
  for i in 0...mask/8 do subnet[i] = (2**8)-1 end
  mask = mask%8
  while subnet.length < 4
    subnet[subnet.length] = 255-((2**(8-mask))-1)
    mask = 0
  end
  subnet
end

#Validates the IP is properly written
def validate_ip(ip)
  invalid("IP") if ip[0] == 0 || ip.length != 4
  ip.each do |x|
    invalid("IP") if x < 0 || x > 255
  end
end

#Validates the subnet is properly written
def validate_subnet(subnet)
  invalid("subnet mask") if subnet[0] != 255 || subnet.length != 4
  for i in 1..3
    invalid("subnet mask") if subnet[i-1] < subnet[i]
  end
end

#Calculates and returns network and broadcast addresses
def get_network_broadcast(ip, subnet)
  network = []
  broadcast = []
  for i in 0..3
    if subnet[i] == 255
      broadcast[i] = network[i] = ip[i]
    else
      temp_broadcast = 255 - subnet[i]
      broadcast[i] = ((temp_broadcast+1)*(1+(ip[i]/temp_broadcast)))-1
      network[i] = broadcast[i]-temp_broadcast
    end
  end
  return network, broadcast
end


#Main program
puts "Enter IPv4 address with subnet in one of the following forms"
puts "192.168.0.1 255.255.255.0"
puts "OR"
puts "192.168.0.1/24"
full_address = gets.chomp

if full_address.include? "/"
  ip, mask = full_address.split("/")
  subnet = mask_to_subnet(mask.to_i)
elsif full_address.include? " "
  ip, mask = full_address.split
  subnet = mask.split(".").map { |s| s.to_i }
else
  invalid("format, exiting.")
end
ip = ip.split(".").map { |s| s.to_i }

validate_ip(ip)
validate_subnet(subnet)
network_address, broadcast_address = get_network_broadcast(ip, subnet)

first_host = network_address.dup
first_host[3] += 1
last_host = broadcast_address.dup
last_host[3] -= 1


printf "%-23s %s\n", "IP Address: ",ip.join(".")
printf "%-23s %s\n", "Subnet Mask: ",subnet.join(".")
printf "%-23s %s\n", "Network Address: ",network_address.join(".")
printf "%-23s %s\n", "Broadcast Address: ",broadcast_address.join(".")
printf "%-23s %s\n", "First Host on Subnet: ",first_host.join(".")
printf "%-23s %s\n", "Last Host on Subnet: ",last_host.join(".")
gets