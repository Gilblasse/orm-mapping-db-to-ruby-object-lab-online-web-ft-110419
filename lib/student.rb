class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id,student.name,student.grade = row 
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql =  <<-SQL
      SELECT * FROM students
    SQL
    
    students = DB[:conn].execute(sql).map {|row| self.new_from_db(row) }
    students
  end
  
  def self.all_students_in_grade_9
    self.all.select {|student| student.grade == "9" }
  end
  
  def self.students_below_12th_grade
    self.all.select {|student| student.grade.to_i <  12 }
  end
  
  def self.first_X_students_in_grade_10(num)
     self.all.select {|student| student.grade.to_i ==  10 }[0...num]
  end
  
  def self.first_student_in_grade_10
    self.all.find {|student| student.grade.to_i ==  10 }
  end
  
  def self.all_students_in_grade_X(num)
     self.all.select {|student| student.grade.to_i ==  num }
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    row = DB[:conn].execute(sql,name)[0]
    self.new_from_db(row)
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
