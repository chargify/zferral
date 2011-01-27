RSpec::Matchers.define :be_an_array_of_campaigns do
  match do |actual|
    actual.is_a?(Array) && actual.first.is_a?(Hashie::Mash) && actual.first.respond_to?(:campaign_status_id)
  end
  
  failure_message_for_should do |actual|
    "expected an array of Campaigns, got #{actual.inspect}"
  end

  failure_message_for_should_not do |actual|
    "expected to not receive an array of Campaigns, got #{actual.inspect}"
  end
end

RSpec::Matchers.define :be_a_campaign do
  match do |actual|
    actual.is_a?(Hashie::Mash) && actual.respond_to?(:campaign_status_id)
  end
  
  failure_message_for_should do |actual|
    "expected a Campaign, got #{actual.inspect}"
  end

  failure_message_for_should_not do |actual|
    "expected not a Campaign, got #{actual.inspect}"
  end
end


