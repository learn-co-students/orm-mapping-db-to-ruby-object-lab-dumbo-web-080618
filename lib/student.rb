require "pry"
class Student
  attr_accessor :id, :name, :grade





  def self.new_from_db(row)
    #binding.pry
    # @id = row[0]
    # @name = row[1]
    # @grade = row[2]
    z = Student.new
    # @id = row[0]
    z.id = row[0]
    z.name = row[1]
    z.grade = row[2]
    z
  end

  # def self.all
  #   # retrieve all the rows from the "Students" database
  #   # remember each row should be a new instance of the Student class
  # end

  def self.find_by_name(name)
      sql = <<-SQL
      SELECT * FROM students WHERE name = ?;
    SQL

    found_by_name = DB[:conn].execute(sql,name).flatten

     Student.new_from_db(found_by_name)
   end

   def self.all
     sql = <<-SQL
     SELECT * FROM students
   SQL

     all_students = DB[:conn].execute(sql)
     all_students.map {|students| Student.new_from_db(students)}
     # students
      #binding.pry
   end



   def self.all_students_in_grade_9
     sql = <<-SQL
     SELECT * FROM students WHERE grade = "9";
   SQL

   grade_9 = DB[:conn].execute(sql)
   #binding.pry


   #binding.pry
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE grade < "12";
  SQL

  all_students = DB[:conn].execute(sql)
  all_students.map {|student|Student.new_from_db(student)}
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = "10" LIMIT ?;
  SQL

    student = DB[:conn].execute(sql,num)
    #binding.pry
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = "10" LIMIT 1;
  SQL

  student = DB[:conn].execute(sql).flatten
  Student.new_from_db(student)
end

def self.all_students_in_grade_X(grade)
  sql = <<-SQL
  SELECT * FROM students WHERE grade = ?;
  SQL

  g= DB[:conn].execute(sql,grade)
  g.map{|student|Student.new_from_db(student)}
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
