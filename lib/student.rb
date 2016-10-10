require 'pry'
require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

def initialize(name, grade, id=nil)
  @name = name
  @grade =grade
  @id = id
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
  if @id
    self.update
  else
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, @name, @grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM Students")[0][0]
  end
end

def self.create(name, grade)
  student = Student.new(name, grade)
  student.save
  student
end

def self.new_from_db(array)
  Student.new(array[1], array[2], array[0])
end

def self.find_by_name(name)
  sql = <<-SQL
  SELECT *
  FROM students
  WHERE name = ?
  SQL

  self.new_from_db(DB[:conn].execute(sql, name).first)
end

def update
  sql = <<-SQL
  UPDATE students
  SET name = ?, grade = ?
  WHERE id = ?
  SQL

  DB[:conn].execute(sql, self.name, self.grade, self.id)
end






  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
