#!/usr/bin/ruby

class Global
	def initialize()
		#@ambiance = rand()-0.5
		@ambiance = 0.2
		@upperLimit = 1.0
		@lowerLimit = -1.0
	end
	def invert()
		@ambiance = -@ambiance
	end
	def average()
		return (@upperLimit+@lowerLimit)/2.0
	end
	attr_reader :upperLimit
	attr_reader :lowerLimit
	attr_reader :ambiance
end

$global = Global.new()

class Wesen
	def initialize(startzahl)
		@startzahl = startzahl
		@leben = startzahl
		@age = 0
	end
	attr_reader :leben
	attr_reader :startzahl
	attr_reader :age

	def round()
		@leben = @leben+ $global.ambiance
		if @leben < $global.lowerLimit or @leben > $global.upperLimit then
			return false
		end
		@age = @age + 1
		return true
	end
end

def makeChild(wesen1, wesen2)
	array = Array.new()
	array.insert(-1, wesen1.startzahl - $global.average)
	array.insert(-1, wesen2.startzahl - $global.average)
	array.insert(-1, (wesen1.startzahl - $global.average) + (wesen2.startzahl - $global.average) )
	tmp = rand()*(array.max-array.min)+array.min
	wesen = Wesen.new(tmp)
	return wesen
end

def testInheritance()
	sum = 0
	low = -0.9
	high =-0.5
	10000.times do
		child = makeChild(Wesen.new(low), Wesen.new(high))
		sum = sum + child.startzahl
		if child.startzahl<low+high or child.startzahl>0.0 then
			puts "panic"
			exit(1)
		end
		if child.startzahl == low then
			puts "found low"
			exit(0)
		end
		if child.startzahl == 0.0 then
			puts "found high"
			exit(0)
		end
		puts child.startzahl
	end
	puts("Average: #{sum/10000}")
	exit()
end
#testInheritance


def finish()
	#puts("Umgebung: #{$global.ambiance}")
	exit(0)
end

population = Array.new()

population.insert(-1, Wesen.new($global.average-rand()) )
population.insert(-1, Wesen.new($global.average+rand()) )
#population.insert(-1, Wesen.new(0.5) )
#population.insert(-1, Wesen.new(-0.5) )
#population.insert(-1, Wesen.new(0.5) )
#population.insert(-1, Wesen.new(-0.5) )

population.each do |wesen| 
	#puts("#{wesen.startzahl}" )
end

50.times do |i|
	if i%10 == 0 then
		$global.invert()
		#puts("Umgebung: #{$global.ambiance}")
	end
	average = 0.0
	averageAge = 0.0
	population.each_index do |wesen|
		#print("#{wesen}:#{population[wesen].startzahl} = #{population[wesen].leben}\t" )
		if not population[wesen].round() then
			population.delete_at(wesen)
		else
			average = average+population[wesen].startzahl
			averageAge = averageAge+population[wesen].age
		end
	end
	#puts("Population: #{population.count}")
	average = average/population.count
	averageAge = averageAge/population.count
	#puts("Round: #{i}\tAverage: #{average}\tAverageAge: #{averageAge}")
	if population.count == 0 or population.count >= 50000 then
		finish
	end
	tmp = Array.new()
	while population.count>=2 do
		rand1 = rand(population.count)
		wesen1 = population.delete_at(rand1)
		tmp.insert(-1, wesen1)

		rand2 = rand(population.count)
		wesen2 = population.delete_at(rand2)
		tmp.insert(-1, wesen2)
		
		child = makeChild( wesen1, wesen2 )
		tmp.insert(-1, child)
	end
	# put remaining numbers from population to tmp
	population.each do |wesen|
		tmp.insert(-1, wesen)
	end
	# put all tmp back to population
	population = tmp

	puts("#{i}\t#{$global.ambiance}\t#{population.count}\t#{average}\t#{averageAge}")
	#puts("--------------")
end
finish

