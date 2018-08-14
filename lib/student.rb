require 'pry'
class Student
  attr_accessor :id, :name, :grade

    # def initialize()
    #   @id = id
    #   @name = name
    #   @grade = grade
    # end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    #self.new(row[0], row[1], row[2])
    temp_stu = self.new
    temp_stu.id = row[0]
    temp_stu.name = row[1]
    temp_stu.grade = row[2]
    temp_stu

  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL

    temp = DB[:conn].execute(sql)
    temp.map do |i|
      self.new_from_db(i)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    temp = DB[:conn].execute(sql, name)
    self.new_from_db(temp.flatten)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    self
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
      SELECT * FROM students WHERE grade <= 11
    SQL
    temp = DB[:conn].execute(sql)
    temp.map do |i|
      self.new_from_db(i)
    end
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL
    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL
    temp = DB[:conn].execute(sql)
    self.new_from_db(temp.flatten)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    DB[:conn].execute(sql, x)
  end

end
