class Company < ActiveRecord::Base
  has_many :employees
end