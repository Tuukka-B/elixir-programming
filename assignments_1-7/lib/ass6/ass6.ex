defmodule Ass6 do
  @moduledoc """
  Documentation for `Ass6`.
  """

  @doc """
      ## Teacher's instructions for the assignment:
          Copy the source code to Moodle return box. Alternatively you can paste a link to GitLab. If using GitLab, verify that you have added at least a Reporter permission for the lecturer.

          Define a module and struct Employee, and add struct fields:
              - first name
              - last name
              - id number
              - salary
              - job, which is one of the {:none, :coder, :designer, :manager, :ceo }

          id number has a default value that is previous id + 1
          salary has a default value 0
          job has a default value of :none

          Implement functions Employee.promote and Employee.demote which updates the job accordingly.
              - job :none salary is set to 0
              - each job above :none gets 2000 more salary than previous

          Test your Employee module and its promote and demote functions.

      ## Examples
          user@localhost:~/M2296/elixir-programming/assignments_1-7$ iex -S mix
          iex(1)> employee1 = Employee.new(%{firstname: "Cecil", lastname: "Cirin",  id: 1, job: :ceo, salary: 10000})
          %Employee{
          firstname: "Cecil",
          id: 1,
          job: :ceo,
          lastname: "Cirin",
          salary: 10000
          }
          iex(2)> employee1 = Employee.demote(employee1)
          %Employee{
          firstname: "Cecil",
          id: 1,
          job: :manager,
          lastname: "Cirin",
          salary: 8000
          }
          iex(3)> employee1 = Employee.demote(employee1)
          %Employee{
          firstname: "Cecil",
          id: 1,
          job: :designer,
          lastname: "Cirin",
          salary: 6000
          }
          iex(4)> employee1 = Employee.demote(employee1)
          %Employee{
          firstname: "Cecil",
          id: 1,
          job: :coder,
          lastname: "Cirin",
          salary: 4000
          }
          iex(5)> employee1 = Employee.demote(employee1)
          %Employee{firstname: "Cecil", id: 1, job: :none, lastname: "Cirin", salary: 0}
          iex(6)> employee1 = Employee.demote(employee1)
          Can't demote a jobless person!
          %Employee{firstname: "Cecil", id: 1, job: :none, lastname: "Cirin", salary: 0}
          iex(7)> employee1 = Employee.promote(employee1)
          %Employee{
          firstname: "Cecil",
          id: 1,
          job: :coder,
          lastname: "Cirin",
          salary: 2000
          }
          iex(8)> employee1 = Employee.promote(employee1)
          %Employee{
          firstname: "Cecil",
          id: 1,
          job: :designer,
          lastname: "Cirin",
          salary: 4000
          }
          iex(9)> employee1 = Employee.promote(employee1)
          %Employee{
          firstname: "Cecil",
          id: 1,
          job: :manager,
          lastname: "Cirin",
          salary: 6000
          }
          iex(10)> employee1 = Employee.promote(employee1)
          %Employee{firstname: "Cecil", id: 1, job: :ceo, lastname: "Cirin", salary: 8000}
          iex(11)> employee1 = Employee.promote(employee1)
          Can't promote a CEO!
          %Employee{firstname: "Cecil", id: 1, job: :ceo, lastname: "Cirin", salary: 8000}
          iex(12)> employee1 = Employee.new(%{firstname: "Cecil", lastname: "Cirin"})
          %Employee{firstname: "Cecil", id: 0, job: :none, lastname: "Cirin", salary: 0}
          iex(13)> employee1 = Employee.new(%{firstname: "Cecil", lastname: "Cirin", id: 10000})
          %Employee{
          firstname: "Cecil",
          id: 10000,
          job: :none,
          lastname: "Cirin",
          salary: 0
          }
          iex(14)> employee1 = Employee.new(%{firstname: "Cecil", lastname: "Cirin", salary: 20000})
          %Employee{firstname: "Cecil", id: 1, job: :none, lastname: "Cirin", salary: 0}
          iex(23)> employee1 = Employee.new(%{firstname: "Cecil", lastname: "Cirin", job: :manager, salary: 5000})
          %Employee{
          firstname: "Cecil",
          id: 2,
          job: :manager,
          lastname: "Cirin",
          salary: 5000
          }
          iex(15)>

  """
  def ass6_mainloop do
    import Employee
    "Testing must be done manually. The results are documented in the module documentation of Ass6 (ass6.ex)"
  end
end
