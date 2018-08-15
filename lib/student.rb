require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(id: nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new(id: row[0])
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    students = DB[:conn].execute(sql).map{|student| Student.new_from_db(student)}
    students
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    students = DB[:conn].execute(sql, grade).map{|student| Student.new_from_db(student)}
    students
  end

  def self.all_students_in_grade_9 
    students = self.all_students_in_grade_X('9')
    # binding.pry
    students
  end



  def self.students_below_12th_grade
    grade = 1
    students = []
    while grade < 12 do
      all_grade = self.all_students_in_grade_X(grade)
      students.concat(all_grade)
      grade += 1
      break if grade >= 12
    end
    students
  end

  def self.first_X_students_in_grade_10(num)
    students = self.all_students_in_grade_X('10').first(num)
    students
  end

  def self.first_student_in_grade_10 
    student = self.all_students_in_grade_X('10').first
    student
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    info = DB[:conn].execute(sql, name)[0]
    student = Student.new(id: info[0])
    student.name = info[1]
    student.grade = info[2]
    student
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
