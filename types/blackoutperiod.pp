# Type to define BlackoutPeriods
type Backuppc::BlackoutPeriod = Struct[{
  'hour_begin' => Variant[Integer, Float],
  'hour_end'   => Variant[Integer, Float],
  'week_days'  => Array[Integer],
}]
