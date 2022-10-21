# Exercise 5 Part 1 (Exception Handling)

class MentalState
  def auditable?
    # true if the external service is online, otherwise false
  end
  def audit!
    # Could fail if external service is offline
    if !autiable?
      raise OfflineException.new('Exeternal Service is offline!')
    end
  end
  def do_work
    # Amazing stuff...
  end
end

def audit_sanity(bedtime_mental_state)
  if bedtime_mental_state.audit!.ok?
    MorningMentalState.new(:ok)
  else 
    MorningMentalState.new(:not_ok)
  end
end

begin
  new_state = audit_sanity(bedtime_mental_state)
rescue OfflineException => e
  e.message()
end



# Exercise 5 Part 2 (Don't Return Null / Null Object Pattern)

class BedtimeMentalState < MentalState ; end

class MorningMentalState < MentalState ; end

class NullMentalState < MentalState ; end

#Leveraging my previous implementation of raising an exception when offline and handling it with a special null object
def audit_sanity(bedtime_mental_state)
  if bedtime_mental_state.audit!.ok?
    MorningMentalState.new(:ok)
  else 
    MorningMentalState.new(:not_ok)
  end
end

begin
  new_state = audit_sanity(bedtime_mental_state)
rescue OfflineException => e
  new_state = NullMentalState.new()
end

#Alternate solution that doesn't use exception handling

# def audit_sanity(bedtime_mental_state)
#   return NullMentalState.new() unless bedtime_mental_state.auditable?
#   if bedtime_mental_state.audit!.ok?
#     MorningMentalState.new(:ok)
#   else 
#     MorningMentalState.new(:not_ok)
#   end
# end

# new_state = audit_sanity(bedtime_mental_state)
# new_state.do_work




# Exercise 5 Part 3 (Wrapping APIs)

require 'candy_service'

# machine = CandyMachine.new
# machine.prepare

#Now 3rd party CandyMachine is wrapped in MyMachine and we can control which functions are accessible
#and if CandyMachine ever breaks we only need to make changes in the wrapper
class MyMachine

  @machine = CandyMachine.new

  def prepare
    machine.prepare
  end

  def ready?
    machine.ready?
  end

  def make!
    machine.make!
  end
end

machine = MyMachine.new()
machine.prepare
if machine.ready?
  machine.make!
else
  puts "sadness"
end