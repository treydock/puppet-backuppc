# Type to define DHCPAddressRanges
type Backuppc::DHCPAddressRange = Struct[{
  'ip_addr_base' => String,
  'first'        => Integer,
  'last'         => Integer,
}]
