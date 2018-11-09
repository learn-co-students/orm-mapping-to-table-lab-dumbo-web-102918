require 'pry'
class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
      id INTEGER PRIMARY KEY,
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
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    #cant put the vales self.name and self.grade inside values because self.name is
    #string nd a string within a string will break it.
    @id = DB[:conn].execute("SELECT students.id FROM students ORDER BY students.id DESC LIMIT 1")[0][0]
    # need the [0][0] because the answer without it comes out to be [[1]].
  end

  def self.create(hash)
   student = Student.new(hash[:name], hash[:grade])
   student.save
   student
  end


end
