defmodule Employee do
  alias GenId

  if !Process.whereis(:Generator) do
    GenId.new()
  end

  def get_occupations() do
    [:none, :coder, :designer, :manager, :ceo]
  end

  defstruct [:firstname, :lastname, :id, salary: 0, job: :none]

  def demote(employee) do
    # the index way of finding a previous item in list isn't probably the best method
    # TO-DO: improve demotion logic
    index = Enum.find_index(get_occupations(), fn x -> x == Map.get(employee, :job) end)

    if index == 0 do
      IO.puts("Can't demote a jobless person!")
      employee
    else
      new_job = elem(List.pop_at(get_occupations(), index - 1), 0)
      new_salary = (employee.salary >= 2000 && employee.salary - 2000) || 0
      new_salary = (new_job == :none && 0) || new_salary

      %Employee{
        id: employee.id,
        firstname: employee.firstname,
        lastname: employee.lastname,
        job: new_job,
        salary: new_salary
      }
    end
  end

  def new(params) do
    is_idgen_alive()
    params = prepare_params(params)

    %{:firstname => firstname, :lastname => lastname, :id => id, :salary => salary, :job => job} =
      params

    if !Enum.find(get_occupations(), fn x -> x == job end) do
      IO.puts("Wrong job title! (Must be one of: :none, :coder, :designer, :manager, :ceo)")
      nil
    else
      %Employee{firstname: firstname, lastname: lastname, salary: salary, job: job, id: id}
    end
  end

  def promote(employee) do
    # the index way of finding a next item in list isn't probably the best method
    # TO-DO: improve promotion logic
    index = Enum.find_index(get_occupations(), fn x -> x == Map.get(employee, :job) end)

    if length(get_occupations) == index + 1 do
      IO.puts("Can't promote a CEO!")
      employee
    else
      %Employee{
        id: employee.id,
        firstname: employee.firstname,
        lastname: employee.lastname,
        job: elem(List.pop_at(get_occupations(), index + 1), 0),
        salary: employee.salary + 2000
      }
    end
  end

  defp is_idgen_alive do
    if !Process.whereis(:Generator) do
      GenId.new()
    end
  end

  defp prepare_params(params) do
    params = (!params[:job] && Map.put(params, :job, :none)) || params

    params =
      ((!params[:salary] || params[:job] == :none) && Map.put(params, :salary, 0)) || params

    params = (!params[:id] && Map.put(params, :id, GenId.get(:Generator))) || params
    params
  end
end
