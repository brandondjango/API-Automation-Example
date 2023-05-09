Given(/^the following API request:$/) do |json|
  # Running the text through the parser in order to clean up whitespace
  @json_request = JSON.parse(json).to_json
end

When(/^the "(.*)" request is sent$/) do | request_type|
  last_char_of_call = @endpoint_url.slice(@endpoint_url.length - 1)
  if last_char_of_call == "?" || last_char_of_call == "&"
    @endpoint_url = @endpoint_url.chop
  end

  @header_hash ||= {}

  print "\n\n#{@endpoint_url}\n\n#{@header_hash}\n\n"

  begin
    case request_type.downcase
    when "get"
      result = RestClient.get(@endpoint_url, @header_hash)
    when "post"
      result = RestClient.post(@endpoint_url, @json_request)
    when "delete"
      result = RestClient.delete(@endpoint_url, @json_request)
    else
      raise RuntimeError, "Request type: #{request_type} is invalid"
    end
  rescue => e
    print e
    result = e.response
  end

  @response = result
  print "\n\nResponse code: #{@response.code}\nResponse header: #{@response.headers} \nRESPONSE:\n" + @response + "\n\n"
end

When(/^the "(.*)" xml request is sent$/) do | request_type|
  last_char_of_call = @endpoint_url.slice(@endpoint_url.length - 1)
  if last_char_of_call == "?" || last_char_of_call == "&"
    @endpoint_url = @endpoint_url.chop
  end

  @header_hash ||= {}

  print "\n\n#{@endpoint_url}\n\n#{@header_hash}\n\n"

  begin
    case request_type.downcase
    when "get"
      result = RestClient.get(@endpoint_url, @header_hash)
    when "post"
      result = RestClient.post(@endpoint_url, @json_request)
    when "delete"
      result = RestClient.delete(@endpoint_url, @json_request)
    else
      raise RuntimeError, "Request type: #{request_type} is invalid"
    end
  rescue => e
    print e
    result = e.response
  end

  @response = result
  #print "\n\nResponse code: #{@response.code}\nResponse header: #{@response.headers} \nRESPONSE:\n" + @response + "\n\n"
  hash = Hash.from_xml(@response)
  print hash
end



Then(/^the following response is received:$/) do |json|
  print JSON.parse(json).class
  print "\n\n#{JSON.parse(json).keys}"
  expect(JSON.parse(json) == JSON.parse(@response)).to (be true), "Expected response: \n\n #{JSON.parse(json)} \n\n Observed Response:\n\n#{JSON.parse(@response)}"
end

And(/^the status code is "([^"]*)"$/) do |status_code|
  expect(@response.code).to eq(status_code.to_i)
end

And(/^the status code is "([^"]*)" or "([^"]*)"$/) do |status_code, status_code2|
  expect(@response.code.to_s.eql?(status_code) || @response.code.to_s.eql?(status_code2)).to eq(true), "Expected status code to be #{status_code.to_s} or #{status_code2.to_s} but it was #{@response.code.to_s}"
end

Given(/^I set the request of my call to the file "([^"]*)"$/) do |call_file|
  request = YAML.load(File.read("api_calls/" + call_file))
  @json_request = JSON.parse(json).to_json
end

Then(/^I expect the response to match the call in file "([^"]*)"$/) do |response_file|
  expected_json_request = JSON.load(File.read("api_calls/" + response_file))
  #print expected_json_request.flatten
  #print "\n\n#{expected_json_request.keys}"
  expect(expected_json_request == JSON.parse(@response)).to (be true), "Expected response: \n\n #{expected_json_request} \n\n Observed Response:\n\n#{JSON.parse(@response)}"
end

When(/^the request is built for "([^"]*)"$/) do |call|
  @endpoint_url = YAML.load(File.read("./config/api_config.yaml"))["host"]
  #@endpoint_url = load_all('C:\Users\BrandonLockridge\IdeaProjects\API-Automation-Example\config\api_config.yaml')["host"]
  @endpoint_url += "#{call}?"
end

And(/^I add the parameter "([^"]*)" with value "([^"]*)"$/) do |key, value|
  @endpoint_url += "#{key}=#{value}&"
end

And(/^the response contains the key "([^"]*)" with the value "([^"]*)"$/) do |key, value|
  expect(hash_contains_key_with_value?(JSON.parse(@response), key, value)).to (be true), "Expected a key \"#{key}\" with a value \"#{value}\" to be in the following response but it was not:\n\n#{@response}"
end

And(/^the response does not contain the key "([^"]*)" with the value "([^"]*)"$/) do |key, value|
  expect(hash_contains_key_with_value?(JSON.parse(@response), key, value)).to (be false), "Expected a key \"#{key}\" with a value \"#{value}\" to be in the following response but it was:\n\n#{@response}"
end

And(/^the response contains the key "([^"]*)" with the boolean value "([^"]*)"$/) do |key, value|
  expect(hash_contains_key_with_value?(JSON.parse(@response), key, value.include?("true"))).to (be true), "Expected a key \"#{key}\" with a value \"#{value}\" to be in the following response but it was not:\n\n#{@response}"
end

And(/^the response header contains the key "([^"]*)"$/) do |key|
  expect(hash_contains_the_key?(@response.headers, key.to_sym)).to (be true), "Expected a header key \"#{key}\" following response but it was not:\n\n#{@response.headers.to_s}"
end

And(/^the response header contains the key "([^"]*)" with the value "([^"]*)"$/) do |key, value|
  expect(hash_contains_key_with_value?(JSON.parse(@response.headers), key.to_sym, value)).to (be true), "Expected a header key \"#{key}\" with a value \"#{value}\" to be in the following response but it was not:\n\n#{@response.headers}"
end

And(/^the response contains the key "([^"]*)" that contains the value "([^"]*)" within the value for that key$/) do |key, value|
  expect(hash_contains_key_with_value_that_contains_value?(JSON.parse(@response), key, value)).to (be true), "Expected a key \"#{key}\" with a value \"#{value}\" to be in the following response but it was not:\n\n#{@response}"
end

And(/^the response does not contain the key "([^"]*)" that contains the value "([^"]*)" within the value for that key$/) do |key, value|
  expect(hash_contains_key_with_value_that_contains_value?(JSON.parse(@response), key, value)).to (be false), "Expected a key \"#{key}\" with a value \"#{value}\" to NOT be in the following response but it was:\n\n#{@response}"
end

And(/^the header response contains the key "([^"]*)" that contains the value "([^"]*)" within the value for that key$/) do |key, value|
  expect(hash_contains_key_with_value_that_contains_value?(@response.headers, key.to_sym, value)).to (be true), "Expected a header key \"#{key}\" with a value \"#{value}\" to be in the following response but it was not:\n\n#{@response.headers}"
end

And(/^the header response does not contain the key "([^"]*)" that contains the value "([^"]*)" within the value for that key$/) do |key, value|
  expect(hash_contains_key_with_value_that_contains_value?(@response.headers, key.to_sym, value)).to (be false), "Did not expect a header key \"#{key}\" with a value \"#{value}\" to be in the following response but it was:\n\n#{@response.headers}"
end

And(/^I add the header parameter "([^"]*)" with value "([^"]*)"$/) do |header_key, header_value|
  @header_hash ||= {}
  @header_hash = @header_hash.merge({header_key => header_value})
end

Then(/^the keys "([^"]*)" in the response should be sorted in alphabetical order$/) do |key|
  expect(keys_in_hash_in_alphabetical_order?(JSON.parse(@response), key)).to (be true), "Expected keys \"#{key}\" in response to be in order but they were not"
end

Then(/^the keys "([^"]*)" in the response should be sorted in REVERSE alphabetical order$/) do |key|
  expect(keys_in_hash_in_reverse_alphabetical_order?(JSON.parse(@response), key)).to (be true), "Expected keys \"#{key}\" in response to be in order but they were not"
end

And(/^the key\(s\) "([^"]*)" contained in object "([^"]*)" do not contain "([^"]*)"$/) do |key, object_key, value|
  expect(value_contained_in_key_within_hash_object?(JSON.parse(@response), key, object_key, value)).to (be false), "Expected key \"#{key}\" within object \"#{object_key}\"in response to be in order to not contain \"#{value}\" but it did"
end

And(/^all keys "([^"]*)" should contain the value "([^"]*)"$/) do |key, value|
  expect(hash_contains_keys_all_with_value?(JSON.parse(@response), key, value)).to (be true), "Expected all keys \"#{key}\" to have a value \"#{value}\" in the following response but it was not:\n\n#{@response}"
end

And(/^all keys "([^"]*)" should contain the value "([^"]*)" or "([^"]*)"$/) do |key, value, value2|
  expect(hash_contains_keys_all_with_one_of_two_values?(JSON.parse(@response), key, value, value2)).to (be true), "Expected all keys \"#{key}\" to have a value \"#{value}\" or \"#{value2}\" in the following response but it was not:\n\n#{@response}"
end

And(/^all keys "([^"]*)" should contain the value "([^"]*)", "([^"]*)", or "([^"]*)"$/) do |key, value, value2, value3|
  expect(hash_contains_keys_all_with_one_of_three_values?(JSON.parse(@response), key, value, value2, value3)).to (be true), "Expected all keys \"#{key}\" to have a value \"#{value}\", \"#{value2}\", or \"#{value3}\" in the following response but it was not:\n\n#{@response}"
end

And(/^the response contains the array key "([^"]*)" with the hash key "([^"]*)" the hash value "([^"]*)"$/) do |array_key, hash_key,  hash_value|
  expect(hash_contains_array_key_with_key_value?(JSON.parse(@response), array_key, hash_key, hash_value)).to (be true), "Expected an array key \"#{array_key}\" with a hash key \"#{hash_key}\" with a hash value \"#{hash_value}\" to be in the following response but it was not:\n\n#{@response}"
end

And(/^the response contains the array key "([^"]*)" with the hash key "([^"]*)" the hash boolean value "([^"]*)"$/) do |array_key, hash_key,  hash_value|
  expect(hash_contains_array_key_with_key_value?(JSON.parse(@response), array_key, hash_key, (hash_value == "true"))).to (be true), "Expected an array key \"#{array_key}\" with a hash key \"#{hash_key}\" with a hash value \"#{hash_value}\" to be in the following response but it was not:\n\n#{@response}"
end

And(/^the key "([^"]*)" should return an integer$/) do |key|
  expect(hash_contains_key_of_data_type?(JSON.parse(@response), key, "Integer")).to (be true), "Expected \"#{JSON.parse(@response)[key]}\" to return an Integer records but it returned a value of class #{JSON.parse(@response)[key].class}"
end

And(/^all values of key "([^"]*)" should return an integer$/) do |key|
  expect(hash_contains_all_key_of_data_type?(JSON.parse(@response), key, "Integer")).to (be true), "Expected \"#{JSON.parse(@response)[key]}\" to return an Integer records but it returned a value of class #{JSON.parse(@response)[key].class}"
end

And(/^the key "([^"]*)" should return an integer value of "([^"]*)"$/) do |key, value|
  expect(hash_contains_key_with_value_that_contains_integer?(JSON.parse(@response), key, value)).to (be true), "Expected response to return \"#{value}\" but it"
end

And(/^the key "([^"]*)" should not return an integer value of "([^"]*)"$/) do |key, value|
  expect(hash_contains_key_with_value_that_contains_integer?(JSON.parse(@response), key, value)).to (be false), "Expected response to not return \"#{value}\" but it did"
end

And(/^the key "([^"]*)" should return a float value of "([^"]*)"$/) do |key, value|
  expect(hash_contains_key_with_value_that_contains_float?(JSON.parse(@response), key, value)).to (be true), "Expected response to return \"#{value}\" but it was not in \"#{JSON.parse(@response)}\""
end

And(/^the key "([^"]*)" should return a float value around "([^"]*)"$/) do |key, expected_value|
  actual_value = first_value_from_key(JSON.parse(@response), key).to_f
  expected_value = expected_value.to_f
  validation_boolean = (((expected_value-1) < actual_value) && ((expected_value + 1 ) > actual_value))
  expect(validation_boolean).to (be true), "Expected response to return a value around \"#{expected_value}\" but it was not in \"#{JSON.parse(@response)}\""
end

Given(/^User does API get request "([^"]*)"$/) do |query_string|
  @response = ApiRequest.discovery_stratus_api(query_string)
end

Then(/^the response contains the "([^"]*)" that contains the "([^"]*)" within$/) do |key, nested_key|
  expect(@response.body["detailedRecords"][0]["#{key}"][0].to_s).to include(nested_key)
end

Then(/^User should receive request code "(.*)" in response$/) do |status_code|
  expect(@response.status.to_s).to eq(status_code)
end




Then(/^the response contains the array key "([^"]*)" that includes the value "([^"]*)"$/) do |expected_key, expected_value|
  expect(hash_contains_key_with_value_that_contains_value?(JSON.parse(@response), expected_key, expected_value)).to (be true), "Expected value #{expected_value} to be with an array at key #{expected_key}} but it was not"
end

And(/^I add the header parameter hash string with key "([^"]*)" and key\/value pairs:$/) do |header_key, table|
  # table is a table.hashes.keys # => [:key, :value]
  header_value_string = "{"
  table.rows.each do |array_in_table|
    header_value_string += ("\"" + array_in_table[0] + "\":\"" + array_in_table[1] + "\",")
  end
  header_value_string = header_value_string[0...-1]
  header_value_string += "}"
  print header_value_string

  @header_hash ||= {}
  @header_hash = @header_hash.merge({header_key => header_value_string})
    #@header_hash = @header_hash.merge({header_key => "{\"context_id\":\"128807\",\"context_id_type\":\"registryId\"}"})
end

And(/^the response contains the key "([^"]*)"$/) do |expected_key|
  expect(hash_contains_the_key?(JSON.parse(@response), expected_key)).to (be true), "Expected key #{expected_key} to be with the response but it was not"
end

And(/^the response does not contain the key "([^"]*)"$/) do |expected_key|
  expect(hash_contains_the_key?(JSON.parse(@response), expected_key)).to (be false), "Expected key #{expected_key} to NOT be within the response but it was"
end

And(/^the response contains a hash from key "([^"]*)" with key "([^"]*)"$/) do |hash_key, expected_key|
  expect(hash_contains_hash_with_key?(JSON.parse(@response), hash_key, expected_key)).to (be true), "Expected key #{expected_key} to be within a hash from key #{hash_key} within the response, but it was not"
end


Then(/^all firefly keys "([^"]*)" should contain the value "([^"]*)"$/) do |key, value|
  expect(hash_contains_keys_all_with_value?(JSON.parse(@response), key, value)).to (be true), "Expected all keys \"#{key}\" to have a value \"#{value}\" in the following response but it was not:\n\n#{@response}"
end

And(/^all keys "([^"]*)" should contain the value "([^"]*)" that are with with key object "([^"]*)"$/) do |key, expected_value, object_key|
  expect(hash_contains_keys_all_with_value_within_object?(JSON.parse(@response), key, expected_value, object_key)).to (be true), "Expected all keys \"#{key}\" to have a value \"#{expected_value}\" that are in the values for key \"#{object_key}\""
end


And(/^all key objects "([^"]*)" should contain the key "([^"]*)"$/) do |object_key, expected_key|
  expect(all_key_object_contain_key?(JSON.parse(@response), expected_key, object_key)).to (be true), "Expected all key objects \"#{object_key}\" to have a key \"#{expected_key}\" but they did not"
end

Then(/^there should be a key "([^"]*)" contain in the value "([^"]*)" within the key object "([^"]*)"$/) do |expected_key, expected_value, object_key|
  expect(hash_contains_key_with_value_within_object?(JSON.parse(@response), expected_key, expected_value, object_key)).to (be true), "Expected a key \"#{expected_key}\" to have a value \"#{expected_value}\" that is in the values for key \"#{object_key}\""
end

Then(/^I should see "([^"]*)" instances of the key "([^"]*)"$/) do |number_of_instances, key|
  expect(hash_number_of_keys(JSON.parse(@response), key) == number_of_instances.to_i).to (be true), "Expected there to be #{number_of_instances} instances of key \"#{key}\" but there were #{@firefly_call.scan(/firefly-service/).length}"
end

And(/^the response should contain equal values for the first keys "([^"]*)" and "([^"]*)"$/) do |key1, key2|
  expect(first_value_for_key(JSON.parse(@response), key1) == first_value_for_key(JSON.parse(@response), key2)).to (be true), "Expected values for key #{key1} and key #{key2} to be equal but they were #{first_value_for_key(JSON.parse(@response), key1)} and #{first_value_for_key(JSON.parse(@response), key2)}"
end

Then(/^the response contains the key "([^"]*)" "([^"]*)" times$/) do |expected_key, expected_number_of_times|
  number_of_of_times_key_was_in_hash = number_of_times_key_in_hash(JSON.parse(@response), expected_key)
  expect(number_of_of_times_key_was_in_hash == expected_number_of_times.to_i).to (be true), "Expected to see ket in hash #{expected_number_of_times} times but it was seen #{number_of_of_times_key_was_in_hash}"
end

Then(/^the response contains the key "([^"]*)" the same amount of times as key "([^"]*)"$/) do |expected_key, expected_key2|
  number_of_of_times_key_was_in_hash = number_of_times_key_in_hash(JSON.parse(@response), expected_key)
  number_of_of_times_key2_was_in_hash = number_of_times_key_in_hash(JSON.parse(@response), expected_key2)
  expect(number_of_of_times_key_was_in_hash == number_of_of_times_key2_was_in_hash).to (be true), "Expected #{expected_key} and #{expected_key2} to be seen the same amount of times but they were not"
end

Then(/^the response contains the key "([^"]*)" within the key "([^"]*)"$/) do |expected_outter_key, expected_inner_key|
  expect(key_within_key?(JSON.parse(@response), expected_outter_key, expected_inner_key)).to (be true), "Expected to see key in hash #{expected_outter_key}, and another key #{expected_inner_key} within #{expected_outter_key} but it was not"
end

Then(/^the response contains a key "([^"]*)" with a value of type "([^"]*)"$/) do |expected_key, class_type|
  expect(hash_contains_key_with_value_of_class?(JSON.parse(@response), expected_key, class_type)).to (be true), "Expected to see key \"#{expected_key}\" in hash with a value of class type \"#{class_type}\" but it was not"
end

And(/^I print values with key "([^"]*)"$/) do |key|
  print_key_values(JSON.parse(@response), key)
end

Then(/^all keys "([^"]*)" should contain either "([^"]*)" or "([^"]*)"$/) do |arg1, arg2, arg3|
  pending
end

Then(/^the length of the array in key "([^"]*)" should be "([^"]*)"$/) do |array_key, expected_number_of_times|
  actual_number_of_times = length_of_array_in_key(JSON.parse(@response), array_key)
  expect(actual_number_of_times == expected_number_of_times.to_i).to (be true), "Expected to see key in hash have an array length of #{expected_number_of_times}, but it was #{actual_number_of_times}"
end

Then(/^the response contains a key "([^"]*)" with an integer value greater than "([^"]*)"$/) do |key, expected_lesser_value|
  actual_value = hash_get_first_key_value(JSON.parse(@response), key)
  expect(actual_value.to_i > expected_lesser_value.to_i).to (be true), "Expected response key to have a value less than #{expected_lesser_value} but it was #{actual_value}"
end

And(/^the response's first key "([^"]*)" should contain value "([^"]*)"$/) do |key, value|
  actual_value = hash_get_first_key_value(JSON.parse(@response), key)
  expect(actual_value.eql?(value)).to (be true), "Expected first key \"#{key}\" to contain value \"#{value}\" but it was #{actual_value} "
end