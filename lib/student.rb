require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new()
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student.id = row[0]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    database_return = DB[:conn].execute("SELECT * FROM students");

    database_return.map do |student_row|
      new_from_db(student_row)
    end

  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class

    found_student = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten;
    new_from_db(found_student)
  end

  def self.all_students_in_grade_9

    found_students = DB[:conn].execute("SELECT * FROM students WHERE grade = 9");
    ninth_graders = found_students.map do |student_in_grade_9|
      new_from_db(student_in_grade_9)
    end
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12").map do |row| new_from_db(row) end
  end

  def self.first_X_students_in_grade_10(num)
    tenth_graders = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT #{num}");
  end

  def self.first_student_in_grade_10
    first_tenth_grader = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1").flatten;
    Student.new_from_db(first_tenth_grader);
  end

  def self.all_students_in_grade_X(grade)
    found_students = DB[:conn].execute("SELECT * FROM students WHERE grade = #{grade}");
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
