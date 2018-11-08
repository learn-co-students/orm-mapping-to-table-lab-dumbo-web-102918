require "pry"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id=id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id  INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name,grade) VALUES (?,?)
    SQL
    DB[:conn].execute(sql,name,grade)
    @id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1").flatten[0]
  end


  def self.create (attributes)
    new_student = self.new(attributes[:name],attributes[:grade])
    new_student.save
    new_student
  end



  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

end
