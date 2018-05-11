require 'colorize'
route = "alumnos.csv"


def readfile(route)
	file = File.open(route, "r")
	data = file.readlines.map{|e| e.gsub("\n","")}
	file.close

	data.each_with_index do |v,i|
		data[i] = v.split(", ")
	end
	data
end

def writefile(output, route)
	file = File.new(route, "w")
	output.each do |v| 
		msg = "#{v[0]}, #{v[1]}"
		file.puts msg
	end

	file.close
end

def average_grades(data)
	a_grades = data.map do |alumno|
		name = alumno[0]
		alumno.shift
		sum = alumno.reduce(0) do |sum, v| 
			v.gsub("A","0")
			sum + v.to_f
		end
		average = sum/alumno.count
		[name,average]
	end
	writefile(a_grades, "promedio_notas.csv")
	a_grades
end

def number_of_absences(data)
	n_absences = data.map do |alumno|
		name = alumno[0]
		alumno.shift
		absences = 0
		alumno.each{|v| absences += 1 if v.include?("A")}
		[name,absences]
	end
end

def pass_students(data, grade_min)
	a_grades = average_grades(data)
	pass = a_grades.select{ |v| v[1] > grade_min}
end
data = []

menu = "Menu de opciones:
		1. Mostrar el promedio de las notas de cada alumno
		2. Mostrar el numero de inasistencias totales de cada alumno
		3. Mostrar los alumnos aprobados y sus notas (debe ingresar la nota minima)
		4. Salir del programa"
puts "Bienvenido al manejador de alumnos más moderno del mundo!!".yellow

option = 0

while option != 4
	data = readfile(route)
	puts "#{menu}".blue
	print "Por favor ingrese una opcion:".yellow
	option = gets.chomp.to_i

	case option
	when 1
		arr = average_grades(data)
		puts "El promedio de notas de cada alumno es: ".green
		arr.each{|v| puts "#{v[0]}: #{v[1]}".green}
	when 2
		arr = number_of_absences(data)
		puts "El numero de inasistencias totales de cada alumno es: ".green
		arr.each{|v| puts "#{v[0]}: #{v[1]}".green}
	when 3
		print "Por favor ingrese la nota minima con la que desea comparar:".yellow
		grade_min = gets.chomp.to_i
		grade_min = 5 if grade_min > 10 || grade_min < 1
		arr = pass_students(data, grade_min)
		puts "La nota minima para pasar es: #{grade_min}.".green
		puts "Los alumnos que estan aprobando son: ".green
		arr.each{|v| puts "#{v[0]}: #{v[1]}".green}
	when 4
		puts "Apagando el programa....".green
	end

	puts "Opcion invalida, por favor vuelva a intentarlo".red if option > 4 || option < 1
end




