def hash_get_first_key_value(hash, key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(key)
  return all_values.first
end

def hash_contains_the_key?(hash, expected_key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)
  !(all_values.nil?)
end

def hash_contains_hash_with_key?(hash, hash_key, expected_key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(hash_key)
  expected_key_within_key_present = all_values.find do |iterative_value|
    begin
      hash_contains_the_key?(iterative_value, expected_key)
    rescue
      false
    end
  end
  !(expected_key_within_key_present.nil?)
end

def hash_contains_key_with_value_that_contains_value?(hash, expected_key, expected_value)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)
  return false if all_values.nil?
  expected_value_present = all_values.find do |iterative_value|
    iterative_value.include?(expected_value)
  end
  !(expected_value_present.nil?)
end

def hash_contains_key_with_value_that_contains_integer?(hash, expected_key, expected_value)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)

  expected_value_present = all_values.find do |iterative_value|
    iterative_value == expected_value.to_i
  end
  !(expected_value_present.nil?)
end

def hash_contains_key_with_value_that_contains_float?(hash, expected_key, expected_value)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)

  expected_value_present = all_values.find do |iterative_value|
    iterative_value == expected_value.to_f
  end
  !(expected_value_present.nil?)
end

def first_value_from_key(hash, expected_key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)

  return all_values.first
end

def hash_contains_key_with_value?(hash, expected_key, expected_value)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)
  return all_values.include? expected_value unless all_values.nil?
  return false
end

def hash_contains_keys_all_with_value?(hash, expected_key, expected_value)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)
  all_values.each do |json_value|
    return false unless json_value.include? expected_value
  end
  return true
end

def hash_contains_keys_all_with_one_of_two_values?(hash, expected_key, expected_value, expected_value2)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)
  all_values.each do |json_value|
    return false unless (json_value.include?(expected_value) || json_value.include?(expected_value2))
  end
  return true
end

def hash_contains_keys_all_with_one_of_three_values?(hash, expected_key, expected_value, expected_value2, expected_value3)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)
  all_values.each do |json_value|
    return false unless (json_value.include?(expected_value) || json_value.include?(expected_value2) || json_value.include?(expected_value3))
  end
  return true
end

def hash_contains_key_with_value_within_object?(hash, expected_key, expected_value, object_key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(object_key)
  object_to_look_for = all_values.find do |json_value|
    hash_contains_key_with_value?(json_value, expected_key, expected_value)
  end
  return !(object_to_look_for.nil?)
end

def hash_contains_keys_all_with_value_within_object?(hash, expected_key, expected_value, object_key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(object_key)
  all_values.each do |json_value|
    return false unless hash_contains_keys_all_with_value?(json_value, expected_key, expected_value)
  end
  return true
end

def hash_number_of_keys(hash, expected_key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)
  return all_values.length
end

def all_key_object_contain_key?(hash, expected_key, object_key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(object_key)
  all_values.each do |json_value|
    return false unless hash_contains_the_key?(json_value, expected_key)
  end
  return true
end

def keys_in_hash_in_alphabetical_order?(hash, key_to_check)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(key_to_check)
  i = 0
  alphabetical_array = all_values.sort_by{|e| e.downcase}
  print all_values.to_s + " " + alphabetical_array.to_s
  begin
    print all_values[i].to_s + " \n " + alphabetical_array[i].to_s
    return false unless (all_values[i].include?(alphabetical_array[i]) || alphabetical_array[i].include?(all_values[i]))
    i +=1
  end while i < all_values.length
  return true
end

def keys_in_hash_in_reverse_alphabetical_order?(hash, key_to_check)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(key_to_check)
  i = 0
  print "\n\n"
  print all_values
  print "\n\n"
  print all_values.sort.reverse
  begin
    return false unless (all_values[i].include?(all_values.sort.reverse[i]) || all_values.sort.reverse[i].include?(all_values[i]))
    i +=1
  end while i < all_values.length
  return true
end

def value_contained_in_key_within_hash_object?(response, key, object_key, value)
  hash = hash.extend Hashie::Extensions::DeepFind
  hash_object = hash.deep_find(object_key)

  hash_object = hash_object.extend Hashie::Extensions::DeepFind
  all_values_to_look_for = hash_object.deep_find_all(key)
  all_values_to_look_for.include? value
end

def hash_contains_number_of_keys(hash, key_to_check)
  hash[key_to_check].length
end

def hash_contains_key_of_data_type?(hash, key, classType)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(key)
  key_with_datatype = all_values.find do |iterative_value|
    iterative_value.class.to_s.include?(classType)
  end
  !(key_with_datatype.nil?)
end

def hash_contains_all_key_of_data_type?(hash, key, classType)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(key)
  all_values.each do |iterative_value|
    return false unless iterative_value.class.to_s.include?(classType)
  end
  return true
end

def first_value_for_key(hash, key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(key)
  return all_values.first
end

def hash_contains_array_key_with_key_value?(hash, array_key, hash_key, hash_value)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(array_key)

  all_values.each do |iterative_value|
    if iterative_value.class.to_s.include?("Array")
      iterative_value.each do |hash_in_array|
        print "\n#{hash_in_array}"
        return true if hash_contains_key_with_value?(hash_in_array, hash_key, hash_value)
      end
    end
  end
  return false
end

def number_of_times_key_in_hash(hash, expected_key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)
  return all_values.length
end

def key_within_key?(hash, expected_outter_key, expected_inner_key)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_outter_key)
  all_values.each do |first_round_of_key|
    if first_round_of_key.class.to_s.include?("Hash")
      return true if hash_contains_the_key?(hash, expected_inner_key)
    end
  end
  return false
end

def hash_contains_key_with_value_of_class?(hash, expected_key, expected_class_type)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(expected_key)
  all_values.each do |key_to_look_at|
    return true if key_to_look_at.class.to_s.downcase.include?(expected_class_type.downcase)
  end
end

def length_of_array_in_key(hash, key_to_check)
  hash = hash.extend Hashie::Extensions::DeepFind
  all_values = hash.deep_find_all(key_to_check)
  return all_values.first.length
end