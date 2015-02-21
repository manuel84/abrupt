# /lib/abrupt/transformation/client/visit.rb

def add_visit_duration
  leavetime = Abrupt.parse_time(@values[:leavetime])
  enterteime = Abrupt.parse_time(@values[:entertime])
  if leavetime && enterteime # maybe not recognized
    visit_duration = (leavetime - enterteime).to_f # in seconds
    add_data_property('visitDuration', visit_duration)
  end
end