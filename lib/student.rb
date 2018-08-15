require "pry"
class Student
  attr_accessor :id, :name, :grade
  def self.new_from_db(row)
    student1 = self.new()
    student1.id= (row[0])
    student1.name= (row[1])
    student1.grade= (row[2])
    student1.save
    student1
  end

  def self.all
    sql1 =         <<-SQL
                  SELECT * FROM students
                  SQL
    found_row = (DB[:conn].execute(sql1))#.flatten!
    found_row.map do |row|
       self.new_from_db(row)
     end
  end

  def self.find_by_name(name)
    sql1 =         <<-SQL
                  SELECT * FROM students
                  WHERE name = ?
                  SQL
    found_row = (DB[:conn].execute(sql1, name)).flatten!
    self.new_from_db (found_row)
  end

  def self.all_students_in_grade_9
    self.all.select do |student_obj|
      student_obj.grade.to_i == 9
    end
  end

  def self.students_below_12th_grade
    self.all.select do |student_obj|
      student_obj.grade.to_i < 12
    end
  end

  def self.first_X_students_in_grade_10(n)
    x = self.all.select do |student_obj|
      student_obj.grade.to_i == 10
    end
    x[0..(n-1)]
  end

  def self.first_student_in_grade_10
    x = self.all.select do |student_obj|
      student_obj.grade.to_i == 10
    end
    x[0]
  end

  def self.all_students_in_grade_X(n)
    self.all.select do |student_obj|
      student_obj.grade.to_i == n
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
