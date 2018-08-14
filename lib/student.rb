require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_stud = Student.new
    new_stud.id = row[0]
    new_stud.name = row[1]
    new_stud.grade = row[2]
    new_stud
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    x = DB[:conn].execute(sql)
    x.map do |student|
      self.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    x = DB[:conn].execute(sql,name).flatten
    self.new_from_db(x)
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

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 9
    SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE grade <> 12
    SQL

    x = DB[:conn].execute(sql)
    x.map do |student|
      self.new_from_db(student)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT 1
    SQL

    x = DB[:conn].execute(sql).flatten
      self.new_from_db(x)

  end


  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL

    x = DB[:conn].execute(sql, num)
    x.map do |student|
      self.new_from_db(student)
    end
  end




  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL

    x = DB[:conn].execute(sql, grade)
    x.map do |student|
      self.new_from_db(student)
    end
  end
















end
