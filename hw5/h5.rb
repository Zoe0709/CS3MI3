def fizzbuzzLooper(list)
	result = []
	for i in list
		if i % 3 == 0 && i % 5 == 0
			result.append("fizzbuzz")
		elsif i % 3 == 0
			result.append("fizz")
		elsif i % 5 == 0
			result.append("buzz")
		else
			result.append(i.to_s)
		end
	end
	result
end

def fizzbuzzIterator(list)
	list.each { |x| 
	if x % 3 == 0 && x % 5 == 0
		puts ("fizzbuzz")
	elsif x % 3 == 0
		puts ("fizz")
	elsif x % 5 == 0
		puts ("buzz")
	else
		puts (x.to_s)
	end}
end
			
