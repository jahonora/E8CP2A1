require 'colorize'
route = "alumnos.csv"

$data = []
def readfile(route)
	file = File.open(route, "r")
	data = file.readlines.map{|e| e.gsub("\n","")}
	data.each_with_index do |v,i|
		data[i] = v.split(", ")
	end
	$data = data
end

def average_grades
	a_grades = $data.map do |alumno|
		name = alumno[0]
		alumno.shift
		sum = alumno.reduce(0) do |sum, v| 
			v.gsub("A","0")
			sum + v.to_f
		end
		average = sum/alumno.count
		[name,average]
	end
end

def number_of_absences
	n_absences = $data.map do |alumno|
		name = alumno[0]
		alumno.shift
		absences = 0
		alumno.each{|v| absences += 1 if v.include?("A")}
		[name,absences]
	end
end

def pass_students(grade_min)
	a_grades = average_grades
	pass = a_grades.select{ |v| v[1] > grade_min}
end

readfile(route)

menu = "Menu de opciones:
		1. Mostrar el promedio de las notas de cada alumno
		2. Mostrar el numero de inasistencias totales de cada alumno
		3. Mostrar los alumnos aprobados y sus notas (debe ingresar la nota minima)
		4. Salir del programa"
puts "Bienvenido al manejador de alumnos más moderno del mundo!!".yellow

option = 0

while option != 4
	puts "#{menu}".blue
	print "Por favor ingrese una opcion:".yellow
	option = gets.chomp.to_i

	case option
	when 1
		arr = average_grades
		puts "El promedio de notas de cada alumno es: ".green
		arr.each{|v| puts "#{v[0]}: #{v[1]}".green}
	when 2
		arr = number_of_absences
		puts "El numero de inasistencias totales de cada alumno es: ".green
		arr.each{|v| puts "#{v[0]}: #{v[1]}".green}
	when 3
		grade_min = 5
		arr = pass_students(grade_min)
		puts "La nota minima para pasar es: #{grade_min}.".green
		puts "Los alumnos que estan aprobando son: ".green
		arr.each{|v| puts "#{v[0]}: #{v[1]}".green}
	when 4
		puts "Apagando el programa....".green
	end

	puts "Opcion invalida, por favor vuelva a intentarlo".red if option > 4 || option < 1
end




