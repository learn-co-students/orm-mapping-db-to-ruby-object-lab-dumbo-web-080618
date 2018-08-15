class Student
  attr_accessor :id, :name, :grade

  # def initialize(name:, grade:, id: nil)
  #   @name = name
  #   @grade = grade
  #   @id = id
  # end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.name = row[1]
    student.id = row[0]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
      SELECT * FROM students;
    SQL
    students = DB[:conn].execute(sql);
    # remember each row should be a new instance of the Student class
    students.map do |student|
      Student.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    Student.new_from_db(DB[:conn].execute(sql, name).flatten)
    # return a new instance of the Student class
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9;
    SQL
    students = DB[:conn].execute(sql);
    # remember each row should be a new instance of the Student class
    students.map do |student|
      Student.new_from_db(student)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12;
    SQL
    students = DB[:conn].execute(sql);
    # remember each row should be a new instance of the Student class
    students.map do |student|
      Student.new_from_db(student)
    end
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?;
    SQL
    students = DB[:conn].execute(sql, x);
    # remember each row should be a new instance of the Student class
    students.map do |student|
      Student.new_from_db(student)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1;
    SQL
    student = DB[:conn].execute(sql).flatten
    Student.new_from_db(student)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?;
    SQL
    students = DB[:conn].execute(sql, x);
    # remember each row should be a new instance of the Student class
    students.map do |student|
      Student.new_from_db(student)
    end
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
